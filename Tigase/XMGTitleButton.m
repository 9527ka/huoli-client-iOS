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
        [self setTitleColor:HEXCOLOR(0x161819) forState:UIControlStateNormal];
        [self setTitleColor:HEXCOLOR(0x2BAF67) forState:UIControlStateDisabled];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return self;
}
@end
