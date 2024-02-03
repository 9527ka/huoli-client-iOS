//
//  WH_RechargeCell.m
//  Tigase
//
//  Created by 1111 on 2023/12/7.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_RechargeCell.h"
#import "WH_webpage_WHVC.h"

@interface WH_RechargeCell()<UITextFieldDelegate>

@end

@implementation WH_RechargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdtingAction)];
    [self.contentView addGestureRecognizer:tap1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBord:) name:UIKeyboardWillShowNotification object:nil];
    self.orderNoField.delegate = self;
    //添加圆角以及阴影
    self.bgTopView.layer.cornerRadius = self.bgBottomView.layer.cornerRadius = 8.0f;
    self.bgTopView.layer.shadowColor = self.bgBottomView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bgTopView.layer.shadowOffset = self.bgBottomView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgTopView.layer.shadowOpacity = self.bgBottomView.layer.shadowOpacity = 0.5;
    self.numCopyBtn.layer.cornerRadius = 16.0f;
    self.certainBtn.layer.cornerRadius = 8.0f;
    
    self.uploadImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageAction)];
    [self.uploadImage addGestureRecognizer:tap];
    

    NSArray *tagArray = @[@(10),@(50),@(100),@(300),@(500),@(1000),@(5000),@(10000)];
    for (NSNumber *tag in tagArray) {
        UIButton *countBtn = (UIButton *)[self.bgTopView viewWithTag:tag.intValue];
        countBtn.layer.cornerRadius = 13.0f;
        countBtn.layer.borderColor = [UIColor systemBlueColor].CGColor;
        countBtn.layer.borderWidth = 0.8f;
        countBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    self.numCopyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [self.monyField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.addressLab.text = [NSString stringWithFormat:@"%@",g_config.sysUsdtUrl];
    
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
    if(self.monyField.text.length > 0 && g_App.rate.doubleValue > 0.0){
        
        self.monyCountLab.text = [NSString stringWithFormat:@"应付：USDT%.2f",self.monyField.text.doubleValue/g_App.rate.doubleValue];
    }else{
        self.monyCountLab.text = @"应付：USDT0.00";
    }
}
-(void)endEdtingAction{
    [self endEditing:YES];
}
//选择图片
-(void)chooseImageAction{
    [self endEditing:YES];
    if(self.chooseImageBlock){
        self.chooseImageBlock();
    }
}
- (IBAction)countAction:(UIButton *)sender {
    [self endEditing:YES];
    sender.titleLabel.font = [UIFont systemFontOfSize:12];
    NSString *countStr = [NSString stringWithFormat:@"%ld",sender.tag];
    self.monyField.text = countStr;
}
//复制
- (IBAction)copyAction:(id)sender {
    [self endEditing:YES];
    self.numCopyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    UIPasteboard *pastBoard = [UIPasteboard generalPasteboard];
    pastBoard.string = self.addressLab.text;
    [g_server showMsg:@"复制成功"];
}
//确认
- (IBAction)certainAction:(id)sender {
    [self endEditing:YES];
    if(self.monyField.text.length == 0){
        [g_server showMsg:@"请输入充值的HOTC金额"];
        return;
    }
    if(self.orderNoField.text.length == 0){
        [g_server showMsg:@"请填写交易TXID或者交易HASH"];
        return;
    }
    if(self.certainBlock){
        self.certainBlock(self.monyField.text, self.orderNoField.text);
    }
}
//指南
- (IBAction)guideAction:(id)sender {
    [self endEditing:YES];
    WH_webpage_WHVC *webVC = [WH_webpage_WHVC alloc];
    webVC.wh_isGotoBack= YES;
    webVC.isSend = YES;
//    webVC.url = [NSString stringWithFormat:@"%@/pages/terms/recharge_term.html",BaseUrl];
    webVC.url = @"https://www.huoli68.com/?company/8.html";
    webVC = [webVC init];
    [g_navigation.navigationView addSubview:webVC.view];
}

-(void)reSetRate{
    self.rateLab.text = [NSString stringWithFormat:@"充值USDT 1 = HOTC %@",g_App.rate];
    if(self.monyField.text.length > 0){
        
        self.monyCountLab.text = [NSString stringWithFormat:@"应付：USDT%.2f",self.monyField.text.doubleValue/g_App.rate.doubleValue];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
