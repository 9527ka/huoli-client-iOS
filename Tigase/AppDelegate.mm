#import "AppDelegate.h"

#import "WH_JXMain_WHViewController.h"
#import "emojiViewController.h"
#import "JXXMPP.h"
#import "WH_VersionManageTool.h"
#import "WH_JXGroup_WHViewController.h"
#import "WH_JXLoginVC.h"
#import "BPush.h"
#if Meeting_Version
#if !TARGET_IPHONE_SIMULATOR
#import <JitsiMeet/JitsiMeet.h>
#endif
#endif
#ifdef USE_GOOGLEMAP
#endif
#import "WH_NumLock_WHViewController.h"
#import <Bugly/Bugly.h>
#import "WH_JXLoginVC.h"
#import "WH_AdvertisingViewController.h"
#import "WH_JXMsg_WHViewController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate+ShareSDK.h"
#import "WH_JXUserObject+GetCurrentUser.h"
#import "WH_webpage_WHVC.h"
#import "AvoidCrash.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
# import <AlipaySDK/AlipaySDK.h>


/**
 applinks:keyuan.tuishenqi.com
 
 */
@implementation AppDelegate
@synthesize window,faceView,mainVc;

#if TAR_IM
#ifdef Meeting_Version
@synthesize jxMeeting;
#endif
#endif

static  WH_webpage_WHVC *webVC;

- (void)dealloc
{
#if TAR_IM
#ifdef Meeting_Version
    [jxMeeting WH_stopMeeting];
#endif
#endif
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    application.statusBarStyle = UIStatusBarStyleDefault;
        
    _navigation = [[JXNavigation alloc] init];
    
    //以防拿不到配置，先写死配置项
    [self setConfiguration];
    
    
    // 网络监听
//    [self networkStatusChange];
    // 监听截屏
//    [g_notify addObserver:self selector:@selector(getScreenShot:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
//    if(isIOS7){
//        application.statusBarStyle = UIStatusBarStyleDefault;
//        window.clipsToBounds = YES;
//        window.frame = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height-20);
//    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    _didPushObj = [WH_JXDidPushObj sharedInstance];

#if TAR_IM
#ifdef Meeting_Version
    jxMeeting = [[WH_JXMeetingObject alloc] init];
    [self startVoIPPush];
#endif
#endif
    
//    [NSThread sleepForTimeInterval:0.3];
    
    [self showLoginUI];
    [self startPush:application didFinishLaunchingWithOptions:launchOptions];
    
    
    //谷歌地图
//#ifdef USE_GOOGLEMAP
//#endif

    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    

    [self registerAPN];
    
    [self setUserAgent];
    
    NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    [g_notify postNotificationName:kDidReceiveRemoteNotification object:pushNotificationKey];
    [g_default setObject:pushNotificationKey forKey:kDidReceiveRemoteDic];
    [g_default synchronize];
    
    // 设置腾讯奔溃日志
    [Bugly startWithAppId:BUGLY_APPID];
    //注册键盘
    [self regiestBord];
    
    
    return YES;
}

//设置配置线
-(void)setConfiguration{
    if(![BaseUrl containsString:@"http://im.liehuo.sho"]){
        return;
    }
    
    NSDictionary *dict = @{@"PCXMPPDomain":@"huoli68.com",@"PCXMPPHost":@"119.45.151.171",@"XMPPDomain":@"huoli68.com",@"XMPPHost":@"119.45.151.171",@"XMPPPort":@(5222),@"XMPPTimeout":@(180),@"address":@"CN",@"aliLoginStatus":@(2),@"aliPayStatus":@(1),@"aliWithdrawStatus":@(1),@"androidAppUrl":@"",@"androidDisable":@"",@"androidExplain":@"",@"androidVersion":@(0),@"apiUrl":@"http://im.liehuo.shop/im/",@"appleId":@"",@"audioLen":@"20",@"bucketName":@"liehuo",@"chatRecordTimeOut":@(-1),@"copyrightInfo":@"",@"cusServerUrl":@"",@"displayRedPacket":@(1),@"distance":@(20),@"downloadAvatarUrl":@"http://img.liehuo.shop/",@"downloadUrl":@"",@"endPoint":@"obs.cn-south-1.myhuaweicloud.com",@"fileValidTime":@(-1),@"guideWebsite":@"",@"headBackgroundImg":@"",@"helpUrl":@"",@"hideSearchByFriends":@(1),@"hmPayStatus":@(2),@"hmWithdrawStatus":@(2),@"invisibleList":@[],@"iosAppUrl":@"",@"iosDisable":@"",@"iosExplain":@"",@"iosVersion":@(0),@"ipAddress":@"0.0.0.0",@"isAudioStatus":@(0),@"isCommonCreateGroup":@(0),@"isCommonFindFriends":@(0),@"isDelAfterReading":@(1),@"isDiscoverStatus":@(1),@"isEnableCusServer":@(1),@"isNodesStatus":@(0),@"isOpenCluster":@(0),@"isOpenDHRecharge":@(0),@"isOpenGoogleFCM":@(0),@"isOpenOSStatus":@(0),@"isOpenPositionService":@(1),@"isOpenReadReceipt":@(1),@"isOpenReceipt":@(1),@"isOpenRegister":@(1),@"isOpenSMSCode":@(1),@"isOpenTelnum":@(1),@"isOpenTwoBarCode":@(1),@"isQestionOpen":@(1),@"isTabBarStatus":@(1),@"isUserSignRedPacket":@(0),@"isWeiBaoStatus":@(0),@"isWithdrawToAdmin":@(0),@"jiGuangStatus":@(2),@"jitsiServer":@"",@"liveUrl":@"",@"location":@"cn-south-1",@"macAppUrl":@"",@"macDisable":@"",@"macExplain":@"",@"macVersion":@(0),@"maxSendRedPagesAmount":@(500.0),@"maxTransferAmount":@(20000.0),@"minTransferAmount":@(50.0),@"minWithdrawToAdmin":@(50.0),@"nicknameSearchUser":@(0),@"osName":@"huawei",@"osType":@(1),@"pcVersion":@(0),@"popularAPP":@"{\"lifeCircle\":1,\"videoMeeting\":1,\"liveVideo\":1,\"shortVideo\":1,\"peopleNearby\":1,\"scan\":1}",@"qqLoginStatus":@(2),@"regeditPhoneOrName":@(1),@"registerInviteCode":@(0),@"shareUrl":@"",@"showContactsUser":@(0),@"softUrl":@"",@"sysRechargeTip":@"充值到平台",@"sysUsdtUrl":@"TTRBNLLNq1CoJSPPwRXEg71cELX9CCSWwE",@"tabBarConfigList":@{@"tabBarNum":@(0),@"tabBarStatus":@(0)},@"telegram":@"",@"tlPayStatus":@(2),@"tlWithdrawStatus":@(2),@"transferRate":@(1.0),@"uploadMaxSize":@(20),@"uploadUrl":@"http://upload.liehuo.shop/",@"videoLen":@"20",@"webDownloadUrl":@"",@"webNewUrl":@"",@"website":@"",@"wechatAppId":@"qrq",@"wechatH5LoginStatus":@(2),@"wechatLoginStatus":@(2),@"wechatPayStatus":@(1),@"wechatWithdrawStatus":@(1),@"weiBaoMaxRedPacketAmount":@(0.0),@"weiBaoMaxTransferAmount":@(0.0),@"weiBaoMinTransferAmount":@(0.0),@"weiBaoTransferRate":@(0.0),@"weiPayStatus":@(2),@"weiWithdrawStatus":@(2),@"whatsApp":@"",@"xmppPingTime":@(72),@"yunPayStatus":@(2),@"yunWithdrawStatus":@(2)};
    //查看本地是否有配置项
    if([JXServer receiveConfigon]){
        dict = [JXServer receiveConfigon];
    }
    [g_config didReceive:dict];
}

//注册键盘
-(void)regiestBord{
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    keyboardManager.enableAutoToolbar = NO;
    keyboardManager.shouldShowToolbarPlaceholder = NO;
}



- (void)setUserAgent {
    WKWebView *webView = [[WKWebView alloc] init];
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id obj, NSError *error) {
    if([obj isKindOfClass:[NSString class]]) {
        NSString *originUA = obj;
        NSString *newUA = [NSString stringWithFormat:@"%@ %@",originUA,@"app-tigimapp"];
        NSDictionary *dictionary = @{@"UserAgent":newUA};
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    }
    }];
}

- (void)registerAPN{
       if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
     //iOS10特有
     UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
     // 必须写代理，不然无法监听通知的接收与点击
     center.delegate = self;
     [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
      if (granted) {
       // 点击允许
       //NSLog(@"注册成功");
       [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//        //NSLog(@"%@", settings);
       }];
      } else {
       // 点击不允许
       //NSLog(@"注册失败");
      }
     }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    }
    // 注册push权限，用于显示本地推送
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//       else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
//      UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    }
}

-(UIView *)subWindow
{
    if (!_subWindow) {
        _subWindow = [[UIView alloc] initWithFrame:CGRectMake(100,200,80,80)];
//        _subWindow.windowLevel  =  UIWindowLevelAlert +1;
//        [_subWindow makeKeyAndVisible]; //关键语句，显示窗口
        [g_window addSubview:_subWindow];
    }
    
    return _subWindow;
}
/**
*开启悬浮的窗口
*/
- (void)showSuspensionWindow
{
    BOOL SUPPORT_FLOATING_WINDOW = NO;//是否开启全局悬浮窗
    if (!SUPPORT_FLOATING_WINDOW)
    {
        return;
    }
    
    NSDictionary *tabBarConfig = g_config.tabBarConfigList;
    NSString *tabBarLinkUrl = tabBarConfig[@"tabBarLinkUrl"];
    NSString *tabBarName = [tabBarConfig objectForKey:@"tabBarName"]?:@"";
    NSString *tabBarImg = tabBarConfig[@"tabBarImg"]?:@"";
    if (tabBarConfig && !IsStringNull(tabBarLinkUrl)&&!IsStringNull(tabBarLinkUrl)&&!IsStringNull(tabBarName) && !_subTopWindow) {

        _subTopWindow = [[UIView alloc] init];
        _subTopWindow.frame = CGRectMake(JX_SCREEN_WIDTH - 50 - 10, (JX_SCREEN_HEIGHT -50)/2, 50, 50);
        
        if (_subWindowInitFrame.origin.x) {
            _subTopWindow.frame  = _subWindowInitFrame;
        }
        _subTopWindow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _subTopWindow.layer.masksToBounds = YES;
        _subTopWindow.layer.cornerRadius = 25;
         [self.window addSubview:_subTopWindow];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_subTopWindow addGestureRecognizer:pan];
        
        _suspensionBtn = [[UIButton alloc] initWithFrame:_subTopWindow.bounds];
        _suspensionBtn.backgroundColor = [UIColor clearColor];
        [_suspensionBtn addTarget:self action:@selector(showFloatWindow) forControlEvents:UIControlEventTouchUpInside];
        [_subTopWindow addSubview:_suspensionBtn];
        
        imgV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 34, 34)];
        [imgV sd_setImageWithURL:[NSURL URLWithString:tabBarImg]];
        imgV.layer.masksToBounds = YES;
        imgV.layer.cornerRadius = 17;
        [_subTopWindow addSubview:imgV];
        
        [self hideWebOnWindow];
    }
    _subTopWindow.hidden = NO;
    [self.window bringSubviewToFront:_subTopWindow];
}
-(void)hideWebOnWindow{
    _isINTopWindow = NO;
  if (webVC) {
      NSDictionary *tabBarConfig = g_config.tabBarConfigList;
      NSString *tabBarImg = tabBarConfig[@"tabBarImg"]?:@"";
      [imgV sd_setImageWithURL:[NSURL URLWithString:tabBarImg]];

        [UIView animateWithDuration:0.25 animations:^{
            webVC.view.frame = CGRectMake(JX_SCREEN_WIDTH, 0, JX_SCREEN_WIDTH, 0);
        } completion:^(BOOL finished) {
            webVC.view.hidden = YES;
        }];
    }
}


- (void)panAction:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        _subWindowFrame = _subTopWindow.frame;
    }
    CGPoint offset = [pan translationInView:g_App.window];
    CGPoint offset1 = [pan translationInView:_subTopWindow];
    //NSLog(@"pan - offset = %@, offset1 = %@", NSStringFromCGPoint(offset), NSStringFromCGPoint(offset1));
    
    CGRect frame = _subWindowFrame;
    frame.origin.x += offset.x;
    frame.origin.y += offset.y;
    _subTopWindow.frame = frame;
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        if (frame.origin.x <= JX_SCREEN_WIDTH / 2) {
            frame.origin.x = 10;
        }else {
            frame.origin.x = JX_SCREEN_WIDTH - frame.size.width - 10;
        }
        if (frame.origin.y < 0) {
            frame.origin.y = 10;
        }
        if ((frame.origin.y + frame.size.height) > JX_SCREEN_HEIGHT) {
            frame.origin.y = JX_SCREEN_HEIGHT - frame.size.height - 10;
        }
        _subWindowInitFrame = frame;
        [UIView animateWithDuration:0.5 animations:^{
            _subTopWindow.frame = frame;
        }];
    }
}

- (void)showFloatWindow {
    if (_isINTopWindow) {
        [self hideWebOnWindow];
        return;
    }
    NSDictionary *tabBarConfig = g_config.tabBarConfigList;
    NSString *tabBarLinkUrl = tabBarConfig[@"tabBarLinkUrl"];
    _isINTopWindow = YES;
    if (tabBarLinkUrl && (!webVC || _isHaveTopWindow)) {
        _isHaveTopWindow = NO;
        webVC = [WH_webpage_WHVC alloc];
        webVC.wh_isGotoBack= YES;
        webVC.isSend = YES;
        webVC.url = tabBarLinkUrl;
        webVC.isFormSuspension = YES;
        webVC = [webVC init];
        webVC.view.hidden = NO;
        [self.window addSubview:webVC.view];
        
        [self.window bringSubviewToFront:_subTopWindow];

    }else if (tabBarLinkUrl && webVC){
        webVC.view.hidden = NO;
    }
        webVC.view.frame = CGRectMake(JX_SCREEN_WIDTH, 0, JX_SCREEN_WIDTH, 0);
       [UIView animateWithDuration:0.25 animations:^{
            webVC.view.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
       } completion:^(BOOL finished) {
           imgV.image = [UIImage imageNamed:@"closefloatWindow"];
       }];
    
    
}

-(void)showLoginUI {

    if (APP_Startup_ShowAdvertisingView) {
        WH_AdvertisingViewController *adVC = [[WH_AdvertisingViewController alloc] init];
        g_navigation.rootViewController = adVC;
        __block WH_JXLoginVC *loginVC = [[ WH_JXLoginVC alloc] init];
        loginVC.isShow = YES;
        adVC.skipActionBlock = ^{
            //NSLog(@"跳过");
            g_navigation.rootViewController = loginVC;
        };
    } else {
        WH_JXLoginVC *loginVC = [[ WH_JXLoginVC alloc] init];
        loginVC.isShow = YES;
        g_navigation.rootViewController = loginVC;
    }
}

#pragma mark - 进入主界面
-(void)showMainUI{
//    if(mainVc==nil){
        mainVc=[[WH_JXMain_WHViewController alloc]init];
    
//    }
//        [window addSubview:mainVc.view];
//        window.rootViewController = mainVc;
        g_navigation.rootViewController = mainVc;
        int height = 218;
        if (THE_DEVICE_HAVE_HEAD) {
            height = 253;
        }
        faceView = [[emojiViewController alloc]initWithFrame:CGRectMake(0, JX_SCREEN_HEIGHT-height, JX_SCREEN_WIDTH, height)];
    
    
    NSString *str = [g_default stringForKey:kDeviceLockPassWord];
    if (str.length > 0) {
        [self showDeviceLock];
    }
    
    [self  showSuspensionWindow];

}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 进入后台
    [g_notify postNotificationName:kApplicationDidEnterBackground object:nil];
    
    [g_notify postNotificationName:kAllVideoPlayerStopNotifaction object:nil userInfo:nil];
    [g_notify postNotificationName:kAllAudioPlayerStopNotifaction object:nil userInfo:nil];
    
    //NSLog(@"XMPP ---- Appdelegate");
    [g_server outTime:nil];
//    g_xmpp.isCloseStream = YES;
//    g_xmpp.isReconnect = NO;
//    [g_xmpp logout];
#if TAR_IM
#ifdef Meeting_Version
    [jxMeeting WH_meetingDidEnterBackground:application];
#endif
#endif
    
    NSString *str = [g_default stringForKey:kDeviceLockPassWord];
    if (str.length > 0) {
        [self showDeviceLock];
    }
    if(self.taskId != UIBackgroundTaskInvalid){
        return;
    }
    self.taskId =[application beginBackgroundTaskWithExpirationHandler:^(void) {
        //当申请的后台时间用完的时候调用这个block
        //此时我们需要结束后台任务，
        [self endTask];
    }];
    // 模拟一个长时间的任务 Task
    self.timer =[NSTimer scheduledTimerWithTimeInterval:1.0f
                                                 target:self
                                               selector:@selector(longTimeTask:)
                                               userInfo:nil
                                                repeats:YES];
}

#pragma mark - 停止timer
-(void)endTask
{
    
    if (_timer != nil||_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
        
        //结束后台任务
        [[UIApplication sharedApplication] endBackgroundTask:_taskId];
        _taskId = UIBackgroundTaskInvalid;
        
        // //NSLog(@"停止timer");
    }
}
- (void) longTimeTask:(NSTimer *)timer{
    
    // 系统留给的我们的时间
    NSTimeInterval time =[[UIApplication sharedApplication] backgroundTimeRemaining];
    
}

- (void)showDeviceLock {
    if (!self.isShowDeviceLock) {
        self.isShowDeviceLock = YES;
        _numLockVC = [[WH_NumLock_WHViewController alloc]init];
        _numLockVC.isClose = NO;
        [g_window addSubview:_numLockVC.view];
    }
}



- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [g_server.config showDisableUse];
    [g_notify postNotificationName:kApplicationWillEnterForeground object:nil];
//    //NSLog(@"applicationWillEnterForeground");
    if(g_server.isLogin){
//        //NSLog(@"login");
        [[JXXMPP sharedInstance] login];
#if TAR_IM
#ifdef Meeting_Version
        [jxMeeting WH_meetingWillEnterForeground:application];
#endif
#endif
    }
    
    // 清除过期聊天记录
    [[WH_JXUserObject sharedUserInstance] WH_deleteUserChatRecordTimeOutMsg];
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//	//NSLog(@"OpenURL:%@",url);
//    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
////    if ([url.host isEqualToString:@"safepay"]) {
////        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
////            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
////            //NSLog(@"result = %@",resultDic);
////        }];
////    }
////    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
////        
////        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
////            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
////            //NSLog(@"result = %@",resultDic);
////        }];
////    }
//    
//    return YES;
//}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
   
#if Meeting_Version
#if !TARGET_IPHONE_SIMULATOR
//    [JitsiMeetView application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
#endif
#endif
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [self payStatueWithDic:resultDic];
        }];
    }
    
    return YES;
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [self payStatueWithDic:resultDic];
        }];
    }
    return YES;
}
//处理支付结果
-(void)payStatueWithDic:(NSDictionary *)resultDic{
    NSInteger resCode = [resultDic[@"resultStatus"]integerValue];
    
//    if(resCode ==9000) {//支付成功
//        //发送支付成功的通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:NoticePaySuccess object:nil];
//
//    }else if(resCode ==6001){//用户中途取消
//        //发送支付取消的通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:NoticePayCancel object:nil];
//
//    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:NoticePayFailure object:nil];
//    }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
   
//    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
//          // NSURL *url = userActivity.webpageURL;
//          // TODO 根据需求进行处理
//       }
     return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // 进入活跃
    [g_notify postNotificationName:kApplicationDidBecomeActive object:nil];
    
//    if(g_server.isLogin && g_xmpp.isLogined != login_status_yes)
//        [[JXXMPP sharedInstance] login];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    

}

- (void) showAlert: (NSString *) message
{

    [GKMessageTool showText:message];
    
}

- (UIAlertView *) showAlert: (NSString *) message delegate:(id)delegate{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:APP_NAME message:message delegate:delegate cancelButtonTitle:Localized(@"JX_Cencal") otherButtonTitles:Localized(@"JX_Confirm"), nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [av show];
    });
    
    return av;
}

- (UIAlertView *) showAlert: (NSString *) message delegate:(id)delegate tag:(NSUInteger)tag onlyConfirm:(BOOL)onlyConfirm
{
    UIAlertView *av;
    if (onlyConfirm)
       av = [[UIAlertView alloc] initWithTitle:APP_NAME message:message delegate:delegate cancelButtonTitle:Localized(@"JX_Confirm") otherButtonTitles:nil];
    else
        av = [[UIAlertView alloc] initWithTitle:APP_NAME message:message delegate:delegate cancelButtonTitle:Localized(@"JX_Cencal") otherButtonTitles:Localized(@"JX_Confirm"), nil];
    av.tag = tag;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [av show];
    });
    return av;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
#if TAR_IM
#ifdef Meeting_Version
//    [jxMeeting doNotify:notification];
#endif
#endif
//    //NSLog(@"推送：接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [g_server outTime:nil];
//    [g_server WH_userChangeMsgNum:[UIApplication sharedApplication].applicationIconBadgeNumber toView:self];
    [g_myself saveCurrentUser:[g_myself toDictionary]];
#if TAR_IM
#ifdef Meeting_Version
    [jxMeeting WH_doTerminate];
    [self endCall];
#endif
#endif
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
#if TAR_IM
#ifdef Meeting_Version
    [jxMeeting clearMemory];
#endif
#endif
}

-(void)endCall{
    if (_uuid) {
        
    }
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        [self applicationDidEnterBackground:[UIApplication sharedApplication]];
    }
}


-(void)startPush:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if (@available(iOS 11.0, *))
        {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (!granted)
                {
//                    dispatch_async_main_safe(^{
//                        [[UIApplication sharedApplication].keyWindow makeToast:@"请开启推送功能否则无法收到推送通知" duration:2.0 position:CSToastPositionCenter];
//                    })
                }
            }];
        }
        else
        {
            UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                     categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }

        [[UIApplication sharedApplication] registerForRemoteNotifications];


        // 注册push权限，用于显示本地推送
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
//        //NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
#if TARGET_IPHONE_SIMULATOR
    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
#endif
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    if (@available(iOS 13.0, *)) {
        NSMutableString *deviceTokenString = [NSMutableString string];
        const char *bytes = (char *)deviceToken.bytes;
        NSInteger count = deviceToken.length;
        for (int i = 0; i < count; i++) {
            [deviceTokenString appendFormat:@"%02x", bytes[i]&0x000000FF];
        }
        //apnsToken 需要提交给服务器
        [g_default setObject:deviceTokenString forKey:@"apnsToken"];
    } else {
        NSString *deviceTokenStr =  [[[[deviceToken description]
                                       stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                      stringByReplacingOccurrencesOfString:@">" withString:@""]
                                     stringByReplacingOccurrencesOfString:@" " withString:@""];
        //apnsToken 需要提交给服务器
        [g_default setObject:deviceTokenStr forKey:@"apnsToken"];
    }
    
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        if (result) {
            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    //NSLog(@"设置tag成功");
                }
            }];
        }
    }];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    
    NSMutableDictionary *mutaDict = [NSMutableDictionary dictionary];
    [userInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *keyStr = [[NSString alloc] init];
        keyStr = [NSString stringWithFormat:@"%@",key];
        if ([obj isKindOfClass:[NSNull class]]) {
            obj = @"";
        }
        [mutaDict setObject:obj forKey:keyStr];
    }];
    
    [g_default setObject:mutaDict forKey:kDidReceiveRemoteDic];
    [g_default synchronize];
//    [g_notify postNotificationName:kDidReceiveRemoteNotification object:userInfo];
    
//    //NSLog(@"********** ios7.0之前 **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
//        //NSLog(@"acitve or background");
//        [self showAlert:userInfo[@"aps"][@"alert"]];
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
    }
}

// 监听网络状态
- (void)networkStatusChange {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status != AFNetworkReachabilityStatusNotReachable) {
            if (g_server.isLogin) {
                if (g_xmpp.isLogined != login_status_yes) {
                    [[JXXMPP sharedInstance] logout];
                    [[JXXMPP sharedInstance] login];
                }
            }
            g_App.mainVc.msgVc.wh_isShowTopPromptV = NO;
        }else {
            [g_xmpp.reconnectTimer invalidate];
            g_xmpp.reconnectTimer = nil;
            g_xmpp.isReconnect = NO;
            [[JXXMPP sharedInstance] logout];
//            [g_App showAlert:Localized(@"JX_NetWorkError")];
            //无网络,网络错误
            g_App.mainVc.msgVc.wh_isShowTopPromptV = YES;
        }
    }];
}

#if TAR_IM
#ifdef Meeting_Version
-(void)startVoIPPush{
//    NSString * identifier = [[NSBundle mainBundle] bundleIdentifier];
//
//    if ([identifier isEqualToString:@"com.shandianyun.wahu"] && [[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//
//    }else{
        [g_default removeObjectForKey:@"voipToken"];
//    }
}

#pragma mark - PKPushRegistryDelegate
-(void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type{
    if ([credentials.token length] == 0) {
        //NSLog(@"voip token NULL");
        return;
    }
    NSString * voipToken = [[[[credentials.token description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    //voipToken 需要提交给服务器
    [g_default setObject:voipToken forKey:@"voipToken"];
    //NSLog(@"voipToken:%@",voipToken);
}

-(void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type{
    
    if (type != PKPushTypeVoIP) {
        return;
    }
    
    NSString * fromUserName = payload.dictionaryPayload[@"fromUserName"];
    int messageType = [[NSString stringWithFormat:@"%@",payload.dictionaryPayload[@"messageType"]] intValue];
    BOOL isVoiceVideoKuangJia = messageType == kWCMessageTypeAudioChatAsk ? YES : NO;
    BOOL isAudio = (messageType == kWCMessageTypeAudioChatAsk || messageType == kWCMessageTypeAudioMeetingInvite) ? YES : NO;
    BOOL isVideo = (messageType == kWCMessageTypeVideoChatAsk || messageType == kWCMessageTypeVideoMeetingInvite) ? YES : NO;
    fromUserName = fromUserName.length > 0 ? fromUserName : APP_NAME;
    
    
    switch ([UIApplication sharedApplication].applicationState) {
        case UIApplicationStateActive:
        case UIApplicationStateInactive:{
            //不处理,显示app接听界面
            if (_uuid) {
                [self endCall];
            }
            break;
        }
        case UIApplicationStateBackground:
        default:{
            if (isVoiceVideoKuangJia && !_uuid && [[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
                if (_uuid) {
                    return;
                }
                
                _uuid = [NSUUID UUID];
                [self applicationWillEnterForeground:[UIApplication sharedApplication]];
                
                
            }else if(isAudio || isVideo){
                _uuid = nil;
                [self meetingLocalNotifi:fromUserName isAudio:isAudio];
            }
            break;
        }
    }
}

-(void)meetingLocalNotifi:(NSString *)fromUserName isAudio:(BOOL)isAudio{
    UILocalNotification *callNotification = [[UILocalNotification alloc] init];
    
    NSString *stringAlert;
    if (isAudio){
        stringAlert = [NSString stringWithFormat:@"%@ \n %@", Localized(@"WaHu_JXMeetingObject_VoiceChat"),fromUserName];
    }else{
        stringAlert = [NSString stringWithFormat:@"%@\n %@",Localized(@"WaHu_JXMeetingObject_VideoChat"), fromUserName];
    }
    callNotification.alertBody = stringAlert;
    
    callNotification.soundName = @"whynotyou.caf";
    [[UIApplication sharedApplication]
     presentLocalNotificationNow:callNotification];
}


#endif
#endif


// 截屏监听
//- (void)getScreenShot:(NSNotification *)notification{
//    //NSLog(@"捕捉截屏事件");
//    
//    //获取截屏图片
////    UIImage *image = [UIImage imageWithData:[self imageDataScreenShot]];
//    NSData *imageData = [self imageDataScreenShot];
//    BOOL isSuccess = [imageData writeToFile:ScreenShotImage atomically:YES];
//    if (isSuccess) {
//        //NSLog(@"截屏存储成功 - %@", NSHomeDirectory());
//    }else {
//        //NSLog(@"截屏存储失败");
//    }
//}

- (NSData *)imageDataScreenShot
{
    CGSize imageSize = CGSizeZero;
    imageSize = [UIScreen mainScreen].bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

- (void)copyDbWithUserId:(NSString *)userId {
    // 拷贝文件到share extension 共享存储空间中
    userId = [userId uppercaseString];
    NSString* t =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* copyPath = [NSString stringWithFormat:@"%@/%@.db",t,userId];
    
    //获取分组的共享目录
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *groupURL = [manager containerURLForSecurityApplicationGroupIdentifier:APP_GROUP_ID];
    NSString *fileName = [NSString stringWithFormat:@"%@.db",userId];
    NSURL *fileURL = [groupURL URLByAppendingPathComponent:fileName];
    
    NSString *path = [fileURL.absoluteString substringFromIndex:7];
    
    NSError *error = nil;
    [manager removeItemAtPath:path error:&error];
    if (error) {
        //NSLog(@"删除失败error : %@",error);
    }
    if (path.length <= 0) {
        return;
    }
    BOOL isCopy = [manager copyItemAtPath:copyPath toPath:path error:nil];
    
    if (isCopy) {
        static dispatch_once_t disOnce;
        dispatch_once(&disOnce,^ {
            //只执行一次的代码
            //NSLog(@"share extension : %@",path);
        });
    }
}

#pragma mark - 请求失败回调
-(int) WH_didServerResult_WaHuFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
   
    if ([aDownload.action isEqualToString:wh_act_userChangeMsgNum]) {
        return WH_hide_error;
    }
    
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    if ([aDownload.action isEqualToString:wh_act_userChangeMsgNum]) {
        return WH_hide_error;
    }
    
    return WH_show_error;
}



@end
