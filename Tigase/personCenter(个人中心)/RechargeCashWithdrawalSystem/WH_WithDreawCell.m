//
//  WH_WithDreawCell.m
//  Tigase
//
//  Created by 1111 on 2023/12/8.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_WithDreawCell.h"

@implementation WH_WithDreawCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdtingAction)];
    [self.contentView addGestureRecognizer:tap1];
    
    //添加圆角以及阴影
    self.bgTopView.layer.cornerRadius = self.bgBottomView.layer.cornerRadius = 8.0f;
    self.bgTopView.layer.shadowColor = self.bgBottomView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bgTopView.layer.shadowOffset = self.bgBottomView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgTopView.layer.shadowOpacity = self.bgBottomView.layer.shadowOpacity = 0.5;
    self.certainBtn.layer.cornerRadius = 8.0f;
    self.allBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.monyCountLab.text = [NSString stringWithFormat:@"余额HOTC%.2f = USDT%.2f",g_App.myMoney,g_App.myMoney];
    [self.monyField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    if(g_App.usdtUrl.length > 0){
        self.orderNoField.text = g_App.usdtUrl;
    }
    
}
-(void)textFieldChanged:(UITextField *)textField{
    if(textField.text.doubleValue > g_App.myMoney){
        self.monyField.text = [NSString stringWithFormat:@"%.2f",g_App.myMoney];
    }
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
    
}

//确认
- (IBAction)certainAction:(id)sender {
    [self endEditing:YES];
    if(self.monyField.text.length == 0 || self.monyField.text.floatValue < 100){
        [g_server showMsg:@"请输入100以上的HOTC金额"];
        return;
    }
    if(self.monyField.text.floatValue > 10000){
        [g_server showMsg:@"请输入10000以内的HOTC金额"];
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
    if(g_App.myMoney > 0.0){
        self.monyCountLab.text = [NSString stringWithFormat:@"余额HOTC%.2f = USDT%.2f",g_App.myMoney,g_App.myMoney/g_App.rate.doubleValue];
    }
    
}

@end
