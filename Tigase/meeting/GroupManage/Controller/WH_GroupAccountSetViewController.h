//
//  WH_GroupAccountSetViewController.h
//  Tigase
//
//  Created by 1111 on 2023/12/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_GroupAccountSetViewController : UIViewController

@property (nonatomic,strong) WH_RoomData* room;

@property(nonatomic,copy)void(^dataBlock)(NSArray *dataArray);

@end

NS_ASSUME_NONNULL_END
