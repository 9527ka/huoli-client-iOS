//
//  WeiboReplyData.h
//  wq8
//
//  Created by weqia on 13-9-5.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "Jastor.h"
#import "MatchParser.h"

#define reply_data_comment 1
#define reply_data_praise 2
#define reply_data_gift 3

@interface WeiboReplyData : Jastor<MatchParserDelegate>
{
    __weak MatchParser * _match;
}
//@property(nonatomic,copy) NSString * files;
@property(nonatomic,copy) NSString * replyId;
@property(nonatomic,copy) NSString * messageId;
@property(nonatomic,copy) NSString * body;
@property(nonatomic,copy) NSString * userId;
@property(nonatomic,copy) NSString * userNickName;
@property(nonatomic,copy) NSString * toUserId;
@property(nonatomic,copy) NSString * toNickName;
@property(nonatomic,copy) NSString * toBody;
@property(nonatomic,copy) NSString * giftId;
@property(nonatomic,copy) NSString * giftName;
@property(nonatomic,copy) NSString * giftCount;
@property(nonatomic,copy) NSString * giftPrice;
@property(nonatomic,copy) NSString * publishTime;
@property(nonatomic,assign) NSTimeInterval createTime;

@property(nonatomic) int height2;
@property(nonatomic) int height;
@property(nonatomic) int addHeight;
@property(nonatomic,strong) NSAttributedString * title;
@property(nonatomic,weak,getter = getMatch,setter = setMatch:) MatchParser * match;
@property(nonatomic) int type;

-(MatchParser*)createMatchType1;
-(void)setMatch;
-(void)updateMatch:(void(^)(NSMutableAttributedString * string, NSRange range))link;
-(void)getHeight2;

+(NSCache*)shareCacheForReply;
-(void)WH_getDataFromDict:(NSDictionary*)dict;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;





@end
