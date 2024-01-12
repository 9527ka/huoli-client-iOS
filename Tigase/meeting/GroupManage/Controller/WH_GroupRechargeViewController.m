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
#import "WH_JXOrderDetaileVC.h"
#import "WH_JXNoticeView.h"
#import "WH_JXOrderCertainVC.h"
#import "WH_JXBuyAndPayListModel.h"

@interface WH_GroupRechargeViewController ()<UITableViewDataSource, UITableViewDelegate>{
    ATMHud* _wait;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *vcTitle;

@property(nonatomic,copy)NSString *balance;//限额
@property(nonatomic,copy)NSString *orderId;//订单ID

@property(nonatomic,strong)NSMutableDictionary *payTypeDic;
@property (strong, nonatomic)WH_JXNoticeView *noticeView;
@property (nonatomic,strong)WH_JXOrderCertainVC *vc;

@property (nonatomic,strong)WH_FinancialInfosModel *payModel;

@end

@implementation WH_GroupRechargeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.noticeView receiveData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //跑马灯的view
    _noticeView = [[WH_JXNoticeView alloc] initWithFrame:CGRectMake(0, JX_SCREEN_TOP + 12, JX_SCREEN_WIDTH, 40)];
    [self.view addSubview:self.noticeView];
        
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
        [weakSelf showCertainView];
    };
    if(self.room){
        cell.groupNameLab.text = self.room.userNickName.length > 0?self.room.userNickName:@"";
        if(self.balance.length > 0){
            cell.balance = self.balance;
        }
    }else{//代理商购买或者出售
        cell.model = self.model;
    }
    
    return cell;
}
-(void)showCertainView{
    if(self.room){//群内购买
        self.room.type = self.type;
        self.room.count = self.count;
        self.vc.room = self.room;
    }else{
        self.model.count = self.count;
        
        float sellCharge = self.count.floatValue * self.model.sellCharge.floatValue;
        //应得
        float grossPay = self.model.isBuy?self.count.floatValue + sellCharge:self.count.floatValue - sellCharge;
                
        self.model.sellCount = [NSString stringWithFormat:@"%.2f",grossPay];
        
        self.vc.model = self.model;
    }
        
    self.vc.view.hidden = NO;
    self.vc.dataArray = self.room?self.dataArray:self.model.financialInfos;
    
//       [UIView animateWithDuration:0.5 animations:^{
           self.vc.view.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
//       }];
}
-(void)certainAction{
    
    if(!self.payModel){//没选的话就是默认第一个
        NSArray *dataArray = self.room?self.dataArray:self.model.financialInfos;
        self.payModel = dataArray.firstObject;
    }
    
    if(self.room){//群内购买
        
        self.payTypeDic = [self.payModel mj_keyValues];
        
        //调接口
        [g_server WH_TradeApplyWithTargetAmount:self.count payType:self.type == 0?2:1 financialInfoId:[NSString stringWithFormat:@"%@",self.payModel.payId] payeeUID:[NSString stringWithFormat:@"%ld",self.room.userId] jid:self.room.roomJid payeeName:[NSString stringWithFormat:@"%@",self.payModel.accountName] payeeAccount:[NSString stringWithFormat:@"%@",self.payModel.accountNo] payeeAccountImg:[NSString stringWithFormat:@"%@",self.payModel.qrCode] toView:self];
    }else{//代理商购买
    
        NSString *paymentCode = self.payModel.qrCode;
        
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
    
    NSString *orderDetaileUrl = [NSString stringWithFormat:@"%@%@",wh_order_detaile,self.orderId];
    
    if ([aDownload.action isEqualToString:url]){
        self.dataArray = [WH_FinancialInfosModel mj_objectArrayWithKeyValuesArray:array1];
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
        
        NSString *paymentCode = self.payModel.qrCode;
        
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
        self.orderId = [NSString stringWithFormat:@"%@",dict[@"id"]];
        //查询订单详情
        [g_server WH_orderDetaileWithId:self.orderId toView:self];
    }else if( [aDownload.action isEqualToString:orderDetaileUrl] ){//详情
        WH_JXOrderDetaileVC *orderVC = [[WH_JXOrderDetaileVC alloc] init];
        orderVC.dict = dict;
        orderVC.orderId = self.orderId;
        [g_navigation pushViewController:orderVC animated:YES];
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
-(WH_JXOrderCertainVC *)vc{
    if(!_vc){
        _vc = [[WH_JXOrderCertainVC alloc] init];
        _vc.view.frame = CGRectMake(0, JX_SCREEN_HEIGHT, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
        _vc.view.hidden = YES;
        [self.view addSubview:self.vc.view];
        __weak typeof (&*self)weakSelf = self;
        _vc.certainBlock = ^(WH_FinancialInfosModel * _Nonnull payModel) {
            weakSelf.payModel = payModel;
            [weakSelf certainAction];
        };
    }
    return _vc;
    
}

@end
