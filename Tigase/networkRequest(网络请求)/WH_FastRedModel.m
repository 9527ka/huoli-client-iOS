//
//  WH_FastRedModel.m
//  Tigase
//
//  Created by 1111 on 2024/2/1.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_FastRedModel.h"

@implementation WH_FastRedModel

+(NSString *)receiveNowInterval{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;
}

//是否可以
+(BOOL)isCanWithEndTime:(NSString *)endTime{
    NSString *startTime = [WH_FastRedModel receiveNowInterval];
    if(startTime.doubleValue > endTime.doubleValue){
        return NO;
    }
    return YES;
}

@end
