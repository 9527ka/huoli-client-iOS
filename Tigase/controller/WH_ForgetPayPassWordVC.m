//
//  WH_ForgetPayPassWordVC.m
//  Tigase
//
//  Created by 1111 on 2024/4/19.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_ForgetPayPassWordVC.h"
#import "NSString+ContainStr.h"


@interface WH_ForgetPayPassWordVC (){
    ATMHud *_wait;
}
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIView *accountBgView;

@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UITextField *imageField;
@property (weak, nonatomic) IBOutlet UIView *codeImageBgView;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@property (weak, nonatomic) IBOutlet UIView *passWordBgView;
@property (weak, nonatomic) IBOutlet UIView *certainPassWordBgView;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;
@property (weak, nonatomic) IBOutlet UIButton *certainLockBtn;
@property (weak, nonatomic) IBOutlet UITextField *certainPassField;
@property (weak, nonatomic) IBOutlet UIButton *lockBtn;

@end

@implementation WH_ForgetPayPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _wait = [ATMHud sharedInstance];
    [self makeUI];
    [self getImgCodeImg];
    [self.imageField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [self.codeField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [self.passWordField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [self.certainPassField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
}
-(void)makeUI{
    self.accountBgView.layer.cornerRadius = 8.0f;
    self.codeImageBgView.layer.cornerRadius = 8.0f;
    self.nextBtn.layer.cornerRadius = 24.0f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getImgCodeImg)];
    [self.codeImage addGestureRecognizer:tap];
    
    NSString *phoneStr = [NSString stringWithFormat:@"请输入%@手机号码收到的验证码验证身份",g_myself.phone];
    self.phoneLab.attributedText = [NSString changeSpecialWordColor:THEMECOLOR AllContent:phoneStr SpcWord:g_myself.phone font:16];
}
-(void)textFieldAction:(UITextField *)textField{
    if(textField == self.codeField){
        if(self.codeField.text.length > 6){
            self.codeField.text = [self.codeField.text substringToIndex:6];
            [self.passWordField becomeFirstResponder];
        }
    }
    if(textField == self.passWordField){
        if(self.passWordField.text.length > 6){
            self.passWordField.text = [self.passWordField.text substringToIndex:6];
            [self.certainPassField becomeFirstResponder];
        }
    }
    if(textField == self.certainPassField){
        if(self.certainPassField.text.length > 6){
            self.certainPassField.text = [self.certainPassField.text substringToIndex:6];
        }
    }
}
-(void)getImgCodeImg{
    if(g_myself.phone.length == 11){
        //    if ([self checkPhoneNum]) {
        //请求图片验证码
        NSString *areaCode = @"86";
        NSString *codeUrl = [g_server getImgCode:g_myself.phone areaCode:areaCode];

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
   
    if(self.imageField.text.length == 0){
        [g_server showMsg:@"请输入图形码"];
        return;
    }
    
    //type;//0登录  1注册   isRegister,    数字类型, 1-注册,2-登录
    [g_server WH_sendSMSCodeWithTel:[NSString stringWithFormat:@"%@",g_myself.phone] areaCode:@"" isRegister:4 imgCode:self.imageField.text toView:self];
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
//300+
- (IBAction)lockBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.tag == 300){
        self.passWordField.secureTextEntry = !sender.selected;
    }else{
        self.certainPassField.secureTextEntry = !sender.selected;
    }
}
- (IBAction)nextAction:(id)sender {
    if(self.codeField.text.length == 0){
        [GKMessageTool showTips:@"请输入验证码"];
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
    [g_server forgetPayPswWithCode:self.codeField.text newPassword:self.passWordField.text toView:self];
    
}


#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
  
    if([aDownload.action isEqualToString:wh_act_forgetPayPassword_sms]){
        [g_server showMsg:@"设置成功"];
        [g_navigation WH_dismiss_WHViewController:self animated:YES];
    }else if([aDownload.action isEqualToString:wh_act_SendSMS]){
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


@end
