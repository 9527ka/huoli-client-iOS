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
@property (weak, nonatomic) IBOutlet UITextField *intervalField;//红包发送金额

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (nonatomic, strong) WH_JXVerifyPay_WHVC * verVC;
@property (nonatomic,copy) NSString *passWord;
@property (weak, nonatomic) IBOutlet UISwitch *passSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *randowSwitch;
@property (weak, nonatomic) IBOutlet UITextField *randowCountField;

@property (weak, nonatomic) IBOutlet UISwitch *remarkSwitchBtn;
@property (weak, nonatomic) IBOutlet UITextField *remarkField;

@property (weak, nonatomic) IBOutlet UISwitch *circulationSwitchBtn;
@property (weak, nonatomic) IBOutlet UITextField *circulationField;


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
        self.intervalField.text = model.timeInter;
        self.randowCountField.text = model.randowCount;
        self.randowSwitch.on = model.isRandow.boolValue;
        self.remarkField.text = model.remark;
        self.remarkSwitchBtn.on = model.isRmarkOn.boolValue;
        self.circulationField.text = model.circle;
        self.circulationSwitchBtn.on = model.isCirclekOn.boolValue;
        self.passSwitch.on = model.isNoPas.boolValue;
    }
    
}
- (IBAction)backAction:(id)sender {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
//随机 固定 循环 500+
- (IBAction)switchAction:(UISwitch *)sender {
    if(sender.tag == 500 && sender.on){//随机
        self.remarkSwitchBtn.on = NO;
        self.circulationSwitchBtn.on = NO;
    }else if (sender.tag == 501 && sender.on){//固定
        self.randowSwitch.on = NO;
        self.circulationSwitchBtn.on = NO;
    }else if (sender.tag == 502 && sender.on){//循环
        self.randowSwitch.on = NO;
        self.remarkSwitchBtn.on = NO;
    }
    
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
    if(self.intervalField.text.length == 0 || self.intervalField.text.floatValue < 5){
        [g_server showMsg:@"红包发送间隔不能少于5秒"];
        return;
    }
    if(self.randowSwitch.on){//开启了随机位数
        if(self.randowCountField.text.length == 0){
            [g_server showMsg:@"请输入随机位数"];
            return;
        }
        if(self.randowCountField.text.intValue > 5 || self.randowCountField.text.intValue < 1){//随机位数：1、2、3、4、5（位）
            [g_server showMsg:@"请输入1~5随机位数"];
            
            self.randowCountField.text = @"5";
            
            return;
        }
        
    }
//    if(self.remarkSwitchBtn.on){//开启了固定留言
//        if(self.remarkField.text.length == 0){
//            [g_server showMsg:@"请输入固定留言内容"];
//            return;
//        }
//    }
    
    if(self.circulationSwitchBtn.on){//开启了固定留言
        if(self.circulationField.text.length == 0){
            [g_server showMsg:@"请输入循环留言内容"];
            return;
        }
    }
    //判断是否有开启留言模式
    if(!self.circulationSwitchBtn.on && !self.remarkSwitchBtn.on && !self.randowSwitch.on){
        [g_server showMsg:@"请开启至少一种留言模式"];
        return;
    }
    
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
         model.timeInter = self.intervalField.text;
         model.passWord = self.passWord;
//         model.time = passTime;
         model.time = @"0";//[WH_FastRedModel receiveNowInterval]
         model.isRandow = @(self.randowSwitch.on);
         model.randowCount = self.randowCountField.text;
         model.isNoPas = @(self.passSwitch.on);
         model.isRmarkOn = @(self.remarkSwitchBtn.on);
         if(self.remarkSwitchBtn.on && self.remarkField.text.length == 0){//开启了固定留言
             model.remark = @"恭喜发财 大吉大利";
         }else{
             model.remark = self.remarkField.text;
         }
         
         model.isCirclekOn = @(self.circulationSwitchBtn.on);
         model.circle = self.circulationField.text;
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
