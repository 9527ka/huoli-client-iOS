//
//  WH_GroupRechargeViewController.m
//  Tigase
//
//  Created by 1111 on 2023/12/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_GroupRechargeViewController.h"
#import "WH_GroupRechargeCell.h"
#import "WH_JXBuyPayViewController.h"

@interface WH_GroupRechargeViewController ()<UITableViewDataSource, UITableViewDelegate>{
    ATMHud* _wait;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *vcTitle;

@property(nonatomic,copy)NSString *balance;//限额

@property(nonatomic,strong)NSMutableDictionary *payTypeDic;

@end

@implementation WH_GroupRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.estimatedRowHeight = 784;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.dataArray = [NSMutableArray array];
    
    self.tableView.rowHeight = 680;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_GroupRechargeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_GroupRechargeCell"];
    if(self.room){//群内购买
        //获取支付方式
        [g_server WH_ReceiveAccountListWithRoomJid:self.room.roomJid toView:self];
        //获取限额
        [g_server WH_BalanceAccountWithId:self.room.roomJid toView:self];
    }else{//代理商购买或者出售
        if(!self.model.isBuy){//出售
            self.vcTitle.text = @"出售HOTC";
        }
    }
    
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_GroupRechargeCell *cell = (WH_GroupRechargeCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_GroupRechargeCell" forIndexPath:indexPath];
    __weak typeof (self)weakSelf = self;
    cell.certainBlock = ^(NSString * _Nonnull count, NSInteger type) {
        weakSelf.count = count;
        weakSelf.type = type;
        [weakSelf certainAction];
    };
    if(self.room){
        cell.groupNameLab.text = self.room.userNickName.length > 0?self.room.userNickName:@"";
        if(self.balance.length > 0){
            cell.balance = self.balance;
        }
        if(self.dataArray.count > 0){
            cell.payArray = self.dataArray;
        }
    }else{//代理商购买或者出售
        cell.model = self.model;
        
    }
    
    return cell;
}
-(void)certainAction{
    
    if(self.room){//群内购买
        self.room.type = self.type;
        self.room.count = self.count;
        NSDictionary *dic;
        //获取支付方式数据
        if(self.dataArray.count == 1){
            dic = self.dataArray.firstObject;
            NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
            if(type.intValue == 1){//微信
                self.type = 1;
            }else{//支付宝
                self.type = 0;
            }
        }else{
            for (NSDictionary *dataDic in self.dataArray) {
                NSString *type = [NSString stringWithFormat:@"%@",dataDic[@"type"]];
                if(self.type == 1 && type.intValue == 1){//微信
                    dic = dataDic;
                }else if(self.type == 0 && type.intValue == 2){
                    dic = dataDic;
                }
            }
        }
        self.payTypeDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        //调接口
        [g_server WH_TradeApplyWithTargetAmount:self.count payType:self.type == 0?2:1 financialInfoId:[NSString stringWithFormat:@"%@",dic[@"id"]] payeeUID:[NSString stringWithFormat:@"%ld",self.room.userId] jid:self.room.roomJid payeeName:[NSString stringWithFormat:@"%@",dic[@"accountName"]] payeeAccount:[NSString stringWithFormat:@"%@",dic[@"accountNo"]] payeeAccountImg:[NSString stringWithFormat:@"%@",dic[@"qrCode"]] toView:self];
    }else{//代理商购买
    
        NSString *paymentCode = self.type == 0?self.model.alipayCode:self.model.wechatCode;
        
        float sellCharge = self.count.floatValue * self.model.sellCharge.floatValue;
        //应得
        float grossPay = self.model.isBuy?self.count.floatValue + sellCharge:self.count.floatValue - sellCharge;
        
        [g_server WH_TradeApplyBuyWithAmount:self.count payAmount:[NSString stringWithFormat:@"%.2f",grossPay] payType:self.type == 0?2:1 merchant:self.model.userId paymentCode:paymentCode isBuy:self.model.isBuy toView:self];
        
    }
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    

    NSString *url = [NSString stringWithFormat:@"%@%@",wh_List_userAccount,self.room.roomJid];
    
    NSString *balanceUrl = [NSString stringWithFormat:@"%@%@",wh_balance_userAccount,self.room.roomJid];
    
    if ([aDownload.action isEqualToString:url]){
        self.dataArray = [NSMutableArray arrayWithArray:array1];
        [self.tableView reloadData];
    }else if ([aDownload.action isEqualToString:balanceUrl]){
        self.balance = [NSString stringWithFormat:@"%@",dict[@"balance"]];
        [self.tableView reloadData];
    }else if ([aDownload.action isEqualToString:wh_trade_apply]){
        //获取过期时间
        NSString *expiryTime = [NSString stringWithFormat:@"%@",dict[@"expiryTime"]];
        [self.payTypeDic setObject:[NSString stringWithFormat:@"%@",dict[@"id"]] forKey:@"id"];
        [self.payTypeDic setObject:@"0" forKey:@"status"];
        
        
        WH_JXBuyPayViewController *vc = [[WH_JXBuyPayViewController alloc] init];
        vc.expiryTime = expiryTime;
        vc.room = self.room;
        vc.payDic = self.payTypeDic;
        [g_navigation pushViewController:vc animated:YES];
    }else if ([aDownload.action isEqualToString:wh_order_buy_List]){//代理商购买
       
        self.payTypeDic = [NSMutableDictionary dictionary];
        //获取过期时间
        NSString *expiryTime = [NSString stringWithFormat:@"%@",dict[@"expiryTime"]];
        [self.payTypeDic setObject:[NSString stringWithFormat:@"%@",dict[@"id"]] forKey:@"id"];
        [self.payTypeDic setObject:@"0" forKey:@"status"];
        
        NSString *paymentCode = self.type == 0?self.model.alipayCode:self.model.wechatCode;
        
        [self.payTypeDic setObject:paymentCode forKey:@"qrCode"];
        [self.payTypeDic setObject:@(self.type) forKey:@"type"];
        
        float sellCharge = self.count.floatValue * self.model.sellCharge.floatValue;
        //应得
        float grossPay = self.model.isBuy?self.count.floatValue + sellCharge:self.count.floatValue - sellCharge;
        
        [self.payTypeDic setObject:@(grossPay) forKey:@"count"];
        
        
        WH_JXBuyPayViewController *vc = [[WH_JXBuyPayViewController alloc] init];
        vc.expiryTime = expiryTime;
        vc.payDic = self.payTypeDic;
        [g_navigation pushViewController:vc animated:YES];
    }else if ([aDownload.action isEqualToString:wh_order_sell_List]){
        //代理商出售
        [g_server showMsg:@"操作成功,等待支付"];
        [self performSelector:@selector(goBackAction) withObject:nil afterDelay:1.0];
    }
}
-(void)goBackAction{
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait hide];
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait hide];
    return WH_show_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    
    [_wait start];

}

@end
