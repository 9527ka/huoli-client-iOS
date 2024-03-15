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
    
    self.payTypeBgView.layer.cornerRadius = 6.0f;
    self.rightNowTitle.layer.cornerRadius = 4.0f;
    self.uploadBtn.layer.cornerRadius = 6.0f;
    
    self.nameField.layer.cornerRadius = 6.0f;
    self.accountField.layer.cornerRadius = 6.0f;
    self.phoneField.layer.cornerRadius = 6.0f;
    self.bankField.layer.cornerRadius = 6.0f;
    
    self.nameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20 , 46)];
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    self.accountField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20 , 46)];
    self.accountField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20 , 46)];
    self.phoneField.leftViewMode = UITextFieldViewModeAlways;
    self.bankField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20 , 46)];
    self.bankField.leftViewMode = UITextFieldViewModeAlways;
    
    self.saveBtn.layer.cornerRadius = 24.0f;
    
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
//    if (self.nameField.text.length == 0) {
//        [g_server showMsg:@"请输入真实姓名"];
//        return;
//    }
//    if (self.accountField.text.length == 0) {
//        [g_server showMsg:@"请输入账号"];
//        return;
//    }
//    if (self.passwordField.text.length == 0) {
//        [g_server showMsg:@"请输入交易密码"];
//        return;
//    }
    if(self.certainBlock){
        self.certainBlock(self.nameField.text.length > 0?self.nameField.text:@"", self.accountField.text.length > 0?self.accountField.text:@"",@"", self.phoneField.text.length > 0?self.phoneField.text:@"",self.bankField.text.length > 0?self.bankField.text:@"");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
