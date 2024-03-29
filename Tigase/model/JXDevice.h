//
//  JXDevice.h
//  Tigase_imChatT
//
//  Created by p on 2018/6/6.
//  Copyright © 2018年 YZK. All rights reserved.
//

#import "WH_JXUserObject.h"

@interface JXDevice : WH_JXUserObject

// 每个端有一个监控定时器
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timerNum;

+(JXDevice*)sharedInstance;

// 更新其他端isOnLine
- (BOOL) updateIsOnLine:(NSNumber *)isOnLine userId:(NSString *)userId;
// 更新其他端isOnLine
- (BOOL) updateIsSendRecipt:(NSNumber *)isSendRecipt userId:(NSString *)userId;
// 查找我的设备
-(NSMutableArray*)fetchAllDeviceFromLocal;

/// 获取设备型号，该型号就是 设置->通用->关于手机->型号名称
+ (NSString *)getDeviceModelName;

@end
