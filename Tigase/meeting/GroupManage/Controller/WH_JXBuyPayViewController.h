//
//  WH_JXBuyPayViewController.h
//  Tigase
//
//  Created by 1111 on 2023/12/12.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXBuyPayViewController : UIViewController

@property (nonatomic,strong) WH_RoomData* room;
@property (nonatomic,strong) NSDictionary *payDic;
@property (nonatomic,strong)NSString *expiryTime;

@end

NS_ASSUME_NONNULL_END
