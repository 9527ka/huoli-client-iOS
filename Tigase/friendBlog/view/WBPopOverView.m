//
//  WBPopOverView.m
//  pop_test
//
//  Created by tuhui－03 on 16/5/19.
//  Copyright © 2016年 tuhui－03. All rights reserved.
//

#import "WBPopOverView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface WBPopOverView ()


@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) WBArrowDirection direction;

@end

@implementation WBPopOverView

-(instancetype)initWithOrigin:(CGPoint)origin Width:(CGFloat)width Height:(float)height Direction:(WBArrowDirection)direction
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        //背景颜色为无色
        self.backgroundColor=[UIColor clearColor];
        
        //定义显示视图的参数
        self.origin = origin;
        self.height = height;
        self.width = width;
        self.direction = direction;
        
        self.wh_backView=[[UIView alloc]initWithFrame:CGRectMake(origin.x, origin.y, width, height)];
        self.wh_backView.backgroundColor=HEXCOLOR(0x4C5154);
        self.wh_backView.layer.cornerRadius = 5;
        self.wh_backView.layer.masksToBounds = YES;
        [self addSubview:self.wh_backView];
      
    
    }

    return self;
}


-(void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    if (_direction==WBArrowDirectionLeft1) {
        
        
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX+5, startY-5);
        CGContextAddLineToPoint(context, startX+5, startY+5);
    }
    else if (_direction==WBArrowDirectionLeft2)
    {
    
        
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX+5, startY-5);
        CGContextAddLineToPoint(context, startX+5, startY+5);
    
    }
    else if (_direction==WBArrowDirectionLeft3)
    {

        
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX+5, startY-5);
        CGContextAddLineToPoint(context, startX+5, startY+5);
        
    }
    else if (_direction==WBArrowDirectionRight1)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX-5, startY-5);
        CGContextAddLineToPoint(context, startX-5, startY+5);
        
    }
    else if (_direction==WBArrowDirectionRight2)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX-5, startY-5);
        CGContextAddLineToPoint(context, startX-5, startY+5);
        
    }
    else if (_direction==WBArrowDirectionRight3)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX-5, startY-5);
        CGContextAddLineToPoint(context, startX-5, startY+5);
        
    }
    else if (_direction==WBArrowDirectionUp1)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX + 5, startY +5);
        CGContextAddLineToPoint(context, startX -5, startY+5);
        
    }
    else if (_direction==WBArrowDirectionUp2)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX + 5, startY +5);
        CGContextAddLineToPoint(context, startX -5, startY+5);
    }
    else if (_direction==WBArrowDirectionUp3)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX + 5, startY +5);
        CGContextAddLineToPoint(context, startX -5, startY+5);
        
    }
    else if (_direction==WBArrowDirectionDown1)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX - 5, startY -5);
        CGContextAddLineToPoint(context, startX +5, startY-5);
        
    }
    else if (_direction==WBArrowDirectionDown2)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX - 5, startY -5);
        CGContextAddLineToPoint(context, startX +5, startY-5);
        
    }
    else if (_direction==WBArrowDirectionDown3)
    {
        CGFloat startX = self.origin.x;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        CGContextAddLineToPoint(context, startX - 5, startY -5);
        CGContextAddLineToPoint(context, startX +5, startY-5);
        
    }
   
    CGContextClosePath(context);
    [self.wh_backView.backgroundColor setFill];
    [self.backgroundColor setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
    
 

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.wh_backView]) {
        [self dismiss];
    }
}

-(void)popView
{
    NSArray *result=[self.wh_backView subviews];
    for (UIView *view in result) {
        
        view.hidden=YES;
        
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    //动画效果弹出
    self.alpha = 0.9;
    
    
    if (_direction==WBArrowDirectionLeft1) {
        self.wh_backView.frame = CGRectMake(self.origin.x+5, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.wh_backView.frame = CGRectMake(self.origin.x+5, self.origin.y-20, self.width,self. height);
        }completion:^(BOOL finished) {
            NSArray *result=[self.wh_backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
        }];
        
        
    }
    else if (_direction==WBArrowDirectionLeft2)
    {
        self.wh_backView.frame = CGRectMake(self.origin.x+5, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.wh_backView.frame = CGRectMake(self.origin.x+5, self.origin.y-self.height/2, self.width,self. height);

        }completion:^(BOOL finished) {
            NSArray *result=[self.wh_backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
        }];
    }
    else if (_direction==WBArrowDirectionLeft3)
    {
        self.wh_backView.frame = CGRectMake(self.origin.x+5, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.wh_backView.frame = CGRectMake(self.origin.x+5, self.origin.y-self.height+20, self.width,self. height);
        }completion:^(BOOL finished) {
            NSArray *result=[self.wh_backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
        }];
        
    }
    else if (_direction==WBArrowDirectionRight1)
    {
        self.wh_backView.frame = CGRectMake(self.origin.x-5, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.wh_backView.frame = CGRectMake(self.origin.x-5, self.origin.y-20, -self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.wh_backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionRight2)
    {
        self.wh_backView.frame = CGRectMake(self.origin.x-5, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.wh_backView.frame = CGRectMake(self.origin.x-5, self.origin.y-self.height/2, -self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.wh_backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionRight3)
    {
        self.wh_backView.frame = CGRectMake(self.origin.x-5, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.wh_backView.frame = CGRectMake(self.origin.x-5, self.origin.y-self.height+20, -self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.wh_backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionUp1)
    {
        self.wh_backView.frame = CGRectMake(self.origin.x, self.origin.y+5, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.wh_backView.frame = CGRectMake(self.origin.x-20, self.origin.y+5, self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.wh_backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionUp2)
    {
        self.wh_backView.frame = CGRectMake(self.origin.x, self.origin.y+5, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.wh_backView.frame = CGRectMake(self.origin.x-self.width/2, self.origin.y+5, self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.wh_backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionUp3)
    {
        self.wh_backView.frame = CGRectMake(self.origin.x, self.origin.y+5, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.wh_backView.frame = CGRectMake(self.origin.x+20, self.origin.y+5, -self.width,self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.wh_backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionDown1)
    {
        self.wh_backView.frame = CGRectMake(self.origin.x, self.origin.y-5, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.wh_backView.frame = CGRectMake(self.origin.x-20, self.origin.y-5, self.width,-self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.wh_backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionDown2)
    {
        self.wh_backView.frame = CGRectMake(self.origin.x, self.origin.y-5, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.wh_backView.frame = CGRectMake(self.origin.x-self.width/2, self.origin.y-5, self.width,-self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.wh_backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }
    else if (_direction==WBArrowDirectionDown3)
    {
        self.wh_backView.frame = CGRectMake(self.origin.x, self.origin.y-5, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.wh_backView.frame = CGRectMake(self.origin.x-self.width+20, self.origin.y-5, self.width,-self. height);
        }completion:^(BOOL finished) {
            
            NSArray *result=[self.wh_backView subviews];
            for (UIView *view in result) {
                
                view.hidden=NO;
                
            }
            
        }];
        
    }

}

-(void)dismiss{
    
    NSArray *result=[self.wh_backView subviews];
    for (UIView *view in result) {
        
        [view removeFromSuperview];

    }
    
         //动画效果淡出
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.9;
        self.wh_backView.frame = CGRectMake(self.origin.x, self.origin.y, 0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
                 
        }
    }];
     


}



- (void)sp_didUserInfoFailed {
    //NSLog(@"Continue");
}
@end
