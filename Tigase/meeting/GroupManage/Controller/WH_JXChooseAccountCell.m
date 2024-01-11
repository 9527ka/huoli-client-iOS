//
//  WH_JXChooseAccountCell.m
//  Tigase
//
//  Created by 1111 on 2024/1/10.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXChooseAccountCell.h"

@implementation WH_JXChooseAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 8.0f;
    self.bgView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.shadowOpacity = 0.5;
    self.bgView.layer.borderColor = [UIColor systemGray6Color].CGColor;
    self.bgView.layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
