//
//  AwemeListCell.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "AwemeListCell.h"
#import "Constants.h"
#import "Masonry.h"
#import "AVPlayerView.h"
#import "WH_GKDYVideoModel.h"
#import "GKDYVideoControlView.h"

static const NSInteger kAwemeListLikeCommentTag = 0x01;
static const NSInteger kAwemeListLikeShareTag   = 0x02;

@interface AwemeListCell()<AVPlayerUpdateDelegate>

@property (nonatomic, strong) UIView                   *container;
@property (nonatomic ,strong) CAGradientLayer          *gradientLayer;
@property (nonatomic ,strong) UIImageView              *pauseIcon;
@property (nonatomic, strong) UIView                   *playerStatusBar;
@property (nonatomic, strong) UITapGestureRecognizer   *singleTapGesture;
@property (nonatomic, assign) NSTimeInterval           lastTapTime;
@property (nonatomic, assign) CGPoint                  lastTapPoint;
@property (nonatomic,strong)GKDYVideoControlView *infoView;
@property (nonatomic,strong)UIImageView *bgImage;

@end

@implementation AwemeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor blackColor];
        self.lastTapTime = 0;
        self.lastTapPoint = CGPointZero;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    //init player view;
    _playerView = [AVPlayerView new];
    _playerView.delegate = self;
    [self.contentView addSubview:_playerView];
    
    //init hover on player view container
    _container = [UIView new];
    _container.userInteractionEnabled = YES;
    [self.contentView addSubview:_container];
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.colors = @[(__bridge id)ColorClear.CGColor, (__bridge id)ColorBlackAlpha20.CGColor, (__bridge id)ColorBlackAlpha40.CGColor];
    _gradientLayer.locations = @[@0.3, @0.6, @1.0];
    _gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    _gradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
    [_container.layer addSublayer:_gradientLayer];
    
    _pauseIcon = [[UIImageView alloc] init];
    _pauseIcon.image = [UIImage imageNamed:@"ss_icon_pause"];
    _pauseIcon.contentMode = UIViewContentModeCenter;
    _pauseIcon.layer.zPosition = 3;
    _pauseIcon.hidden = YES;
    [_container addSubview:_pauseIcon];
    
    _bgImage = [[UIImageView alloc] init];
    _bgImage.contentMode = UIViewContentModeScaleAspectFill;
    [_container addSubview:_bgImage];
    
    //init player status bar
    _playerStatusBar = [[UIView alloc]init];
    _playerStatusBar.backgroundColor = THEMECOLOR;
    [_playerStatusBar setHidden:YES];
    [_container addSubview:_playerStatusBar];
  
    [_container addSubview:self.infoView];
    
//    _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    [_container addGestureRecognizer:self.singleTapGesture];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    
    _isPlayerReady = NO;
    [_playerView cancelLoading];
    [_pauseIcon setHidden:YES];
}

-(void)layoutSubviews {
    [super layoutSubviews];
//    _playerView.frame = self.bounds;
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _container.frame = self.bounds;
    
    _pauseIcon.frame = CGRectMake(CGRectGetMidX(self.bounds) - 50, CGRectGetMidY(self.bounds) - 50, 100, 100);
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _gradientLayer.frame = CGRectMake(0, self.frame.size.height - 500, self.frame.size.width, 500);
    [CATransaction commit];
    
    [_playerStatusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).inset(59.5f + SafeAreaBottomHeight);
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(0.5f);
    }];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
   
}

//HoverTextViewDelegate delegate
-(void)hoverTextViewStateChange:(BOOL)isHover {
    _container.alpha = isHover ? 0.0f : 1.0f;
}

//gesture
- (void)handleGesture:(UITapGestureRecognizer *)sender {
    
    [self singleTapAction];
}

- (void)singleTapAction {
    [self showPauseViewAnim:[self.playerView rate]];
    [self.playerView updatePlayerState];
}

//暂停播放动画
- (void)showPauseViewAnim:(CGFloat)rate {
    if(rate == 0) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             self.pauseIcon.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             [self.pauseIcon setHidden:YES];
                         }];
    }else {
        [_pauseIcon setHidden:NO];
        _pauseIcon.transform = CGAffineTransformMakeScale(1.8f, 1.8f);
        _pauseIcon.alpha = 1.0f;
        [UIView animateWithDuration:0.25f delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.pauseIcon.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                            } completion:^(BOOL finished) {
                            }];
    }
}

//加载动画
-(void)startLoadingPlayItemAnim:(BOOL)isStart {
    if (isStart) {
        self.playerStatusBar.backgroundColor = ColorWhite;
        [self.playerStatusBar setHidden:NO];
        [self.playerStatusBar.layer removeAllAnimations];
        
        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.duration = 0.5;
        animationGroup.beginTime = CACurrentMediaTime() + 0.5;
        animationGroup.repeatCount = MAXFLOAT;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animation];
        scaleAnimation.keyPath = @"transform.scale.x";
        scaleAnimation.fromValue = @(1.0f);
        scaleAnimation.toValue = @(1.0f * ScreenWidth);
        
        CABasicAnimation * alphaAnimation = [CABasicAnimation animation];
        alphaAnimation.keyPath = @"opacity";
        alphaAnimation.fromValue = @(1.0f);
        alphaAnimation.toValue = @(0.5f);
        [animationGroup setAnimations:@[scaleAnimation, alphaAnimation]];
        [self.playerStatusBar.layer addAnimation:animationGroup forKey:nil];
    } else {
        [self.playerStatusBar.layer removeAllAnimations];
        [self.playerStatusBar setHidden:YES];
    }
    
}

// AVPlayerUpdateDelegate
-(void)onProgressUpdate:(CGFloat)current total:(CGFloat)total {
    //播放进度更新
}

-(void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status {
    switch (status) {
        case AVPlayerItemStatusUnknown:
            [self startLoadingPlayItemAnim:YES];
            break;
        case AVPlayerItemStatusReadyToPlay:
            [self startLoadingPlayItemAnim:NO];
            
            self.isPlayerReady = YES;
//            [self.musicAlum startAnimation:_aweme.rate];
            self.bgImage.hidden = YES;
            if(_onPlayerReady) {
                _onPlayerReady();
            }
            break;
        case AVPlayerItemStatusFailed:
            [self startLoadingPlayItemAnim:NO];
            [UIWindow showTips:@"加载失败"];
            break;
        default:
            break;
    }
}
- (void)startDownloadHighPriorityTask {
    NSString *playUrl = self.aweme.video_url;
    [self.playerView startDownloadTask:[[NSURL alloc] initWithString:playUrl] isBackground:NO];
}
- (void)startDownloadBackgroundTask {
    [_playerView setPlayerWithUrl:self.aweme.video_url];
}

// update method
- (void)initData:(WH_GKDYVideoModel *)aweme scroller:(UIScrollView *)scrollView{
    _aweme = aweme;
    self.infoView.wh_model = aweme;
    [_playerView setPlayerWithUrl:aweme.video_url];
    self.infoView.wh_scrollView = scrollView;
    self.bgImage.hidden = NO;
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:aweme.thumbnail_url]];
   
}

-(void)play {
    [_playerView play];
    [_pauseIcon setHidden:YES];
    
}

-(void)pause {
    [_playerView pause];
    [_pauseIcon setHidden:NO];
}

-(void)replay {
    [_playerView replay];
    [_pauseIcon setHidden:YES];
}
-(GKDYVideoControlView *)infoView{
    if(!_infoView){
        _infoView = [GKDYVideoControlView new];
        _infoView.wh_coverImgView.hidden = YES;
        __weak typeof (&*self)weakSelf = self;
        _infoView.lookAllPlayletBlock = ^{
            if(weakSelf.lookAllPlayletBlock){
                weakSelf.lookAllPlayletBlock();
            }
        };
        _infoView.stopActionBlock = ^{
            [weakSelf singleTapAction];
        };
    }
    return _infoView;
}

- (void)dealloc {
    _playerView = nil;
}

@end
