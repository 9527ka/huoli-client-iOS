//
//  KKTextView.m
//  WWImageEdit
//
//  Created by 邬维 on 2017/1/18.
//  Copyright © 2017年 kook. All rights reserved.
//

#import "WH_KKTextView.h"
#import "WH_KKTextTool.h"
#import "WH_KKTextLable.h"

@implementation WH_KKTextView{
   
    UIButton *_deleteButton;
    CGPoint _initialPoint;
    WH_KKTextLable *_label;
    __weak WH_KKTextTool *_tool;
}

+ (void)setActiveTextView:(WH_KKTextView*)view
{
    static WH_KKTextView *activeView = nil;
    if(view != activeView){
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
    }
}

- (id)initWithTool:(WH_KKTextTool*)tool
{
    self = [super initWithFrame:CGRectZero];
    if(self){
        _tool = tool;
        _label = [[WH_KKTextLable alloc] init];
        [_label setTextColor:[WH_KKImageEditorTheme theme].toolbarTextColor];
        _label.numberOfLines = 0;
        _label.backgroundColor = [UIColor clearColor];
        _label.layer.masksToBounds = YES;
        _label.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        _label.layer.borderWidth = 1;
        _label.layer.cornerRadius = 3;
        _label.font = [UIFont systemFontOfSize:30];
        _label.lineBreakMode = NSLineBreakByCharWrapping;
        [_label setTextColor:_textColor];
        _label.textInsets = UIEdgeInsetsMake(0.f, 10, 0.f, 10);
//        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"";
        [self addSubview:_label];
        [self setLableFrameWithText:_label.text];
        self.frame = CGRectMake(0, 0, _label.frame.size.width + 32, _label.frame.size.height + 32);
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 32, 32);
        _deleteButton.center = _label.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        [self initGestures];
    }
    return self;
}

//计算lable的frame
- (void)setLableFrameWithText:(NSString *)text{
    CGSize constraint = CGSizeMake(_tool.editor.imageView.frame.size.width - 45,0); //这里是指lable的宽度，下同
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjects:@[[UIFont systemFontOfSize:30]] forKeys:@[NSFontAttributeName]];
    
    //计算lable的frame 根据文字计算lable的高度
    CGRect size = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    _label.frame = CGRectMake(16, 16, _tool.editor.imageView.frame.size.width - 45, size.size.height);

}

- (void)initGestures
{
    _label.userInteractionEnabled = YES;
    [_label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [_label addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
}

- (void)setAvtive:(BOOL)active
{
    _deleteButton.hidden = !active;
    if (active) {
        _label.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    }else{
        _label.layer.borderColor = [[UIColor clearColor] CGColor];
    }
}

- (void)setLableText:(NSString *)text{
    if ([text isEqualToString:@""]) {
        [self removeFromSuperview];
        return;
    }
    _label.text = text;
    [_label setTextColor:_textColor];
    [self setLableFrameWithText:text];
    self.frame = CGRectMake(0, 0, _label.frame.size.width + 32, _label.frame.size.height + 32);
}

- (NSString *)getLableText{
    return _label.text;
}

#pragma mark- gesture events

- (void)pushedDeleteBtn:(id)sender
{
    WH_KKTextView *nextTarget = nil;
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i){
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[WH_KKTextView class]]){
            nextTarget = (WH_KKTextView*)view;
            break;
        }
    }
    
    if(nextTarget==nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[WH_KKTextView class]]){
                nextTarget = (WH_KKTextView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveTextView:nextTarget];
    [self removeFromSuperview];
}

- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    if(!_deleteButton.hidden){
        _tool.selectedTextView = self;
        NSNotification *n = [NSNotification notificationWithName:kTextViewActiveViewDidTapNotification object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:n waitUntilDone:NO];
    }
    [[self class] setActiveTextView:self];
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveTextView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}


- (void)sp_getMediaData {
    //NSLog(@"Get User Succrss");
}
@end
