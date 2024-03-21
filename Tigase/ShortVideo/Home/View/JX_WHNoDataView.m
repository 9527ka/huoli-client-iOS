//
//  JX_WHNoDataView.m
//  Tigase
//
//  Created by 1111 on 2024/3/21.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "JX_WHNoDataView.h"



@implementation JX_WHNoDataView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    [self addSubview:self.iconImage];
    [self addSubview:self.nodataTitle];
    [self addSubview:self.commentBtn];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(4);
        make.centerX.equalTo(self);
    }];
    [self.nodataTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage.mas_bottom).offset(16);
        make.centerX.equalTo(self);
    }];
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nodataTitle.mas_bottom).offset(60);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(158);
        make.height.mas_equalTo(42);
    }];
    
    
}
-(UIImageView *)iconImage{
    if(!_iconImage){
        _iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_comment_icon"]];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImage;
}
-(UILabel *)nodataTitle{
    if(!_nodataTitle){
        _nodataTitle = [[UILabel alloc] init];
        _nodataTitle.text = @"期待你的评论";
        _nodataTitle.font = [UIFont systemFontOfSize:16];
        _nodataTitle.textColor = HEXCOLOR(0xBABABA);
    }
    return _nodataTitle;
}
-(UIButton *)commentBtn{
    if(!_commentBtn){
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setTitle:@"去评论" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:HEXCOLOR(0x161819) forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _commentBtn.backgroundColor = HEXCOLOR(0xf3f3f3);
        _commentBtn.layer.masksToBounds = YES;
        _commentBtn.layer.cornerRadius = 6.0f;
        [_commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}
-(void)commentAction{
    if(self.commentBlock){
        self.commentBlock();
    }
}

@end
