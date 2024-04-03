//
//  WH_JXGroupRedPacketVC.m
//  Tigase
//
//  Created by luan on 2023/6/7.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupRedPacketVC.h"
#import "WH_JXGroupRedPacketCell.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"
#import "NSString+ContainStr.h"

@interface WH_JXGroupRedPacketVC () <UITableViewDataSource, UITableViewDelegate> {
    BOOL isSelectStartDate;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    ATMHud* _wait;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeight;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (nonatomic,assign)NSInteger page;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation WH_JXGroupRedPacketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _wait = [ATMHud sharedInstance];
    //券类型：0:全部 1：普通券 2：拼手气券 3:口令券
    if(self.type == 0){
        self.titleLab.text = @"全部券";
    }else if (self.type == 1){
        self.titleLab.text = @"专属券";
    }else if (self.type == 2){
        self.titleLab.text = @"手气券";
    }
    
    
    self.dataSource = [NSMutableArray array];
   
    
    self.navHeight.constant = JX_SCREEN_TOP;
    self.avatarImage.layer.cornerRadius = 22;
    
    
    self.nickNameLabel.text = g_myself.userNickname;//
    [g_server WH_getHeadImageSmallWIthUserId:g_myself.userId userName:g_myself.userNickname imageView:self.avatarImage];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXGroupRedPacketCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXGroupRedPacketCell"];
    
    
    //设置刷新的头部以及加载
    [self setTableHeaderAndFotter];
    [self WH_getServerData];
    
    
    //渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xFFF6E8).CGColor, (__bridge id)HEXCOLOR(0xFFFFFF).CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT - 150);
    [self.view.layer addSublayer:gradientLayer];
    
    [self.view bringSubviewToFront:self.bgView];
    [self.view bringSubviewToFront:self.titleLab];
    [self.view bringSubviewToFront:self.avatarImage];
    [self.view bringSubviewToFront:self.numberLabel];
    [self.view bringSubviewToFront:self.moneyLabel];
    [self.view bringSubviewToFront:self.backBtn];
    [self.view bringSubviewToFront:self.nickNameLabel];
    
    
    
}
//设置刷新以及加载
-(void)setTableHeaderAndFotter{
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.tableView;
    __weak WH_JXGroupRedPacketVC *weakSelf = self;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        weakSelf.page ++;
        [weakSelf WH_getServerData];
        //        //NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self.tableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        weakSelf.page = 0;
        // 进入刷新状态就会回调这个Block
        [weakSelf WH_getServerData];
    };
}
- (void) WH_getServerData {
    
    [g_server WH_redPacketGetAndSendRedReceiveListIndex:_selIndex startTime:self.startTime endTime:self.endTime type:self.type roomJId:self.room.roomJid pageIndex:self.page toView:self];
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

// MARK: -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXGroupRedPacketCell *cell = (WH_JXGroupRedPacketCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXGroupRedPacketCell" forIndexPath:indexPath];
    if(self.dataSource.count > indexPath.row){
        NSDictionary *dic = self.dataSource[indexPath.row];
        
        //券类型 1.普通券   2.拼手气   3.口令
        NSString *type = self.room.category == 1?@"专属钻石":@"专属券";
        NSNumber *redType = [NSNumber numberWithInteger:[NSString stringWithFormat:@"%@",self.selIndex == 1?dic[@"redPacketType"]:dic[@"type"]].integerValue];
        if(redType.intValue == 2){
            type = self.room.category == 1?@"手气钻石":@"手气券";
        }else if (redType.intValue == 3){
            type = self.room.category == 1?@"口令钻石":@"口令券";
        }
        cell.typeLabel.text = type;
        
        
        NSString *time = [NSString stringWithFormat:@"%@",self.selIndex > 0?dic[@"time"]:dic[@"sendTime"]];
        //时间
        cell.timeLabel.text = [self getTimeFrom:time.doubleValue];
        
        //抢到的券金额
        NSString *monyStr = [NSString stringWithFormat:@"￥%@",self.selIndex > 0?dic[@"money"]:dic[@"money"]];
        
        cell.moneyLabel.attributedText = [NSString changeSpecialWordColor:HEXCOLOR(0xFF5150) AllContent:monyStr SpcWord:@"￥" font:12];
        
        NSString *receiveCount = [NSString stringWithFormat:@"%@",dic[@"receiveCount"]];//已领个数
        NSString *count = [NSString stringWithFormat:@"%@",dic[@"count"]];//券个数
        
        cell.stateLabel.text = self.selIndex > 0?@"":[NSString stringWithFormat:@"已领%@/%@",receiveCount,count];
        
    }
    return cell;
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
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    [self WH_stopLoading];
    NSArray *array = dict[@"data"];
    
    if (self.page == 0) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:array];
        
        //开始时间
        NSString *startTimeStr = [self.startTime componentsSeparatedByString:@" "].firstObject;
        //结束时间
        NSString *endTimeStr = [self.endTime componentsSeparatedByString:@" "].firstObject;;
    //2024-03-01至2024-03-12共发出2个券
        
        NSString *countStr = [NSString stringWithFormat:@"%@至%@共%@%@个券",startTimeStr,endTimeStr,self.selIndex == 0?@"发出":@"抢到",dict[@"total"]];
        NSString *total = [NSString stringWithFormat:@"%@个券",dict[@"total"]];
        
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:countStr];
        
        [contentStr addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xFF5150)  range:NSMakeRange(countStr.length - total.length , total.length - 3)];
        
        //修改特定字符的字体大小
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(countStr.length - total.length , total.length - 3)];
        
        //券个数
        self.numberLabel.attributedText = contentStr;
        
        //金额
        NSString *moneyStr = [NSString stringWithFormat:@"￥%.2f",[NSString stringWithFormat:@"%@",dict[@"extraData"][@"totalMoney"]].doubleValue];
        self.moneyLabel.attributedText = [NSString changeSpecialWordColor:HEXCOLOR(0xFF5150) AllContent:moneyStr SpcWord:@"￥" font:12];
        
//        self.nodataImage.hidden = self.nodataLab.hidden = array1.count > 0?YES:NO;
    }else {
        [self.dataSource addObjectsFromArray:array];
    }
    
    [self.tableView reloadData];
}
#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    [self WH_stopLoading];
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    [self WH_stopLoading];
    return WH_show_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    [_wait start];
}
- (void)WH_stopLoading {
    [_footer endRefreshing];
    [_header endRefreshing];
}

@end
