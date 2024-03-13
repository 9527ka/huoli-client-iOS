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

@interface WH_RegisterViewController (){
    ATMHud *_wait;
}

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;
@property (weak, nonatomic) IBOutlet UIButton *certainLockBtn;
@property (weak, nonatomic) IBOutlet UITextField *certainPassField;
@property (weak, nonatomic) IBOutlet UIButton *lockBtn;
@property (weak, nonatomic) IBOutlet UIView *accountBgView;
@property (weak, nonatomic) IBOutlet UIView *passWordBgView;
@property (weak, nonatomic) IBOutlet UIView *certainPassWordBgView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *regiestBtn;

@end

@implementation WH_RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _wait = [ATMHud sharedInstance];
    [self makeUI];
    
}
-(void)makeUI{
    self.logoImage.layer.cornerRadius = 16.0f;
    self.accountBgView.layer.cornerRadius = 24.0f;
    self.passWordBgView.layer.cornerRadius = 24.0f;
    self.certainPassWordBgView.layer.cornerRadius = 24.0f;
    self.regiestBtn.layer.cornerRadius = 24.0f;
    [self.lockBtn setImage:[UIImage imageNamed:@"pass_look"] forState:UIControlStateSelected];
    [self.lockBtn setImage:[UIImage imageNamed:@"pass_lock"] forState:UIControlStateNormal];
    [self.certainLockBtn setImage:[UIImage imageNamed:@"pass_look"] forState:UIControlStateSelected];
    [self.certainLockBtn setImage:[UIImage imageNamed:@"pass_lock"] forState:UIControlStateNormal];
    
    
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
    if(self.accountField.text.length == 0){
        [GKMessageTool showTips:@"请输入用户名"];
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
   
    [_wait start];
//    if (self.registType == 0) {
//        NSString *areaCode = @"86";
//        NSDictionary *params = @{@"telephone":self.accountField.text, @"smsCode": @"", @"areaCode": areaCode};
//        NSMutableDictionary *mutParams = [[NSMutableDictionary alloc] initWithDictionary:params];
//        [g_server checkPhoneNum:mutParams toView:self];
//    }else {
        [g_server checkUser:self.accountField.text inviteCode:nil toView:self];
//    }
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
  
    if([aDownload.action isEqualToString:wh_act_CheckPhone]){
        [self pushToBasicInfoViewController];
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

-(void)pushToBasicInfoViewController {
    WH_JXUserObject* user = [[WH_JXUserObject alloc] init];
    user.telephone = self.accountField.text;
    [g_default setObject:user.telephone forKey:kMY_USER_LoginName];//下次进入登录页面时需要用来判断是否显示头像
    user.password  = [g_server WH_getMD5StringWithStr:self.passWordField.text];
//    user.areaCode = [_areaCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
    user.areaCode = @"86";
    //    user.companyId = [NSNumber numberWithInt:self.isCompany];
    WH_PSRegisterBaseVC* vc = [WH_PSRegisterBaseVC alloc];
    vc.isSmsRegister = NO;
    vc.registType = 1;
    vc.user       = user;
    vc.smsCode = nil;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
    
    [self actionQuit];
}

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
