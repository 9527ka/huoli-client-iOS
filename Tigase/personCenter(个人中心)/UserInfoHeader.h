//
//  UserInfoHeader.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideTabBar.h"

//loading type enum
typedef NS_ENUM(NSUInteger,FunctionType) {
    FunctionType_Order,
    FunctionType_Safe,
    FunctionType_Prive,
    FunctionType_Other,
    FunctionType_Wallet,
    FunctionType_Editor,
    FunctionType_Head,
};


@interface UserInfoHeader : UICollectionReusableView


@property (nonatomic, strong) UIImageView                  *avatar;
@property (nonatomic, strong) UILabel                      *nickName;
@property (nonatomic, strong) UILabel                      *accounLab;
@property (nonatomic, strong) UIButton                     *editorBtn;
@property (nonatomic, strong) UILabel                      *moneyLab;



@property (nonatomic, strong) SlideTabBar                  *slideTabBar;

@property(nonatomic,copy)void(^clickBlock)(FunctionType type);

-(void)setUserInfo;


@end
