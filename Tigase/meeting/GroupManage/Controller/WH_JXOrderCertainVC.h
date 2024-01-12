//
//  WH_JXOrderCertainVC.h
//  Tigase
//
//  Created by 1111 on 2024/1/10.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WH_JXBuyAndPayListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXOrderCertainVC : UIViewController

@property(nonatomic,copy)void(^certainBlock)(WH_FinancialInfosModel *payModel);
@property(nonatomic,strong)NSArray *dataArray;//收款方式

@property (nonatomic,strong) WH_RoomData* room;
@property (nonatomic,strong) WH_JXBuyAndPayListModel *model;

@end

NS_ASSUME_NONNULL_END
