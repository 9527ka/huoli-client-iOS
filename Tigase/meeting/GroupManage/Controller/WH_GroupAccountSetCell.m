//
//  WH_GroupAccountSetCell.m
//  Tigase
//
//  Created by 1111 on 2023/12/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_GroupAccountSetCell.h"

@implementation WH_GroupAccountSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.unitLab.layer.cornerRadius = 4.0f;
    self.rightPayLab.layer.cornerRadius = 9.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
