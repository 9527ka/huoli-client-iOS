//
//  AwemeListCell.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OnPlayerReady)(void);

@class WH_GKDYVideoModel;
@class AVPlayerView;



@interface AwemeListCell : UITableViewCell

@property (nonatomic, strong) WH_GKDYVideoModel            *aweme;

@property (nonatomic, strong) AVPlayerView     *playerView;

@property (nonatomic, strong) OnPlayerReady    onPlayerReady;
@property (nonatomic, assign) BOOL             isPlayerReady;

@property (nonatomic,copy)void(^lookAllPlayletBlock)(void);

- (void)initData:(WH_GKDYVideoModel *)aweme scroller:(UIScrollView *)scrollView;

- (void)startDownloadHighPriorityTask;
- (void)startDownloadBackgroundTask;


- (void)play;
- (void)pause;
- (void)replay;

@end
