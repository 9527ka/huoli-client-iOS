//
//  GH_GKDYVideoPlayer.m
//  GH_GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GH_GKDYVideoPlayer.h"
//#import <TXLiteAVSDK_Player/TXLiveBase.h>
//#import <TXLiteAVSDK_Player/TXVodPlayer.h>
//#import <TXLiteAVSDK_Player/TXVodPlayListener.h>

@interface GH_GKDYVideoPlayer()//<TXVodPlayListener>

//@property (nonatomic, strong) TXVodPlayer   *player;

@property (nonatomic, assign) float         duration;

@property (nonatomic, assign) BOOL          isNeedResume;

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
    
}

/**
 停止播放并移除播放视图
 */
- (void)removeVideo{
    
}

/**
 暂停播放
 */
- (void)pause{
    
}

/**
 恢复播放
 */
- (void)resume{
    
}
- (void)sp_getMediaData{
    
}



 
@end
