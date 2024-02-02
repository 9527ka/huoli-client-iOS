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

@property(nonatomic,copy)NSString *amount;//金额
@property(nonatomic,copy)NSString *count;//数量
@property(nonatomic,copy)NSString *time;//时间
@property(nonatomic,copy)NSString *passWord;//密码
@property(nonatomic,copy)NSString *timeInter;//时间间隔
@property(nonatomic,strong)NSNumber *isNoPas;//是否免密

@property(nonatomic,strong)NSNumber *isRandow;//是否随机
@property(nonatomic,copy)NSString *randowCount;//随机位数

@property(nonatomic,strong)NSNumber *isRmarkOn;//是否开启固定留言
@property(nonatomic,copy)NSString *remark;//固定留言

@property(nonatomic,strong)NSNumber *isCirclekOn;//是否开启循环留言
@property(nonatomic,copy)NSString *circle;//循环留言

@property(nonatomic,copy)NSString *greet;//上一个发送的内容 循环模式用


//获取当前时间戳
+(NSString *)receiveNowInterval;

//是否可以
+(BOOL)isCanWithEndTime:(NSString *)endTime;

@end

NS_ASSUME_NONNULL_END
