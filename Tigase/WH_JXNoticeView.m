//
//  WH_JXNoticeView.m
//  Tigase
//
//  Created by 1111 on 2024/1/9.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXNoticeView.h"
#import "WH_JXNoticeModel.h"

@interface WH_JXNoticeView(){
    ATMHud *_wait;
}

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UILabel *noticeLab;
@property(nonatomic,strong)UILabel *secNoticeLab;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation WH_JXNoticeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _wait = [ATMHud sharedInstance];
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, frame.size.width - 30, frame.size.height)];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 18.0f;
        bgView.backgroundColor = HEXCOLOR(0xF3FFF8);
        [self addSubview:bgView];
        
        UIImageView *noticeImagw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notice_icon"]];
        noticeImagw.frame = CGRectMake(10, 10, 16, 16);
        [bgView addSubview:noticeImagw];
        
        self.dataArray = [NSMutableArray array];
        
        [self creatUI];
        
    }
    return self;
}

-(void)setLabData{
    if(self.dataArray.count > 0){
        self.currentIndex =self.dataArray.count > 1?1:0;

    }else{
        self.hidden = YES;
        self.frame = CGRectMake(0, 0, 0, 0);
    }
}

-(void)creatUI{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, JX_SCREEN_WIDTH - 54, self.frame.size.height)];
    label.textColor = HEXCOLOR(0x797979);
    label.text = @"欢迎加入悦介大家庭";
    label.font = [UIFont systemFontOfSize:13];
    [self addSubview:label];
    self.noticeLab = label;
    
    _secNoticeLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 36, JX_SCREEN_WIDTH - 54, self.frame.size.height)];
    _secNoticeLab.textColor = HEXCOLOR(0x797979);
    _secNoticeLab.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.secNoticeLab];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(moveLabel:) userInfo:nil repeats:YES];
    
}
//移动UILabel的位置
- (void)moveLabel:(NSTimer *)timer {
    if(self.dataArray.count == 0){
        return;
    }
    
    WH_JXNoticeModel *model = self.dataArray[self.currentIndex];
    NSString *currentStr = model.content;
    
    CGFloat y = self.noticeLab.frame.origin.y;
    
    if(y==0){//当前是这个
        
        self.secNoticeLab.text = currentStr;
        
        self.secNoticeLab.frame = CGRectMake(50, 36, self.secNoticeLab.frame.size.width, self.secNoticeLab.frame.size.height);
        
        [UIView animateWithDuration:1.0 animations:^{
            //消失
            self.noticeLab.frame = CGRectMake(self.noticeLab.frame.origin.x, -36, self.noticeLab.frame.size.width, self.noticeLab.frame.size.height);
            
            //出现
            self.secNoticeLab.frame = CGRectMake(50, 0, self.secNoticeLab.frame.size.width, self.secNoticeLab.frame.size.height);
            
        } completion:^(BOOL finished) {
            self.currentIndex++;
            if(self.dataArray.count<=self.currentIndex){
                self.currentIndex = 0;
            }
            self.noticeLab.frame = CGRectMake(self.noticeLab.frame.origin.x, 36, self.noticeLab.frame.size.width, self.noticeLab.frame.size.height);
        }];
    }else{
        self.noticeLab.text = currentStr;
        
        self.noticeLab.frame = CGRectMake(50, 36, self.noticeLab.frame.size.width, self.noticeLab.frame.size.height);
        
        [UIView animateWithDuration:1.0 animations:^{
            //消失
            self.secNoticeLab.frame = CGRectMake(self.secNoticeLab.frame.origin.x, -36, self.secNoticeLab.frame.size.width, self.secNoticeLab.frame.size.height);
            
            //出现
            self.noticeLab.frame = CGRectMake(50, 0, self.noticeLab.frame.size.width, self.noticeLab.frame.size.height);
                        
        } completion:^(BOOL finished) {
            self.currentIndex++;
            if(self.dataArray.count<=self.currentIndex){
                self.currentIndex = 0;
            }
            self.secNoticeLab.frame = CGRectMake(self.secNoticeLab.frame.origin.x, 36, self.secNoticeLab.frame.size.width, self.secNoticeLab.frame.size.height);
        }];
    }

}

//获取数据
-(void)receiveData{
    [g_server WH_eventlogLatestWithCount:0 toView:self];
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if ([aDownload.action isEqualToString:wh_eventlog_latest]) {//
        self.dataArray = [NSMutableArray arrayWithArray:[WH_JXNoticeModel mj_objectArrayWithKeyValuesArray:array1]];
        [self setLabData];
    }
    
}

#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    
    return WH_show_error;
}
#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    
    return WH_show_error;
}
#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    [_wait start];
}



@end
