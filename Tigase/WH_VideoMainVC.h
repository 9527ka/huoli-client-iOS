//
//  WH_VideoMainVC.h
//  Tigase
//
//  Created by 1111 on 2024/4/7.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_admob_WHViewController.h"
#import "UIView+LK.h"
#import "XMGTitleButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface WH_VideoMainVC : WH_admob_WHViewController


/** 顶部的所有标签 */
@property (nonatomic, weak) UIView *titlesView;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;
 
@property (nonatomic,weak) XMGTitleButton *topButton;

@end

NS_ASSUME_NONNULL_END
