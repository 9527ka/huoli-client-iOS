//
//  WH_RoomData.h
//  Tigase_imChatT
//
//  Created by flyeagleTang on 15-2-6.
//  Copyright (c) 2015年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WH_RoomData;

@interface WH_RoomData : NSObject{
    NSString* _tableName;
}
//自定义的两个字段
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString *count;

@property(nonatomic,assign) int countryId;//国家
@property(nonatomic,assign) int provinceId;//省份
@property(nonatomic,assign) int cityId;//城市
@property(nonatomic,assign) int areaId;//区域

@property(nonatomic,assign) int category;//类别 0普通 1钻石
@property(nonatomic,assign) int maxCount;//最大成员数
@property(nonatomic,assign,getter = getCurCount) NSInteger curCount;//当前成员数

@property(nonatomic,assign) NSTimeInterval createTime;//建立时间
@property(nonatomic,assign) NSTimeInterval updateTime;//修改时间
@property(nonatomic,assign) long updateUserId;//修改人

@property(nonatomic,strong) NSString* roomJid;//ID
@property(nonatomic,strong) NSString* roomId;//ID
@property(nonatomic,strong) NSString* name;//名字
@property(nonatomic,strong) NSString* desc;//说明
@property(nonatomic,strong) NSString* subject;//主题
@property(nonatomic,strong) NSString* note;//公告
@property(nonatomic,assign) long userId;//建立人
@property(nonatomic,strong) NSString* userNickName;//建立人昵称
@property (nonatomic, strong) NSString * lordRemarkName;  // 群主修改的昵称
@property(nonatomic,assign) BOOL showRead; //群内消息是否发送已读 回执 显示数量 0不显示 1要求显示
//@property (nonatomic,strong) NSString* call;//群音频会议号码
@property (nonatomic, assign) BOOL isLook; // 是否公开 0：公开  1：不公开
@property (nonatomic, assign) BOOL isNeedVerify; // 邀请进群是否需要验证，1：需要  0：不需要  默认不需要
@property (nonatomic, assign) BOOL showMember; // 显示群成员给普通用户，1：显示  0：不显示 默认显示
@property (nonatomic, assign) BOOL allowSendCard; // 允许私聊，1：允许  0：不允许  默认允许
@property (nonatomic, assign) BOOL allowHostUpdate; // 允许群主修改群属性  1：允许  0：不允许  默认允许
@property (nonatomic, assign) BOOL allowInviteFriend; // 允许普通成员邀请好友，1：允许  0：不允许  默认允许
@property (nonatomic, assign) BOOL allowUploadFile; // 允许群成员上传群共享文件，1：允许  0：不允许  默认允许
@property (nonatomic, assign) BOOL allowConference; // 允许成员召开会议，1：允许  0：不允许  默认允许
@property (nonatomic, assign) BOOL allowSpeakCourse; // 允许群成员发起讲课，1：允许  0：不允许  默认允许

@property (nonatomic, assign) BOOL showAllValidRedPacket;   //!< 群成员使用长时间未领取红包 1：允许

@property (nonatomic, assign) BOOL allowForceNotice;//允许发强提醒公告// 1: 允许 0:不允许 默认不允许

@property (nonatomic, assign) BOOL isAttritionNotice; // 群组减员通知，1：开启通知  0：不通知  默认通知
@property (nonatomic, assign) long long talkTime;   // 全员禁言时间

@property (nonatomic,strong) NSString*   chatRecordTimeOut; // 消息保留天数

@property (nonatomic ,assign) NSInteger isShowSignIn ; //是否开启群签到 1:开启
@property (nonatomic ,assign) NSInteger financialAccountCount ; //配置 的收款帐号的条数

@property (nonatomic ,assign) NSInteger luckyRecPacketMax ; //手气红包最大在值参数
@property (nonatomic ,assign) NSInteger exclusiveRedPacketMax ; //专属红包最大值参数
@property (nonatomic,strong) NSString *redPackageBanList; //谁不可以抢红包100001,100002,100004 表示userId为100001,

@property(nonatomic,assign) double longitude;
@property(nonatomic,assign) double latitude;
@property (nonatomic ,assign) NSInteger level ;//群等级

@property(nonatomic,strong) NSMutableArray* members;    //房间成员列表

@property (nonatomic,copy) NSString *expiryTime; //过期时间,单位毫秒
@property (nonatomic,copy) NSString *currentTime;

@property (nonatomic,copy) NSString *quotaUnit; //钻石群单位
@property (nonatomic,copy) NSString *quota; //群钻石额度
@property (nonatomic,copy) NSString* amount;//群成员的钻石额度




-(void)WH_getDataFromDict:(NSDictionary*)dict;
-(BOOL)isMember:(NSString*)theUserId;
-(NSString*)getNickNameInRoom;
-(memberData*)getMember:(NSString*)theUserId;
-(void)setNickNameForUser:(WH_JXUserObject*)user;
-(NSString *)roomDataToNSString;


/**
 群头像,多个成员头像拼接
 */
-(void)roomHeadImageToView:(UIImageView *)toView;
+(void)roomHeadImageRoomId:(NSString *)roomId toView:(UIImageView *)toView;

@end

@interface memberData : NSObject{
    
}
@property(nonatomic,assign) NSTimeInterval createTime;//建立时间
@property(nonatomic,assign) NSTimeInterval updateTime;//修改时间
@property(nonatomic,assign) NSTimeInterval active;//最后一次互动时间
@property(nonatomic,assign) NSTimeInterval talkTime;//禁言结束时间

@property (nonatomic, assign) int offlineNoPushMsg;// 是否消息免打扰 1=是，0=否

@property(nonatomic,assign) int sub;//是否屏bi

@property(nonatomic,assign) long userId;//成员id
@property(nonatomic,strong) NSString* userNickName;//成员昵称
@property(nonatomic,strong) NSString* nickname;
@property (nonatomic, strong) NSString * roomId;
//@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * cardName;
@property (nonatomic, strong) NSString * lordRemarkName;  // 群主修改的昵称
@property (nonatomic, strong) NSNumber * role; //角色 1创建者,2管理员,3成员,4隐身人,5监控人6,群助手
@property (nonatomic, strong) NSString * idStr;

@property (nonatomic ,strong) NSNumber *vip; //用户等级

@property (nonatomic ,strong) NSNumber *onLineState;//在线状态(是否在线)
@property (nonatomic ,assign) NSInteger offlineTime;//上次离线时间(毫秒时间戳)

@property (nonatomic ,strong) NSNumber *isAddFirend;//是否允许添加好友

@property (nonatomic ,assign) BOOL isSelect;

@property (nonatomic,copy) NSString *amount;//群成员的钻石额度

@property (nonatomic,copy) NSString *delays;// 延迟抢红包的时间,


//@property (nonatomic ,strong) NSDictionary *user;

-(void)WH_getDataFromDict:(NSDictionary*)dict;

-(BOOL)checkTableCreatedInDb:(NSString *)queryRoomId;

-(BOOL)insert;

-(BOOL)remove;

-(BOOL)update;

//删除房间成员列表
-(BOOL)deleteRoomMemeber;

+(NSArray <memberData *>*)fetchAllMembers:(NSString *)queryRoomId;

/**
 返回排过序的群组成员列表

 @param queryRoomId 群组roomId
 @param sortByName 排序类型,YES只按cardName排序,NO先按role再按cardName排序
 @return 成员列表
 */
+(NSArray <memberData *>*)fetchAllMembers:(NSString *)queryRoomId sortByName:(BOOL)sortByName;
/**
 返回排过序的非隐身人和监控人的群组成员列表
 
 @param queryRoomId 群组roomId
 @param sortByName 排序类型,YES只按cardName排序,NO先按role再按cardName排序
 @return 成员列表
 */
+(NSArray <memberData *>*)fetchAllMembersAndHideMonitor:(NSString *)queryRoomId sortByName:(BOOL)sortByName;
-(memberData *)searchMemberByName:(NSString *)cardName;

// 查找群主
+ (memberData *)searchGroupOwner:(NSString *)roomId;
// 获取群昵称
- (memberData*)getCardNameById:(NSString*)aUserId;

// 更新身份
- (BOOL)updateRole;

// 更新群昵称
- (BOOL)updateCardName;

// 更新群昵称
- (BOOL)WH_updateUserNickname;

+(NSMutableArray *)searchMemberByFilter:(NSString *)filter room:(NSString *)roomId;

@end
