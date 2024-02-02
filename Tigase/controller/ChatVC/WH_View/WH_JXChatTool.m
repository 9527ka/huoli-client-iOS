//
//  WH_JXChatTool.m
//  Tigase
//
//  Created by 1111 on 2024/2/2.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXChatTool.h"

@implementation WH_JXChatTool



/**
 获取当前登录用户
  */
+ (memberData *)getCurrentLoginMerber:(WH_RoomData *)room {
    memberData *currentMember = nil;
    WH_JXUserObject *currentUser = g_myself;
    for (memberData *member in room.members) {
        if (member.userId == [currentUser.userId longLongValue]) {
            currentMember = member;
            break;
        }
    }
    return currentMember;
}
/**
 是否是管理员 群组(role : 1)/管理员(role : 2)均 视为 管理员

 */
+ (BOOL)isManger:(memberData *)user {
    return [user.role intValue] == 1 || [user.role intValue] == 2;
}

+(BOOL)isManagrData:(NSString *)roomJid{
    WH_JXUserObject *roomObj = [[WH_JXUserObject sharedUserInstance] getUserById:roomJid];
    NSArray *members = [memberData fetchAllMembers:roomObj.roomId];
    
    /// 拿到当前用户 在群组里扮演的角色
    memberData *currentMember = nil;
    WH_JXUserObject *currentUser = g_myself;
    for (memberData *member in members) {
        if (member.userId == [currentUser.userId longLongValue]) {
            currentMember = member;
        }
    }
    
    /// 是不是群主 或者 管理员 yes:是 no:不是
    BOOL isManger = [currentMember.role intValue] == 1 || [currentMember.role intValue] == 2;
    
    return isManger;

}


@end
