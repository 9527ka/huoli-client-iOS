//
//  WH_JXChooseAccountVC.h
//  Tigase
//
//  Created by 1111 on 2024/1/10.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WH_JXBuyAndPayListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXChooseAccountVC : UIViewController

@property(nonatomic,copy)void(^certainBlock)(WH_FinancialInfosModel *payModel);

@property(nonatomic,strong)NSArray *dataArray;//收款方式

@property(nonatomic,assign)BOOL isMySelf;//是不是我自己的账号

@property (nonatomic,strong)WH_FinancialInfosModel *payModel;

@end

NS_ASSUME_NONNULL_END
