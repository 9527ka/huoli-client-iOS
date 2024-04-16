//
//  WH_Player_WHVC.h
//  Tigase
//
//  Created by 1111 on 2024/3/22.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WH_GKDYBase_WHViewController.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WH_Player_WHVC : WH_GKDYBase_WHViewController

@property (nonatomic, strong) ZFPlayerController *player;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger pageIndex;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,strong)NSIndexPath *currentIndex;//要删除的cell
@property(nonatomic,assign)NSInteger selectIndex;
@property(nonatomic,copy)void(^requestFinishBlock)(void);
//暂停播放
-(void)stopPlayVideoAction;

@end

NS_ASSUME_NONNULL_END
