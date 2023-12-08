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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
