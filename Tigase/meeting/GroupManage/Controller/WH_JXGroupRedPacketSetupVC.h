//
//  WH_JXGroupRedPacketSetupVC.h
//  Tigase
//
//  Created by luan on 2023/7/8.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXGroupRedPacketSetupVC : UIViewController

@property (nonatomic, strong) WH_RoomData* room;
@property (nonatomic, assign) NSInteger type;//0表示红包，1表示钻石

@end

NS_ASSUME_NONNULL_END
