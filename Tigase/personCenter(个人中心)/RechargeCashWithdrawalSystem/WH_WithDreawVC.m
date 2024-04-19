//
//  WH_WithDreawVC.m
//  Tigase
//
//  Created by 1111 on 2023/12/8.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_WithDreawVC.h"
#import "WH_WithDreawCell.h"
#import "BindTelephoneChecker.h"
#import "WH_JXVerifyPay_WHVC.h"

@interface WH_WithDreawVC ()<UITableViewDataSource, UITableViewDelegate>{
    ATMHud* _wait;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) WH_JXVerifyPay_WHVC *verVC;
@property (nonatomic, copy) NSString *amountStr;
@property (nonatomic, copy) NSString *orderNoStr;


@end

@implementation WH_WithDreawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 684;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_WithDreawCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_WithDreawCell"];
    //获取汇率
    [g_server WH_receiveRateWithToView:self];
    
}
- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_WithDreawCell *cell = (WH_WithDreawCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_WithDreawCell" forIndexPath:indexPath];
    __weak typeof (self)weakSelf = self;
    cell.certainBlock = ^(NSString * _Nonnull amountStr, NSString * _Nonnull orderNoStr) {
        weakSelf.amountStr = amountStr;
        weakSelf.orderNoStr = orderNoStr;
        
        if ([g_myself.isPayPassword boolValue]) {
            self.verVC = [WH_JXVerifyPay_WHVC alloc];
            self.verVC.type = JXVerifyTypeWithdrawal;
            self.verVC.wh_RMB = amountStr;
            self.verVC.delegate = self;
            self.verVC.didDismissVC = @selector(WH_dismiss_WHVerifyPayVC);
            self.verVC.didVerifyPay = @selector(WH_didVerifyPay:);
            self.verVC = [self.verVC init];
            
            [self.view addSubview:self.verVC.view];
            
        }else {//没有支付密码
            [BindTelephoneChecker checkBindPhoneWithViewController:weakSelf entertype:JXEnterTypeDefault];
        }
        
        
    };
    if(g_App.rate.doubleValue > 0.0){
        [cell reSetRate];
    }
    
        
    return cell;
}
- (void)WH_didVerifyPay:(NSString *)sender {
    NSString *payPassword = [NSString stringWithString:sender];
    
    //服务费
    NSString *transferRateStr = [NSString stringWithFormat:@"%.2f",g_config.transferRate.floatValue/100*self.amountStr.doubleValue];
    //实际到账
    float count = self.amountStr.doubleValue - transferRateStr.floatValue;
    NSString *trealStr = [NSString stringWithFormat:@"%.2f",count/g_App.rate.floatValue];
    
    
    long time = (long)[[NSDate date] timeIntervalSince1970] + (g_server.timeDifference / 1000);
    NSString *timeStr = [NSString stringWithFormat:@"%ld",time];
    NSString *secret = [self getSecretWithText:payPassword time:timeStr];
    
    [g_server WH_transferWithAmount:self.amountStr aliUserId:self.orderNoStr secret:secret time:timeStr targetAmount:trealStr servicecharge:transferRateStr toView:self];
    

    //    [g_server WH_WithdrawWithAmount:self.amountStr usdtUrl:self.orderNoStr payPassword:payPassword targetAmount:trealStr serviceCharge:transferRateStr toView:self];

}
- (NSString *)getSecretWithText:(NSString *)text time:(NSString *)time {
    NSMutableString *str1 = [NSMutableString string];
    [str1 appendString:APIKEY];
    [str1 appendString:time];
    [str1 appendString:[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:[self.amountStr doubleValue]]]];
    str1 = [[g_server WH_getMD5StringWithStr:str1] mutableCopy];
    
    [str1 appendString:g_myself.userId];
    [str1 appendString:g_server.access_token];
    NSMutableString *str2 = [NSMutableString string];
    str2 = [[g_server WH_getMD5StringWithStr:text] mutableCopy];
    [str1 appendString:str2];
    str1 = [[g_server WH_getMD5StringWithStr:str1] mutableCopy];
    
    return [str1 copy];
    
}
- (void)WH_dismiss_WHVerifyPayVC {
    [self.verVC.view removeFromSuperview];
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    if ([aDownload.action isEqualToString:wh_act_TransferToAdmin]){
        [g_server showMsg:@"提交成功，请等待核实"];
        [g_navigation WH_dismiss_WHViewController:self animated:YES];
    }else if ([aDownload.action isEqualToString:wh_rate_current]){
        NSString *rate = [NSString stringWithFormat:@"%@",dict[@"data"]];
        g_App.rate = rate;
        [self.tableView reloadData];
        
    }
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
    if ([aDownload.action isEqualToString:wh_act_UploadFile]) {
        [_wait start:Localized(@"JXFile_uploading")];
    }else{
        [_wait start];
    }
}


@end
