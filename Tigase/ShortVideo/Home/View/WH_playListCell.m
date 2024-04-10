//
//  WH_playListCell.m
//  Tigase
//
//  Created by 1111 on 2024/4/7.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_playListCell.h"

@implementation WH_playListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.coverImage.layer.cornerRadius = 6.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
