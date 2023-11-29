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
 
@end
