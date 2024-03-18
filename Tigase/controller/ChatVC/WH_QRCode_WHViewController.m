//
//  WH_QRCode_WHViewController.m
//  Tigase
//
//  Created by Apple on 2019/7/3.
//  Copyright © 2019 Reese. All rights reserved.
//

#import "WH_QRCode_WHViewController.h"

#import "WH_QRImage.h"


@interface WH_QRCode_WHViewController ()
@property (nonatomic, strong) UIImageView *groupHeadImg;
@end

@implementation WH_QRCode_WHViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.wh_heightHeader = JX_SCREEN_TOP;
    self.wh_heightFooter = 0;
    self.wh_isGotoBack = YES;
    self.title = @"二维码";
    [self createHeadAndFoot];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.wh_tableBody.backgroundColor = [UIColor whiteColor];
    
    [self createContentView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)createContentView {
    Boolean thirdLogin;
    if ([g_config.wechatLoginStatus integerValue] == 1) {
        thirdLogin = YES;
    }else{
        thirdLogin = NO;
    }
    
    //先去掉分享到微信功能
    //    thirdLogin = NO;
    self.wh_contentView = [[UIView alloc] initWithFrame:CGRectMake(20, JX_SCREEN_TOP + 40, JX_SCREEN_WIDTH - 40, JX_SCREEN_HEIGHT - JX_SCREEN_TOP - 40)];
    [self.wh_contentView setBackgroundColor:HEXCOLOR(0xffffff)];
    [self.view addSubview:self.wh_contentView];
    self.wh_contentView.layer.masksToBounds = YES;
    self.wh_contentView.layer.cornerRadius = g_factory.cardCornerRadius;
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(40, 20, 46, 46)];
    self.groupHeadImg = headImg;
    [self.wh_contentView addSubview:headImg];
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = (MainHeadType)?(CGRectGetWidth(headImg.frame)/2):(g_factory.headViewCornerRadius);
    if (self.type == QR_GroupType) {
        [g_server WH_getRoomHeadImageSmallWithUserId:self.wh_roomJId roomId:self.wh_userId imageView:headImg];
    }else {
        [g_server WH_getHeadImageLargeWithUserId:self.wh_userId userName:self.wh_nickName imageView:headImg];
    }
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(headImg.frame.origin.x + headImg.frame.size.width + 12, headImg.frame.origin.y, self.wh_contentView.frame.size.width - CGRectGetMaxX(headImg.frame) - 26, headImg.frame.size.height)];
    if ([self.wh_groupNum integerValue] > 0) {
        [name setText:[NSString stringWithFormat:@"%@(%@)" ,self.wh_nickName?:@"" ,self.wh_groupNum]];
    }else{
        [name setText:self.wh_nickName?:@"" ];
    }
    
    [self.wh_contentView addSubview:name];
    [name setTextColor:HEXCOLOR(0x161819)];
    [name setFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 14]];
    
    NSMutableString * qrStr = [NSMutableString stringWithFormat:@"%@?action=",g_config.website];
    if(self.type == QR_UserType)
        [qrStr appendString:@"user"];
    else if(self.type == QR_GroupType)
        [qrStr appendString:@"group"];
    if(self.wh_userId != nil)
        [qrStr appendFormat:@"&tigId=%@",self.wh_userId];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 6.0f;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 1.5f;
    if (self.type == QR_GroupType) {
        [g_server WH_getRoomHeadImageSmallWithUserId:self.wh_roomJId roomId:self.wh_userId imageView:imageView];
    }else {
        [g_server WH_getHeadImageLargeWithUserId:self.wh_userId userName:self.wh_nickName imageView:imageView];
    }
    
    UIImage * qrImage = [WH_QRImage qrImageForString:qrStr imageSize:217 logoImage:imageView.image logoImageSize:52];
    self.wh_qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.wh_contentView.frame.size.width-217)/2, CGRectGetMaxY(headImg.frame) + 48, 217, 217)];
    self.wh_qrImageView.image = qrImage;
    [self.wh_contentView addSubview:self.wh_qrImageView];
    
    UILabel *label = [[UILabel alloc] init];
    if (self.type == QR_GroupType && thirdLogin) {
        [label setText:Localized(@"New_sacn_qrcode_enter_group")];
        [label setFrame:CGRectMake(0, CGRectGetMaxY(self.wh_qrImageView.frame) + 46, self.wh_contentView.frame.size.width, 20)];
    }else{
        [label setText:(self.type == QR_GroupType)?Localized(@"New_sacn_qrcode_enter_group"):Localized(@"New_scan_qrcode")];
        [label setFrame:CGRectMake(0, CGRectGetMaxY(self.wh_qrImageView.frame) + 46, self.wh_contentView.frame.size.width, 20)];
    }
    
    [label setTextColor:HEXCOLOR(0xBABABA)];
    [label setFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 12]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.wh_contentView addSubview:label];
    
    //    if (self.type == QR_GroupType && thirdLogin) {
    //        NSArray *array = @[@"保存到手机" ,@"发送给微信好友"];
    NSArray *array = @[@"保存到手机"];
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //            [button setFrame:CGRectMake(20 + i*((CGRectGetWidth(self.wh_contentView.frame) - 40 - 15)/2 + 15), CGRectGetHeight(self.wh_contentView.frame) - 27 - 44, (CGRectGetWidth(self.wh_contentView.frame) - 40 - 15)/2, 44)];
        
        //            float wide = (CGRectGetWidth(self.wh_contentView.frame) - 40 - 15)/2;
        
        float wide = JX_SCREEN_WIDTH - 74;
        
        [button setFrame:CGRectMake(17, CGRectGetMaxY(self.wh_qrImageView.frame) + 113, wide, 48)];
        
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [button setBackgroundColor:THEMECOLOR];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 24.0f;
        [button setTag:i];
        [self.wh_contentView addSubview:button];
        [button addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    //    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewController];
}

- (void)buttonClickMethod:(UIButton *)button {
    //0:保存到手机 1:发送给微信好友
    [self dismissViewController];
    if (button.tag == 0) {
        UIImageWriteToSavedPhotosAlbum(self.wh_qrImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else{
        //发给微信好友
       
    }
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        [g_server showMsg:Localized(@"ImageBrowser_saveFaild")];
    }else{
        [g_server showMsg:Localized(@"ImageBrowser_saveSuccess")];
    }
}
-(void)actionQuit{
    [self dismissViewController];
}
- (void)dismissViewController {
    [UIView animateWithDuration:.3f animations:^{
        self.wh_contentView.frame = CGRectMake(0, JX_SCREEN_HEIGHT, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
        self.view.frame = CGRectMake(0, JX_SCREEN_HEIGHT, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if (self) {
            [self.view removeFromSuperview];
        }
    }];
}


@end
