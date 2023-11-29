//
//  UIBarButtonItem+XMGExtension.h
//  6期-百思不得姐
//
//  Created by xiaomage on 15/12/4.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XMGExtension)
/**
    首页标题
 */
+ (instancetype)xmg_homeOrderMangerNavTitle:(NSString *)title target:(id)target action:(SEL)action;
/** 单个搜索页面按钮*/
+ (instancetype)xmg_itemSearchNavTitle:(NSString *)title target:(id)target action:(SEL)action;


+ (instancetype)xmg_itemWithImage:(NSString *)image highTitle:(NSString *)highTitle target:(id)target action:(SEL)action;

/**
 图片与标题
 */
+ (instancetype)xmg_itemWithImage:(NSString *)image title:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)xmg_itemWithAplpImage:(NSString *)image target:(id)target action:(SEL)action;

+ (instancetype)xmg_itemWithAplpImage:(NSString *)image  selectIMG:(NSString *)selectedIMG target:(id)target action:(SEL)action;
@end
