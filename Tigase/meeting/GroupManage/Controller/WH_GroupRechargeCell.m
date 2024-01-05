//
//  WH_GroupRechargeCell.m
//  Tigase
//
//  Created by 1111 on 2023/12/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_GroupRechargeCell.h"
#import "WH_webpage_WHVC.h"

@implementation WH_GroupRechargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdtingAction)];
    [self.contentView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rulerAction)];
    [self.rulerLab addGestureRecognizer:tap2];
    
    NSMutableAttributedString *rulerStr = [[NSMutableAttributedString alloc] initWithString:self.rulerLab.text];
    [rulerStr addAttribute:NSForegroundColorAttributeName value:[UIColor linkColor] range:NSMakeRange(self.rulerLab.text.length - 6, 6)];
    self.rulerLab.attributedText = rulerStr;
    
    //添加圆角以及阴影
    self.payBgView.layer.cornerRadius = 8.0f;
    self.zfbBgView.layer.cornerRadius = 8.0f;
    self.vxBgView.layer.cornerRadius = 8.0f;
    self.payBgView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.zfbBgView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.vxBgView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.payBgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.zfbBgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.vxBgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.payBgView.layer.shadowOpacity = 0.5;
    self.zfbBgView.layer.shadowOpacity = 0.5;
    self.vxBgView.layer.shadowOpacity = 0.5;
    self.certainBtn.layer.cornerRadius = 8.0f;
    self.zfbPayLab.layer.cornerRadius = 9.0f;
    self.vxPayLab.layer.cornerRadius = 9.0f;
    
    [self.countField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    
}
-(void)textChanged:(UITextField *)textField{
//    if(textField.text.doubleValue > self.balance.doubleValue){
//        textField.text = self.balance;
//    }
    
    if(self.model){
        float sellCharge = textField.text.floatValue * self.model.sellCharge.floatValue;
        //应得
        float grossPay = self.model.isBuy?textField.text.floatValue + sellCharge:textField.text.floatValue - sellCharge;
        
        self.payCountLab.text = [NSString stringWithFormat:@"%@ ￥%.2f",self.model.isBuy?@"应付":@"可得",textField.text.length > 0?grossPay:0.00];
    }else{
        self.payCountLab.text = [NSString stringWithFormat:@"应付 ￥%.2f",textField.text.length > 0?textField.text.doubleValue:0.00];
    }
    

}
-(void)rulerAction{
    WH_webpage_WHVC *webVC = [WH_webpage_WHVC alloc];
    webVC.wh_isGotoBack= YES;
    webVC.isSend = YES;
    webVC.titleString = @"免责声明";
    webVC.url = [NSString stringWithFormat:@"%@/pages/terms/trade_term.html",BaseUrl];
    
    webVC = [webVC init];
    [g_navigation.navigationView addSubview:webVC.view];
}
//最大的点击事件
- (IBAction)bigAction:(id)sender {
    self.countField.text = self.balance;
}
- (IBAction)certainAction:(id)sender {
    if(self.countField.text.length == 0){
        [g_server showMsg:@"请输入HOTC数量"];
        return;
    }
    if(self.countField.text.doubleValue > self.balance.doubleValue && !self.model){
        [g_server showMsg:@"超出群主限额"];
        return;
    }
    if(self.certainBlock){
        self.certainBlock(self.countField.text,self.type);
    }
}
//500+
- (IBAction)chooseTypeAction:(UIButton *)sender {
    self.type = sender.tag - 500;
    if(sender.tag== 500){
        self.zfbChooseImage.hidden = NO;
        self.vxChooseImage.hidden = YES;
    }else{
        self.zfbChooseImage.hidden = YES;
        self.vxChooseImage.hidden = NO;
    }
}

-(void)endEdtingAction{
    [self endEditing:YES];
}

-(void)setPayArray:(NSArray *)payArray{
    _payArray = payArray;
    //只有一个的时候看看是什么类型
    if(payArray.count == 1){
        NSDictionary *dic = payArray.firstObject;
        NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
        if(type.intValue == 1){//微信
            self.zfbBgView.hidden = YES;
            self.vxBgView.hidden = NO;
            self.vxViewTopConstant.constant = 24;
            self.vxChooseImage.hidden = NO;
            [self.contentView bringSubviewToFront:self.vxBgView];
        }else{//支付宝
            self.vxBgView.hidden = YES;
            self.zfbBgView.hidden = NO;
            self.vxViewTopConstant.constant = 24;
            self.zfbChooseImage.hidden = NO;
            [self.contentView bringSubviewToFront:self.zfbBgView];
        }
    }else if (payArray.count == 0){
        self.vxBgView.hidden = self.zfbBgView.hidden = YES;
        self.vxViewTopConstant.constant = 24;
    }else{
        self.vxBgView.hidden = self.zfbBgView.hidden = NO;
        self.vxViewTopConstant.constant = 128;
    }
}
-(void)setBalance:(NSString *)balance{
    _balance = balance;
    self.limitCountLab.text = [NSString stringWithFormat:@"限额：0.00-%.2fHOTC",balance.doubleValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setModel:(WH_JXBuyAndPayListModel *)model{
    _model = model;
    self.timeTitle.text = @"20分钟";
    self.userInfoTitle.text = @"商家信息";
    self.userNameTitle.text = @"商家昵称";
    self.groupNameLab.text = model.name;
    
    [self.certainBtn setTitle:model.isBuy?@"0手续买入HOTC":@"0手续卖出HOTC" forState:UIControlStateNormal];
    
    self.vxBgView.hidden = self.zfbBgView.hidden = YES;
    self.vxViewTopConstant.constant = 24;
    
    //只有一个的时候看看是什么类型
    if(model.alipayCode.length > 0 && model.wechatCode.length == 0){
        //支付宝
        self.vxBgView.hidden = YES;
        self.zfbBgView.hidden = NO;
        self.vxViewTopConstant.constant = 24;
        self.zfbChooseImage.hidden = NO;
        [self.contentView bringSubviewToFront:self.zfbBgView];
        
    }else if (model.alipayCode.length == 0 && model.wechatCode.length > 0){
        //微信
        self.zfbBgView.hidden = YES;
        self.vxBgView.hidden = NO;
        self.vxViewTopConstant.constant = 24;
        self.vxChooseImage.hidden = NO;
        [self.contentView bringSubviewToFront:self.vxBgView];
        
    }else{
        self.vxBgView.hidden = self.zfbBgView.hidden = NO;
        self.vxViewTopConstant.constant = 128;
    }
}

@end
