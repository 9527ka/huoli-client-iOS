//
//  WH_JXOrderDetaileVC.h
//  Tigase
//
//  Created by 1111 on 2023/12/20.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXOrderDetaileVC : UIViewController

@property(nonatomic,copy)NSString *orderId;

@property (nonatomic,strong) NSDictionary *dict;//数据字典

@end

NS_ASSUME_NONNULL_END
