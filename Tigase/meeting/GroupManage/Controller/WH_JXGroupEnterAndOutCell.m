//
//  WH_JXGroupEnterAndOutCell.m
//  Tigase
//
//  Created by luan on 2023/7/8.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupEnterAndOutCell.h"

@implementation WH_JXGroupEnterAndOutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.memberImage.layer.cornerRadius = 19.0f;
    self.operatorImage.layer.cornerRadius = 19.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
