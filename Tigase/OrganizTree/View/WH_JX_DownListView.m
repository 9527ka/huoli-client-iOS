//
//  WH_JX_DownListView.m
//  Tigase_imChatT
//
//  Created by 1 on 17/5/24.
//  Copyright © 2019年 YanZhenKui. All rights reserved.
//

#import "WH_JX_DownListView.h"

@interface WH_JX_DownListView ()
@property (nonnull, strong) UIView *backgroundView;
@property (nonatomic, strong) DownListPopOptionBlock optionBlock;
@end


@implementation WH_JX_DownListView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.alpha = 0.0f;
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(instancetype)WH_downlistPopOption:(DownListPopOptionBlock)block whichFrame:(CGRect)frame animate:(BOOL)animate {
    
    self.optionBlock = block;
    [self setupParams:animate];
    
    if (self.maxWidth > 0) {
        if (self.maxWidth + 50 < self.frame.size.width*self.wh_mutiple) {
            self.maxWidth = self.frame.size.width*self.wh_mutiple - 30;
        }else {
            self.maxWidth = self.maxWidth + 20;
        }
    }else {
        for (NSInteger i = 0; i < self.wh_listContents.count; i ++) {
            NSString *str = self.wh_listContents[i];
            NSString *imageStr = self.wh_listImages[i];
            CGSize size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size;
            if (imageStr.length > 0) {
                if (size.width > self.maxWidth - 60) {
                    self.maxWidth = size.width + 60;
                }
            }else {
                if (size.width > self.maxWidth) {
                    self.maxWidth = size.width + 20;
                }
            }
        }
    }
    
    [self WH_setupBackgourndview:frame];
    return self;
}


-(void)show {
    [UIView animateWithDuration:self.wh_animateTime animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(WH_tapGesturePressed)];
//        [self addGestureRecognizer:tapGesture];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self WH_tapGesturePressed];
}

#pragma mark - private
-(void) setupParams:(BOOL)animate {
    if (self.wh_lineHeight == 0) {
        self.wh_lineHeight = 40.0f;
    }
    if (self.wh_mutiple == 0) {
        self.wh_mutiple = 0.4f;
    }
    if (animate) {
        if (self.wh_animateTime == 0) {
            self.wh_animateTime = 0.2f;
        }
    } else {
        self.wh_animateTime = 0;
    }
}

// 创建背景
- (void) WH_setupBackgourndview:(CGRect)whichFrame {
    self.backgroundView = [UIView new];
    self.backgroundView.backgroundColor = HEXCOLOR(0x393b3f);
    self.backgroundView.layer.cornerRadius = 5;
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.borderWidth = 0.5;
    self.backgroundView.layer.borderColor = [HEXCOLOR(0xd8d8d8) CGColor];
    [self addSubview:self.backgroundView];
    [self WH_setupOptionButton];
    [self tochangeBackgroudViewFrame:whichFrame];
}
- (void) WH_setupOptionButton {
    if ((self.wh_listContents&&self.wh_listContents.count>0)) {
        for (NSInteger i = 0; i < self.wh_listContents.count; i++) {
            UIButton *optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            optionButton.frame = CGRectMake(0,
                                            self.wh_lineHeight*i,
                                            self.maxWidth,
                                            self.wh_lineHeight);
            if (_wh_color) {
                [optionButton setBackgroundColor:_wh_color];
            }
            
            optionButton.tag = i;
            BOOL unEnable = NO;
            if (self.wh_listEnables && self.wh_listEnables.count > 0) {
                BOOL enable = [self.wh_listEnables[optionButton.tag] boolValue];
                //                optionButton.enabled = enable;
                if (!enable){
                    unEnable = YES;
                    [optionButton addTarget:self action:@selector(WH_noPermission:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [optionButton addTarget:self action:@selector(WH_buttonSelectPressed:)
                           forControlEvents:UIControlEventTouchUpInside];
                }
            }else{
                [optionButton addTarget:self action:@selector(WH_buttonSelectPressed:)
                       forControlEvents:UIControlEventTouchUpInside];
            }
            
            [optionButton addTarget:self action:@selector(WH_buttonSelectDown:)
                   forControlEvents:UIControlEventTouchDown];
            [optionButton addTarget:self action:@selector(WH_buttonSelectOutside:)
                   forControlEvents:UIControlEventTouchUpOutside];
            [self.backgroundView addSubview:optionButton];
            
            [self WH_setupOptionContent:optionButton enable:unEnable];
        }
    }
}
- (void) WH_setupOptionContent:(UIButton *)optionButton enable:(BOOL)enable{
    if(self.wh_listImages && self.wh_listImages.count>0) {
        
        UIImageView *headImageView = [UIImageView new];
        headImageView.frame = CGRectMake(14, 10, self.wh_lineHeight-20, self.wh_lineHeight-20);
        headImageView.image = [UIImage imageNamed:self.wh_listImages[optionButton.tag]];
        [optionButton addSubview:headImageView];
        
        UILabel *contentLabel = [UILabel new];
        contentLabel.frame = CGRectMake(self.wh_lineHeight+7,
                                        0,
                                        self.frame.size.width-(self.wh_lineHeight-14),
                                        self.wh_lineHeight);
        contentLabel.text = self.wh_listContents[optionButton.tag];
        if (self.textColor) {
            contentLabel.textColor = self.textColor;
        }else {
            contentLabel.textColor = [UIColor whiteColor];
        }
        contentLabel.font = [UIFont systemFontOfSize:15];
        if (enable) {
            contentLabel.textColor = [UIColor grayColor];
        }
        [optionButton addSubview:contentLabel];
    } else {
        UILabel *contentLabel = [UILabel new];
        [optionButton addSubview:contentLabel];
        contentLabel.frame = optionButton.bounds;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.text = self.wh_listContents[optionButton.tag];
        if (self.textColor) {
            contentLabel.textColor = self.textColor;
        }else {
            contentLabel.textColor = [UIColor whiteColor];
        }
        contentLabel.font = [UIFont systemFontOfSize:15];
        if (enable) {
            contentLabel.textColor = [UIColor grayColor];
        }
    }
    
    if(optionButton.tag != 0) {
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [HEXCOLOR(0xd8d8d8) colorWithAlphaComponent:0.1];
        lineView.frame = CGRectMake(0,
                                    0,
                                    self.maxWidth,
                                    .5);
        [optionButton addSubview:lineView];
    }
    
}
- (void) tochangeBackgroudViewFrame:(CGRect)whichFrame {
    CGFloat self_w = self.frame.size.width;
    
    CGFloat which_x = whichFrame.origin.x;
    CGFloat which_w = whichFrame.size.width;
    CGFloat which_h = whichFrame.size.height;
    
    CGFloat background_x = which_x-((self.maxWidth/2)-which_w/2);
    CGFloat background_w = self.maxWidth;
    CGFloat background_h = self.wh_lineHeight*self.wh_listContents.count;
    CGFloat background_y;
    if (self.showType == DownListView_ShowUp) {
        background_y = whichFrame.origin.y - background_h - 10;
    }else {
        background_y = whichFrame.origin.y+which_h+10;
        if ((background_y + background_h) > JX_SCREEN_HEIGHT) {
            background_y = whichFrame.origin.y - background_h - 10;
            self.showType = DownListView_ShowUp;
        }
    }
    
    
    if (background_x < 10) {
        background_x = 10;
    }
//    if (self_w-(which_x+which_w)<=10||
//        ((self_w*self.mutiple/2)-which_w/2>=(self_w-(which_x+which_w)))) {
//        background_x = self_w-(self_w*self.mutiple)-10;
//    }
    
    if ((background_x + background_w + 10) > self_w) {
        background_x = self_w-(self.maxWidth)-10;
    }
    
    self.backgroundView.frame = CGRectMake(background_x, background_y, background_w, background_h);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downlistSelect_Black"]];
    [self addSubview:imageView];
    imageView.frame = CGRectMake(which_x+which_w/2-10,
                                 background_y-15,
                                 20,
                                 15);
    if (self.showType == DownListView_ShowUp) {
        imageView.image = [UIImage imageNamed:@"ic_public_menu"];
        imageView.frame = CGRectMake(imageView.frame.origin.x, background_y + background_h - 6, imageView.frame.size.width, imageView.frame.size.height);
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
// 点击消失
- (void) WH_tapGesturePressed {
    [UIView animateWithDuration:self.wh_animateTime animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:self.wh_animateTime animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}


#pragma mark - inside outside down

- (void) WH_buttonSelectPressed:(UIButton *)button {
    self.optionBlock(button.tag, self.wh_listContents[button.tag]);
    button.backgroundColor = [UIColor whiteColor];
    [self WH_tapGesturePressed];
}
-(void) WH_noPermission:(UIButton *)button{
    [g_App showAlert:Localized(@"OrgaVC_PermissionDenied")];
    [self WH_tapGesturePressed];
}
- (void) WH_buttonSelectDown:(UIButton *)button {
    button.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
}
- (void) WH_buttonSelectOutside:(UIButton *)button {
    button.backgroundColor = [UIColor whiteColor];
}


#pragma mark - dealloc

- (void)dealloc {
    self.optionBlock = nil;
}

@end
