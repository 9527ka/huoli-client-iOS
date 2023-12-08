//
//  GH_GKDYVideoPlayer.m
//  GH_GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GH_GKDYVideoPlayer.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GH_GKDYVideoPlayer()

@property (nonatomic, assign) float         duration;

@property (nonatomic, assign) BOOL          isNeedResume;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@implementation GH_GKDYVideoPlayer

- (instancetype)init {
    if (self = [super init]) {
        // 监听APP退出后台及进入前台
    }
    return self;
}
/**
 根据指定url在指定视图上播放视频
 
 @param playView 播放视图
 @param url 播放地址
 */
- (void)playVideoWithView:(UIView *)playView url:(NSString *)url{
    NSURL *playUrl = [NSURL URLWithString:url];
    
    self.playerItem = [AVPlayerItem playerItemWithURL:playUrl];
    //如果要切换视频需要调AVPlayer的replaceCurrentItemWithPlayerItem:方法
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    
    
    [self addProgressObserver];
    
    [self addObserverToPlayerItem:self.playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//视频填充模式
    self.playerLayer.frame = playView.bounds;
    //放置播放器的视图
    [playView.layer addSublayer:self.playerLayer];
    [_player play];
}
-(void)addProgressObserver{
 
    //get current playerItem object
    AVPlayerItem *playerItem = self.player.currentItem;
    __weak typeof(self) weakSelf = self;
 
    //Set once per second
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
 
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
        float progress = total > 0?current/total:0;
        
        if ([weakSelf.delegate respondsToSelector:@selector(player:currentTime:totalTime:progress:)]) {
            [weakSelf.delegate player:weakSelf currentTime:current totalTime:total progress:progress];
        }
        
        if (current) {
//            NSLog(@"%f", current / total);
 
            if (progress == 1.0) {      //complete block
//                if (weakSelf.completedPlayingBlock) {
//                    weakSelf.completedPlayingBlock(weakSelf);
//                }else {       //finish and loop playback
                
                    CMTime currentCMTime = CMTimeMake(0, 1);
                    [weakSelf.player seekToTime:currentCMTime completionHandler:^(BOOL finished) {
                        [weakSelf.player play];
                    }];
//                }
            }
        }
    }];
}
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //network loading progress
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem = object;
    
    if ([keyPath isEqualToString:@"status"]) {
        GKDYVideoPlayerStatus currentStatus;
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        
        if(status == AVPlayerStatusReadyToPlay){
            currentStatus = GKDYVideoPlayerStatusPrepared;
        }else if (status == AVPlayerStatusUnknown){
            currentStatus = GKDYVideoPlayerStatusUnload;
        }else if (status == AVPlayerStatusFailed){
            currentStatus = GKDYVideoPlayerStatusError;
        }
        if ([self.delegate respondsToSelector:@selector(player:statusChanged:)]) {
            [self.delegate player:self statusChanged:currentStatus];
        }
        
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
         
       float middleValue = totalBuffer / CMTimeGetSeconds(playerItem.duration);
        NSLog(@"totalBuffer：%.2f",totalBuffer);

        if (middleValue <= 0.0) {
            if ([self.delegate respondsToSelector:@selector(player:statusChanged:)]) {
                [self.delegate player:self statusChanged:GKDYVideoPlayerStatusLoading];
            }
        }else {
            if ([self.delegate respondsToSelector:@selector(player:statusChanged:)]) {
                [self.delegate player:self statusChanged:GKDYVideoPlayerStatusPrepared];
            }
        }
    }
}

/**
 停止播放并移除播放视图
 */
- (void)removeVideo{
    [self.player pause];
    [self.playerLayer removeFromSuperlayer];
    if ([self.delegate respondsToSelector:@selector(player:statusChanged:)]) {
        [self.delegate player:self statusChanged:GKDYVideoPlayerStatusEnded];
    }
}

/**
 暂停播放
 */
- (void)pause{
    [self.player pause];
    if ([self.delegate respondsToSelector:@selector(player:statusChanged:)]) {
        [self.delegate player:self statusChanged:GKDYVideoPlayerStatusPaused];
    }
}

/**
 恢复播放
 */
- (void)resume{
    [self.player play];
    if ([self.delegate respondsToSelector:@selector(player:statusChanged:)]) {
        [self.delegate player:self statusChanged:GKDYVideoPlayerStatusPlaying];
    }
}
- (void)sp_getMediaData{
    
}



 
@end
