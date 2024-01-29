//
//  WH_JXAgentCell.m
//  Tigase
//
//  Created by 1111 on 2024/1/19.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXAgentCell.h"

@implementation WH_JXAgentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.commitBtn.layer.cornerRadius = 8.0f;
}
//上传图片或者视频 700+
- (IBAction)uploadImageAction:(UIButton *)sender {
    if(self.chooseImageBlock){
        self.chooseImageBlock(sender.tag - 700);
    }
}
- (IBAction)commitAction:(id)sender {
    
    if(self.nameField.text.length == 0){
        [g_server showMsg:@"请输入姓名"];
        return;
    }
    if(self.phoneField.text.length == 0){
        [g_server showMsg:@"请输入手机号码"];
        return;
    }
    if(self.cardNumField.text.length == 0){
        [g_server showMsg:@"请输入身份证号"];
        return;
    }
    
    if (self.commitBlock) {
        self.commitBlock(self.nameField.text,self.phoneField.text,self.cardNumField.text);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
