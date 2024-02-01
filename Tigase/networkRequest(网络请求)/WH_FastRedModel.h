//
//  WH_FastRedModel.h
//  Tigase
//
//  Created by 1111 on 2024/2/1.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_FastRedModel : NSObject

@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *passWord;
@property(nonatomic,copy)NSNumber *isOn;

//获取当前时间戳
+(NSString *)receiveNowInterval;

//是否可以
+(BOOL)isCanWithEndTime:(NSString *)endTime;

@end

NS_ASSUME_NONNULL_END
