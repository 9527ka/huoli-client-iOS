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

@interface WH_JXGroupRedPacketVC () <UITableViewDataSource, UITableViewDelegate> {
    BOOL isSelectStartDate;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    ATMHud* _wait;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeight;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIView *dateContentView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic,copy)NSString *startTime;//yyyy-MM-dd HH:mm:ss
@property (nonatomic,copy)NSString *endTime;//yyyy-MM-dd HH:mm:ss
@property (nonatomic,assign)NSInteger type;//红包类型：0:全部 1：普通红包 2：拼手气红包 3:口令红包

@property (nonatomic,assign)NSInteger page;

@property (nonatomic, assign) NSInteger selIndex;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation WH_JXGroupRedPacketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = self.room.category == 1?@"群钻石红包":@"群红包";
    [self.segmentedControl setTitle:self.room.category == 1?@"发出的钻石":@"发出的红包" forSegmentAtIndex:0];
    [self.segmentedControl setTitle:self.room.category == 1?@"抢到的钻石":@"抢到的红包" forSegmentAtIndex:1];
    self.dataSource = [NSMutableArray array];
    //设置展示样式
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    self.navHeight.constant = JX_SCREEN_TOP;
    self.avatarImage.layer.cornerRadius = 4;
    
    [self.datePicker setMaximumDate:[NSDate date]];
    [self.startDateBtn setTitle:[NSDate date].xmppDateString forState:UIControlStateNormal];
    [self.endDateBtn setTitle:[NSDate date].xmppDateString forState:UIControlStateNormal];
    
    self.nickNameLabel.text = g_myself.userNickname;
    [g_server WH_getHeadImageSmallWIthUserId:g_myself.userId userName:g_myself.userNickname imageView:self.avatarImage];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXGroupRedPacketCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXGroupRedPacketCell"];
    
    self.type = 0;
    //开始时间
    NSString *startTimeStr = [NSString stringWithFormat:@"%@ 00:00:00",[NSDate date].xmppDateString];
    self.startTime = startTimeStr;
    
    //结束时间
    NSString *endTimeStr = [NSString stringWithFormat:@"%@ 23:59:59",[NSDate date].xmppDateString];
    self.endTime = endTimeStr;
    
    //设置刷新的头部以及加载
    [self setTableHeaderAndFotter];
    [self WH_getServerData];
    
    
    
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
- (IBAction)didTapSegmented:(UISegmentedControl *)sender {
    self.page = 0;
    self.selIndex = sender.selectedSegmentIndex;

    [self WH_getServerData];
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

- (IBAction)didTapType {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *typeArray = @[@"全部", self.room.category == 1?@"手气钻石":@"手气红包", self.room.category == 1?@"口令钻石":@"口令红包", self.room.category == 1?@"专属钻石":@"专属红包"];
    ////红包类型：0:全部 1：普通红包 2：拼手气红包 3:口令红包
    NSArray *tagArray = @[@(0),@(2),@(3),@(1)];
    
    for (int i = 0; i < typeArray.count; i++) {
        NSString *type = typeArray[i];
        NSNumber *chooseType = tagArray[i];
        [actionSheet addAction:[UIAlertAction actionWithTitle:type style:[type isEqualToString:self.typeBtn.currentTitle] ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.typeBtn setTitle:type forState:UIControlStateNormal];
            self.type = chooseType.integerValue;
            self.page = 0;
            //刷新接口
            [self WH_getServerData];
        }]];
    }
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:actionSheet animated:YES completion:NULL];
}

- (IBAction)didTapStartDate {
    isSelectStartDate = YES;
    [self.datePicker setDate:[NSDate dateWithXmppDateString:self.startDateBtn.currentTitle]];
    self.dateContentView.hidden = NO;
}

- (IBAction)didTapEndDate {
    isSelectStartDate = NO;
    [self.datePicker setDate:[NSDate dateWithXmppDateString:self.endDateBtn.currentTitle]];
    self.dateContentView.hidden = NO;
}

- (IBAction)didTapCancelDate:(id)sender {
    self.dateContentView.hidden = YES;
}

- (IBAction)didTapConfirmDate:(id)sender {
    if (isSelectStartDate) {
        if ([self.datePicker.date timeIntervalSinceDate:[NSDate dateWithXmppDateHHMMString:self.endDateBtn.currentTitle]] > 0) {
            [GKMessageTool showError:@"开始时间不能比结束时间大"];
            return;
        }
        [self.startDateBtn setTitle:self.datePicker.date.xmppDateString forState:UIControlStateNormal];
        self.startTime = [NSString stringWithFormat:@"%@:00",self.datePicker.date.xmppDateSSString];
        
    } else {
        if ([self.datePicker.date timeIntervalSinceDate:[NSDate dateWithXmppDateHHMMString:self.startDateBtn.currentTitle]] < 0) {
            [GKMessageTool showError:@"结束时间不能比开始时间小"];
            return;
        }
        [self.endDateBtn setTitle:self.datePicker.date.xmppDateString forState:UIControlStateNormal];
        self.endTime = [NSString stringWithFormat:@"%@:00",self.datePicker.date.xmppDateSSString];
    }
    self.dateContentView.hidden = YES;
    self.page = 0;
    [self WH_getServerData];
}

// MARK: -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXGroupRedPacketCell *cell = (WH_JXGroupRedPacketCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXGroupRedPacketCell" forIndexPath:indexPath];
    if(self.dataSource.count > indexPath.row){
        NSDictionary *dic = self.dataSource[indexPath.row];
        
        //红包类型 1.普通红包   2.拼手气   3.口令
        NSString *type = self.room.category == 1?@"专属钻石":@"专属红包";
        NSNumber *redType = [NSNumber numberWithInteger:[NSString stringWithFormat:@"%@",dic[@"type"]].integerValue];
        if(redType.intValue == 2){
            type = self.room.category == 1?@"手气钻石":@"手气红包";
        }else if (redType.intValue == 3){
            type = self.room.category == 1?@"口令钻石":@"口令红包";
        }
        cell.typeLabel.text = type;
        
        
        NSString *time = [NSString stringWithFormat:@"%@",self.selIndex > 0?dic[@"time"]:dic[@"sendTime"]];
        //时间
        cell.timeLabel.text = [self getTimeFrom:time.doubleValue];
        
        //抢到的红包金额
        NSString *monyStr = [NSString stringWithFormat:@"%@",self.selIndex > 0?dic[@"money"]:dic[@"money"]];
        
        cell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f%@",monyStr.doubleValue,self.room.category == 1?@"钻石":@"HOTC"];
        
        NSString *receiveCount = [NSString stringWithFormat:@"%@",dic[@"receiveCount"]];//已领个数
        NSString *count = [NSString stringWithFormat:@"%@",dic[@"count"]];//红包个数
        
        
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
        //红包个数
        self.numberLabel.text = [NSString stringWithFormat:@"共%@个%@红包",dict[@"total"],self.room.category == 1?@"钻石":@""];
        //金额
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f%@",[NSString stringWithFormat:@"%@",dict[@"extraData"][@"totalMoney"]].doubleValue,self.room.category == 1?@"钻石":@"HOTC"];
        
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
