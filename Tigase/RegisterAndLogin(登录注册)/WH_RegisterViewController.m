//
//  WH_RegisterViewController.m
//  Tigase
//
//  Created by 1111 on 2024/3/12.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_RegisterViewController.h"
#import "WH_webpage_WHVC.h"
#import "WH_PSRegisterBaseVC.h"
#import "WH_CodeLoginVC.h"

@interface WH_RegisterViewController (){
    ATMHud *_wait;
}

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *certainLockBtn;
@property (weak, nonatomic) IBOutlet UITextField *certainPassField;
@property (weak, nonatomic) IBOutlet UIButton *lockBtn;
@property (weak, nonatomic) IBOutlet UIView *accountBgView;
@property (weak, nonatomic) IBOutlet UIView *passWordBgView;
@property (weak, nonatomic) IBOutlet UIView *certainPassWordBgView;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *regiestBtn;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UITextField *imageField;
@property (weak, nonatomic) IBOutlet UIView *codeImageBgView;

@end

@implementation WH_RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _wait = [ATMHud sharedInstance];
    [self makeUI];
    [self.phoneField addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
}
-(void)makeUI{
    self.logoImage.layer.cornerRadius = 16.0f;
    self.accountBgView.layer.cornerRadius = 24.0f;
    self.passWordBgView.layer.cornerRadius = 24.0f;
    self.codeImageBgView.layer.cornerRadius = 24.0f;
    self.codeBgView.layer.cornerRadius = 24.0f;
    self.certainPassWordBgView.layer.cornerRadius = 24.0f;
    self.regiestBtn.layer.cornerRadius = 24.0f;
    [self.lockBtn setImage:[UIImage imageNamed:@"pass_look"] forState:UIControlStateSelected];
    [self.lockBtn setImage:[UIImage imageNamed:@"pass_lock"] forState:UIControlStateNormal];
    [self.certainLockBtn setImage:[UIImage imageNamed:@"pass_look"] forState:UIControlStateSelected];
    [self.certainLockBtn setImage:[UIImage imageNamed:@"pass_lock"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getImgCodeImg)];
    [self.codeImage addGestureRecognizer:tap];
    
}
-(void)textChangeAction:(UITextField *)textField{
    if(textField == self.phoneField){
        if(self.phoneField.text.length > 11){
            self.phoneField.text = [textField.text substringToIndex:11];
        }
        if(self.phoneField.text.length == 11){//获取图形验证码
            [self getImgCodeImg];
        }
    }
}

-(void)getImgCodeImg{
    if(self.phoneField.text.length == 11){
        //    if ([self checkPhoneNum]) {
        //请求图片验证码
        NSString *areaCode = @"86";
        NSString *codeUrl = [g_server getImgCode:self.phoneField.text areaCode:areaCode];

        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:codeUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            if (!connectionError) {
                UIImage * codeImage = [UIImage imageWithData:data];
                self.codeImage.image = codeImage;
            }else{
                //NSLog(@"%@",connectionError);
                [g_App showAlert:connectionError.localizedDescription];
            }
        }];
    }
    
}
- (IBAction)codeAction:(id)sender {
    if(self.phoneField.text.length != 11){
        [g_server showMsg:@"请输入正确格式的手机号码"];
        return;
    }
    if(self.imageField.text.length == 0){
        [g_server showMsg:@"请输入图形码"];
        return;
    }
    
    //type;//0登录  1注册   isRegister,    数字类型, 1-注册,2-登录
    [g_server WH_sendSMSCodeWithTel:[NSString stringWithFormat:@"%@",self.phoneField.text] areaCode:@"" isRegister:1 imgCode:self.imageField.text toView:self];
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
//300+
- (IBAction)lockBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.tag == 300){
        self.passWordField.secureTextEntry = !sender.selected;
    }else{
        self.certainPassField.secureTextEntry = !sender.selected;
    }
}
- (IBAction)gobackAction:(id)sender {
    [self actionQuit];
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
-(void)actionQuit{
    [_wait stop];
    [g_server stopConnection:self];
    [g_window endEditing:YES];
    [g_notify removeObserver:self];
    
}
- (IBAction)loginAction:(id)sender {
    //返回上一级
    UIViewController *goVC = [g_navigation.subViews objectAtIndex:(g_navigation.subViews.count >= 2 ? (g_navigation.subViews.count - 2):0)];
    [g_navigation popToViewController:[goVC class] animated:YES];
}


- (IBAction)regiestAction:(id)sender {
    [self.view endEditing:YES];
    if(self.phoneField.text.length != 11){
        [GKMessageTool showTips:@"请输入正确手机号码"];
        return;
    }
    if (self.passWordField.text.length < 6 || self.certainPassField.text.length < 6) {
        [GKMessageTool showTips:Localized(@"PasswordRegistFomatError")];
        return;
    }
    if(![self.passWordField.text isEqualToString:self.certainPassField.text]){
        [GKMessageTool showTips:@"两次密码不一致"];
        return;
    }
    
    if(self.codeField.text.length == 0){
        [GKMessageTool showTips:@"请输入验证码"];
        return;
    }
    [_wait start];
    
    [g_server phoneRegiestWithTelephone:self.phoneField.text password:self.passWordField.text smsCode:self.codeField.text toView:self];
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
  
    if([aDownload.action isEqualToString:wh_act_RegisterPhone]){
        [g_default setObject:[dict objectForKey:@"payPassword"] forKey:PayPasswordKey];//登录成功时,保存一下支付密码的设置状态
        [g_default setBool:NO forKey:kTHIRD_LOGIN_AUTO];
        [g_default setBool:YES forKey:kIsAutoLogin];
        [g_default setObject:self.phoneField.text forKey:kMY_USER_LoginName];
        
        WH_JXUserObject *userObject = [[WH_JXUserObject alloc] init];
        userObject.areaCode = @"86";
        userObject.password = [g_server WH_getMD5StringWithStr:self.passWordField.text];
        userObject.phone = self.phoneField.text;
        userObject.telephone = self.phoneField.text;
        userObject.account = self.phoneField.text;
        
        [g_server doLoginOK:dict user:userObject];
        
            [g_default setBool:NO forKey:WH_ThirdPartyLogins];
            g_config.lastLoginType = [NSNumber numberWithInteger:0];
            g_myself.password = [[g_server WH_getMD5StringWithStr:self.passWordField.text] copy];
            [[WH_JXUserObject sharedUserInstance] getCurrentUser];
            [WH_JXUserObject sharedUserInstance].complete = ^(HttpRequestStatus status, NSDictionary * _Nullable userInfo, NSError * _Nullable error) {
                [g_App showMainUI];
                [self actionQuit];
            };
    }else if ([aDownload.action isEqualToString:wh_act_SendSMS]){
        self.codeBtn.userInteractionEnabled = NO;
           //同时创建计时器 开始倒计时
            [self createTimer];
    }
}

#pragma mark - 请求失败回调

-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    return WH_show_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    
}

//-(void)pushToBasicInfoViewController {
//    WH_JXUserObject* user = [[WH_JXUserObject alloc] init];
//    user.telephone = self.phoneField.text;
//    [g_default setObject:user.telephone forKey:kMY_USER_LoginName];//下次进入登录页面时需要用来判断是否显示头像
//    user.password  = [g_server WH_getMD5StringWithStr:self.passWordField.text];
////    user.areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
//    user.areaCode = @"86";
//    //    user.companyId = [NSNumber numberWithInt:self.isCompany];
//    WH_PSRegisterBaseVC* vc = [WH_PSRegisterBaseVC alloc];
//    vc.isSmsRegister = NO;
//    vc.registType = 1;
//    vc.user       = user;
//    vc.smsCode = nil;
//    vc = [vc init];
//    [g_navigation pushViewController:vc animated:YES];
//
//    [self actionQuit];
//}

- (IBAction)rulerActon:(id)sender {
    WH_webpage_WHVC * webVC = [WH_webpage_WHVC alloc];
    webVC.url = [self protocolUrl];
    webVC.isSend = NO;
    webVC = [webVC init];
    webVC.isGoBack = YES;
    [g_navigation pushViewController:webVC animated:YES];
}
-(NSString *)protocolUrl{
    NSString * protocolStr = [NSString stringWithFormat:@"http://%@/agreement/",PrivacyAgreementBaseApiUrl];
    NSString * lange = g_constant.sysLanguage;
    if (![lange isEqualToString:ZHHANTNAME] && ![lange isEqualToString:NAME]) {
        lange = ENNAME;
    }
//    return [NSString stringWithFormat:@"%@%@.html",protocolStr,lange];
    return  [NSString stringWithFormat:@"%@/pages/terms/register_term.html",BaseUrl];;
}

@end
