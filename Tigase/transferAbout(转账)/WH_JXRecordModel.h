//
//  WH_JXRecordModel.h
//  Tigase_imChatT
//
//  Created by 1 on 2019/4/20.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXRecordModel : NSObject
@property (nonatomic, assign) double money;
@property (nonatomic, strong) NSString *desc;// 说明
@property (nonatomic, assign) int payType;
@property (nonatomic, assign) long time;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int type;


- (void)getDataWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
