//
//  WH_JXAppealListCell.m
//  Tigase
//
//  Created by 1111 on 2023/12/22.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXAppealListCell.h"

@implementation WH_JXAppealListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picBgViewHeight.constant = 0.0f;
    self.headImage.layer.cornerRadius = 15.0f;
    self.bgView.layer.cornerRadius = 4.0f;
    self.picBgView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
