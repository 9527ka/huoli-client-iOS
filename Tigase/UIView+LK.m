//
//  UIView+LK.m
//  Categorys
//
//  Created by 陈中宝 on 15/7/9.
//  Copyright (c) 2015年 陈中宝. All rights reserved.
//

#import "UIView+LK.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIView (LKExtension)
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

-(void)setCenterX:(CGFloat)centerX{
    CGPoint center=self.center;
    center.x=centerX;
    self.center=center;
    
}

-(void)setCenterY:(CGFloat)centerY{
    
    CGPoint center=self.center;
    center.y=centerY;
    self.center=center;
}

-(CGFloat)centerX{
    return self.center.x;
}

-(CGFloat)centerY{
    return self.center.y;
}
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

/***/
-(void)setXmg_size:(CGSize)xmg_size{
    
    
    CGRect frame = self.frame;
    frame.size = xmg_size;
    self.frame = frame;
}
-(CGSize)xmg_size{
    
    
    return self.frame.size;
}

- (void)setXmg_x:(CGFloat)xmg_x
{
    CGRect frame = self.frame;
    frame.origin.x = xmg_x;
    self.frame = frame;
}

- (void)setXmg_y:(CGFloat)xmg_y
{
    CGRect frame = self.frame;
    frame.origin.y = xmg_y;
    self.frame = frame;
}

- (void)setXmg_width:(CGFloat)xmg_width
{
    CGRect frame = self.frame;
    frame.size.width = xmg_width;
    self.frame = frame;
}

- (void)setXmg_height:(CGFloat)xmg_height
{
    CGRect frame = self.frame;
    frame.size.height = xmg_height;
    self.frame = frame;
}

- (CGFloat)xmg_x
{
    return self.frame.origin.x;
}

- (CGFloat)xmg_y
{
    return self.frame.origin.y;
}

- (CGFloat)xmg_width
{
    return self.frame.size.width;
}

- (CGFloat)xmg_height
{
    return self.frame.size.height;
}

- (void)setXmg_centerX:(CGFloat)xmg_centerX
{
    CGPoint center = self.center;
    center.x = xmg_centerX;
    self.center = center;
}

- (void)setXmg_centerY:(CGFloat)xmg_centerY
{
    CGPoint center = self.center;
    center.y = xmg_centerY;
    self.center = center;
}

- (CGFloat)xmg_centerX
{
    return self.center.x;
}

- (CGFloat)xmg_centerY
{
    return self.center.y;
}

/***/
@end

@implementation UIView (LKConstraint)

#pragma mark 移除高度约束
-(void)removeHeightConstraint{
    [self removeConstraintWithType:NSLayoutAttributeHeight];
}

#pragma mark 移除宽度约束
-(void)removeWidthConstraint{
    [self removeConstraintWithType:NSLayoutAttributeWidth];
}

#pragma mark 移除某约束
-(void)removeConstraintWithType:(NSLayoutAttribute)attribute{
    NSArray *constraintArr = [self constraints];
    for (NSLayoutConstraint *constraint in constraintArr) {
        if (constraint.firstItem == self && constraint.secondItem == nil && constraint.firstAttribute == attribute) {
            [self removeConstraint:constraint];
            break;
        }
    }
}

#pragma mark 移除底部约束
-(void)removeBottomConstraint{
    NSArray *contraintArr = [self constraints];
    for (NSLayoutConstraint *constraint in contraintArr) {
        if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeBottom) {
            [self removeConstraint:constraint];
        }
    }
}

- (void)lk_didMoveToSuperview{
    [self lk_didMoveToSuperview];
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = [UIColor redColor].CGColor;
}

#pragma 使用边界调试
+ (void)useBorderdebugger{
    //这里的代码是测试布局边界用的，发布前应该删掉
    //虽然Xcode有查看布局的工具，但有的时候，这个工具显示不出界面来，所以只好用这个了
    Method preMethod = class_getInstanceMethod([self class], @selector(didMoveToSuperview));
    Method swizzleMethod = class_getInstanceMethod([self class], @selector(lk_didMoveToSuperview));
    
    IMP swizzleImp = method_getImplementation(swizzleMethod);
    const char * swizzleTypes = method_getTypeEncoding(swizzleMethod);
    if (class_addMethod([self class], @selector(didMoveToSuperview), swizzleImp, swizzleTypes)) {
        IMP preImp = method_getImplementation(preMethod);
        const char * preTypes = method_getTypeEncoding(preMethod);
        class_replaceMethod([self class], @selector(lk_didMoveToSuperview), preImp, preTypes);
    }else{
        method_exchangeImplementations(preMethod, swizzleMethod);
    }
}

+ (void)load{
    //取消注释下面的代码，就可以在界面中显示每个控件的边界了
//    [self useBorderdebugger];
}

@end


@implementation UIView(LKVC)

- (UIViewController *)curVc{
    for (UIView *nextV = self; nextV; nextV = nextV.superview) {
        UIResponder *responder = [nextV nextResponder];
        if (responder && [responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

@end

