//
//  WH_JXFastRedSetVC.m
//  Tigase
//
//  Created by 1111 on 2024/2/1.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXFastRedSetVC.h"
#import "WH_JXVerifyPay_WHVC.h"
#import "BindTelephoneChecker.h"

@interface WH_JXFastRedSetVC (){
    ATMHud *_wait;
}
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UITextField *countField;
@property (weak, nonatomic) IBOutlet UITextField *timeField;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic, strong) WH_JXVerifyPay_WHVC * verVC;
@property (nonatomic,copy) NSString *passWord;

@end

@implementation WH_JXFastRedSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _wait = [ATMHud sharedInstance];
    self.commitBtn.layer.cornerRadius = 8.0f;
    
    WH_FastRedModel *model = [JXServer receiveFastRed];
    if(model){
        self.amountField.text = model.amount;
        self.countField.text = model.count;
    }
    
}
- (IBAction)backAction:(id)sender {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

- (IBAction)commitAction:(id)sender {
    
    //判断是否为空
    if(self.amountField.text.length == 0 || self.amountField.text.doubleValue == 0.0f){
        [g_server showMsg:@"请输入红包金额"];
        return;
    }
    if(self.countField.text.length == 0 || self.countField.text.intValue < 1.0f){
        [g_server showMsg:@"请输入红包数量"];
        return;
    }
//    if(self.timeField.text.length == 0){
//        [g_server showMsg:@"请输入支付密码有效时间"];
//        return;
//    }
    
    g_myself.isPayPassword = [g_default objectForKey:PayPasswordKey];
    if ([g_myself.isPayPassword boolValue]) {
        self.verVC = [WH_JXVerifyPay_WHVC alloc];
        self.verVC.type =  JXVerifyTypeSendReadPacket;
        self.verVC.wh_RMB = self.amountField.text;
        self.verVC.delegate = self;
        self.verVC.didDismissVC = @selector(WH_dismiss_WHVerifyPayVC);
        self.verVC.didVerifyPay = @selector(WH_didVerifyPay:);
        self.verVC = [self.verVC init];
        
        [self.view addSubview:self.verVC.view];
    } else {
        [BindTelephoneChecker checkBindPhoneWithViewController:self entertype:JXEnterTypeSetChatFast];
    }
    
}
- (void)WH_dismiss_WHVerifyPayVC {
    [self.verVC.view removeFromSuperview];
    
}
- (void)WH_didVerifyPay:(NSString *)sender {
    self.passWord = sender;

    WH_JXUserObject *user = [[WH_JXUserObject alloc] init];
    user.payPassword = sender;
    [g_server WH_checkPayPasswordWithUser:user toView:self];
    
   
}
//服务端返回数据
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
     if ([aDownload.action isEqualToString:wh_act_CheckPayPassword]) {
//         if(![payPass isEqualToString:sender]){
//             [g_server showMsg:@"密码不正确，请重新输入"];
//
//             return;
//         }
         //过期时间
         NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
         NSTimeInterval a=[dat timeIntervalSince1970];
         NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
         
         NSString *passTime = [NSString stringWithFormat:@"%0.f",self.timeField.text.doubleValue * 60 + timeString.doubleValue];
         
         
         WH_FastRedModel *model = [[WH_FastRedModel alloc] init];
         model.amount = self.amountField.text;
         model.count = self.countField.text;
         model.passWord = self.passWord;
         model.time = passTime;
         model.isOn = @(self.switchBtn.on);
         //保存
         [JXServer setFastRedWithDic:model.mj_keyValues];
         
         [g_navigation WH_dismiss_WHViewController:self animated:YES];
    }

}
#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    [self.verVC WH_clearUpPassword];
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    [self.verVC WH_clearUpPassword];
    return WH_show_error;
}
#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    [_wait start];
}


@end
