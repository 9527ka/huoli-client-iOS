//
//  WH_JXGroupRedPacketSetupMemberVC.h
//  Tigase
//
//  Created by luan on 2023/7/9.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXGroupRedPacketSetupMemberVC : UIViewController

@property (nonatomic, strong) WH_RoomData* room;
@property (nonatomic, assign) NSInteger type;//0表示红包，1表示钻石
@property (nonatomic, assign) NSInteger direction;//0表示抢，1表示发

@end

NS_ASSUME_NONNULL_END
