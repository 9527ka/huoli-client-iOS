//
//  WH_JXAppealListCell.m
//  Tigase
//
//  Created by 1111 on 2023/12/22.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXAppealListCell.h"
#import "UIButton+WebCache.h"

@implementation WH_JXAppealListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picBgViewHeight.constant = 0.0f;
    self.headImage.layer.cornerRadius = 14.0f;
    self.bgView.layer.cornerRadius = 8.0f;
    self.picBgView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(WH_JXAppealModel *)model{
    _model = model;
    NSString *time = model.createTime;
//    [NSString stringWithFormat:@"%@",dict[@"createTime"]];
    //时间
    self.timeLab.text = [self getTimeFrom:time.doubleValue/1000];
    self.contentLab.text = [NSString stringWithFormat:@"%@",model.note];
    
    NSString *userId = [NSString stringWithFormat:@"%@",model.participantUID];
    WH_JXUserObject *userobj = [[WH_JXUserObject sharedUserInstance] getUserById:userId];
    
    self.nameLab.text = userobj.userNickname?userobj.userNickname:model.participantNickname;
    //头像
    [g_server WH_getHeadImageSmallWIthUserId:userId userName:userobj.userNickname imageView:self.headImage];
    
    self.picBgView.hidden = YES;
    self.picBgViewHeight.constant = 0.0f;
    [self.picBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.items = [NSMutableArray array];
    //看看是否有视频或者图片
    if(model.items){
        NSArray *items = model.items;
        //创建图片
        [self creatFileList:items];
    }
}
//创建图片
-(void)creatFileList:(NSArray *)items{
    float height = items.count > 3?172:84;
    
    self.picBgView.hidden = items.count == 0?YES:NO;
    self.picBgViewHeight.constant = items.count == 0?0.0f:height;
    
    NSInteger count = items.count;
    for (int i = 0; i < count; i++) {
        NSString *url = [NSString stringWithFormat:@"%@",items[i]];
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//
        //video/mp4
        if([url containsString:@"video"] || [url containsString:@"mp4"]){
            [imageBtn setImage:[UIImage imageNamed:@"开始"] forState:UIControlStateNormal];
            [imageBtn addTarget:self action:@selector(lookVideoAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [imageBtn setBackgroundImage:self.model.cover forState:UIControlStateNormal];
            self.videoUrl = url;
//            [imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        }else{
            [self.items addObject:url];
            [imageBtn addTarget:self action:@selector(lookImageAction:) forControlEvents:UIControlEventTouchUpInside];
            [imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        }
        imageBtn.layer.masksToBounds = YES;
        imageBtn.layer.cornerRadius = 4.0f;
        imageBtn.tag = 800 + i;
        imageBtn.frame = CGRectMake(16 + i%3*84, i/3*84, 80, 80);
        
        [self.picBgView addSubview:imageBtn];
    }
}

-(void)lookVideoAction:(UIButton *)sender{
    
    if(self.lookVideoBlock){
        self.lookVideoBlock(self.videoUrl);
    }
}

//800+
-(void)lookImageAction:(UIButton *)sender{
    
    if(self.lookImageBlock){
        self.lookImageBlock(sender.tag - 800,self.items);
    }
}
/**
 *根据时间戳 转时间
 */
-(NSString *)getTimeFrom:(double)second{
    //将对象类型的时间转换为NSDate类型
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:second];
        
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter2 stringFromDate:date];
        
    return dateString;
}



@end


//createTime = 1703319281873;
//id = 658696f15feedd038196d5f5;
//items =             (
//    "http://192.168.1.88:8089/resources/u/12/10000012/202312/o/db9c9fcb92c747658b8caa18307a9d49.jpg",
//    "http://192.168.1.88:8089/resources/u/12/10000012/202312/o/7f128dc765e34f178717adbd960f8516.jpg",
//    "http://192.168.1.88:8089/resources/u/12/10000012/202312/58ebd885835543dcb18da7324d1e2eca.mp4"
//);
//note = "\U54c8\U55bd\U54c8\U54c8\U54c8\U54c8\U54c8";
//participantUID = 10000012;
//result = 0;
//round = 2;
//tradeComplaintId = 65868ae7757fc81b345384db;
//tradeNo = T495970470899781;
//viewed = 0;
