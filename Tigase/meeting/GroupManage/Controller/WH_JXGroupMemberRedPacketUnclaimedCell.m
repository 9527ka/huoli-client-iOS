//
//  WH_JXGroupMemberRedPacketUnclaimedCell.m
//  Tigase
//
//  Created by luan on 2023/6/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupMemberRedPacketUnclaimedCell.h"

@implementation WH_JXGroupMemberRedPacketUnclaimedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImage.layer.cornerRadius = 22;
    self.bgView.layer.cornerRadius = 10.0f;
    self.bgView.layer.borderColor = HEXCOLOR(0xF6D2A0).CGColor;
    self.bgView.layer.borderWidth = 0.5;
    self.receiveLab.layer.cornerRadius = 13.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
