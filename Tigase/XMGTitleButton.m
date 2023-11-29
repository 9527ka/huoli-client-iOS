//
//  XMGTitleButton.m
//  备课-百思不得姐
//
//  Created by MJ Lee on 15/6/15.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGTitleButton.h"

@implementation XMGTitleButton
- (nonnull instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:RGB(151, 151, 151) forState:UIControlStateNormal];
        [self setTitleColor:RGB(51, 51, 51) forState:UIControlStateDisabled];
        self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold]; 
       // [self setBackgroundImage:[UIImage imageNamed:@"first-icon3"] forState:UIControlStateNormal];
       // [self setBackgroundImage:[UIImage imageNamed:@"homePage"] forState:UIControlStateDisabled];
        self.layer.cornerRadius = 18;
        self.layer.masksToBounds = YES;
    }
    return self;
}
@end
