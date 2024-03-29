/*
 *  ATMHud.m
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud
 */

#import "ATMHud.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioServices.h>
#import "ATMHudView.h"
#import "ATMProgressLayer.h"
#import "ATMHudDelegate.h"
#import "ATMSoundFX.h"
#import "ATMHudQueueItem.h"

@interface ATMHud (Private)
- (void)construct;
@end

@implementation ATMHud
@synthesize margin, padding, alpha, appearScaleFactor, disappearScaleFactor, progressBorderRadius, progressBorderWidth, progressBarRadius, progressBarInset;
@synthesize delegate, accessoryPosition;
@synthesize center;
@synthesize shadowEnabled, blockTouches, allowSuperviewInteraction;
@synthesize showSound, updateSound, hideSound;
@synthesize __view, sound, displayQueue, queuePosition;
@synthesize isShowing;

static ATMHud *shared;

+(ATMHud*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared=[[ATMHud alloc]init];
    });
//    shared.alpha = 0.5;
    shared.allowSuperviewInteraction = NO;
    [shared setActivity:YES];
    [shared setActivityStyle:UIActivityIndicatorViewStyleGray];
    return shared;
}



- (id)init {
	if ((self = [super init])) {
		[self construct];
	}
	return self;
}

- (id)initWithDelegate:(id)hudDelegate {
	if ((self = [super init])) {
		delegate = hudDelegate;
		[self construct];
	}
	return self;
}

- (void)loadView {
	UIView *base = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	base.backgroundColor = [UIColor clearColor];
	base.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
							 UIViewAutoresizingFlexibleHeight);
	base.userInteractionEnabled = NO;
	[base addSubview:__view];
	
	self.view = base;
//	[base release];
}

// 控制器生命周期方法(view加载完成)
- (void)viewDidLoad{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
////	[sound release];
////	[__view release];
////	[displayQueue release];
////	
////	[showSound release];
////	[updateSound release];
////	[hideSound release];
//	
//    [super dealloc];
}

+ (NSString *)buildInfo {
	return @"atomHUD 1.2 • 2011-03-01";
}

#pragma mark -
#pragma mark Overrides
- (void)setAppearScaleFactor:(CGFloat)value {
	if (value == 0) {
		value = 0.01;
	}
	appearScaleFactor = value;
}

- (void)setDisappearScaleFactor:(CGFloat)value {
	if (value == 0) {
		value = 0.01;
	}
	disappearScaleFactor = value;
}

- (void)setAlpha:(CGFloat)value {
	alpha = value;
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	__view.backgroundLayer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:value].CGColor;
	[CATransaction commit];
}

- (void)setShadowEnabled:(BOOL)value {
	shadowEnabled = value;
	if (shadowEnabled) {
		__view.layer.shadowOpacity = 0.4;
	} else {
		__view.layer.shadowOpacity = 0.0;
	}
}

#pragma mark -
#pragma mark Property forwards
- (void)setCaption:(NSString *)caption {
	__view.caption = caption;
}

- (void)setImage:(UIImage *)image {
	__view.image = image;
}

- (void)setActivity:(BOOL)activity {
	__view.showActivity = activity;
	if (activity) {
		[__view.activity startAnimating];
	} else {
		[__view.activity stopAnimating];
	}
}

- (void)setActivityStyle:(UIActivityIndicatorViewStyle)activityStyle {
	__view.activityStyle = activityStyle;
	if (activityStyle == UIActivityIndicatorViewStyleWhiteLarge) {
		__view.activitySize = CGSizeMake(37, 37);
	} else {
		__view.activitySize = CGSizeMake(20, 20);
	}
}

- (void)setFixedSize:(CGSize)fixedSize {
	__view.fixedSize = fixedSize;
}

- (void)setProgress:(CGFloat)progress {
	__view.progress = progress;
	
	[__view.progressLayer setTheProgress:progress];
	[__view.progressLayer setNeedsDisplay];
}

#pragma mark -
#pragma mark Queue
- (void)addQueueItem:(ATMHudQueueItem *)item {
	[displayQueue addObject:item];
}

- (void)addQueueItems:(NSArray *)items {
	[displayQueue addObjectsFromArray:items];
}

- (void)clearQueue {
	[displayQueue removeAllObjects];
}

- (void)startQueue {
	queuePosition = 0;
	if (!CGSizeEqualToSize(__view.fixedSize, CGSizeZero)) {
		CGSize newSize = __view.fixedSize;
		CGSize targetSize;
		ATMHudQueueItem *queueItem;
		for (int i = 0; i < [displayQueue count]; i++) {
			queueItem = [displayQueue objectAtIndex:i];
			
			targetSize = [__view calculateSizeForQueueItem:queueItem];
			if (targetSize.width > newSize.width) {
				newSize.width = targetSize.width;
			}
			if (targetSize.height > newSize.height) {
				newSize.height = targetSize.height;
			}
		}
		[self setFixedSize:newSize];
	}
	[self showQueueAtIndex:queuePosition];
}

- (void)showNextInQueue {
	queuePosition++;
	[self showQueueAtIndex:queuePosition];
}

- (void)showQueueAtIndex:(NSInteger)index {
	if ([displayQueue count] > 0) {
		queuePosition = index;
		if (queuePosition == [displayQueue count]) {
			[self hide];
			return;
		}
		ATMHudQueueItem *item = [displayQueue objectAtIndex:queuePosition];
		
		__view.caption = item.caption;
		__view.image = item.image;
		
		BOOL flag = item.showActivity;
		__view.showActivity = flag;
		if (flag) {
			[__view.activity startAnimating];
		} else {
			[__view.activity stopAnimating];
		}
		
		self.accessoryPosition = item.accessoryPosition;
		[self setActivityStyle:item.activityStyle];
		
		if (queuePosition == 0) {
			[__view show];
		} else {
			[__view update];
		}
	}
}

#pragma mark -
#pragma mark Controlling
- (void)show {
//    [self hide];
    isShowing = YES;
	[__view show];
}

- (void)show:(UIView*)parent{
    [parent addSubview:self.view];
//    [parent bringSubviewToFront:self.view];
    [self show];
}

- (void)start{
//    self.alpha = 0.5;
    self.alpha = 0.0;
    [self setActivity:YES];
    [self show:[UIApplication sharedApplication].keyWindow];
}

- (void)startWithClearColor {
    self.alpha = 0;
    [self setActivity:YES];
    [self show:[UIApplication sharedApplication].keyWindow];
}

- (void)start:(NSString*)s{
//    self.alpha = 0.5;
    self.alpha = 0.3;
    [self setCaption:s];
    [self setActivity:YES];
    [self show:[UIApplication sharedApplication].keyWindow];
}

- (void)start:(NSString*)s inView:(UIView *)parent{
    self.alpha = 0.5;
    [self setCaption:s];
    [self setActivity:YES];
    [self show:parent];
}

- (void)start:(NSString*)s delay:(int)delay{
    self.alpha = 0.5;
    [self setCaption:s];
    [self show:[UIApplication sharedApplication].keyWindow];
    [self hideAfter:delay];
}

- (void)update {
	[__view update];
}

- (void)hide {
    //回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        // 需要在主线程执行的代码
    isShowing = NO;
        [__view hide];
        //    [[UIApplication sharedApplication].keyWindow sendSubviewToBack:self.view];
        [self.view removeFromSuperview];
    });
    
}

- (void)stop {
	[self hide];
}

- (void)hideAfter:(NSTimeInterval)delay {
	[self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

#pragma mark -
#pragma mark Internal methods
- (void)construct {
    isShowing = NO;
	margin = padding = 10.0;
	alpha = 0.7;
	progressBorderRadius = 8.0;
	progressBorderWidth = 2.0;
	progressBarRadius = 5.0;
	progressBarInset = 3.0;
	accessoryPosition = ATMHudAccessoryPositionBottom;
	appearScaleFactor = disappearScaleFactor = 1.4;
	
	__view = [[ATMHudView alloc] initWithFrame:CGRectZero andController:self];
	__view.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
							   UIViewAutoresizingFlexibleRightMargin |
							   UIViewAutoresizingFlexibleBottomMargin |
							   UIViewAutoresizingFlexibleLeftMargin);
	
	displayQueue = [[NSMutableArray alloc] init];
	queuePosition = 0;
	center = CGPointZero;
	blockTouches = NO;
	allowSuperviewInteraction = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!blockTouches) {
		UITouch *aTouch = [touches anyObject];
		if (aTouch.tapCount == 1) {
			CGPoint p = [aTouch locationInView:self.view];
			if (CGRectContainsPoint(__view.frame, p)) {
				if ([(id)self.delegate respondsToSelector:@selector(userDidTapHud:)]) {
					[self.delegate userDidTapHud:self];
				}
			}
		}
	}
}

- (void)playSound:(NSString *)soundPath {
	sound = [[ATMSoundFX alloc] initWithContentsOfFile:soundPath];
	[sound play];
}

@end
