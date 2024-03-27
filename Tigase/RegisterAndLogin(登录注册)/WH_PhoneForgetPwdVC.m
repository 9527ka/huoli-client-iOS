//
//  WH_PhoneForgetPwdVC.m
//  Tigase
//
//  Created by 1111 on 2024/3/27.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_PhoneForgetPwdVC.h"

@interface WH_PhoneForgetPwdVC (){
    ATMHud *_wait;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIView *accountBgView;
@property (weak, nonatomic) IBOutlet UIView *passWordBgView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@end

@implementation WH_PhoneForgetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _wait = [ATMHud sharedInstance];

    [self makeUI];
}
-(void)makeUI{
    self.accountBgView.layer.cornerRadius = 6.0f;
    self.passWordBgView.layer.cornerRadius = 6.0f;
    self.loginBtn.layer.cornerRadius = 24.0f;

}
- (IBAction)gobackAction:(id)sender {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
- (IBAction)codeAction:(id)sender {
    if(self.phoneField.text.length != 11){
        [g_server showMsg:@"请输入正确格式的手机号码"];
        return;
    }
    
    self.codeBtn.userInteractionEnabled = NO;
       //同时创建计时器 开始倒计时
        [self createTimer];
}
#pragma mark - 定时器 (GCD)
- (void)createTimer {
    //设置倒计时时间
    //通过检验发现，方法调用后，timeout会先自动-1，所以如果从15秒开始倒计时timeout应该写16
    //__block 如果修饰指针时，指针相当于弱引用，指针对指向的对象不产生引用计数的影响
    __block int timeout = 59;
   
    //获取全局队列
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建一个定时器，并将定时器的任务交给全局队列执行(并行，不会造成主线程阻塞)
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    
    // 设置触发的间隔时间
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //1.0 * NSEC_PER_SEC  代表设置定时器触发的时间间隔为1s
    //0 * NSEC_PER_SEC    代表时间允许的误差是 0s
    
     //block内部 如果对当前对象的强引用属性修改 应该使用__weak typeof(self)weakSelf 修饰  避免循环调用
    __weak typeof(self)weakSelf = self;
    //设置定时器的触发事件
    dispatch_source_set_event_handler(timer, ^{
        //倒计时  刷新button上的title ，当倒计时时间为0时，结束倒计时

        //1. 每调用一次 时间-1s
        timeout --;
        
        //2.对timeout进行判断时间是停止倒计时，还是修改button的title
        if (timeout <= 0) {
            //停止倒计时，button打开交互，背景颜色还原，title还原
            //关闭定时器
            dispatch_source_cancel(timer);
            
            //MRC下需要释放，这里不需要
//            dispatch_realse(timer);
            
            //button上的相关设置
            //注意: button是属于UI，在iOS中多线程处理时，UI控件的操作必须是交给主线程(主队列)
            //在主线程中对button进行修改操作
            dispatch_async(dispatch_get_main_queue(), ^{

                weakSelf.codeBtn.userInteractionEnabled = YES;
                [weakSelf.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else {

            //处于正在倒计时，在主线程中刷新button上的title，时间-1秒
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString * title = [NSString stringWithFormat:@"%d秒",timeout];
                
                [weakSelf.codeBtn setTitle:title forState:UIControlStateNormal];
            });
        }
    });
    
    dispatch_resume(timer);
}


- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    if(self.phoneField.text.length == 0 || self.phoneField.text.length != 11){
        [GKMessageTool showTips:@"手机号码格式不正确"];
        return;
    }
    
    if(self.codeField.text.length != 6){
        [GKMessageTool showTips:@"验证码格式不正确"];
        return;
    }
}
#pragma mark ------ 网络请求
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
//  if( [aDownload.action isEqualToString:wh_act_Config]){
//
//        [g_config didReceive:dict];
//
//
//        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//        [manager stopMonitoring];
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
//        return;
//    }
//
//    if( [aDownload.action isEqualToString:wh_act_UserLogin]){//所有登录类型
//        [g_default setObject:[dict objectForKey:@"payPassword"] forKey:PayPasswordKey];//登录成功时,保存一下支付密码的设置状态
//        if (isRegistSuccess) {
//            [g_App showMainUI];
//            [self actionQuit];
//
//            return;
//        }
//        [g_default setBool:NO forKey:kTHIRD_LOGIN_AUTO];
//        [g_default setBool:YES forKey:kIsAutoLogin];
//        [g_default setObject:currentLoginType == 0 ? userObject.telephone : userObject.account forKey:kMY_USER_LoginName];
//        [g_server doLoginOK:dict user:userObject];
//
//
////        if([aDownload.action isEqualToString:wh_act_UserLogin]) {
//            [g_default setBool:NO forKey:WH_ThirdPartyLogins];
//            g_config.lastLoginType = [NSNumber numberWithInteger:currentLoginType];
//
//            g_myself.password = [[g_server WH_getMD5StringWithStr:self.codeField.text] copy];
//            [[WH_JXUserObject sharedUserInstance] getCurrentUser];
//            [WH_JXUserObject sharedUserInstance].complete = ^(HttpRequestStatus status, NSDictionary * _Nullable userInfo, NSError * _Nullable error) {
//                [g_App showMainUI];
//                [self actionQuit];
//                [lunchImageView removeFromSuperview];
//            };
////        }
//        return;
//    }
//    if([aDownload.action isEqualToString:wh_act_UserLoginAuto]){
//        [lunchImageView removeFromSuperview];
//        [g_server doLoginOK:dict user:nil];
//        NSString *passwordsalt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"salt"]];
//        if (passwordsalt.length) {
//            [g_default setObject:passwordsalt forKey:kMY_USER_PASSWORDSalt];
//            [g_default synchronize];
//        }
//
//        [g_App showMainUI];
//        [self actionQuit];
//        [_wait stop];
//    }
   
}

#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict {
    [_wait stop];
    
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    
    return WH_show_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_MiXinStart:(WH_JXConnection*)aDownload{
     
    [_wait start];
}


@end
