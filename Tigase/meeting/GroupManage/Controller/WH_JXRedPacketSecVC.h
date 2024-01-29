//
//  WH_JXRedPacketSecVC.h
//  Tigase
//
//  Created by 1111 on 2024/1/27.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXRedPacketSecVC : UIViewController

@property (nonatomic, strong) WH_RoomData* room;
@property (nonatomic, assign) NSInteger type;//0表示红包，1表示钻石
@property (nonatomic, assign) NSInteger direction;//0表示抢，1表示发 2设置用户发红包

@end

NS_ASSUME_NONNULL_END
