//
//  WH_Player_WHVC.m
//  Tigase
//
//  Created by 1111 on 2024/3/22.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_Player_WHVC.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "JX_WHVideoPlayCell.h"
#import "MJRefresh.h"
#import "WH_GKDYVideoModel.h"

@interface WH_Player_WHVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZFTableViewCellDelegate>

@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) ZFPlayerController *player;
@property(nonatomic,assign)NSInteger pageIndex;
@property(nonatomic,strong)NSIndexPath *currentIndex;//要删除的cell
@property(nonatomic,strong)JX_WHVideoPlayCell *currentCell;

@end

@implementation WH_Player_WHVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

   self.player.viewControllerDisappear = YES;
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @zf_weakify(self)
    [self.player zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @zf_strongify(self)
        [self playTheVideoAtIndexPath:indexPath];
    }];
}
// 控制器生命周期方法(view加载完成)
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.gk_navigationBar.hidden = YES;
    self.gk_statusBarHidden = YES;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //设置video数据
    [self receiveVideoData];
    //请求数据
    [self receiveListData];
}
-(void)receiveListData{
    [g_server WH_circleMsgPureVideoPageIndex:self.pageIndex lable:nil toView:self];
}
/// *设置视频数据
-(void)receiveVideoData{
    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
//    playerManager.muted = YES;//静音播放
    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.collectionView playerManager:playerManager containerViewTag:100100];
    self.player.controlView = self.controlView;
    /// 0.4是消失40%时候
    self.player.playerDisapperaPercent = 0.4;
    /// 0.6是出现60%时候
    self.player.playerApperaPercent = 0.6;
    /// 移动网络依然自动播放
    self.player.WWANAutoPlay = YES;
    /// 续播
    self.player.resumePlayRecord = NO;

    @zf_weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
//        kAPPDelegate.allowOrentitaionRotation = isFullScreen;
    };
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @zf_strongify(self)
         //重复播放
        ZFAVPlayerManager *manager = (ZFAVPlayerManager *)asset;
        
        CGFloat y= self.collectionView.contentOffset.y;
        NSString *height = [NSString stringWithFormat:@"%g",y];
        CGFloat scrHeight=[[UIScreen mainScreen] bounds].size.height;
        NSString *screenHeight = [NSString stringWithFormat:@"%g",scrHeight];
        int index = [height intValue]/[screenHeight intValue];
    
        [self.player playTheIndexPath:[NSIndexPath indexPathWithIndex:index] assetURL:manager.assetURL];
        
    };
    /// 停止的时候找出最合适的播放
    self.player.zf_scrollViewDidEndScrollingCallback = ^(NSIndexPath * _Nonnull indexPath) {
        @zf_strongify(self)
        if (!self.player.playingIndexPath) {
            [self playTheVideoAtIndexPath:indexPath];
        }
    };
    
    /// 滑动中找到适合的就自动播放
    /// 如果是停止后再寻找播放可以忽略这个回调
    /// 如果在滑动中就要寻找到播放的indexPath，并且开始播放，那就要这样写
    self.player.zf_playerShouldPlayInScrollView = ^(NSIndexPath * _Nonnull indexPath) {
        @zf_strongify(self)
        if ([indexPath compare:self.player.playingIndexPath] != NSOrderedSame) {
            [self playTheVideoAtIndexPath:indexPath];
        }
    };
}
/// *设置当前详情模型
-(void)receiveDetaileDataIndex{
    CGFloat y= self.collectionView.contentOffset.y;
    NSString *height = [NSString stringWithFormat:@"%g",y];
    CGFloat scrHeight=[[UIScreen mainScreen] bounds].size.height;
    NSString *screenHeight = [NSString stringWithFormat:@"%g",scrHeight];
    int index = [height intValue]/[screenHeight intValue];
    self.currentCell = (JX_WHVideoPlayCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    //获取当前的index
    self.currentIndex = [NSIndexPath indexPathWithIndex:index];
    
}
#pragma mark  设置CollectionView每组所包含的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    JX_WHVideoPlayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (indexPath.item < self.dataArray.count) {
        WH_GKDYVideoModel *model = self.dataArray[indexPath.item];
        [cell setDelegate:self withIndexPath:indexPath scroller:collectionView];
        cell.wh_model = model;
    }
    __weak typeof (&*self)weakSelf = self;
    cell.stopPlayBlock = ^{
        [weakSelf stopPlayVideoAction];
    };
    return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(JX_SCREEN_WIDTH,JX_SCREEN_HEIGHT);
}
#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,0,0,0);//（上、左、下、右）
}
#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
#pragma mark  点击CollectionView触发事件eishiren
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return;
    }
}
#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - UIScrollViewDelegate 列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
    //判断当前是多少
    [self receiveDetaileDataIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //增加
    [scrollView zf_scrollViewDidScroll];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}
#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath];
}
#pragma mark - private method

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath {

    if (self.dataArray.count > indexPath.item) {
        self.currentCell.playImageBtn.hidden = YES;
        CGFloat y= self.collectionView.contentOffset.y;
        NSString *height = [NSString stringWithFormat:@"%g",y];
        CGFloat scrHeight=[[UIScreen mainScreen] bounds].size.height;
        NSString *screenHeight = [NSString stringWithFormat:@"%g",scrHeight];
        int index = [height intValue]/[screenHeight intValue];
        JX_WHVideoPlayCell *currentCell = (JX_WHVideoPlayCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        currentCell.playImageBtn.hidden = YES;
                
        WH_GKDYVideoModel *videoModel = self.dataArray[indexPath.item];
        [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:videoModel.video_url?videoModel.video_url:@""]];
        
        [self.controlView showTitle:@""
                     coverURLString:videoModel.thumbnail_url
                     fullScreenMode:ZFFullScreenModePortrait];
        
    }
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // 列表中是否存在更多数据
//    if (self.isEnd) {
//        return;
//    }
//    if (indexPath.item > self.dataArray.count * 0.8) {//加载数据
//        self.pageIndex ++;
//        self.request.currentDynamicId = @"";
//        self.request.hasSlide = @(1);
//        [self receiveData];
//    }
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(JX_SCREEN_WIDTH,JX_SCREEN_HEIGHT);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        //设置CollectionView的属性
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,JX_SCREEN_WIDTH,JX_SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.clipsToBounds = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor blackColor];
        
        __weak typeof (&*self)weakSelf = self;
                
//        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf.player stopCurrentPlayingCell];
//            weakSelf.pageIndex = 0;
//            [weakSelf receiveListData];
//        }];
        if (@available(iOS 11.0, *)) {
                self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                self.automaticallyAdjustsScrollViewInsets = NO;
            }

//        _collectionView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
//            weakSelf.pageIndex ++;
//            [weakSelf receiveListData];
//        }];
        //注册Cell
        [_collectionView registerClass:[JX_WHVideoPlayCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.prepareShowControlView = YES;
        _controlView.fastViewAnimated = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [singleTap setNumberOfTapsRequired:1];
        [_controlView addGestureRecognizer:singleTap];
//        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
//        doubleTap.numberOfTapsRequired = 2;//需要点两下h
//        [_controlView addGestureRecognizer:doubleTap];
//        [singleTap requireGestureRecognizerToFail:doubleTap];  //加入这一行就不会出现这个问题
        _controlView.horizontalPanShowControlView = NO;
        for (UIView *view in _controlView.subviews) {
            view.backgroundColor = [UIColor blackColor];
        }
    }
    return _controlView;
}
-(void)tapGesture:(UITapGestureRecognizer *)sender{
    //暂停播放
    [self stopPlayVideoAction];
}
//暂停播放
-(void)stopPlayVideoAction{
    CGFloat y= self.collectionView.contentOffset.y;
    NSString *height = [NSString stringWithFormat:@"%g",y];
    CGFloat scrHeight=[[UIScreen mainScreen] bounds].size.height;
    NSString *screenHeight = [NSString stringWithFormat:@"%g",scrHeight];
    int index = [height intValue]/[screenHeight intValue];
    JX_WHVideoPlayCell *currentCell = (JX_WHVideoPlayCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    currentCell.playImageBtn.hidden = ![self.player.currentPlayerManager isPlaying];
    [currentCell.contentView bringSubviewToFront:self.currentCell.playImageBtn];
    
    if([self.player.currentPlayerManager isPlaying]){//暂停
        [self.player.currentPlayerManager pause];
    }else{//播放
        [self.player.currentPlayerManager play];
    }
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    //    [_wait hide];
    if( [aDownload.action isEqualToString:wh_act_CircleMsgPureVideo] ){
        [self.dataArray removeAllObjects];
        for (int i = 0; i < array1.count; i++) {
            WH_GKDYVideoModel *model = [[WH_GKDYVideoModel alloc] init];
            [model WH_getDataFromDict:array1[i]];
            [self.dataArray addObject:model];
        }
        [self.collectionView reloadData];
    }
}

#pragma mark - 请求失败回调
- (int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    //    [_wait hide];
    
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    //    [_wait hide];
    
    return WH_show_error;
}



@end
