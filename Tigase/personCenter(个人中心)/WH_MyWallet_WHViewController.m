  //
//  WH_MyWallet_WHViewController.m
//  Tigase
//
//  Created by Apple on 2019/7/5.
//  Copyright © 2019 Reese. All rights reserved.
//

#import "WH_MyWallet_WHViewController.h"

#import "WH_JXPayPassword_WHVC.h"

#import "WH_JXRecordCode_WHVC.h"
#import "JX_NewWithdrawViewController.h"


#import "MiXin_WithdrawCoin_MiXinVC.h"
#import "WH_H5Transaction_JXViewController.h"

#import "BindTelephoneChecker.h"

#import "WH_JXChat_WHViewController.h"
#import "WH_webpage_WHVC.h"
#import "WH_RechargeVC.h"
#import "WH_WithDreawVC.h"

#define View_Height (IS_SHOW_BLACK_HOURSE_DEAL)?(384 + 66 + 44):(384 + 44)

@interface WH_MyWallet_WHViewController ()

@end

@implementation WH_MyWallet_WHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的钱包";
    self.wh_heightHeader = JX_SCREEN_TOP;
    self.wh_heightFooter = 0;
    self.wh_isGotoBack = YES;
    [self createHeadAndFoot];
    
    [self.wh_tableBody setBackgroundColor:[UIColor whiteColor]];
    
    [self.wh_tableHeader addSubview:[self createHeadButton]];
    
    [self createContentView];
    
    [g_notify addObserver:self selector:@selector(WH_doRefresh:) name:kUpdateUser_WHNotifaction object:nil];
    
    [g_notify addObserver:self selector:@selector(WH_doRefresh:) name:kXMPPMessageH5Payment__WHNotification object:nil];
}

-(void)WH_doRefresh:(NSNotification *)notifacation{
    self.wh_moneyLabel.text = [NSString stringWithFormat:@"HOTC%.2f",g_App.myMoney];
    
    //获取用户余额
    [g_server WH_getUserMoenyToView:self];
}

- (void)createContentView {
    CGFloat viewHieght = View_Height;
    if ([g_config.hmPayStatus integerValue] == 1) {
        viewHieght = viewHieght + 44 + 12;
    }
    
    if ([g_config.hmWithdrawStatus integerValue] == 1) {
        viewHieght = viewHieght + 44 + 12;
    }
    UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(g_factory.globelEdgeInset, 0, JX_SCREEN_WIDTH - 2*g_factory.globelEdgeInset, viewHieght)];
    [cView setBackgroundColor:HEXCOLOR(0xffffff)];
    [self.wh_tableBody addSubview:cView];
   
    
    //icon
    UIImageView *jbImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, JX_SCREEN_WIDTH - 40, 192)];
    jbImg.userInteractionEnabled = YES;
    [jbImg setImage:[UIImage imageNamed:@"my_account_bg"]];
    [cView addSubview:jbImg];
    
    //我的余额
    UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 28, cView.frame.size.width, 20)];
    [mLabel setText:Localized(@"MY_BALANCE")];
    [mLabel setTextColor:[UIColor whiteColor]];
    [mLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 14]];
    [mLabel setTextAlignment:NSTextAlignmentLeft];
    [jbImg addSubview:mLabel];
    
    self.wh_moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 58, cView.frame.size.width, 42)];
    [self.wh_moneyLabel setText:@""];
    [self.wh_moneyLabel setTextColor:HEXCOLOR(0xffffff)];
    [self.wh_moneyLabel setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size: 30]];
    [jbImg addSubview:self.wh_moneyLabel];
    [self.wh_moneyLabel setTextAlignment:NSTextAlignmentLeft];
    
    //创建半透明背景
    UIView *aaView = [[UIView alloc] initWithFrame:CGRectMake(0, jbImg.frame.size.height - 69, jbImg.frame.size.width, 69)];
    aaView.backgroundColor = [UIColor whiteColor];
    aaView.alpha = 0.37;
    [jbImg addSubview:aaView];
    
    //创建充值以及提现的按钮
    UIButton *rechargeBtn = [self creatButtonWithTitle:@"充值" icon:@"mine_recharge_icon"];
    [rechargeBtn addTarget:self action:@selector(recargeAction) forControlEvents:UIControlEventTouchUpInside];
    [jbImg addSubview:rechargeBtn];
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(aaView);
        make.width.mas_equalTo(aaView.frame.size.width/2);
    }];
    
    UIButton *withDrawBtn = [self creatButtonWithTitle:@"提现" icon:@"mine_withraw_icon"];
    [withDrawBtn addTarget:self action:@selector(withDrawBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [jbImg addSubview:withDrawBtn];
    [withDrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(aaView);
        make.width.mas_equalTo(aaView.frame.size.width/2);
    }];
    
    //创建分割线
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor whiteColor];
    [jbImg addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(34);
        make.left.equalTo(rechargeBtn.mas_right);
        make.top.equalTo(aaView).offset(17);
    }];
    
        
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(37, JX_SCREEN_HEIGHT - 136, JX_SCREEN_WIDTH - 74, 48)];
    [btn setTitle:@"联系客服充值" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x797979) forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x797979) forState:UIControlStateHighlighted];
    [btn setBackgroundColor:HEXCOLOR(0xffffff)];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 24.0f;
    btn.layer.borderColor = HEXCOLOR(0xEEEEEE).CGColor;
    btn.layer.borderWidth = g_factory.cardBorderWithd;
    [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 17]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(lianxikehu) forControlEvents:UIControlEventTouchUpInside];
    
    //获取余额
    [g_server WH_getUserMoenyToView:self];
}

-(UIButton *)creatButtonWithTitle:(NSString *)title icon:(NSString *)icon{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    [btn addSubview:imageIcon];
    [imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.top.equalTo(btn).offset(16);
    }];
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = title;
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [btn addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageIcon.mas_bottom).offset(4);
        make.centerX.equalTo(imageIcon);
    }];
    
    return btn;
}

- (UIButton *)createHeadButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(JX_SCREEN_WIDTH - 72, JX_SCREEN_TOP - 33, 62, 21)];
    [btn setTitle:Localized(@"JX_Bill") forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x161819) forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x161819) forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 14]];
    [btn addTarget:self action:@selector(recordMethod) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    
    if ([aDownload.action isEqualToString:wh_act_getUserMoeny]) {
        g_App.myMoney = [dict[@"balance"] doubleValue];
        if([dict objectForKey:@"usdtUrl"]){
            g_App.usdtUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"usdtUrl"]];
        }
        NSString * moneyStr = [NSString stringWithFormat:@"HOTC%.2f",g_App.myMoney];
        self.wh_moneyLabel.text = moneyStr;
    }
}
- (void)lianxikehu{
    
    WH_JXUserObject *userobj = [[WH_JXUserObject alloc]init];
    
    userobj.userId = [NSString stringWithFormat:@"%@",g_myself.officialCSUid];
//    userobj.userNickname = Localized(@"New_online_service");
    WH_JXChat_WHViewController *sendView=[WH_JXChat_WHViewController alloc];
    
    sendView.scrollLine = 0;
    sendView.title = Localized(@"New_online_service");
//    if(!user){
//        sendView.chatPerson = g_myself;
//    }else{
        sendView.chatPerson = userobj;
//    }
    sendView = [sendView init];
    [g_navigation pushViewController:sendView animated:YES];
}
-(void)recargeAction{
    if ([g_config.aliPayStatus integerValue] != 1 && [g_config.wechatPayStatus integerValue] != 1 && [g_config.yunPayStatus integerValue] != 1) {
        //aliPayStatus;  //支付宝充值状态 1:开启 2：关闭 wechatWithdrawStatus; //微信提现状态1：开启 2：关闭
        [GKMessageTool showText:Localized(@"New_not_open_temporarily")];
        [self lianxikehu];
       
        return;
        
    }else {
        
        WH_RechargeVC *rechargeVC = [[WH_RechargeVC alloc] init];
        [g_navigation pushViewController:rechargeVC animated:YES];
        

    }
}
-(void)withDrawBtnAction{
    if ([g_config.aliWithdrawStatus integerValue] != 1 && [g_config.wechatWithdrawStatus integerValue] != 1 && [g_config.isWithdrawToAdmin integerValue] != 1) {
        [GKMessageTool showText:Localized(@"New_temporarily_closed")];
        return;
    }else {
        //提现到后台审核
        //先判断是否绑定了手机号
        if ([g_config.isWithdrawToAdmin intValue] == 1) {//提现
            //提现到后台审核
            g_myself.isPayPassword = [g_default objectForKey:PayPasswordKey];
            if ([g_myself.isPayPassword boolValue]) {
                
                WH_WithDreawVC *tranVC = [[WH_WithDreawVC alloc] init];
                [g_navigation pushViewController:tranVC animated:YES];
                
                
            }else {//没有支付密码
                [BindTelephoneChecker checkBindPhoneWithViewController:self entertype:JXEnterTypeDefault];
            }
        } else {
             
            WH_WithDreawVC *tranVC = [[WH_WithDreawVC alloc] init];
            [g_navigation pushViewController:tranVC animated:YES];
            
        }
    }
}
//未设置支付密码，设置支付密码
- (void)setPaypassForFirstTime {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"您还未设置支付密码，请设置支付密码。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:Localized(@"JX_Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WH_JXPayPassword_WHVC * PayVC = [WH_JXPayPassword_WHVC alloc];
        PayVC.type = JXPayTypeSetupPassword;
        PayVC.enterType = JXEnterTypeDefault;
        PayVC = [PayVC init];
        [g_navigation pushViewController:PayVC animated:YES];
    }];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark 消费记录
- (void)recordMethod {
//    WH_PurchaseHistory_WHViewController *phVC = [[WH_PurchaseHistory_WHViewController alloc] init];
//    [g_navigation pushViewController:phVC animated:YES];
    
    WH_JXRecordCode_WHVC * recordVC = [[WH_JXRecordCode_WHVC alloc]init];
    [g_navigation pushViewController:recordVC animated:YES];
}



@end
