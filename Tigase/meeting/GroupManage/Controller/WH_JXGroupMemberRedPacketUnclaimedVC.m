//
//  WH_JXGroupMemberRedPacketUnclaimedVC.m
//  Tigase
//
//  Created by luan on 2023/6/11.
//  Copyright © 2023 Reese. All rights reserved.
//长时间未领取红包列表

#import "WH_JXGroupMemberRedPacketUnclaimedVC.h"
#import "WH_JXGroupMemberRedPacketUnclaimedCell.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"

@interface WH_JXGroupMemberRedPacketUnclaimedVC () <UITableViewDataSource, UITableViewDelegate>{
    BOOL _isLoading;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    ATMHud* _wait;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;

@end

@implementation WH_JXGroupMemberRedPacketUnclaimedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    _wait = [ATMHud sharedInstance];
    _isLoading = YES;
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXGroupMemberRedPacketUnclaimedCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXGroupMemberRedPacketUnclaimedCell"];
    //设置刷新的头部以及加载
    [self setTableHeaderAndFotter];
    //数据请求、
    [self receiveRedReceiveListData];
}
//设置刷新以及加载
-(void)setTableHeaderAndFotter{
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.tableView;
    __weak WH_JXGroupMemberRedPacketUnclaimedVC *weakSelf = self;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        weakSelf.page ++;
        [weakSelf receiveRedReceiveListData];
//        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self.tableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        weakSelf.page = 1;
        // 进入刷新状态就会回调这个Block
        [weakSelf receiveRedReceiveListData];
    };
    
}
//数据请求
-(void)receiveRedReceiveListData{
    [g_server WH_redListPageIndex:self.page roomId:self.room.roomId toView:self];
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    [self WH_stopLoading];
    
    if (_page == 0) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array1];
    }else {
        [self.dataArray addObjectsFromArray:array1];
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
    _isLoading = NO;
    [_footer endRefreshing];
    [_header endRefreshing];
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXGroupMemberRedPacketUnclaimedCell *cell = (WH_JXGroupMemberRedPacketUnclaimedCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXGroupMemberRedPacketUnclaimedCell" forIndexPath:indexPath];
    [g_server WH_getHeadImageSmallWIthUserId:g_myself.userId userName:g_myself.userNickname imageView:cell.avatarImage];
    return cell;
}

@end
