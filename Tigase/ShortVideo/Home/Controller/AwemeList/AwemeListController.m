//
//  AwemeListController.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <AVKit/AVKit.h>
#import "AwemeListController.h"
#import "AwemeListCell.h"
#import "AVPlayerView.h"
#import "LoadMoreControl.h"
#import "AVPlayerManager.h"
#import "Constants.h"
#import "WH_GKDYVideoModel.h"
#import "WH_playListVC.h"

NSString * const kAwemeListCell   = @"AwemeListCell";

@interface AwemeListController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL                              isCurPlayerPause;
@property (nonatomic, assign) NSInteger                         pageIndex;
@property (nonatomic, assign) NSInteger                         pageSize;
@property (nonatomic, assign) AwemeType                         awemeType;
@property (nonatomic, copy) NSString                            *uid;

@property (nonatomic, strong) NSMutableArray           *data;
@property (nonatomic, strong) NSMutableArray           *awemes;
@property (nonatomic, strong) LoadMoreControl                      *loadMore;
@property(nonatomic,assign)BOOL isEnd;
@property(nonatomic,strong)UIButton *backBtn;

@end

@implementation AwemeListController

-(instancetype)initWithVideoData:(NSMutableArray *)data currentIndex:(NSInteger)currentIndex pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize awemeType:(AwemeType)type uid:(NSString *)uid {
    self = [super init];
    if(self) {
        NSArray *list = [data mutableCopy];
        _data = [NSMutableArray arrayWithArray:list];
        
        _isCurPlayerPause = NO;
        _currentIndex = currentIndex;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
        _type = type;
        _uid = uid;
        
//
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTouchBegin) name:@"StatusBarTouchBeginNotification" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setUpView];
    if(!self.data){
        _isCurPlayerPause = NO;
        _currentIndex = 0;
        _pageIndex = 0;
        _pageSize = 20;
        
        _data = [[NSMutableArray alloc] init];
        //请求数据
        [self receiveListData];
    }else{
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(12, JX_SCREEN_TOP - 44, 32, 44);
        [_backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.backBtn];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTouchBegin) name:@"StatusBarTouchBeginNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    
    
//    [self setBackgroundImage:@"img_video_loading"];
   
//    [self setLeftButton:@"icon_titlebar_whiteback"];
    
    
    
    
}
-(void)receiveListData{
    if(self.type == 0){//推荐
        [g_server receiveRecordList:self];
    }else if (self.type == 1){//短剧
        [g_server WH_receiveSeriesListWithIndex:self.pageIndex type:1 toView:self];
    }else if (self.type == 2){//短视频
        [g_server WH_receiveSeriesListWithIndex:self.pageIndex type:2 toView:self];
    }else if (self.type == 3){//收藏
        [g_server WH_LookMyVideoWithPageIndex:self.pageIndex type:0 toView:self];
    }else if (self.type == 4){//作品
        [g_server WH_LookMyVideoWithPageIndex:self.pageIndex type:1 toView:self];
    }
}

- (void)setUpView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -ScreenHeight, ScreenWidth, ScreenHeight * 5)];
    _tableView.contentInset = UIEdgeInsetsMake(ScreenHeight, 0, ScreenHeight * 3, 0);
    
    _tableView.backgroundColor = ColorClear;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView registerClass:AwemeListCell.class forCellReuseIdentifier:kAwemeListCell];
    
    _loadMore = [[LoadMoreControl alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 50) surplusCount:10];
    __weak __typeof(self) wself = self;
    [_loadMore setOnLoad:^{
        [wself receiveListData];
    }];
    [_tableView addSubview:_loadMore];
    
    [self.view addSubview:self.tableView];
    
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    
}
-(void)goBackAction:(id)sender{
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_tableView.layer removeAllAnimations];
    NSArray<AwemeListCell *> *cells = [_tableView visibleCells];
    for(AwemeListCell *cell in cells) {
        [cell.playerView cancelLoading];
    }
    [[AVPlayerManager shareManager] removeAllPlayers];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self removeObserver:self forKeyPath:@"currentIndex"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //填充视频数据
    AwemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:kAwemeListCell];
    if(self.data.count > indexPath.row){
        WH_GKDYVideoModel *model = [_data objectAtIndex:indexPath.row];
        model.dataType = self.type;
        [cell initData:model scroller:tableView];
    }
   
    __weak typeof (&*self)weakSelf = self;
    cell.lookAllPlayletBlock = ^{
        [weakSelf lookAllPlaerletWithIndex:indexPath];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 列表中是否存在更多数据
    if (!self.isEnd) {
        return;
    }
    if (indexPath.row > self.data.count * 0.8) {//加载数据
        [self receiveListData];
    }
}
#pragma ScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(self.data.count == 0){
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        //UITableView禁止响应其他滑动手势
        scrollView.panGestureRecognizer.enabled = NO;
        
        if(translatedPoint.y < -50 && self.currentIndex < (self.data.count - 1)) {
            self.currentIndex ++;   //向下滑动索引递增
        }
        if(translatedPoint.y > 50 && self.currentIndex > 0) {
            self.currentIndex --;   //向上滑动索引递减
        }
        //检测是否是视频
        if (self.data.count > self.currentIndex) {
            __weak typeof (self) wself = self;
            
            wself.isCurPlayerPause = NO;
            AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
            [cell startDownloadBackgroundTask];
            __weak typeof (cell) wcell = cell;
            
            //判断当前cell的视频源是否已经准备播放
            if(cell.isPlayerReady) {
                //播放视频
                [cell replay];
            }else {
                [[AVPlayerManager shareManager] pauseAll];
                //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
                cell.onPlayerReady = ^{
                    NSIndexPath *indexPath = [wself.tableView indexPathForCell:wcell];
                    if(!wself.isCurPlayerPause && indexPath && indexPath.row == wself.currentIndex) {
                        [wcell play];
                    }
                };
            }
            
        }
        
        
        
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
            //UITableView滑动到指定cell
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        } completion:^(BOOL finished) {
            //UITableView可以响应其他滑动手势
            scrollView.panGestureRecognizer.enabled = YES;
        }];
        
    });
}

#pragma KVO
- (void)statusBarTouchBegin {
    _currentIndex = 0;
}

- (void)applicationBecomeActive {
    AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    if(!_isCurPlayerPause) {
        [cell.playerView play];
    }
}

- (void)applicationEnterBackground {
    AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    _isCurPlayerPause = ![cell.playerView rate];
    [cell.playerView pause];
}

//观察currentIndex变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentIndex"]) {
        //设置用于标记当前视频是否播放的BOOL值为NO
        _isCurPlayerPause = NO;
        //获取当前显示的cell
        AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        __weak typeof (cell) wcell = cell;
        __weak typeof (self) wself = self;
        //标记已经看过 recommended可选参数,默认值为０　１表示来源于推荐中的视频,０表求非推荐中的视频
        [g_server WH_SeriesShortFlipWithId:wcell.aweme.msgId recommended:self.type == 0?1:0 toView:self];
//        [cell startDownloadHighPriorityTask];
        //判断当前cell的视频源是否已经准备播放
        if(cell.isPlayerReady) {
            //播放视频
            [cell replay];
        }else {
            [[AVPlayerManager shareManager] pauseAll];
            //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等带视频准备好后通知播放
            cell.onPlayerReady = ^{
                NSIndexPath *indexPath = [wself.tableView indexPathForCell:wcell];
                if(!wself.isCurPlayerPause && indexPath && indexPath.row == wself.currentIndex) {
//                    //标记已经看过 recommended可选参数,默认值为０　１表示来源于推荐中的视频,０表求非推荐中的视频
//                    [g_server WH_SeriesShortFlipWithId:wcell.aweme.msgId recommended:self.type == 0?1:0 toView:self];
                    [wcell play];
                }
            };
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    self.isEnd = YES;
    //    [_wait hide];
    if([aDownload.action isEqualToString:wh_act_ShortRecommended]){
        for (int i = 0; i < array1.count; i++) {
            WH_GKDYVideoModel *model = [[WH_GKDYVideoModel alloc] init];
            [model WH_getDataFromDict:array1[i]];
            [self.data addObject:model];
        }
        [self.tableView reloadData];
        if(self.data.count == array1.count){
            [self performSelector:@selector(showVideo) withObject:nil afterDelay:1.0];
        }
    }else if ([aDownload.action isEqualToString:wh_act_SeriesList]){
        self.pageIndex ++;
        for (int i = 0; i < array1.count; i++) {
            WH_GKDYVideoModel *model = [[WH_GKDYVideoModel alloc] init];
            [model WH_getDataFromDict:array1[i]];
            [self.data addObject:model];
        }
        [self.tableView reloadData];
        
        if(self.data.count == array1.count){
            [self performSelector:@selector(showVideo) withObject:nil afterDelay:1.0];
        }
    }else if ([aDownload.action isEqualToString:wh_myvideos] || [aDownload.action isEqualToString:wh_mycollects]){
        
        if(self.pageIndex == 1){
            [self.data removeAllObjects];
        }
        
        for (int i = 0; i < array1.count; i++) {
            WH_GKDYVideoModel *model = [[WH_GKDYVideoModel alloc] init];
            [model WH_getDataFromDict:array1[i]];
            [self.data addObject:model];
        }
        self.pageIndex++;
        if(self.data.count == array1.count){
            [self performSelector:@selector(showVideo) withObject:nil afterDelay:1.0];
        }
    }
}
-(void)showVideo{
    self.currentIndex = 0;
}
#pragma mark - 请求失败回调
- (int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    //    [_wait hide];
    self.isEnd = YES;
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    //    [_wait hide];
    self.isEnd = YES;
    return WH_show_error;
}
#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    self.isEnd = NO;
}
//查看所有剧情
-(void)lookAllPlaerletWithIndex:(NSIndexPath *)indexPath{
    if(self.data.count > indexPath.row){
        WH_GKDYVideoModel *currentModel = self.data[indexPath.row];
        WH_playListVC *vc = [[WH_playListVC alloc] init];
        vc.videoId = currentModel.msgId;
        __weak typeof (&*self)weakSelf = self;
        vc.chooseVideoPlayBlock = ^(WH_GKDYVideoModel * _Nonnull model) {
            [weakSelf.data replaceObjectAtIndex:indexPath.row withObject:model];
            [weakSelf.tableView reloadData];
            weakSelf.currentIndex = indexPath.row;
        };
        vc.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

@end
