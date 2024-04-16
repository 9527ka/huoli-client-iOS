//
//  WH_PopularVideoCell.m
//  Tigase
//
//  Created by 1111 on 2024/4/11.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_PopularVideoCell.h"

@implementation WH_PopularVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 8.0f;
    self.bgView.layer.borderColor = THEMECOLOR.CGColor;
    self.bgView.layer.borderWidth = 2.0f;
}
- (IBAction)chooseAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.chooseVideoBlock) {
        self.chooseVideoBlock();
    }
}



@end
