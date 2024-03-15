//
//  WH_WithDreawCell.m
//  Tigase
//
//  Created by 1111 on 2023/12/8.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_WithDreawCell.h"
#import "WH_webpage_WHVC.h"
#import "WH_JXBuyAndPayListVC.h"

@interface WH_WithDreawCell()<UITextFieldDelegate>

@end

@implementation WH_WithDreawCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdtingAction)];
    [self.contentView addGestureRecognizer:tap1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBord:) name:UIKeyboardWillShowNotification object:nil];
    
    self.orderNoField.delegate = self;
    
    //添加圆角以及阴影
    self.noticeBgView.layer.cornerRadius =  self.bgTopView.layer.cornerRadius = self.bgBottomView.layer.cornerRadius = 8.0f;
//    self.bgTopView.layer.shadowColor = self.bgBottomView.layer.shadowColor = [UIColor grayColor].CGColor;
//    self.bgTopView.layer.shadowOffset = self.bgBottomView.layer.shadowOffset = CGSizeMake(0, 0);
//    self.bgTopView.layer.shadowOpacity = self.bgBottomView.layer.shadowOpacity = 0.5;
    self.certainBtn.layer.cornerRadius = 24.0f;
    self.allBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    self.monyCountLab.text = [NSString stringWithFormat:@"余额HOTC%.2f = USDT%.2f",g_App.myMoney,g_App.myMoney];
    [self.monyField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    if(g_App.usdtUrl.length > 0){
        self.orderNoField.text = g_App.usdtUrl;
    }
    
    self.monyField.placeholder = [NSString stringWithFormat:@"请输入至少%@的HOTC金额",g_config.minTransferAmount];
    
    
    NSString *contentStr = [NSString stringWithFormat:@"友情提示\n1.每次提币金额在%@~%@HOTC之间。\n2.提现手续费为%@%@。\n3.提现时间为0-24小时。\n4.此处为USDT加密货币提现（什么是加密货币提现？）",g_config.minTransferAmount,g_config.maxTransferAmount,g_config.transferRate,@"%"];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:contentStr];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f]  range:NSMakeRange(0, 4)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x161819) range:NSMakeRange(0, 4)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:THEMECOLOR range:NSMakeRange(contentStr.length - 12, 12)];
    
    //段落格式
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 6;//行间距
    /// 添加段落设置
    [attributedText addAttribute:NSParagraphStyleAttributeName
    value:paragraph range:NSMakeRange(0, contentStr.length)];
    
    
    self.detaileLab.attributedText = attributedText;
    
    self.monyCountLab.text = [NSString stringWithFormat:@"USDT 1 = HOTC %@",g_App.rate];
    
}
-(void)showKeyBord:(NSNotification *)notifi{
    NSDictionary *info = [notifi userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboradSize = [value CGRectValue].size;
    if(keyboradSize.height > 0&& self.orderNoField.secureTextEntry){
        self.orderNoField.secureTextEntry = NO;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.orderNoField) {
        textField.secureTextEntry = YES;
    }
}

-(void)textFieldChanged:(UITextField *)textField{
    if(textField.text.doubleValue > g_App.myMoney){
        self.monyField.text = [NSString stringWithFormat:@"%.2f",g_App.myMoney];
    }
    [self changeUsDTCount];
    
}
-(void)changeUsDTCount{
    //服务费
    NSString *transferRateStr = [NSString stringWithFormat:@"%.2f",g_config.transferRate.floatValue/100*self.monyField.text.doubleValue];
    self.transferRateLab.text = [NSString stringWithFormat:@"服务费：%@HOTC",transferRateStr];
    //实际到账
    float count = self.monyField.text.doubleValue - transferRateStr.floatValue;
    NSString *trealStr = [NSString stringWithFormat:@"%.2f",count/g_App.rate.floatValue];
    self.realMoneyLab.text = [NSString stringWithFormat:@"实际到账：%@USDT",trealStr];
}
-(void)endEdtingAction{
    [self endEditing:YES];
}
//全部提现
- (IBAction)allAction:(id)sender {
    [self endEditing:YES];
    self.allBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    NSString * moneyStr = [NSString stringWithFormat:@"%.2f",g_App.myMoney];
    self.monyField.text = moneyStr;
    
    [self changeUsDTCount];
}

//确认
- (IBAction)certainAction:(id)sender {
    [self endEditing:YES];
    if(self.monyField.text.length == 0 || self.monyField.text.floatValue < g_config.minTransferAmount.floatValue){
        [g_server showMsg:[NSString stringWithFormat:@"请输入至少%@的HOTC金额",g_config.minTransferAmount]];
        return;
    }
    if(self.monyField.text.floatValue > g_config.maxTransferAmount.floatValue){
        [g_server showMsg:[NSString stringWithFormat:@"请输入%@以内的HOTC金额",g_config.maxTransferAmount]];
        return;
    }
    if(self.orderNoField.text.length == 0){
        [g_server showMsg:@"请填写USDT-TRC20"];
        return;
    }
    if(self.certainBlock){
        self.certainBlock(self.monyField.text, self.orderNoField.text);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)reSetRate{
//    if(g_App.myMoney > 0.0){
//        self.monyCountLab.text = [NSString stringWithFormat:@"余额HOTC%.2f = USDT%.2f",g_App.myMoney,g_App.myMoney/g_App.rate.doubleValue];
//    }
    
    self.monyCountLab.text = [NSString stringWithFormat:@"USDT 1 = HOTC %@",g_App.rate];
    
}
//400+
- (IBAction)lookUrlDetaileAction:(UIButton *)sender {
    if(sender.tag == 400){//跳转C2C交易的出售列表
        WH_JXBuyAndPayListVC *vc = [[WH_JXBuyAndPayListVC alloc] init];
        [g_navigation pushViewController:vc animated:YES];
    }else{//什么是加密货币提现？
    
        WH_webpage_WHVC *webVC = [WH_webpage_WHVC alloc];
        webVC.wh_isGotoBack= YES;
        webVC.isSend = YES;
        webVC.titleString = @"加密货币提现";
        webVC.url = [NSString stringWithFormat:@"%@",@"https://www.huoli68.com/?industry/6.html"];
        
        webVC = [webVC init];
        [g_navigation.navigationView addSubview:webVC.view];
    }
    
}

@end
