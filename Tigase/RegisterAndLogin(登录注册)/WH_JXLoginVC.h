//
//  WH_JXLoginVC.h
//  Tigase
//
//  Created by 1111 on 2024/2/19.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXLoginVC : WH_admob_WHViewController

@property (nonatomic ,strong) UIButton *pointBtn;
@property (nonatomic ,strong) UILabel *pointLabel; //节点

@property (nonatomic ,assign) Boolean isInitialization; //是否为初始化

@property (nonatomic ,assign) Boolean isPushEntering ;//是否是push进入的


@end

NS_ASSUME_NONNULL_END
