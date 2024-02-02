//
//  WH_JXChatTool.h
//  Tigase
//
//  Created by 1111 on 2024/2/2.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXChatTool : NSObject

/**
 获取当前登录用户
  */
+ (memberData *)getCurrentLoginMerber:(WH_RoomData *)room;
/**
 是否是管理员 群组(role : 1)/管理员(role : 2)均 视为 管理员

 */
+ (BOOL)isManger:(memberData *)user;

+(BOOL)isManagrData:(NSString *)roomJid;

@end

NS_ASSUME_NONNULL_END
