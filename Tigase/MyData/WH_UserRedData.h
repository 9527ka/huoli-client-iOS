//
//  WH_UserRedData.h
//  Tigase
//
//  Created by 1111 on 2024/1/27.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_UserRedData : NSObject

@property(nonatomic,copy)NSString *memberName;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *delay;
@property(nonatomic,copy)NSString *roomJid;
@property(nonatomic,copy)NSString *createTime;

@end

NS_ASSUME_NONNULL_END
