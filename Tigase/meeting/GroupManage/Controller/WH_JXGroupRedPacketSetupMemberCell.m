//
//  WH_JXGroupRedPacketSetupMemberCell.m
//  Tigase
//
//  Created by luan on 2023/7/9.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupRedPacketSetupMemberCell.h"

@implementation WH_JXGroupRedPacketSetupMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarImage.layer.cornerRadius = 5;
    self.avatarImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
