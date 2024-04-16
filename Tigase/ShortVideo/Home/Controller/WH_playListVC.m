//
//  WH_playListVC.m
//  Tigase
//
//  Created by 1111 on 2024/4/7.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_playListVC.h"
#import "WH_playListCell.h"


@interface WH_playListVC ()<UITableViewDataSource, UITableViewDelegate> {
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    ATMHud* _wait;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,assign)NSInteger page;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *colectBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *zzView;

@end

@implementation WH_playListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _wait = [ATMHud sharedInstance];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissAction)];
    [self.zzView addGestureRecognizer:tap];

    self.colectBtn.layer.cornerRadius = 24.0f;
    self.bgView.layer.cornerRadius = 8.0f;
    self.dataSource = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_playListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_playListCell"];
    
    self.tableView.rowHeight = 100.0f;
    //设置刷新的头部以及加载
//    [self setTableHeaderAndFotter];
    [self WH_getServerData];
    
}
//设置刷新以及加载
-(void)setTableHeaderAndFotter{
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.tableView;
    __weak WH_playListVC *weakSelf = self;
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
  
    [g_server WH_VideoAllWithId:self.videoId toView:self];
    
}
- (IBAction)coloctAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected){//收藏
        [g_server WH_VideoCollectWithId:self.videoId toView:self];
    }else{//取消收藏
        [g_server WH_VideoCancleCollectWithId:self.videoId toView:self];
    }
    
}

-(void)dissMissAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_playListCell *cell = (WH_playListCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_playListCell" forIndexPath:indexPath];
    if(self.dataSource.count > indexPath.row){
        WH_GKDYVideoModel *model = self.dataSource[indexPath.row];
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail_url]];
        cell.titleLab.text = [NSString stringWithFormat:@"第%@集 | %@",model.index,model.shortName];
        NSInteger min = model.video_duration.integerValue/60.0;
        NSInteger sec = model.video_duration.integerValue%60;
        cell.timeLab.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)min,(long)sec];
        [cell.likeCount setTitle:model.agree_num forState:UIControlStateNormal];
        
        self.titleLab.text = [NSString stringWithFormat:@"短剧·%@【%lu集全】",model.shortName,(unsigned long)self.dataSource.count];

    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataSource.count > indexPath.row){
        WH_GKDYVideoModel *model = self.dataSource[indexPath.row];
        if(self.chooseVideoPlayBlock){
            self.chooseVideoPlayBlock(model);
        }
        [self dissMissAction];
    }
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    [self WH_stopLoading];
    
    if([aDownload.action isEqualToString:wh_series_info]){
        for (int i = 0; i < array1.count; i++) {
            WH_GKDYVideoModel *model = [[WH_GKDYVideoModel alloc] init];
            [model WH_getDataFromDict:array1[i]];
            if([model.msgId isEqualToString:self.videoId]){
                self.colectBtn.selected = model.collect;
            }
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
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
- (void)WH_stopLoading {
    [_footer endRefreshing];
    [_header endRefreshing];
}



@end
