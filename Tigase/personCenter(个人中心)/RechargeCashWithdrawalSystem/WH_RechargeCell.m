//
//  WH_RechargeCell.m
//  Tigase
//
//  Created by 1111 on 2023/12/7.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_RechargeCell.h"


@implementation WH_RechargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdtingAction)];
    [self.contentView addGestureRecognizer:tap1];
    
    //添加圆角以及阴影
    self.bgTopView.layer.cornerRadius = self.bgBottomView.layer.cornerRadius = 8.0f;
    self.bgTopView.layer.shadowColor = self.bgBottomView.layer.shadowColor = [UIColor blackColor].CGColor;
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
        countBtn.layer.borderWidth = 0.6f;
        countBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    
    self.numCopyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
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
    NSString *countStr = [NSString stringWithFormat:@"%ld",sender.tag];
    self.monyField.text = countStr;
}
//复制
- (IBAction)copyAction:(id)sender {
    [self endEditing:YES];
    UIPasteboard *pastBoard = [UIPasteboard generalPasteboard];
    pastBoard.string = self.addressLab.text;
    [g_server showMsg:@"复制成功"];
}
//确认
- (IBAction)certainAction:(id)sender {
    [self endEditing:YES];
}
//指南
- (IBAction)guideAction:(id)sender {
    [self endEditing:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
