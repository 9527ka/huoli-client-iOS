//
//  WH_JXBuyAndPayListCell.m
//  Tigase
//
//  Created by 1111 on 2024/1/2.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXBuyAndPayListCell.h"

@implementation WH_JXBuyAndPayListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImage.layer.cornerRadius = 4.0f;
    self.onlineLab.layer.cornerRadius = 6.0f;
    self.zfbBgView.layer.cornerRadius = 4.0f;
    self.wxBgView.layer.cornerRadius = 4.0f;
    self.buyBtn.layer.cornerRadius = 14.0f;
    
}
- (IBAction)buyAction:(id)sender {
    if(self.buyBlock){
        self.buyBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(WH_JXBuyAndPayListModel *)model{
    _model = model;
    self.nameLab.text = model.name;
    self.zfbBgView.hidden = model.alipayCode.length > 0?NO:YES;
    self.wxBgView.hidden = model.wechatCode.length > 0?NO:YES;
    self.wxLeftConstant.constant = model.alipayCode.length > 0?112.0f:16.0f;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_normal"]];
    self.onlineLab.hidden = !model.online;
}

@end
