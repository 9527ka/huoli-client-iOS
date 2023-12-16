//
//  WH_AddAccountCell.m
//  Tigase
//
//  Created by 1111 on 2023/12/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_AddAccountCell.h"

@implementation WH_AddAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.payTypeBgView.layer.cornerRadius = 4.0f;
    self.payTypeBgView.layer.borderColor = [UIColor systemGray5Color].CGColor;
    self.payTypeBgView.layer.borderWidth = 0.6f;
    
    self.uploadBtn.layer.cornerRadius = 4.0f;
    self.uploadBtn.layer.borderColor = [UIColor systemGray5Color].CGColor;
    self.uploadBtn.layer.borderWidth = 0.6f;
    
    self.saveBtn.layer.cornerRadius = 22.0f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingAction)];
    [self.contentView addGestureRecognizer:tap];
    
    
}

-(void)endEditingAction{
    [self endEditing:YES];
}
- (IBAction)chooseTypeAction:(id)sender {
    [self endEditing:YES];
    if(self.chooseTypeBlock){
        self.chooseTypeBlock();
    }
}
- (IBAction)uploadImageAction:(id)sender {
    [self endEditing:YES];
    if(self.chooseImageBlock){
        self.chooseImageBlock();
    }
}
- (IBAction)certainAction:(id)sender {
    [self endEditing:YES];
    if (self.nameField.text.length == 0) {
        [g_server showMsg:@"请输入真实姓名"];
        return;
    }
    if (self.accountField.text.length == 0) {
        [g_server showMsg:@"请输入账号"];
        return;
    }
//    if (self.passwordField.text.length == 0) {
//        [g_server showMsg:@"请输入交易密码"];
//        return;
//    }
    if(self.certainBlock){
        self.certainBlock(self.nameField.text, self.accountField.text,@"");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
