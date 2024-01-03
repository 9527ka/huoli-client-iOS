//
//  WH_GroupRechargeViewController.h
//  Tigase
//
//  Created by 1111 on 2023/12/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WH_JXBuyAndPayListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WH_GroupRechargeViewController : UIViewController

@property (nonatomic,strong) WH_RoomData* room;
@property (nonatomic,strong) WH_JXBuyAndPayListModel *model;



@end

NS_ASSUME_NONNULL_END
