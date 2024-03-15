//
//  WH_SetGroupHeads_WHView.m
//  Tigase
//
//  Created by Apple on 2019/7/4.
//  Copyright © 2019 Reese. All rights reserved.
//

#import "WH_SetGroupHeads_WHView.h"

@implementation WH_SetGroupHeads_WHView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray{
    self = [super initWithFrame:frame];
    if (self) {
        [self dataUIWithArray:titleArray frame:frame];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray istype:(BOOL)istype{
    self = [super initWithFrame:frame];
    if (self) {
        self.isPayType = istype;
        [self dataUIWithArray:titleArray frame:frame];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = @[Localized(@"JX_TakePhoto") ,Localized(@"JX_ChoosePhoto"),Localized(@"JX_Cencal")];
        [self dataUIWithArray:array frame:frame];
    }
    return self;
}

-(void)dataUIWithArray:(NSArray *)array frame:(CGRect)frame{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *topBgView = [[UIView alloc] init];
    topBgView.backgroundColor = [UIColor whiteColor];
    [topBgView radiusWithAngle:15];
    [self addSubview:topBgView];
    
    topBgView.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, CGRectGetHeight(frame)+20);
    
    
    CGFloat buttonHeight = (CGRectGetHeight(frame) - (THE_DEVICE_HAVE_HEAD ? 34 : 0))/ array.count;
    for (int i = 0; i < array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, i*buttonHeight, self.frame.size.width, buttonHeight)];
        [btn setTag:i];
        
        if (self.isPayType) {//添加账号类型
            NSString *name = [array objectAtIndex:i];
            NSString *imageName = @"";
            BOOL isNow = NO;
            if([name containsString:@"支付宝"]){
                imageName = @"pay_type_2";
                isNow = YES;
            }else if ([name containsString:@"微信"]){
                imageName = @"pay_type_1";
                isNow = YES;
            }else if ([name containsString:@"银行卡"]){
                imageName = @"pay_type_3";
            }
            
            
            UIImageView *iconimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            iconimage.frame = CGRectMake(20, (buttonHeight - 18)/2, 18, 18);
            [btn addSubview:iconimage];
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(46, 0, name.length *20, buttonHeight)];
            titleLab.font = [UIFont boldSystemFontOfSize:14];
            titleLab.text = name;
            [btn addSubview:titleLab];
            
            if(isNow){
                UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(70 + name.length*10, (buttonHeight - 18)/2, 54, 18)];
                rightLab.backgroundColor = HEXCOLOR(0xe9fcf0);
                rightLab.layer.masksToBounds = YES;
                rightLab.layer.cornerRadius = 4.0f;
                rightLab.text = @"即时付款";
                rightLab.textAlignment = NSTextAlignmentCenter;
                rightLab.textColor = HEXCOLOR(0x31bd65);
                rightLab.font = [UIFont systemFontOfSize:11];
                [btn addSubview:rightLab];
            }
            
        }else{
            [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:HEXCOLOR(0x8C9AB8) forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 17]];
        }
        [btn setBackgroundColor:[UIColor whiteColor]];
        [topBgView addSubview:btn];
        [btn addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i > 0 && i < array.count) {
            UIView *lView = [[UIView alloc] initWithFrame:CGRectMake(0, i*(buttonHeight + 10), self.frame.size.width, g_factory.cardBorderWithd)];
            [lView setBackgroundColor:HEXCOLOR(0xE8E8E8)];
            [topBgView addSubview:lView];
            [lView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(btn);
                make.height.offset(g_factory.cardBorderWithd);
            }];
        }
        
    }
}

- (void)buttonClickMethod:(UIButton *)btn {
    //button.tag 0:拍摄照片 1:选择照片 2:取消
    if (self.wh_selectActionBlock) {
        self.wh_selectActionBlock(btn.tag);
    }
}


- (void)sp_checkNetWorking:(NSString *)isLogin {
    //NSLog(@"Get User Succrss");
}
@end
