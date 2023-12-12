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
    self.payCountLab.text = [NSString stringWithFormat:@"应付 ￥%.2f",textField.text.length > 0?textField.text.doubleValue:0.00];
}
-(void)rulerAction{
    WH_webpage_WHVC *webVC = [WH_webpage_WHVC alloc];
    webVC.wh_isGotoBack= YES;
    webVC.isSend = YES;
    webVC.url = @"";
    webVC = [webVC init];
    [g_navigation.navigationView addSubview:webVC.view];
}
//最大的点击事件
- (IBAction)bigAction:(id)sender {
    self.countField.text = @"10000";
}
- (IBAction)certainAction:(id)sender {
    if(self.countField.text.length == 0){
        [g_server showMsg:@"请输入HOTC数量"];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
