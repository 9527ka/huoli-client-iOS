//
//  GKDYVideoModel.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "WH_GKDYVideoModel.h"

@implementation WH_GKDYVideoAuthorModel

@end

@implementation WH_GKDYVideoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"author" : [WH_GKDYVideoAuthorModel class]};
}

- (void)WH_getDataFromDict:(NSDictionary *)dict {
    self.title = [[dict objectForKey:@"body"] objectForKey:@"text"];
    NSArray *images = [[dict objectForKey:@"body"] objectForKey:@"images"];
    self.first_frame_cover = [images.firstObject objectForKey:@"oUrl"];
    self.thumbnail_url = self.first_frame_cover;
    
    NSArray *videos = [[dict objectForKey:@"body"] objectForKey:@"videos"];
    self.video_url = [videos.firstObject objectForKey:@"oUrl"];
    self.video_length = [videos.firstObject objectForKey:@"size"];
    self.video_duration = [NSString stringWithFormat:@"%ld",[[videos.firstObject objectForKey:@"length"] integerValue] / 1000];
    self.post_id = [dict objectForKey:@"msgId"];
    self.agree_num = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"count"] objectForKey:@"praise"]];
    self.comment_num = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"count"] objectForKey:@"comment"]];
    self.share_num = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"count"] objectForKey:@"share"]];
    
    self.isPraise = [[dict objectForKey:@"isPraise"] boolValue];
    self.msgId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"msgId"]];
    
    NSString *s = [dict objectForKey:@"userId"];
    self.userId = s;
    NSString* dir  = [NSString stringWithFormat:@"%d",[s intValue] % 10000];
    NSString* url  = [NSString stringWithFormat:@"%@avatar/o/%@/%@.jpg",g_config.downloadAvatarUrl,dir,s];
    self.author = [[WH_GKDYVideoAuthorModel alloc] init];
    self.author.wh_portrait = url;
    self.author.wh_name_show = [dict objectForKey:@"nickname"];
    
    
    NSArray *p = [dict objectForKey:@"comments"];
    self.replys = [NSMutableArray array];
    for(NSInteger i = 0; i < p.count; i++){
        WeiboReplyData * reply=[[WeiboReplyData alloc]init];
        reply.font = sysFontWithSize(15);
        reply.textColor = [UIColor whiteColor];
        reply.type=reply_data_comment;
        reply.addHeight = 0;
        reply.messageId=self.msgId;
        NSDictionary *row = [p objectAtIndex:i];
        [reply WH_getDataFromDict:row];
        //计算时间
       reply.publishTime = [self receiveTimeWithCurrentTime:reply.createTime];
        
        [self.replys addObject:reply];
    }
    CGSize size = [self.title boundingRectWithSize:CGSizeMake(JX_SCREEN_WIDTH/2-2, 45) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:sysFontWithSize(13)} context:nil].size;
    self.height = size.height;
}
-(NSString *)receiveTimeWithCurrentTime:(NSTimeInterval)second{
    //将对象类型的时间转换为NSDate类型
    
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:second];
    
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = second;
    // 时间差
    NSTimeInterval timeInterval = currentTime - createTime;
    
    long temp = 0;
    
    if (timeInterval < 60) {
        return [NSString stringWithFormat:@"刚刚"];
    }else if((temp = timeInterval/60) <60){
        return [NSString stringWithFormat:@"%ld分钟前",temp];
    }else if((temp = timeInterval/(60*60)) <24){
        return [NSString stringWithFormat:@"%ld小时前",temp];
    }
//    else if((temp = timeInterval/(60*60)) >= 24 && (temp = timeInterval/(60*60)) < 48){
//        return @"昨天";
//    }else if((temp = timeInterval/(60*60)) >= 24 && (temp = timeInterval/(60*60)) < 720){//一个月内
//        NSInteger hours = timeInterval/(60*60);
//        return [NSString stringWithFormat:@"%ld天前",hours/24];
//    }
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter2 stringFromDate:date];
    return dateString;
}


- (void)sp_checkNetWorking {
    //NSLog(@"Get Info Failed");
}
@end
