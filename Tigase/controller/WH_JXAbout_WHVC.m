//
//  WH_JXAbout_WHVC.m
//  Tigase_imChatT
//
//  Created by flyeagleTang on 14-6-10.
//  Copyright (c) 2019年 YZK. All rights reserved.
//

#import "WH_JXAbout_WHVC.h"
#import "WH_JXShareList_WHVC.h"
#import "WH_webpage_WHVC.h"
#import "WH_ComplaintViewController.h"
#define HEIGHT 55
#define STARTTIME_TAG 1

@interface WH_JXAbout_WHVC ()<ShareListDelegate,UITextViewDelegate>

@end

@implementation WH_JXAbout_WHVC

- (id)init
{
    self = [super init];
    if (self) {
        self.wh_isGotoBack   = YES;
            self.title = Localized(@"WaHu_AboutUs_WaHu");
        self.wh_heightFooter = 0;
        self.wh_heightHeader = JX_SCREEN_TOP;
        //self.view.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
        [self createHeadAndFoot];
        self.wh_tableBody.backgroundColor = [UIColor whiteColor];
        self.wh_tableBody.scrollEnabled = YES;
//        int h = 0;
        
        
        CGFloat logoImageViewWH = 80;
        WH_JXImageView* iv;
        iv = [[WH_JXImageView alloc]initWithFrame:CGRectMake((JX_SCREEN_WIDTH-logoImageViewWH)/2, 50, logoImageViewWH, logoImageViewWH)];
        iv.center = CGPointMake(JX_SCREEN_WIDTH/2, iv.center.y);
        iv.image = [UIImage imageNamed:@"appLogo"];
        [self.wh_tableBody addSubview:iv];
        iv.layer.masksToBounds = YES;
        iv.layer.cornerRadius = g_factory.cardCornerRadius;
        
        
        NSString *buildStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        NSString *versionStr = g_config.version;
        
        UILabel* p = [self WH_createLabel:self.wh_tableBody default:[NSString stringWithFormat:@"%@",APP_NAME]];
        p.frame = CGRectMake(0, iv.frame.origin.y+iv.frame.size.height+20, JX_SCREEN_WIDTH, 31);
        p.textColor = THEMECOLOR;
        p.textAlignment = NSTextAlignmentCenter;
        p.font = sysBoldFontWithSize(18);
        
        

        UILabel* p2 = [self WH_createLabel:self.wh_tableBody default:[NSString stringWithFormat:@"Version: %@-%@",versionStr,buildStr]];
        p2.frame = CGRectMake(0, p.frame.origin.y+p.frame.size.height+5, JX_SCREEN_WIDTH, 23);
        p2.textColor = THEMECOLOR;
        p2.textAlignment = NSTextAlignmentCenter;
        p2.font = sysBoldFontWithSize(14);
        
        //如果是上架版本
        if (IS_APP_STORE_VERSION) {
            iv = [self WH_createMiXinButton:@"去评分" superView:self.wh_tableBody drawTop:NO drawBottom:YES icon:nil click:@selector(clickGrade)];
            iv.frame = CGRectMake(0, CGRectGetMaxY(p2.frame)+25, JX_SCREEN_WIDTH, HEIGHT);
            CGFloat nowHeight = CGRectGetMaxY(iv.frame);
            
            iv = [self WH_createMiXinButton:@"投诉" superView:self.wh_tableBody drawTop:NO drawBottom:YES icon:nil click:@selector(clickComplaint)];
            iv.frame = CGRectMake(0, nowHeight, JX_SCREEN_WIDTH, HEIGHT);
            nowHeight += CGRectGetHeight(iv.frame);
            
            iv = [self WH_createMiXinButton:@"版本更新" superView:self.wh_tableBody drawTop:NO drawBottom:YES icon:nil click:@selector(clickVersionUpdate)];
            iv.frame = CGRectMake(0, nowHeight, JX_SCREEN_WIDTH, HEIGHT);
            nowHeight += CGRectGetHeight(iv.frame);
            
            
            //协议
            CGFloat tempMargin = 0;
            if (THE_DEVICE_HAVE_HEAD) {
                tempMargin = 40;
            }
            UITextView *agreView = [[UITextView alloc] initWithFrame:CGRectMake(0, JX_SCREEN_HEIGHT - JX_SCREEN_TOP - 30 - tempMargin - 40, JX_SCREEN_WIDTH, 40)];
            agreView.editable = NO;
            agreView.delegate = self;
            
            //去除左右边距
            agreView.textContainer.lineFragmentPadding = 0.0;
            //设置垂直居中
            agreView.textContainerInset = UIEdgeInsetsMake(15, 0, 0, 0);
            
            agreView.backgroundColor = self.wh_tableBody.backgroundColor;
            //设置添加链接部分文字的颜色，即“《XXX隐私政策》”
            agreView.linkTextAttributes = @{NSForegroundColorAttributeName:THEMECOLOR};
            [self.wh_tableBody addSubview:agreView];
            
            
            NSString *rangeStr1 = [NSString stringWithFormat:@"《%@》",@"个人账号使用规范"];
            NSString *rangeStr2 = [NSString stringWithFormat:@"《%@》",@"社交圈使用规范"];
            NSString *protocolStr = [NSString stringWithFormat:@"%@ 和 %@", rangeStr1, rangeStr2];
            NSRange privacyRange1 = [protocolStr rangeOfString:rangeStr1];
            NSRange privacyRange2 = [protocolStr rangeOfString:rangeStr2];
            NSMutableAttributedString *privacyMutableAttrStr = [[NSMutableAttributedString alloc] initWithString:protocolStr attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size: 11],NSForegroundColorAttributeName:HEXCOLOR(0xBABABA)}];
            
            //给需要 点击事件的部分添加链接
            [privacyMutableAttrStr addAttribute:NSLinkAttributeName value:@"privacy1://" range:privacyRange1];
            [privacyMutableAttrStr addAttribute:NSLinkAttributeName value:@"privacy2://" range:privacyRange2];
            
            agreView.attributedText = privacyMutableAttrStr;
            agreView.textAlignment = NSTextAlignmentCenter;
            
            
            //@"Tigase 版权所有"
            UILabel *banquanL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(agreView.frame), JX_SCREEN_WIDTH, 20)];
            banquanL.text = @"Tigase版权所有";
            banquanL.font = sysFontWithSize(12);
            banquanL.textColor = HEXCOLOR(0xBABABA);
            banquanL.textAlignment = NSTextAlignmentCenter;
            [self.wh_tableBody addSubview:banquanL];
        }else{
            p2.text = [NSString stringWithFormat:@"version: %@.%@",versionStr,buildStr];
        }
        
        
    }
    return self;
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    if ([URL.scheme isEqualToString:@"privacy1"]) {
        //这里调用方法跳到隐私政策页面
        WH_webpage_WHVC * webVC = [WH_webpage_WHVC alloc];
        webVC.url = [self protocolUrl1];
        webVC.isSend = NO;
        webVC = [webVC init];
        webVC.isGoBack = YES;
        [g_navigation pushViewController:webVC animated:YES];
        
        return NO;
    }else if ([URL.scheme isEqualToString:@"privacy2"]) {
        //这里调用方法跳到隐私政策页面
        WH_webpage_WHVC * webVC = [WH_webpage_WHVC alloc];
        webVC.url = [self protocolUrl2];
        webVC.isSend = NO;
        webVC = [webVC init];
        webVC.isGoBack = YES;
        [g_navigation pushViewController:webVC animated:YES];
        
        return NO;
    }
    
    return YES;
}

#pragma mark 获取协议
-(NSString *)protocolUrl1{
//    NSString * protocolStr = [NSString stringWithFormat:@"http://%@/agreement/accountUseNorm.html",PrivacyAgreementBaseApiUrl];
    //    NSString * lange = g_constant.sysLanguage;
    //    if (![lange isEqualToString:ZHHANTNAME] && ![lange isEqualToString:NAME]) {
    //        lange = ENNAME;
    //    }
    //    return [NSString stringWithFormat:@"%@%@.html",protocolStr,lange];
    
    NSString * protocolStr = @"https://www.huoli68.com/?gbook/";
    
    return protocolStr;
}

-(NSString *)protocolUrl2{
//    NSString * protocolStr = [NSString stringWithFormat:@"http://%@/agreement/SoFUseNorm.html",PrivacyAgreementBaseApiUrl];
    //    NSString * lange = g_constant.sysLanguage;
    //    if (![lange isEqualToString:ZHHANTNAME] && ![lange isEqualToString:NAME]) {
    //        lange = ENNAME;
    //    }
    //    return [NSString stringWithFormat:@"%@%@.html",protocolStr,lange];
    NSString * protocolStr = @"https://www.huoli68.com/?contact/";
    return protocolStr;
}


-(WH_JXImageView*)WH_createMiXinButton:(NSString*)title superView:(UIView *)view drawTop:(BOOL)drawTop drawBottom:(BOOL)drawBottom icon:(NSString*)icon click:(SEL)click{
    WH_JXImageView* btn = [[WH_JXImageView alloc] init];
    btn.backgroundColor = [UIColor clearColor];
    btn.userInteractionEnabled = YES;
    btn.didTouch = click;
    btn.wh_delegate = self;
    [view addSubview:btn];
    
    JXLabel* p = [[JXLabel alloc] initWithFrame:CGRectMake(30+3, 0, JX_SCREEN_WIDTH-100, HEIGHT)];
    p.text = title;
    p.font = sysFontWithSize(14);
    p.backgroundColor = [UIColor clearColor];
    p.textColor = HEXCOLOR(0x161819);
    p.wh_delegate = self;
    p.didTouch = click;
    [btn addSubview:p];
    
    if(icon){
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, (HEIGHT-20)/2, 20, 20)];
        iv.image = [UIImage imageNamed:icon];
        [btn addSubview:iv];
        //        [iv release];
    }
    
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(30,0,JX_SCREEN_WIDTH-60,0.3)];
        line.backgroundColor = HEXCOLOR(0xEEEEEE);
        [btn addSubview:line];
        //        [line release];
    }
    
    if(drawBottom){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(30,HEIGHT-1,JX_SCREEN_WIDTH-60,0.3)];
        line.backgroundColor = HEXCOLOR(0xEEEEEE);
        [btn addSubview:line];
        //        [line release];
    }
    
    if(click){
        UIImageView* iv;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH-30-14-3, (HEIGHT-14)/2, 14, 14)];
        iv.image = [UIImage imageNamed:@"set_list_next"];
        [btn addSubview:iv];
        //        [iv release];
    }
    
    return btn;
}

#pragma mark - 按钮的点击事件
/**
 点击去评分
 */
- (void)clickGrade{
    //跳转到app store评价
    NSURL *url = [NSURL URLWithString:AppStoreString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

/**
 点击投诉
 */
- (void)clickComplaint{
    WH_ComplaintViewController *vc = [[WH_ComplaintViewController alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}


/**
 点击版本更新
 */
- (void)clickVersionUpdate{
    
    
    //跳转第三方更新网站01
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://testflight.apple.com/join/d6QcK52T"]];
    
    
    return;
    
    
    //发布到app store
    //如果是苹果商店提交是以下代码
    NSURL *url = [NSURL URLWithString:AppStoreString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

-(void)dealloc{
    //NSLog(@"WH_JXAbout_WHVC.dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UILabel*)WH_createLabel:(UIView*)parent default:(NSString*)s{
    UILabel* p = [[UILabel alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH/2,INSETS,JX_SCREEN_WIDTH/2 -20,HEIGHT-INSETS*2)];
    p.userInteractionEnabled = NO;
    p.text = s;
    p.font = sysFontWithSize(13);
    p.textAlignment = NSTextAlignmentRight;
    [parent addSubview:p];
//    [p release];
    return p;
}

-(void)onGood{
    if (g_config.appleId.length > 0) {
        NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",g_config.appleId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

//分享按钮点击事件
- (void)shareBtnClick:(UIButton *)shareBtn{
    WH_JXShareList_WHVC *shareListVC = [[WH_JXShareList_WHVC alloc] init];
    shareListVC.shareListDelegate = self;
    [self.view addSubview:shareListVC.view];
}

#pragma mark JXShareSelectView delegate
- (void)didShareBtnClick:(UIButton *)shareBtn{
    
    
}

@end
