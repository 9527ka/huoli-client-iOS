//
//  JX_WHVideoPlayCell.h
//  Tigase
//
//  Created by 1111 on 2024/3/22.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WH_GKDYVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZFTableViewCellDelegate <NSObject>

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JX_WHVideoPlayCell : UICollectionViewCell

@property(nonatomic,strong)UIButton *playImageBtn;//播放按钮的展示
@property(nonatomic,strong) UIButton *videoBtn;//视频播放btn

@property (nonatomic, strong) WH_GKDYVideoModel    *wh_model;

@property(nonatomic,strong)void(^stopPlayBlock)(void);//暂停播放

- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath scroller:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
