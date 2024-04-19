//
//  UserInfoHeader.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "UserInfoHeader.h"
#import "Masonry.h"


@interface UserInfoHeader ()



@end

@implementation UserInfoHeader
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self initAvatar];
    [self initInfoView];
}
 

- (void) initAvatar {
    int avatarRadius = 27;
    _avatar = [[UIImageView alloc] init];
    _avatar.userInteractionEnabled = YES;
    _avatar.layer.cornerRadius = avatarRadius;
    _avatar.layer.masksToBounds = YES;
    _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatar.layer.borderWidth = 1.0f;
    [_avatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)]];
    [self addSubview:_avatar];
    
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(17);
        make.left.equalTo(self).offset(33);
        make.width.height.mas_equalTo(avatarRadius*2);
    }];
    
    _nickName = [[UILabel alloc] init];
    _nickName.text = @"name";
    _nickName.textColor = [UIColor whiteColor];
    _nickName.font = [UIFont systemFontOfSize:16];
    [self addSubview:_nickName];
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar).offset(3);
        make.left.equalTo(self.avatar.mas_right).offset(12);
    }];
    
    _accounLab = [[UILabel alloc] init];
    _accounLab.text = @"账号：";
    _accounLab.textColor = [UIColor whiteColor];
    _accounLab.font = [UIFont systemFontOfSize:14];
    _accounLab.userInteractionEnabled = YES;
    [self addSubview:_accounLab];
    [_accounLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickName.mas_bottom).offset(6);
        make.left.equalTo(self.nickName);
    }];
    
    UITapGestureRecognizer *tapCopy = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyAccountAction)];
    [self.accounLab addGestureRecognizer:tapCopy];
    
    _editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editorBtn setTitle:@"点击编辑资料" forState:UIControlStateNormal];
    [_editorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _editorBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _editorBtn.backgroundColor = RGBA(107, 201, 156, 0.8);
    _editorBtn.layer.masksToBounds = YES;
    _editorBtn.layer.cornerRadius = 12.0f;
    [_editorBtn addTarget:self action:@selector(editorBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_editorBtn];
    [_editorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatar);
        make.right.equalTo(self).offset(12);
        make.width.mas_equalTo(116);
        make.height.mas_equalTo(24);
    }];
    
    UIView *walletView = [[UIView alloc] init];
    walletView.backgroundColor = [UIColor whiteColor];
    walletView.layer.cornerRadius = 15.0f;
    walletView.layer.masksToBounds = YES;
    [self addSubview:walletView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookWalletAction)];
    [walletView addGestureRecognizer:tap];
    
    [walletView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar.mas_bottom).offset(24);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(98);
    }];
    
    UILabel *walletTitle = [[UILabel alloc] init];
    walletTitle.text = @"我的钱包余额(元)";
    walletTitle.font = [UIFont systemFontOfSize:14];
    walletTitle.textColor = HEXCOLOR(0x161819);
    [walletView addSubview:walletTitle];
    [walletTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(walletView).offset(20);
    }];
    
    UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lookBtn setImage:[UIImage imageNamed:@"pass_look"] forState:UIControlStateNormal];
    [lookBtn setImage:[UIImage imageNamed:@"pass_biyan"] forState:UIControlStateSelected];
    [lookBtn addTarget:self action:@selector(lookMonyAction:) forControlEvents:UIControlEventTouchUpInside];
    [walletView addSubview:lookBtn];
    [lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(walletTitle);
        make.left.equalTo(walletTitle.mas_right);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    
    UIImageView *weiboArrow = [[UIImageView alloc] init];
    weiboArrow.image = [UIImage imageNamed:@"icon_right_arrow"];
    [self addSubview:weiboArrow];
    [weiboArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(walletTitle);
        make.right.equalTo(walletView).offset(-20);
        make.width.height.mas_equalTo(14);
    }];
    
    _moneyLab = [[UILabel alloc] init];
    _moneyLab.text = @"0.00";
    _moneyLab.font = [UIFont boldSystemFontOfSize:20];
    _moneyLab.textColor = HEXCOLOR(0x161819);
    [walletView addSubview:self.moneyLab];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(walletTitle.mas_bottom).offset(9);
        make.left.equalTo(walletTitle);
    }];
    
    
    UIView *functionView = [[UIView alloc] init];
    functionView.backgroundColor = [UIColor whiteColor];
    functionView.layer.cornerRadius = 15.0f;
    functionView.layer.masksToBounds = YES;
    [self addSubview:functionView];
    [functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(walletView.mas_bottom).offset(20);
        make.left.right.equalTo(walletView);
        make.height.mas_equalTo(132);
    }];
    
    UILabel *functionTitle = [[UILabel alloc] init];
    functionTitle.text = @"更多功能";
    functionTitle.font = [UIFont boldSystemFontOfSize:16];
    functionTitle.textColor = HEXCOLOR(0x161819);
    [functionView addSubview:functionTitle];
    [functionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(functionView).offset(20);
    }];
    
    NSArray *titleArr = @[@"安全设置",@"隐私设置",@"其他设置"];
    NSArray *iconArr = @[@"safy_mine_icon",@"yssz_mine_icon",@"set_mine_icon"];
    
    NSArray *tagArr = @[@(FunctionType_Safe),@(FunctionType_Prive),@(FunctionType_Other)];
    
    float wide = (JX_SCREEN_WIDTH - 40)/tagArr.count;
    
    for (int i = 0; i < tagArr.count ; i++) {
        UIButton *functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        functionBtn.frame = CGRectMake(i*wide, 54, wide, 58);
        [functionBtn addTarget:self action:@selector(functionAction:) forControlEvents:UIControlEventTouchUpInside];
        NSNumber *tag = tagArr[i];
        functionBtn.tag = tag.intValue;
        [functionView addSubview:functionBtn];
        
        UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconArr[i]]];
        [functionBtn addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(functionBtn);
            make.top.equalTo(functionBtn).offset(4);
        }];
        UILabel *functionLab = [[UILabel alloc] init];
        functionLab.text = titleArr[i];
        functionLab.font = [UIFont systemFontOfSize:14];
        functionLab.textColor = HEXCOLOR(0x161819);
        [functionBtn addSubview:functionLab];
        [functionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(functionBtn);
            make.top.equalTo(iconImage.mas_bottom).offset(4);
        }];
    }
    
}
-(void)functionAction:(UIButton *)sender{
    if (self.clickBlock) {
            self.clickBlock(sender.tag);
        }
}
-(void)lookMonyAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        self.moneyLab.text = @"****";
    }else{
        self.moneyLab.text = [NSString stringWithFormat:@"%.2f",g_App.myMoney];
    }
}
-(void)editorBtnAction{
    if (self.clickBlock) {
            self.clickBlock(FunctionType_Editor);
        }
}
-(void)lookWalletAction{
    if (self.clickBlock) {
            self.clickBlock(FunctionType_Wallet);
        }
}


- (void)initInfoView {
    
    UIView *bgSliderView = [[UIView alloc] init];
    bgSliderView.layer.cornerRadius = 20.0;
    bgSliderView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    bgSliderView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgSliderView];
    [bgSliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(57);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self).offset(-12);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = HEXCOLOR(0xEEEEEE);
    [bgSliderView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.bottom.equalTo(bgSliderView);
    }];
    
    _slideTabBar = [SlideTabBar new];
    [bgSliderView addSubview:_slideTabBar];
   
    [_slideTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(bgSliderView).offset(8);
    }];
//    [_slideTabBar setLabels:@[@"收藏",@"喜欢",@"作品"] tabIndex:0];
    [_slideTabBar setLabels:@[@"收藏",@"喜欢"] tabIndex:0];
}

- (void)onTapAction:(UITapGestureRecognizer *)sender {
    if (self.clickBlock) {
        self.clickBlock(FunctionType_Head);
    }
}
-(void)copyAccountAction{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = g_myself.account;
    [GKMessageTool showText:@"已复制"];
}

-(void)setUserInfo{
    self.avatar.image = nil;
    [g_server WH_getHeadImageSmallWIthUserId:g_myself.userId userName:g_myself.userNickname imageView:self.avatar];
    self.nickName.text = g_myself.userNickname;
    self.accounLab.text = [NSString stringWithFormat:@"账号：%@",g_myself.account?:@""];
    self.moneyLab.text = [NSString stringWithFormat:@"%.2f",g_App.myMoney];
    
}


@end
