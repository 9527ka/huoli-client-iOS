//
//  WH_JXLoginVC.m
//  Tigase
//
//  Created by 1111 on 2024/3/12.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXLoginVC.h"
#import "WH_JXLocation.h"
#import "WH_RegisterViewController.h"
#import "MiXin_forgetPwd_MiXinVC.h"
#import "WH_ForgetPwdForUserViewController.h"
#import "WH_CodeLoginVC.h"
#import "WH_PhoneForgetPwdVC.h"

@interface WH_JXLoginVC ()<JXLocationDelegate, UITextFieldDelegate>{
    BOOL isRegistSuccess; //!< 是否注册成功
    NSInteger currentLoginType; //!< 0 手机号， 1 用户名
    WH_JXLocation *userLocation; //!< 用户定位
    WH_JXUserObject *userObject; //!< 用户对象
    ATMHud *_wait;
    NSInteger tryCount;//重试次数
    UIImageView *lunchImageView; //!< 在自动登录时显示启动图
}
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;
@property (weak, nonatomic) IBOutlet UIButton *lockBtn;
@property (weak, nonatomic) IBOutlet UIView *accountBgView;
@property (weak, nonatomic) IBOutlet UIView *passWordBgView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *regiestBtn;

@end

@implementation WH_JXLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _wait = [ATMHud sharedInstance];
    [g_server getSetting:self];
    [self makeUI];
    [self setData];
    //不拿配置项，直接获取
    [self setUpDefaultValues];
    [self reSetConfigFile];
        
    [g_notify addObserver:self selector:@selector(onRegistered:) name:kRegistSuccessNotifaction object:nil];
    
}
#pragma mark ---- 获取启动图
// 获取启动图
- (NSString *)getLaunchImageName
{
    NSString *viewOrientation = @"Portrait";
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        viewOrientation = @"Landscape";
    }
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    return launchImageName;
}
-(void)setData{
    g_server.isLogin = NO;
    g_navigation.lastVC = nil;
    
    //先从服务器的config数据设定当前登录类型
    if (g_config.regeditPhoneOrName && [g_config.regeditPhoneOrName integerValue] != 2) {
        currentLoginType = [g_config.regeditPhoneOrName integerValue];
    }
    //如果不是首次登录，会保存登录类型，获取登录类型作为当前的类型
    currentLoginType = (g_config.lastLoginType != nil) ? [g_config.lastLoginType integerValue] : 0;//默认用户名登录
}
#pragma mark ---- Handle Data
- (void)setUpDefaultValues {
    [self setUpLoginStatus];
    if ([g_default objectForKey:kLocationLogin]) {
        NSDictionary *dict = [g_default objectForKey:kLocationLogin];
        g_server.longitude = [[dict objectForKey:@"longitude"] doubleValue];
        g_server.latitude = [[dict objectForKey:@"latitude"] doubleValue];
    }
}
- (void)setUpLoginStatus {
    if (g_config.regeditPhoneOrName && [g_config.regeditPhoneOrName integerValue] != 2) {
        currentLoginType = [g_config.regeditPhoneOrName integerValue];
    }
    
    NSString *loginName = [NSString stringWithFormat:@"%@",[g_default objectForKey:kMY_USER_LoginName]];
    NSString *userId = [NSString stringWithFormat:@"%@",[g_default objectForKey:kMY_USER_ID]];
    if (IsStringNull(loginName) || IsStringNull(userId)) {
        userObject = [[WH_JXUserObject alloc] init];
    }else{
        if (!IsStringNull(loginName) && ![userId isEqualToString:@"10000"]) {
            //从Document文件读取用户数据
            userObject = [WH_JXUserObject sharedUserInstance];
        }else {
            userObject = [[WH_JXUserObject alloc] init];
        }
    }
}
//设置配置文件
- (void)reSetConfigFile {
    self.regiestBtn.hidden = [g_config.isOpenRegister integerValue] == 1?NO:YES;
    // 自动登录失败，清除token后，重新赋值一次
    if (g_config.XMPPDomain) {
        if ([g_config.isOpenPositionService intValue] == 0) {
            if (IS_LOCATE_ATFIRST) {
                userLocation = [[WH_JXLocation alloc] init];
                userLocation.delegate = self;
                g_server.location = userLocation;
                [g_server locate];
            }
            
        }
    }
    BOOL autoLogin = [[g_default objectForKey:kIsAutoLogin] boolValue];
    NSString *userToken = [g_default objectForKey:kMY_USER_TOKEN];
    if(autoLogin && !IsStringNull(userToken)) {
        [self performSelector:@selector(autoLogin) withObject:nil afterDelay:.5];
    }else{
        [lunchImageView removeFromSuperview];
    }
}
-(void)autoLogin{
     [g_server autoLogin:self];
}
-(void)onRegistered:(NSNotification *)notifacation{
    isRegistSuccess = YES;
    [[JXServer sharedServer] login:g_myself loginType:currentLoginType toView:self];
}
-(void)makeUI{
    self.logoImage.layer.cornerRadius = 16.0f;
    self.accountBgView.layer.cornerRadius = 24.0f;
    self.passWordBgView.layer.cornerRadius = 24.0f;
    self.loginBtn.layer.cornerRadius = 24.0f;
    [self.lockBtn setImage:[UIImage imageNamed:@"pass_look"] forState:UIControlStateSelected];
    [self.lockBtn setImage:[UIImage imageNamed:@"pass_lock"] forState:UIControlStateNormal];
    
    if (self.isShow) {
        lunchImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        lunchImageView.image = [UIImage imageNamed:[self getLaunchImageName]];
        [self.view addSubview:lunchImageView];
    }
    
    
//    NSString *str = [g_default objectForKey:kMY_USER_NICKNAME];
//    NSString *userId = [g_default objectForKey:kMY_USER_ID];
//
//    if(str.length > 0 && userId.length > 0){
//        [g_server WH_getHeadImageLargeWithUserId:userId userName:str imageView:self.logoImage];
//        self.nameLab.text = str;
//    }
}

- (IBAction)lockBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.passWordField.secureTextEntry = !sender.selected;
}

- (IBAction)forgetPasswordAction:(id)sender {
    [self.view endEditing:YES];
    WH_PhoneForgetPwdVC *vc = [[WH_PhoneForgetPwdVC alloc] init];
    [g_navigation pushViewController:vc animated:YES];
//    if (currentLoginType == 1) {ddddd
//        WH_ForgetPwdForUserViewController *pwsVC = [[WH_ForgetPwdForUserViewController alloc] init];
//        pwsVC.forgetStep = 1;
//        [g_navigation pushViewController:pwsVC animated:YES];
//        return;
//    }
//    MiXin_forgetPwd_MiXinVC* vc = [[MiXin_forgetPwd_MiXinVC alloc] init];
//    vc.isModify = NO;
//    vc.forgetType = currentLoginType;
//    [g_navigation pushViewController:vc animated:YES];
}
- (IBAction)regiestAction:(id)sender {
    [self.view endEditing:YES];
    WH_RegisterViewController *vc = [[WH_RegisterViewController alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}
- (IBAction)codeLoginAction:(id)sender {
    WH_CodeLoginVC *vc = [[WH_CodeLoginVC alloc] init];
    vc.type = 0;
    [g_navigation pushViewController:vc animated:YES];
}

- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    if(self.accountField.text.length == 0){
        [GKMessageTool showTips:@"请输入账号"];
        return;
    }

    if(self.passWordField.text.length == 0){
        [GKMessageTool showTips:@"请输入密码"];
        return;
    }
    userObject.areaCode = g_myself.areaCode.length > 0?g_myself.areaCode:@"86";
    userObject.password = [g_server WH_getMD5StringWithStr:self.passWordField.text];
    userObject.phone = self.accountField.text;
    userObject.telephone = self.accountField.text;
    userObject.account = self.accountField.text;
    
    [_wait start];
    [[JXServer sharedServer] login:userObject loginType:currentLoginType toView:self];
}
-(void)actionQuit{
    [_wait stop];
    [g_server stopConnection:self];
    [g_window endEditing:YES];
    [g_notify removeObserver:self];
    
}
#pragma mark ------ 网络请求
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
  if( [aDownload.action isEqualToString:wh_act_Config]){
        
        [g_config didReceive:dict];
        
        [self setUpDefaultValues];
    
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager stopMonitoring];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reSetConfigFile];
        });
        return;
    }
    
    if( [aDownload.action isEqualToString:wh_act_UserLogin]){//所有登录类型
        [g_default setObject:[dict objectForKey:@"payPassword"] forKey:PayPasswordKey];//登录成功时,保存一下支付密码的设置状态
        if (isRegistSuccess) {
            [g_App showMainUI];
            [self actionQuit];
            
            return;
        }
        [g_default setBool:NO forKey:kTHIRD_LOGIN_AUTO];
        [g_default setBool:YES forKey:kIsAutoLogin];
        [g_default setObject:currentLoginType == 0 ? userObject.telephone : userObject.account forKey:kMY_USER_LoginName];
        [g_server doLoginOK:dict user:userObject];
        
        
//        if([aDownload.action isEqualToString:wh_act_UserLogin]) {
            [g_default setBool:NO forKey:WH_ThirdPartyLogins];
            g_config.lastLoginType = [NSNumber numberWithInteger:currentLoginType];
            
            g_myself.password = [[g_server WH_getMD5StringWithStr:self.passWordField.text] copy];
            [[WH_JXUserObject sharedUserInstance] getCurrentUser];
            [WH_JXUserObject sharedUserInstance].complete = ^(HttpRequestStatus status, NSDictionary * _Nullable userInfo, NSError * _Nullable error) {
                [g_App showMainUI];
                [self actionQuit];
                [lunchImageView removeFromSuperview];
            };
//        }
        return;
    }
    if([aDownload.action isEqualToString:wh_act_UserLoginAuto]){
        [lunchImageView removeFromSuperview];
        [g_server doLoginOK:dict user:nil];
        NSString *passwordsalt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"salt"]];
        if (passwordsalt.length) {
            [g_default setObject:passwordsalt forKey:kMY_USER_PASSWORDSalt];
            [g_default synchronize];
        }
        
        [g_App showMainUI];
        [self actionQuit];
        [_wait stop];
    }
   
}

#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict {
    [_wait stop];
   if ([aDownload.action isEqualToString:wh_act_Config]) {
        
        NSString *url = [g_default stringForKey:kLastApiUrl];
        if (url && [url isKindOfClass:[NSString class]] && url.length) {
            g_config.apiUrl = url;
        }else{
            g_config.apiUrl = BaseUrl;
        }
        
        if(tryCount < 3){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                tryCount ++;
                //重新请求
                [g_server getSetting:self];

            });
        }
        
        [self reSetConfigFile];
        return WH_hide_error;
    }else if([aDownload.action isEqualToString:wh_act_UserLoginAuto]){
        [g_default removeObjectForKey:kMY_USER_TOKEN];
        [share_defaults removeObjectForKey:kMY_ShareExtensionToken];
        [lunchImageView removeFromSuperview];
    }
    
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [lunchImageView removeFromSuperview];
    if ([aDownload.action isEqualToString:wh_act_Config]) {
        
        NSString *url = [g_default stringForKey:kLastApiUrl];
        if (url && [url isKindOfClass:[NSString class]] && url.length) {
            g_config.apiUrl = url;
        }else{
            g_config.apiUrl = BaseUrl;
        }
        
        if(tryCount < 3){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                tryCount ++;
                //重新请求
                [g_server getSetting:self];
            });
        }
        
        [self reSetConfigFile];
        
        return WH_hide_error;
    }
    if([aDownload.action isEqualToString:wh_act_UserLoginAuto]){
        [g_default removeObjectForKey:kMY_USER_TOKEN];
        [share_defaults removeObjectForKey:kMY_ShareExtensionToken];
    }
    if ([aDownload.action isEqualToString:wh_act_thirdLogin]) {
        g_server.openId = nil;
    }
    
    [_wait stop];
    return WH_show_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_MiXinStart:(WH_JXConnection*)aDownload{
    if([aDownload.action isEqualToString:wh_act_thirdLogin] || [aDownload.action isEqualToString:act_sdkLogin]|| [aDownload.action isEqualToString:act_otherLogin]){
        [_wait start];
    }else{
        [_wait start];
    }
}

#pragma mark ----- JXLocationDelegate
- (void) location:(WH_JXLocation *)location CountryCode:(NSString *)countryCode CityName:(NSString *)cityName CityId:(NSString *)cityId Address:(NSString *)address Latitude:(double)lat Longitude:(double)lon {
    g_server.countryCode = countryCode;
    g_server.cityName = cityName;
    g_server.cityId = [cityId intValue];
    g_server.address = address;
    g_server.latitude = lat;
    g_server.longitude = lon;
    NSDictionary *dict = @{@"latitude":@(lat),@"longitude":@(lon)};
    [g_default setObject:dict forKey:kLocationLogin];
}

- (void)location:(WH_JXLocation *)location getLocationWithIp:(NSDictionary *)dict {
    
}
- (void)location:(WH_JXLocation *)location getLocationError:(NSError *)error {
    
}

@end
