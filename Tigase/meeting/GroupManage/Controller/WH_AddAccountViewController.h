//
//  WH_AddAccountViewController.h
//  Tigase
//
//  Created by 1111 on 2023/12/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_AddAccountViewController : UIViewController

@property (nonatomic,strong) WH_RoomData* room;

@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *account;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *accountId;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *qrCode;

@property(nonatomic,copy) NSString *bankName;

@end

NS_ASSUME_NONNULL_END
