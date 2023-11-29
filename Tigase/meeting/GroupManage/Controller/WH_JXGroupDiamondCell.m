//
//  WH_JXGroupDiamondCell.m
//  Tigase
//
//  Created by luan on 2023/5/31.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupDiamondCell.h"

@implementation WH_JXGroupDiamondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarImage.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)updateDiamondNumer:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateDiamondNumber:type:)]) {
        [self.delegate updateDiamondNumber:self.tag type:sender.tag];
    }
}

@end
