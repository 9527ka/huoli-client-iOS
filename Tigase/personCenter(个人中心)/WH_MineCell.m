//
//  WH_MineCell.m
//  Tigase
//
//  Created by 1111 on 2024/3/27.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_MineCell.h"

@implementation WH_MineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0f;
}

@end
