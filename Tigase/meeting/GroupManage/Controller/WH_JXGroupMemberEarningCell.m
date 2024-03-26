//
//  WH_JXGroupMemberEarningCell.m
//  Tigase
//
//  Created by 1111 on 2024/3/25.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXGroupMemberEarningCell.h"

@implementation WH_JXGroupMemberEarningCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImage.layer.cornerRadius = 21.0f;
    self.bgView.layer.cornerRadius = 10.0f;
    self.bgView.layer.borderColor = HEXCOLOR(0xF6D2A0).CGColor;
    self.bgView.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
