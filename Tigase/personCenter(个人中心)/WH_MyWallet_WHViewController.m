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
#import "WH_JXRecharge_WHViewController.h"
#import "WH_JXCashWithDraw_WHViewController.h"
#import "JX_NewWithdrawViewController.h"

#import "WH_Recharge_WHViewController.h"


#import "WH_NewRecharge_WHViewController.h"
#import "MiXin_WithdrawCoin_MiXinVC.h"
#import "WH_H5Transaction_JXViewController.h"

#import "WH_WithdrawalToBackground_WHViewController.h"
#import "BindTelephoneChecker.h"

#import "WH_JXChat_WHViewController.h"
#import "WH_webpage_WHVC.h"
#import "WH_RechargeVC.h"
#import "WH_WithDreawVC.h"
#import "WH_JXBuyAndPayListVC.h"

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
    UIImageView *jbImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, JX_SCREEN_WIDTH - 40, 126)];
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
    
    NSArray *array = @[@"USDT充值" ,@"USDT提现"];;
    if ([g_config.hmPayStatus integerValue] == 1 && [g_config.hmWithdrawStatus integerValue] != 1) {
        array = @[@"USDT充值" ,@"H5充值",@"USDT提现"];
    }
    if ([g_config.hmPayStatus integerValue] != 2 && [g_config.hmWithdrawStatus integerValue] == 1) {
        array = @[@"USDT充值" ,@"USDT提现" ,@"H5提现"];
    }
    if ([g_config.hmPayStatus integerValue] == 1 && [g_config.hmWithdrawStatus integerValue] == 1) {
        array = @[@"USDT充值" ,@"H5充值",@"USDT提现",@"H5提现"];
    }
    NSMutableArray *titleArr = [NSMutableArray arrayWithArray:array];
    [titleArr addObject:@"联系客服充值"];
    [titleArr addObject:@"C2C交易（推荐）"];
    
    for (int i = 0; i < titleArr.count; i++) {
        NSString *titleStr = [titleArr objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(17, (CGRectGetMaxY(jbImg.frame) + 30) + i*(20 + 48), cView.frame.size.width - 34, 48)];
        [btn setTag:i];
        [btn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:i == titleArr.count - 1?HEXCOLOR(0xffffff):HEXCOLOR(0x797979) forState:UIControlStateNormal];
        [btn setTitleColor:i == titleArr.count - 1?HEXCOLOR(0xffffff):HEXCOLOR(0x797979) forState:UIControlStateHighlighted];
        [btn setBackgroundColor:([titleStr isEqualToString:@"C2C交易（推荐）"])?THEMECOLOR:HEXCOLOR(0xffffff)];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 24.0f;
        if (![titleStr isEqualToString:@"C2C交易（推荐）"]) {
            btn.layer.borderColor = HEXCOLOR(0xEEEEEE).CGColor;
            btn.layer.borderWidth = g_factory.cardBorderWithd;
        }
        [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 17]];
        [cView addSubview:btn];
        [btn addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //获取余额
    [g_server WH_getUserMoenyToView:self];
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
- (void)buttonClickMethod:(UIButton *)button {
    
    /*@[@"USDT充值" ,@"H5充值",@"USDT提现"] */
    NSString *actionTitle = [button titleForState:UIControlStateNormal];
    if ([actionTitle isEqualToString:@"USDT充值"]) {
        
        if ([g_config.aliPayStatus integerValue] != 1 && [g_config.wechatPayStatus integerValue] != 1 && [g_config.yunPayStatus integerValue] != 1) {
            //aliPayStatus;  //支付宝充值状态 1:开启 2：关闭 wechatWithdrawStatus; //微信提现状态1：开启 2：关闭
            [GKMessageTool showText:Localized(@"New_not_open_temporarily")];
            [self lianxikehu];
           
            return;
            
        }else {
            
            WH_RechargeVC *rechargeVC = [[WH_RechargeVC alloc] init];
            [g_navigation pushViewController:rechargeVC animated:YES];
            
//            WH_Recharge_WHViewController *rechargeVC = [[WH_Recharge_WHViewController alloc] init];
//            [g_navigation pushViewController:rechargeVC animated:YES];
            
            
            //            WH_NewRecharge_WHViewController *rechargeVC = [[WH_NewRecharge_WHViewController alloc] init];
            //            [g_navigation pushViewController:rechargeVC animated:YES];
        }
        
    } else if ([actionTitle isEqualToString:@"H5充值"]) {
        
//        NSString *str = [NSString stringWithFormat:@"http://ht.icloudpay.us/mobile/chongzhi/wahucz?accessToken=%@" ,g_server.access_token];
//        WH_webpage_WHVC *webVC = [WH_webpage_WHVC alloc];
//        webVC.isGoBack= YES;
//        webVC.isSend = YES;
//        webVC.title = @"";
//        webVC.url = str;
//        webVC = [webVC init];
//        [g_navigation.navigationView addSubview:webVC.view];
        
        WH_H5Transaction_JXViewController *tranVC = [[WH_H5Transaction_JXViewController alloc] init];
        tranVC.transactionType = 1;
        [g_navigation pushViewController:tranVC animated:YES];
        
    } else if ([actionTitle isEqualToString:@"USDT提现"]) {
        //        MiXin_WithdrawCoin_MiXinVC *vc = [[MiXin_WithdrawCoin_MiXinVC alloc] init];
        //        [g_navigation pushViewController:vc animated:YES];
        //        return;
        
        /**
         * aliWithdrawStatus  支付宝提现状态 1:开启 2：关闭
         * wechatWithdrawStatus 微信提现状态1：开启 2：关闭
         * isWithdrawToAdmin 是否提现到后台 1：开启
         */
        
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
                    
//                    WH_WithdrawalToBackground_WHViewController *withdrawalBGVC = [[WH_WithdrawalToBackground_WHViewController alloc] init];
//                    [g_navigation pushViewController:withdrawalBGVC animated:YES];
                    
                    
                }else {//没有支付密码
                    [BindTelephoneChecker checkBindPhoneWithViewController:self entertype:JXEnterTypeDefault];
                }
            } else {
                 
                WH_WithDreawVC *tranVC = [[WH_WithDreawVC alloc] init];
                [g_navigation pushViewController:tranVC animated:YES];
                
//                WH_JXCashWithDraw_WHViewController *cashWithVC = [[WH_JXCashWithDraw_WHViewController alloc] init];
//                [g_navigation pushViewController:cashWithVC animated:YES];
            }
        }
    }else if ([actionTitle isEqualToString:Localized(@"H5提现")]) {
        WH_H5Transaction_JXViewController *tranVC = [[WH_H5Transaction_JXViewController alloc] init];
        tranVC.transactionType = 2;
        [g_navigation pushViewController:tranVC animated:YES];
    }else if ([actionTitle isEqualToString:@"联系客服充值"]){
        [self lianxikehu];
    }else if ([actionTitle isEqualToString:@"C2C交易（推荐）"]) {
        WH_JXBuyAndPayListVC *vc = [[WH_JXBuyAndPayListVC alloc] init];
        [g_navigation pushViewController:vc animated:YES];
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
