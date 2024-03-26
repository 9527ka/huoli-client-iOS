//
//  WH_JXGroundEnterAndOutVC.m
//  Tigase
//
//  Created by luan on 2023/7/8.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupEnterAndOutVC.h"
#import "WH_JXGroupEnterAndOutCell.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"

@interface WH_JXGroupEnterAndOutVC () <UITableViewDataSource, UITableViewDelegate>{
    BOOL isSelectStartDate;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    ATMHud* _wait;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *operatorLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign)NSInteger page;

@property (nonatomic, assign) NSInteger selIndex;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UILabel *nodataLab;
@property (weak, nonatomic) IBOutlet UIImageView *nodataImage;
@property (weak, nonatomic) IBOutlet UIButton *comBtn;
@property (weak, nonatomic) IBOutlet UIButton *goBtn;

@property (nonatomic,strong)UIButton *selectBtn;

@end

@implementation WH_JXGroupEnterAndOutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXGroupEnterAndOutCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXGroupEnterAndOutCell"];
    
    self.comBtn.layer.cornerRadius = 17.0f;
    self.goBtn.layer.cornerRadius = 17.0f;
    [self.comBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.goBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    self.selectBtn = self.comBtn;
    self.selectBtn.selected = YES;
    self.selectBtn.backgroundColor = HEXCOLOR(0x2BAF67);
    
    self.tableView.rowHeight = 97.0f;
    
    //渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xE8FFF2).CGColor, (__bridge id)HEXCOLOR(0xFFFFFF).CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, JX_SCREEN_TOP + 100, JX_SCREEN_WIDTH, 380);
    [self.view.layer addSublayer:gradientLayer];
    
    [self.view bringSubviewToFront:self.tableView];
    
    [self setTableHeaderAndFotter];
    
    self.page = 0;
    [self WH_getServerData];
}
//设置刷新以及加载
-(void)setTableHeaderAndFotter{
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.tableView;
    __weak WH_JXGroupEnterAndOutVC *weakSelf = self;
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
    
    [g_server WH_OutListPageIndex:self.page roomId:self.room.roomJid selectIndex:self.selIndex toView:self];
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

- (IBAction)didTapTypeAction:(UIButton *)sender {
    self.selectBtn.selected = NO;
    self.selectBtn.backgroundColor = [UIColor whiteColor];
    
    self.selectBtn = self.goBtn;
    self.selectBtn.selected = YES;
    self.selectBtn.backgroundColor = HEXCOLOR(0x2BAF67);
    
    self.memberLabel.text = @"出群人";
    self.timeLabel.text = @"操作时间";
    self.operatorLabel.text = @"执行人";
    self.page = 0;
    self.selIndex = 1;

    [self WH_getServerData];
}
- (IBAction)comAction:(id)sender {
    
    self.selectBtn.selected = NO;
    self.selectBtn.backgroundColor = [UIColor whiteColor];
    
    self.selectBtn = self.comBtn;
    self.selectBtn.selected = YES;
    self.selectBtn.backgroundColor = HEXCOLOR(0x2BAF67);
    
    self.memberLabel.text = @"被邀请人";
    self.timeLabel.text = @"邀请时间";
    self.operatorLabel.text = @"邀请人";
    self.page = 0;
    self.selIndex = 0;

    [self WH_getServerData];
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXGroupEnterAndOutCell *cell = (WH_JXGroupEnterAndOutCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXGroupEnterAndOutCell" forIndexPath:indexPath];
    
    if(self.dataSource.count > indexPath.row){
        NSDictionary *dic = self.dataSource[indexPath.row];
        //被操作人
        WH_JXUserObject *userMember = [[WH_JXUserObject sharedUserInstance] getUserById:[dic objectForKey:@"userId"]];
        //操作人
        WH_JXUserObject *member = [[WH_JXUserObject sharedUserInstance] getUserById:[dic objectForKey:@"referenceUserId"]];
        
        cell.memberLabel.text = [NSString stringWithFormat:@"%@",userMember.userNickname.length > 0?userMember.userNickname:[dic objectForKey:@"userNickname"]];//@"张三张三张\n123"
        
        NSString *time = [NSString stringWithFormat:@"%@",dic[@"eventTime"]];
        
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:time.doubleValue/1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];//中国专用
        cell.timeLabel.text = [dateFormatter stringFromDate:date];
        
//        cell.operatorLabel.text = [NSString stringWithFormat:@"%@",member.userNickname];
        cell.operatorLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"referenceData"]];
        
        UIImage *placeholderImage = [UIImage imageNamed:@"avatar_normal"];
        
        cell.operatorImage.image = placeholderImage;
        cell.memberImage.image = placeholderImage;
        
        [g_server WH_getHeadImageSmallWIthUserId:member.userId userName:member.userNickname imageView:cell.operatorImage];
        
        [g_server WH_getHeadImageSmallWIthUserId:userMember.userId userName:userMember.userNickname imageView:cell.memberImage];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    [self WH_stopLoading];
    
    if (self.page == 0) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:array1];
        
        self.nodataLab.hidden = self.nodataImage.hidden = array1.count > 0?YES:NO;
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
