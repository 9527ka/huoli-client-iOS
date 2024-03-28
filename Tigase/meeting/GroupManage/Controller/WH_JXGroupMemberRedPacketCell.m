//
//  WH_JXGroupMemberRedPacketCell.m
//  Tigase
//
//  Created by luan on 2023/6/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupMemberRedPacketCell.h"

@implementation WH_JXGroupMemberRedPacketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImage.layer.cornerRadius = 21;
    self.avatarImage.layer.borderColor = HEXCOLOR(0xF6D2A0).CGColor;
    self.avatarImage.layer.borderWidth = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
