//
//  GKDYVideoModel.h
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_GKDYVideoAuthorModel : NSObject

@property (nonatomic, copy) NSString        *wh_fans_num;
@property (nonatomic, copy) NSString        *wh_follow_num;
@property (nonatomic, copy) NSString        *wh_gender;
@property (nonatomic, copy) NSString        *wh_intro;
@property (nonatomic, copy) NSString        *wh_is_follow;
@property (nonatomic, copy) NSString        *wh_name_show;
@property (nonatomic, copy) NSString        *wh_portrait;
@property (nonatomic, copy) NSString        *wh_user_id;
@property (nonatomic, copy) NSString        *wh_user_name;

@end

@interface WH_GKDYVideoModel : NSObject
@property (nonatomic, copy) NSString        *title;
@property (nonatomic, copy) NSString        *agree_num;
@property (nonatomic, copy) NSString        *agreed_num;
@property (nonatomic, strong) WH_GKDYVideoAuthorModel   *author;
@property (nonatomic, copy) NSString        *comment_num;
@property (nonatomic, copy) NSString        *create_time;
@property (nonatomic, copy) NSString        *first_frame_cover;
@property (nonatomic, copy) NSString        *is_deleted;
@property (nonatomic, copy) NSString        *is_private;
@property (nonatomic, copy) NSString        *need_hide_title;
@property (nonatomic, copy) NSString        *play_count;
@property (nonatomic, copy) NSString        *post_id;
@property (nonatomic, copy) NSString        *share_num;
@property (nonatomic, copy) NSString        *tags;
@property (nonatomic, copy) NSString        *thread_id;
@property (nonatomic, copy) NSString        *thumbnail_height;
@property (nonatomic, copy) NSString        *thumbnail_url;//封面图
@property (nonatomic, copy) NSString        *thumbnail_width;
@property (nonatomic, copy) NSString        *shortName;
@property (nonatomic, copy) NSString        *video_duration;
@property (nonatomic, copy) NSString        *video_height;
@property (nonatomic, copy) NSString        *video_length;
@property (nonatomic, copy) NSString        *video_log_id;
@property (nonatomic, copy) NSString        *video_url;//视频播放地址
@property (nonatomic, copy) NSString        *video_width;

@property (nonatomic, assign) BOOL isPraise;
@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, copy) NSString *userId;
@property(nonatomic,strong) NSMutableArray * replys;
@property (nonatomic, assign) CGFloat height; // 分类短视频cell 高度

@property (nonatomic, copy) NSString        *album;
@property (nonatomic,assign)BOOL allowComment;//是否允许评论
@property (nonatomic, copy) NSString        *artist;//作者
@property (nonatomic, copy) NSString        *collect;//收藏数
@property (nonatomic, assign) BOOL        collected;//是否收藏
@property (nonatomic, copy) NSString        *index;//第几集
@property (nonatomic, copy) NSString        *play;//播放次数
@property (nonatomic, copy) NSString        *totalSeries;//157,总集数
@property (nonatomic, copy) NSString        *type;//1短剧,２用户发的视频















- (void)WH_getDataFromDict:(NSDictionary *)dict;



NS_ASSUME_NONNULL_END
- (void)sp_checkNetWorking;
@end
