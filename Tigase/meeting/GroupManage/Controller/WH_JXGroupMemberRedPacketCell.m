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
    
    self.avatarImage.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
