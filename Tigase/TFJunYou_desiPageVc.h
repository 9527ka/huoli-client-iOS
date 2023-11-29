//
//  ZhouXin_desiPageVc.h
//  ZhouXinChat
//
//  Created by lifengye on 2021/10/24.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "WH_admob_WHViewController.h"
#import "UIView+LK.h"
#import "XMGTitleButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface TFJunYou_desiPageVc : WH_admob_WHViewController

/** 顶部的所有标签 */
@property (nonatomic, weak) UIView *titlesView;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;
 
@property (nonatomic,weak) XMGTitleButton *topButton;

  @end

NS_ASSUME_NONNULL_END
