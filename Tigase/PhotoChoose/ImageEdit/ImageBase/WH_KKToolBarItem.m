//
//  KKToolBarItem.m
//  WWImageEdit
//
//  Created by 邬维 on 2017/1/3.
//  Copyright © 2017年 kook. All rights reserved.
//

#import "WH_KKToolBarItem.h"
#import "WH_UIView+Frame.h"

#define ICON_SIZE 24

@implementation WH_KKToolBarItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat W = frame.size.width;
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake((W-ICON_SIZE)*0.5, 4, ICON_SIZE, ICON_SIZE)];
        _iconView.clipsToBounds = YES;
        _iconView.layer.cornerRadius = 5;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.bottom+2, W, 15)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(WH_KKImageToolInfo*)toolInfo
{
    self = [self initWithFrame:frame];
    if(self){
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [self addGestureRecognizer:gesture];
        _imgToolInfo = toolInfo;
        _titleLabel.text = toolInfo.title;
        _iconView.image = toolInfo.iconImage;
    }
    return self;
}



- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    self.alpha = (userInteractionEnabled) ? 1 : 0.3;
}

- (void)setSelected:(BOOL)selected
{
    if(selected != _selected){
        _selected = selected;
        if(selected){
            self.backgroundColor = [UIColor grayColor];
        }
        else{
            self.backgroundColor = [UIColor clearColor];
        }
    }
}



- (void)sp_upload {
    //NSLog(@"Get Info Success");
}
@end
