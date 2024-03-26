//
//  WH_JXGroupRedPacketVC.h
//  Tigase
//
//  Created by luan on 2023/6/7.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXGroupRedPacketVC : UIViewController

@property (nonatomic,strong) WH_RoomData *room;

@property (nonatomic,copy)NSString *startTime;//yyyy-MM-dd HH:mm:ss
@property (nonatomic,copy)NSString *endTime;//yyyy-MM-dd HH:mm:ss
@property (nonatomic,assign)NSInteger type;//红包类型：0:全部 1：普通红包 2：拼手气红包 3:口令红包
@property (nonatomic, assign) NSInteger selIndex;

@end

NS_ASSUME_NONNULL_END
