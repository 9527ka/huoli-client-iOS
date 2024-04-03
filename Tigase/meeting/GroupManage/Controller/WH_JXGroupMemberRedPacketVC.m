//
//  WH_JXGroupMemberRedPacketVC.m
//  Tigase
//
//  Created by luan on 2023/6/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupMemberRedPacketVC.h"
#import "WH_JXGroupMemberRedPacketCell.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"
#import "WH_JXGroupMemberEarningVC.h"

@interface WH_JXGroupMemberRedPacketVC ()<UITableViewDataSource, UITableViewDelegate> {
    BOOL isSelectStartDate;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    ATMHud* _wait;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic) UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *dateContentView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIView *timeBgView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic,copy)NSString *startTime;//yyyy-MM-dd HH:mm:ss
@property (nonatomic,copy)NSString *endTime;//yyyy-MM-dd HH:mm:ss
@property (nonatomic,assign)NSInteger type;//优惠券类型：0:全部 1：普通优惠券 2：拼手气优惠券 3:口令优惠券

@property (nonatomic,assign)NSInteger page;

@property (nonatomic, assign) NSInteger selIndex;

@property (weak, nonatomic) IBOutlet UIImageView *nodataImage;
@property (weak, nonatomic) IBOutlet UILabel *nodataLab;

@end

@implementation WH_JXGroupMemberRedPacketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = self.room.category == 1?@"群成员钻石优惠券列表":@"群成员优惠券列表";
    
    [self creatUI];
    
    //设置刷新的头部以及加载
    [self setTableHeaderAndFotter];
    [self WH_getServerData];
    
}
-(void)creatUI{
    self.startDateBtn.layer.cornerRadius = 14.0f;
    self.endDateBtn.layer.cornerRadius = 14.0f;
    
    self.timeBgView.layer.cornerRadius = 10.0f;
    self.timeBgView.layer.borderColor = HEXCOLOR(0xF6D2A0).CGColor;
    self.timeBgView.layer.borderWidth = 0.5f;
    
    self.dataSource = [NSMutableArray array];
    //设置展示样式
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    [self.datePicker setMaximumDate:[NSDate date]];
    self.type = 0;
    self.selectBtn = (UIButton *)[self.view viewWithTag:801];
    self.selectBtn.selected = YES;
    
    //开始时间
    NSString *startTimeStr = [NSString stringWithFormat:@"%@ 00:00:00",[NSDate date].xmppDateString];
    self.startTime = startTimeStr;
    [self.startDateBtn setTitle:[NSDate date].xmppDateString forState:UIControlStateNormal];
    
    //结束时间
    NSString *endTimeStr = [NSString stringWithFormat:@"%@ 23:59:59",[NSDate date].xmppDateString];
    self.endTime = endTimeStr;
    
    [self.endDateBtn setTitle:[NSDate date].xmppDateString forState:UIControlStateNormal];
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXGroupMemberRedPacketCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXGroupMemberRedPacketCell"];
    self.tableView.rowHeight = 100.0f;
}
//设置刷新以及加载
-(void)setTableHeaderAndFotter{
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.tableView;
    __weak WH_JXGroupMemberRedPacketVC *weakSelf = self;
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
    
    [g_server WH_redPacketEarnListIndex:self.page startTime:self.startTime endTime:self.endTime type:self.type roomJId:self.room.roomJid toView:self];
    
//    if (_selIndex == 1) {
//        [g_server WH_redPacketGetRedReceiveListIndex:self.page startTime:self.startTime endTime:self.endTime type:self.type roomJId:self.room.roomJid toView:self];
//    }else {
//        [g_server WH_redPacketGetSendRedPacketListIndex:self.page startTime:self.startTime endTime:self.endTime type:self.type roomJId:self.room.roomJid toView:self];
//    }
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
- (IBAction)memberEarningAction {
    WH_JXGroupMemberEarningVC *vc = [[WH_JXGroupMemberEarningVC alloc] init];
    vc.room = self.room;
    [g_navigation pushViewController:vc animated:YES];
}
//801+
- (IBAction)didTapTypeAction:(UIButton *)sender {
    self.selectBtn.selected = NO;
    self.selectBtn = sender;
    self.selectBtn.selected = YES;
    self.bgImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"group_red_lisBg_%ld",sender.tag - 800]];
    ////优惠券类型：0:全部 1：普通优惠券 2：拼手气优惠券 3:口令优惠券
    NSArray *tagArray = @[@(0),@(2),@(1)];
    NSNumber *chooseType = tagArray[sender.tag - 801];
    self.type = chooseType.integerValue;
    self.page = 0;
    //刷新接口
    [self WH_getServerData];
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
    WH_JXGroupMemberRedPacketCell *cell = (WH_JXGroupMemberRedPacketCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXGroupMemberRedPacketCell" forIndexPath:indexPath];
    if(self.dataSource.count > indexPath.row){
        NSDictionary *dic = self.dataSource[indexPath.row];
        [g_server WH_getHeadImageSmallWIthUserId:[NSString stringWithFormat:@"%@",dic[@"userId"]] userName:[NSString stringWithFormat:@"%@",dic[@"userName"]] imageView:cell.avatarImage];
        
        cell.nicknameLabel.text = [NSString stringWithFormat:@"%@", dic[@"userName"]];
        cell.receiveMoneyLab.text = [NSString stringWithFormat:@"￥%.2f",[NSString stringWithFormat:@"%@",dic[@"receiveAmount"]].doubleValue];
        cell.sendMoneyLab.text = [NSString stringWithFormat:@"￥%.2f",[NSString stringWithFormat:@"%@",dic[@"sendAmount"]].doubleValue];
    }
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
