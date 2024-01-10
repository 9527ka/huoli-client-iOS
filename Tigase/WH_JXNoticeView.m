//
//  WH_JXNoticeView.m
//  Tigase
//
//  Created by 1111 on 2024/1/9.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXNoticeView.h"

@interface WH_JXNoticeView()

@property(nonatomic,strong)NSArray *dataArray;

@property(nonatomic,strong)UILabel *noticeLab;
@property(nonatomic,strong)UILabel *secNoticeLab;
@property(nonatomic,assign)NSInteger currentIndex;

@end

@implementation WH_JXNoticeView

-(instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, frame.size.width - 24, frame.size.height)];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 8.0f;
        bgView.layer.borderColor = HEXCOLOR(0x179cfb).CGColor;
        bgView.layer.borderWidth = 1.0f;
        [self addSubview:bgView];
        
        UIImageView *noticeImagw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notice_icon"]];
        noticeImagw.frame = CGRectMake(10, 10, 20, 20);
        [bgView addSubview:noticeImagw];
        
        
        if(dataArr.count > 0){
            self.currentIndex =dataArr.count > 1?1:0;
            self.dataArray = dataArr;
            [self creatUI];
        }else{
            self.hidden = YES;
            self.frame = CGRectMake(0, 0, 0, 0);
        }
        
    }
    return self;
    
}
-(void)creatUI{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, JX_SCREEN_WIDTH - 24, self.frame.size.height)];
    label.textColor = HEXCOLOR(0x179cfb);
    label.text = [NSString stringWithFormat:@"%@",self.dataArray.firstObject];
    label.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:label];
    self.noticeLab = label;
    
    _secNoticeLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 40, JX_SCREEN_WIDTH - 24, self.frame.size.height)];
    _secNoticeLab.textColor = HEXCOLOR(0x179cfb);
    _secNoticeLab.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:self.secNoticeLab];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(moveLabel:) userInfo:nil repeats:YES];
    
}
//移动UILabel的位置
- (void)moveLabel:(NSTimer *)timer {
    NSString *currentStr = self.dataArray[self.currentIndex];
    
    CGFloat y = self.noticeLab.frame.origin.y;
    
    if(y==0){//当前是这个
        
        self.secNoticeLab.text = currentStr;
        
        self.secNoticeLab.frame = CGRectMake(50, 40, self.secNoticeLab.frame.size.width, self.secNoticeLab.frame.size.height);
        
        [UIView animateWithDuration:1.0 animations:^{
            //消失
            self.noticeLab.frame = CGRectMake(self.noticeLab.frame.origin.x, -40, self.noticeLab.frame.size.width, self.noticeLab.frame.size.height);
            
            //出现
            self.secNoticeLab.frame = CGRectMake(50, 0, self.secNoticeLab.frame.size.width, self.secNoticeLab.frame.size.height);
            
        } completion:^(BOOL finished) {
            self.currentIndex++;
            if(self.dataArray.count<=self.currentIndex){
                self.currentIndex = 0;
            }
            self.noticeLab.frame = CGRectMake(self.noticeLab.frame.origin.x, 40, self.noticeLab.frame.size.width, self.noticeLab.frame.size.height);
        }];
    }else{
        self.noticeLab.text = currentStr;
        
        self.noticeLab.frame = CGRectMake(50, 40, self.noticeLab.frame.size.width, self.noticeLab.frame.size.height);
        
        [UIView animateWithDuration:1.0 animations:^{
            //消失
            self.secNoticeLab.frame = CGRectMake(self.secNoticeLab.frame.origin.x, -40, self.secNoticeLab.frame.size.width, self.secNoticeLab.frame.size.height);
            
            //出现
            self.noticeLab.frame = CGRectMake(50, 0, self.noticeLab.frame.size.width, self.noticeLab.frame.size.height);
                        
        } completion:^(BOOL finished) {
            self.currentIndex++;
            if(self.dataArray.count<=self.currentIndex){
                self.currentIndex = 0;
            }
            self.secNoticeLab.frame = CGRectMake(self.secNoticeLab.frame.origin.x, 40, self.secNoticeLab.frame.size.width, self.secNoticeLab.frame.size.height);
        }];
    }

}


@end
