//
//  WH_JXBuyAndPayListVC.m
//  Tigase
//
//  Created by 1111 on 2024/1/2.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXBuyAndPayListVC.h"
#import "WH_JXBuyAndPayListCell.h"
#import "WH_GroupRechargeViewController.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"
#import "WH_JXBuyAndPayListModel.h"
#import "WH_GroupAccountSetViewController.h"
#import "WH_AddAccountViewController.h"
#import "WH_JXAgentVC.h"
#import "WH_JXAgentManagerVC.h"

@interface WH_JXBuyAndPayListVC ()<UITableViewDataSource, UITableViewDelegate> {
    ATMHud* _wait;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@property (nonatomic,assign)NSInteger page;

@property (weak, nonatomic) IBOutlet UIImageView *nodataImage;
@property (weak, nonatomic) IBOutlet UILabel *nodataLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *accountList;

@property(nonatomic,assign)NSInteger tag;
@property (weak, nonatomic) IBOutlet UIButton *managerBtn;

@end

@implementation WH_JXBuyAndPayListVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   //查询当前用户是否设置收款方式
    [self receiveUserCode];
    
    [self WH_getServerData];
    
    [self.managerBtn setBackgroundImage:[UIImage imageNamed:g_myself.merchant.boolValue?@"agent_add":@"agent_add_icon"] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _wait = [ATMHud sharedInstance];
    self.dataSource = [NSMutableArray array];
    self.page = 0;
//    self.addBtn.layer.cornerRadius = 37.5f;
    self.tableView.rowHeight = 120.0f;
    self.tag = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXBuyAndPayListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXBuyAndPayListCell"];
    //设置刷新的头部以及加载
    [self setTableHeaderAndFotter];
    
}
//设置刷新以及加载
-(void)setTableHeaderAndFotter{
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.tableView;
    __weak WH_JXBuyAndPayListVC *weakSelf = self;
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
//成为代理商
- (IBAction)addAction:(id)sender {
    
    if(g_myself.merchant.boolValue){
        
        WH_JXAgentManagerVC *vc = [[WH_JXAgentManagerVC alloc] init];
        [g_navigation pushViewController:vc animated:YES];
    }else{
        WH_JXAgentVC *vc = [[WH_JXAgentVC alloc] init];
        [g_navigation pushViewController:vc animated:YES];
    }
    
}
-(void)receiveUserCode{
    [g_server WH_UserAccount:self];
}
- (IBAction)myAccountAction:(id)sender {
    
    WH_GroupAccountSetViewController *vc = [[WH_GroupAccountSetViewController alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}
- (void) WH_getServerData {
    
    [g_server WH_MerchantWithTag:self.tag pageIndex:self.page toView:self];
}
- (IBAction)didTapSegmented:(UISegmentedControl *)sender {
    self.page = 0;
    self.tag = sender.selectedSegmentIndex;
    if(sender.selectedSegmentIndex == 0){//未完成
//        self.statue = @"0,1,3";
    }else if (sender.selectedSegmentIndex == 1){//已完成
//        self.statue = @"4,5";
    }
    [self WH_getServerData];
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
// MARK: -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXBuyAndPayListCell *cell = (WH_JXBuyAndPayListCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXBuyAndPayListCell" forIndexPath:indexPath];
    
    cell.buyBtn.backgroundColor = self.tag == 0?HEXCOLOR(0x23B525):HEXCOLOR(0xFF0000);
    [cell.buyBtn setTitle:self.tag == 0?@"购买":@"出售" forState:UIControlStateNormal];
    
    if(self.dataSource.count > indexPath.row){
        WH_JXBuyAndPayListModel *model = self.dataSource[indexPath.row];
        model.isBuy = self.tag == 0?YES:NO;
        cell.model = model;
        cell.orderCountLab.text = [NSString stringWithFormat:@"成交量：%@",self.tag == 0?model.buyVolume:model.sellVolume];
        //营业时间
        cell.timeLab.text = model.flag.boolValue?[NSString stringWithFormat:@"营业时间：%@-%@",model.startHour,model.endHour]:@"营业时间：休息中";
        if(!model.open.boolValue){
            cell.buyBtn.backgroundColor = [UIColor grayColor];
        }
        
    }
   
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataSource.count > indexPath.row){
        WH_JXBuyAndPayListModel *model = self.dataSource[indexPath.row];
        if(!model.open.boolValue){
            [g_server showMsg:@"商家休息中"];
            return;
        }
        
        if(self.tag == 1 &&  self.accountList.count == 0){
            [g_server showMsg:@"请设置您的收款账号！"];
            
            WH_AddAccountViewController *vc = [[WH_AddAccountViewController alloc] init];
            vc.type = 1;
            [g_navigation pushViewController:vc animated:YES];
            
        }else{
            if(self.tag == 1){//设置收款账号
                model.financialInfos = self.accountList;
            }
            model.isBuy = self.tag == 0?YES:NO;
            
            WH_GroupRechargeViewController *vc = [[WH_GroupRechargeViewController alloc] init];
            vc.model = model;
            [g_navigation pushViewController:vc animated:YES];
        }
    }
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    [self WH_stopLoading];
    
    if([aDownload.action isEqualToString:wh_order_merchant_List]){
        if (self.page == 0) {
            [self.dataSource removeAllObjects];
           
            self.nodataImage.hidden = self.nodataLab.hidden = array1.count > 0?YES:NO;
        }
        NSArray *list = [WH_JXBuyAndPayListModel mj_objectArrayWithKeyValuesArray:array1];
        [self.dataSource addObjectsFromArray:list];
        
        [self.tableView reloadData];
    }else if ([aDownload.action isEqualToString:wh_user_account]){//我的收款账号
        self.accountList = [WH_FinancialInfosModel mj_objectArrayWithKeyValuesArray:array1];
    }
    
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
