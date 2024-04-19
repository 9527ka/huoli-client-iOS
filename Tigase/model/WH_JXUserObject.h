//
//  WH_JXUserObject.h
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WH_JXUserBaseObj.h"

@class WH_ResumeBaseData;
@class memberData;

#define PayPasswordKey @"payPassword" //因为通过获取用户信息的接口,获取不到用户的支付密码是否已经设置信息,所以目前采用保存在g_default中,防止发生修改支付密码出现无法识别返回值问题.

@interface WH_JXUserObject : WH_JXUserBaseObj{
}
@property (nonatomic,copy) NSString* telephone; //!< 加区号
@property (nonatomic,copy) NSString* phone; //!< 未加区号,暂未存数据库
@property (nonatomic,copy) NSString* amount;//群成员的钻石额度
@property (nonatomic,copy) NSString* quota;//群的钻石总配额
@property (nonatomic, copy) NSString *name; //!<
@property (nonatomic, copy) NSString *payAccount;
@property (nonatomic, copy) NSString *aliUserId;
@property (nonatomic, copy) NSString *active; //!<
@property (nonatomic, copy) NSString *anonymous;
@property (nonatomic, copy) NSString *carrier;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, copy) NSString *idCardUrl;
@property (nonatomic, copy) NSString *officialCSUid;//客服id
@property (nonatomic, assign) BOOL isAuth;
@property (nonatomic, copy) NSString *isCreateRoom;
@property (nonatomic, copy) NSString *isPasuse;
@property (nonatomic, copy) NSString *loginIp;
@property (nonatomic, copy) NSString *modifyTime;
@property (nonatomic, strong) NSNumber *num;
@property (nonatomic, strong) NSNumber *onlinestate;
@property (nonatomic, copy) NSString *phoneToLocation;
@property (nonatomic, copy) NSString *regInviteCode;
@property (nonatomic, copy) NSString *serInviteCode;
@property (nonatomic, copy) NSString *allowAtt;
@property (nonatomic, copy) NSString *allowGreet;
@property (nonatomic, copy) NSString *closeTelephoneFind;
@property (nonatomic, copy) NSString *friendFromList;
@property (nonatomic, assign) BOOL isKeepalive;
@property (nonatomic, assign) BOOL openService;
@property (nonatomic, assign) BOOL showTelephone;
@property (nonatomic, copy) NSString *totalConsume;
@property (nonatomic, copy) NSString *totalRecharge;
@property (nonatomic, copy) NSString *userKey;
@property (nonatomic, assign) BOOL isTestAccount;

@property (nonatomic,copy) NSString* password;
@property (nonatomic,strong) NSDate*   birthday;
@property (nonatomic,copy) NSString* companyName;
@property (nonatomic,copy) NSString* model;
@property (nonatomic,copy) NSString* osVersion;
@property (nonatomic,copy) NSString* serialNumber;
@property (nonatomic,copy) NSString* location;
@property (nonatomic,strong) NSNumber* sex;  //0 : 女   1 : 男
@property (nonatomic,strong) NSNumber* countryId;
@property (nonatomic,strong) NSNumber* provinceId;
@property (nonatomic,strong) NSNumber* cityId;
@property (nonatomic,strong) NSNumber* areaId;
@property (nonatomic,strong) NSNumber* latitude;
@property (nonatomic,strong) NSNumber* longitude;
@property (nonatomic,strong) NSNumber* level;
@property (nonatomic,strong) NSNumber* vip;
@property (nonatomic,strong) NSNumber* fansCount;
@property (nonatomic,strong) NSNumber* attCount;
@property (nonatomic,copy) NSString * friendCount;
@property (nonatomic,copy) NSString* areaCode;
@property (nonatomic,strong) NSNumber* isBeenBlack;//!< 是否被拉黑
@property (nonatomic,strong) NSNumber* merchant;//是否是代理商
@property (nonatomic,copy) NSString* myInviteCode;  //!<  多人邀请码
@property (nonatomic, copy) NSString *account;  //!< 即时通讯号
@property (nonatomic, copy) NSString *setAccountCount;  //!< 即时通讯号已修改次数
//@property (nonatomic, strong) NSNumber *isMultipleLogin;
@property (nonatomic, assign) BOOL showLastLoginTime; //!< 是否显示离线时间
@property (nonatomic, strong) NSNumber *lastLoginTime; //!< 离线时间
@property (nonatomic, strong) NSArray *questions; //!< 密保
@property (nonatomic ,strong) NSNumber *isAddFirend; //!< 是否有权限加好友 1、允许 0、禁止
@property (nonatomic, strong) NSNumber *redPacketVip; //!< 红包Vip 0、否; 1、是

// 隐私设置
@property (nonatomic,copy) NSString *chatSyncTimeLen; //!< 单聊聊天记录 同步时长
@property (nonatomic,copy) NSString *friendsVerify; //!< 好友验证
@property (nonatomic,copy) NSString *isEncrypt; //!< 消息加密传输
@property (nonatomic,copy) NSString *isTyping; //!<正在输入
@property (nonatomic,copy) NSString *isVibration; //!< 震动
@property (nonatomic,copy) NSString *multipleDevices; //!< 多点登录
@property (nonatomic,copy) NSString *isUseGoogleMap; //!< 谷歌地图
@property (nonatomic,copy) NSString *payPassword; //!< 支付密码
@property (nonatomic,copy) NSString *oldPayPassword; //!< 旧支付密码
@property (nonatomic,strong) NSNumber *isPayPassword; //!< 是否存在支付密码
@property (nonatomic,copy) NSString *phoneSearch; //!< 允许通过手机号搜索我 1 允许 0 不允许
@property (nonatomic,copy) NSString *nameSearch; //!< 允许通过昵称搜索我  1 允许 0 不允许

@property (nonatomic, copy) NSString *msgBackGroundUrl;//!< 朋友圈顶部图片URL

@property (nonatomic ,strong) NSDictionary *friends; 

//短信验证码登录
@property (nonatomic, copy) NSString *verificationCode;//!< 短信验证码

// 我收藏的表情
@property (nonatomic, strong) NSMutableArray *favorites;

// 已拨打的电话号码
@property (nonatomic, strong) NSMutableDictionary *phoneDic;

+(WH_JXUserObject*)sharedUserInstance;

-(NSMutableArray*)WH_fetchAllFriendsFromLocal;
-(NSMutableArray*)WH_fetchFriendsFromLocalWhereLike:(NSString *)searchStr;
//搜索群组
-(NSMutableArray*)WH_fetchGroupsFromLocalWhereLike:(NSString *)searchStr;
-(NSMutableArray*)WH_fetchAllRoomsFromLocal;
// 获取指定类型群组
-(NSMutableArray*)WH_fetchRoomsFromLocalWithCategory:(NSNumber *)category;
-(NSMutableArray*)WH_fetchAllCompanyFromLocal;
-(NSMutableArray*)WH_fetchAllPayFromLocal;
-(NSMutableArray*)WH_fetchAllUserFromLocal;
-(NSMutableArray*)WH_fetchAllBlackFromLocal;
-(NSMutableArray*)WH_fetchBlackFromLocalWhereLike:(NSString *)searchStr;
-(NSMutableArray*)WH_fetchSystemUser;

-(BOOL)insertRoom;
-(void)WH_createSystemFriend;
-(WH_JXUserObject*)getUserById:(NSString*)aUserId;
//通过userID获取好友信息
- (WH_JXUserObject *)getFriendWithUserId:(NSString *)userId;

-(void)WH_getDataFromDict:(NSDictionary*)dict;
-(void)WH_getDataFromDictSmall:(NSDictionary*)dict;
-(void)copyFromResume:(WH_ResumeBaseData*)resume;
-(void)copyFromRoomMember:(memberData*)p;
-(int)getNewTotal;

+(void)deleteUserAndMsg:(NSString*)userId;

//解散群组
+ (void)deleteRoom:(NSString *)roomId;

+(BOOL)WH_updateNewMsgsTo0;
+(NSString*)WH_getUserNameWithUserId:(NSString*)userId;
- (void)insertFriend;
-(NSMutableArray*)WH_fetchAllFriendsOrNotFromLocal;

// 更新最后输入
- (BOOL) updateLastInput;

// 更新消息界面显示的最后一条消息
- (BOOL) updateLastContent;

// 更新置顶时间
- (BOOL) WH_updateTopTime;

// 更新群组有效性
- (BOOL) WH_updateGroupInvalid;

// 更新用户昵称
- (BOOL) WH_updateUserNickname;

// 更新用户备注
- (BOOL) WH_updateRemarkName;

// 更新用户聊天记录过期时间
- (BOOL) WH_updateUserChatRecordTimeOut;

// 更新列表最近一条消息记录
- (BOOL) WH_updateUserLastChatList:(NSArray *)array;

// 更新是否开启阅后即焚标志
- (BOOL) WH_updateIsOpenReadDel;

// 更新消息免打扰
- (BOOL) updateOfflineNoPushMsg;

// 更新@我
- (BOOL) updateIsAtMe;

// 更新群组全员禁言时间
- (BOOL) WH_updateGroupTalkTime;

// 更新userType
- (BOOL) updateUserType;

// 更新创建者
- (BOOL)updateCreateUser;

// 更新群组设置
- (BOOL)WH_updateGroupSetting;

// 更新好友关系
- (BOOL)WH_updateStatus;

// 更新我的设备是否在线
- (BOOL)updateIsOnLine;

// 更新群组最后群成员加入时间
- (BOOL)updateJoinTime;

// 更新新消息数量
- (BOOL)WH_updateNewMsgNum;


// 删除用户过期聊天记录
- (BOOL) WH_deleteUserChatRecordTimeOutMsg;

- (BOOL) deleteAllUser;

// 获取已拨打号码
- (NSMutableDictionary *) getPhoneDic;
//插入已拨打的电话号码
- (BOOL) insertPhone:(NSString *)phone time:(NSDate *)time;
// 删除已拨打的电话号码
- (BOOL) deletePhone:(NSString *)phone;




@end
