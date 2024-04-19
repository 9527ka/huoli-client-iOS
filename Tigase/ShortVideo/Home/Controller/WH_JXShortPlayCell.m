//
//  WH_JXShortPlayCell.m
//  Tigase
//
//  Created by 1111 on 2024/4/19.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXShortPlayCell.h"

@implementation WH_JXShortPlayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.coverImage.layer.masksToBounds = YES;
    self.coverImage.layer.cornerRadius = 12.0f;
}

@end
