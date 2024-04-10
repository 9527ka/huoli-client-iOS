//
//  WH_playListVC.h
//  Tigase
//
//  Created by 1111 on 2024/4/7.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WH_GKDYVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WH_playListVC : UIViewController

@property(nonatomic,copy)NSString *videoId;
@property(nonatomic,copy)void(^chooseVideoPlayBlock)(WH_GKDYVideoModel *model);

@end

NS_ASSUME_NONNULL_END
