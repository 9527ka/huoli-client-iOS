//
//  UIBarButtonItem+XMGExtension.m
//  6期-百思不得姐
//
//  Created by xiaomage on 15/12/4.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "UIBarButtonItem+XMGExtension.h"
@implementation UIBarButtonItem (XMGExtension)


+ (instancetype)xmg_homeOrderMangerNavTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font=[UIFont systemFontOfSize:15.0];
    [button setTitle:title  forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

/** 单个搜索页面按钮*/
+ (instancetype)xmg_itemSearchNavTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [button setTitle:title  forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 10, 44, 36);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)xmg_itemWithImage:(NSString *)title highTitle:(NSString *)highTitle target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
      button.titleLabel.font=[UIFont systemFontOfSize:15.0];
      [button setTitle:title  forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}


+ (instancetype)xmg_itemWithImage:(NSString *)image title:(NSString *)title target:(id)target action:(SEL)action{
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
    button.titleLabel.font=[UIFont systemFontOfSize:15.0];
    [button setTitle:title  forState:UIControlStateNormal];  
   // [button sizeToFit];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -16)];
    [button setFrame:CGRectMake(0, 0, 60, 44)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}
+ (instancetype)xmg_itemWithAplpImage:(NSString *)image target:(id)target action:(SEL)action{
    
    UIImage *imageAlaph = [UIImage imageNamed:image];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:imageAlaph forState:UIControlStateNormal];
    [button setImage:imageAlaph forState:UIControlStateHighlighted]; 
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setFrame:CGRectMake(10, 10, 33, 33)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)xmg_itemWithAplpImage:(NSString *)image  selectIMG:(NSString *)selectedIMG target:(id)target action:(SEL)action{
      
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedIMG] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setFrame:CGRectMake(10, 10, 33, 33)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}
 
@end
