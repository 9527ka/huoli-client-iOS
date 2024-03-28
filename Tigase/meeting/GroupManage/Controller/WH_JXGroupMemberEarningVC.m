//
//  WH_JXGroupMemberEarningVC.m
//  Tigase
//
//  Created by 1111 on 2024/2/27.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXGroupMemberEarningVC.h"
#import "WH_JXGroupMemberEarningCell.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"

@interface WH_JXGroupMemberEarningVC ()<UITableViewDataSource, UITableViewDelegate> {
    BOOL isSelectStartDate;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    ATMHud* _wait;
}
@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *dateContentView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic,copy)NSString *startTime;//yyyy-MM-dd HH:mm:ss
@property (nonatomic,copy)NSString *endTime;//yyyy-MM-dd HH:mm:ss

@property (nonatomic,assign)NSInteger page;

@property (weak, nonatomic) IBOutlet UIImageView *nodataImage;
@property (weak, nonatomic) IBOutlet UILabel *nodataLab;

@end

@implementation WH_JXGroupMemberEarningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.startDateBtn.layer.cornerRadius = self.endDateBtn.layer.cornerRadius = 14.0f;
    
    self.dataSource = [NSMutableArray array];
    //设置展示样式
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    [self.datePicker setMaximumDate:[NSDate date]];
    //开始时间
    NSString *startTimeStr = [NSString stringWithFormat:@"%@ 00:00:00",[NSDate date].xmppDateString];
    self.startTime = startTimeStr;
    [self.startDateBtn setTitle:[NSDate date].xmppDateString forState:UIControlStateNormal];
    
    //结束时间
    NSString *endTimeStr = [NSString stringWithFormat:@"%@ 23:59:59",[NSDate date].xmppDateString];
    self.endTime = endTimeStr;
    
    [self.endDateBtn setTitle:[NSDate date].xmppDateString forState:UIControlStateNormal];
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXGroupMemberEarningCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXGroupMemberEarningCell"];
    
    
    
    //渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xFFF6E8).CGColor, (__bridge id)HEXCOLOR(0xFFFFFF).CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, JX_SCREEN_TOP + 60, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
    [self.view.layer addSublayer:gradientLayer];
    
    [self.view bringSubviewToFront:self.tableView];
    [self.view bringSubviewToFront:self.dateContentView];
    
    self.tableView.rowHeight = 125.0f;
    
    //设置刷新的头部以及加载
    [self setTableHeaderAndFotter];
    [self WH_getServerData];
    
}
//设置刷新以及加载
-(void)setTableHeaderAndFotter{
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.tableView;
    __weak WH_JXGroupMemberEarningVC *weakSelf = self;
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
  
    [g_server WH_redPacketEarnListIndex:self.page startTime:self.startTime endTime:self.endTime type:0 roomJId:self.room.roomJid toView:self];
    
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
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
        if ([self.datePicker.date timeIntervalSinceDate:[NSDate dateWithXmppDateString:self.endDateBtn.currentTitle]] > 0) {
            [GKMessageTool showError:@"开始时间不能比结束时间大"];
            return;
        }
        [self.startDateBtn setTitle:self.datePicker.date.xmppDateString forState:UIControlStateNormal];
        
        self.startTime = [NSString stringWithFormat:@"%@:00",self.datePicker.date.xmppDateSSString];
        
    } else {
        if ([self.datePicker.date timeIntervalSinceDate:[NSDate dateWithXmppDateString:self.startDateBtn.currentTitle]] < 0) {
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

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXGroupMemberEarningCell *cell = (WH_JXGroupMemberEarningCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXGroupMemberEarningCell" forIndexPath:indexPath];
    if(self.dataSource.count > indexPath.row){
        NSDictionary *dic = self.dataSource[indexPath.row];
        [g_server WH_getHeadImageSmallWIthUserId:[NSString stringWithFormat:@"%@",dic[@"userId"]] userName:[NSString stringWithFormat:@"%@",dic[@"userName"]] imageView:cell.avatarImage];
        
        cell.nicknameLabel.text = [NSString stringWithFormat:@"%@", dic[@"userName"]];
        
        cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f%@",[NSString stringWithFormat:@"%@",dic[@"diff"]].doubleValue,self.room.category == 1?@"钻石":@""];
        cell.receiveLab.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",dic[@"receiveAmount"]].doubleValue];
        cell.sendLab.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",dic[@"sendAmount"]].doubleValue];
//        cell.hotcIcon.hidden = self.room.category == 1?YES:NO;
//        cell.moneyRightConstaint.constant = self.room.category == 1?15.0f:38.0f;
    }

//    if (indexPath.row < 3) {
//        cell.medalIcon.hidden = NO;
//        cell.medalIcon.image = [UIImage imageNamed:@[@"gold_medal", @"silver_medal", @"bronze_medal"][indexPath.row]];
//        cell.numberLabel.text = @"";
//    } else {
//        cell.medalIcon.hidden = YES;
//        cell.numberLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
//    }
    return cell;
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    [self WH_stopLoading];
    
    if (self.page == 0) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:array1];
        
        self.nodataImage.hidden = self.nodataLab.hidden = array1.count > 0?YES:NO;
    }else {
        [self.dataSource addObjectsFromArray:array1];
    }
    
    [self.tableView reloadData];
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
- (void)WH_stopLoading {
    [_footer endRefreshing];
    [_header endRefreshing];
}

@end
