//
//  WH_JXChatDefaultBgCell.m
//  Tigase
//
//  Created by 1111 on 2024/2/28.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXChatDefaultBgCell.h"

@implementation WH_JXChatDefaultBgCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.0f;
        
        [self.contentView addSubview:self.bgImage];
        [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
    }
    return self;
}
-(UIImageView *)bgImage{
    if(!_bgImage){
        _bgImage = [[UIImageView alloc] init];
        _bgImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImage;
}

@end
