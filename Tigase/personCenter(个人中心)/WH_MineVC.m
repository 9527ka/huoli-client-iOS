//
//  WH_MineVC.m
//  Tigase
//
//  Created by 1111 on 2024/3/27.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_MineVC.h"
#import "LoadMoreControl.h"
#import "ScalePresentAnimation.h"
#import "SwipeLeftInteractiveTransition.h"
#import "ScaleDismissAnimation.h"
#import "HoverViewFlowLayout.h"
#import "UserInfoHeader.h"
#import "WH_MineCell.h"
#import "WH_MyWallet_WHViewController.h"
#import "WH_JXSecuritySetting_WHVC.h"
#import "WH_JXSetting_WHVC.h"
#import "WH_JXSettings_WHViewController.h"
#import "WH_JXImageScroll_WHVC.h"
#import "DMScaleTransition.h"
#import "WH_PersonalData_WHViewController.h"
#import "WH_GKDYVideoModel.h"
#import "AwemeListController.h"
#import "WH_Player_WHVC.h"

#define kUserInfoHeaderHeight          433
#define kSlideTabBarHeight             57

NSString * const kUserInfoCell         = @"UserInfoCell";
NSString * const kWH_MineCell  = @"WH_MineCell";

@interface WH_MineVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIViewControllerTransitioningDelegate,UIScrollViewDelegate,OnTabTapActionDelegate>{
    ATMHud *_wait;
}

@property (nonatomic, assign) NSInteger                        pageIndex;
@property (nonatomic, assign) NSInteger                        pageSize;

@property (nonatomic, assign) NSInteger                        tabIndex;
@property (nonatomic, assign) CGFloat                          itemWidth;
@property (nonatomic, assign) CGFloat                          itemHeight;
@property (nonatomic, strong) ScalePresentAnimation            *scalePresentAnimation;
@property (nonatomic, strong) ScaleDismissAnimation            *scaleDismissAnimation;
@property (nonatomic, strong) SwipeLeftInteractiveTransition   *swipeLeftInteractiveTransition;
@property (nonatomic, strong) UserInfoHeader                   *userInfoHeader;
@property (nonatomic, strong) LoadMoreControl                  *loadMore;

@property (nonatomic, strong) UICollectionView                 *collectionView;
@property (nonatomic, assign) NSInteger                        selectIndex;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *collectsArr;

@end

@implementation WH_MineVC

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageIndex = 1;
        _pageSize = 21;
        
        _tabIndex = 0;
        
        _scalePresentAnimation = [ScalePresentAnimation new];
        _scaleDismissAnimation = [ScaleDismissAnimation new];
        _swipeLeftInteractiveTransition = [SwipeLeftInteractiveTransition new];
        
        _dataArray = [NSMutableArray array];
        _collectsArr = [NSMutableArray array];
        
        //获取余额
        [g_server WH_getUserMoenyToView:self];
        
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self WH_doRefresh:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _wait = [ATMHud sharedInstance];
    [self initCollectionView];

    [self receiveListData];
    
    [self getCurrentUserInfo];
    
    
    [g_notify addObserver:self selector:@selector(WH_doRefresh:) name:kUpdateUser_WHNotifaction object:nil];
    
    [g_notify addObserver:self selector:@selector(wh_updateUserInfo:) name:kXMPPMessageUpdateUserInfo_WHNotification object:nil];
    
}
-(void)receiveListData{
    [g_server WH_LookMyVideoWithPageIndex:self.pageIndex type:_tabIndex == 2?3:_tabIndex toView:self];
}
- (void)getCurrentUserInfo {
    [[WH_JXUserObject sharedUserInstance] getCurrentUser];
    [WH_JXUserObject sharedUserInstance].complete = ^(HttpRequestStatus status, NSDictionary * _Nullable userInfo, NSError * _Nullable error) {
        switch (status) {
            case HttpRequestSuccess:
            {
                [_userInfoHeader setUserInfo];
            }
                break;
            case HttpRequestFailed:
            {
                
            }
                break;
            case HttpRequestError:
            {
                
            }
                break;
                
            default:
                break;
        }
    };
}
-(void)WH_doRefresh:(NSNotification *)notifacation{
    
    WH_JXMessageObject *msg=[[WH_JXMessageObject alloc]init];
    msg.timeSend     = [NSDate date];
    msg.fromUserId   = MY_USER_ID;
    msg.content = @"1";
    msg.toUserId     = MY_USER_ID;
    msg.type         = [NSNumber numberWithInt:kWCMessageTypeMultipleGetUserInfo];
    [g_xmpp sendMessage:msg roomName:nil];
    
    [_userInfoHeader setUserInfo];
}
#pragma mark 用户信息更改消息
- (void)wh_updateUserInfo:(NSNotification *)notification {
    [g_server getUser:MY_USER_ID toView:self];
}
- (void)initCollectionView {
    _itemWidth = (JX_SCREEN_WIDTH - 64) / 3.0f;
    _itemHeight = _itemWidth * 1.25f;
    HoverViewFlowLayout *layout = [[HoverViewFlowLayout alloc] initWithTopHeight:kSlideTabBarHeight+10];
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(0, JX_SCREEN_TOP, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT - JX_SCREEN_TOP) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UserInfoHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kUserInfoCell];
    [_collectionView registerNib:[UINib nibWithNibName:kWH_MineCell bundle:nil] forCellWithReuseIdentifier:kWH_MineCell];
    [self.view addSubview:_collectionView];
    
    _loadMore = [[LoadMoreControl alloc] initWithFrame:CGRectMake(0, kUserInfoHeaderHeight, JX_SCREEN_WIDTH, 50) surplusCount:15];
    [_loadMore startLoading];
    __weak __typeof(self) wself = self;
    [_loadMore setOnLoad:^{
        [wself receiveListData];
    }];
    [_collectionView addSubview:_loadMore];
}
//UICollectionViewDataSource Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && kind == UICollectionElementKindSectionHeader) {
        UserInfoHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kUserInfoCell forIndexPath:indexPath];
        _userInfoHeader = header;
        __weak typeof (&*self)weakSelf = self;
        header.clickBlock = ^(FunctionType type) {
            [weakSelf jumpWithType:type];
        };
//        if(_user) {
//            [header initData:_user];
            header.slideTabBar.delegate = self;
//        }
        return header;
    }
    return [UICollectionReusableView new];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == 1) {
        return _tabIndex == 0 ? self.collectsArr.count : self.dataArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WH_MineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWH_MineCell forIndexPath:indexPath];
    WH_GKDYVideoModel *model;
    if(_tabIndex == 0) {
        if(self.collectsArr.count > indexPath.item){
            model = self.collectsArr[indexPath.item];
        }

    }else {
        if(self.dataArray.count > indexPath.item){
            model = self.dataArray[indexPath.item];
        }
    }
    if(model){
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail_url]];
        [cell.playCountBtn setTitle:model.play forState:UIControlStateNormal];
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//UICollectionViewDelegate Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectIndex = indexPath.item;
    AwemeType type = AwemeMyLike;
    if(_tabIndex == 0){
        type = AwemeColoct;
    }else if (_tabIndex == 1){
        type = AwemeMyLike;
    }else if (_tabIndex == 2){
        type = AwemeMyLookShort;
    }
    
    WH_Player_WHVC *vc = [[WH_Player_WHVC alloc] init];
    vc.pageIndex = _pageIndex;
    vc.type = type;
    vc.selectIndex = indexPath.item;
    vc.dataArray = _tabIndex == 0?self.collectsArr:self.dataArray;
    [g_navigation pushViewController:vc animated:YES];
    
//    AwemeListController *controller;
//    if(_tabIndex == 0) {
//        controller = [[AwemeListController alloc] initWithVideoData:self.collectsArr currentIndex:indexPath.row pageIndex:_pageIndex pageSize:_pageSize awemeType:AwemeColoct uid:@""];
//    }else {
//        controller = [[AwemeListController alloc] initWithVideoData:self.dataArray currentIndex:indexPath.row pageIndex:_pageIndex pageSize:_pageSize awemeType:AwemeMyShort uid:@""];
//    }
//    [g_navigation pushViewController:controller animated:YES];
    
    
    
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout: (UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex: (NSInteger)section {
    if(section == 0){
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(0, 20, 0, 20); //  分别为上、左、下、右
}

//UICollectionFlowLayout Delegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return CGSizeMake(JX_SCREEN_WIDTH, kUserInfoHeaderHeight);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(_itemWidth, _itemHeight);
}

//UIViewControllerTransitioningDelegate Delegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _scalePresentAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return _scaleDismissAnimation;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return _swipeLeftInteractiveTransition.interacting ? _swipeLeftInteractiveTransition : nil;
}

//UIScrollViewDelegate Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > kUserInfoHeaderHeight - kSlideTabBarHeight) {
       self.collectionView.backgroundColor = HEXCOLOR(0xf3f3f3);
    }else {
        self.collectionView.backgroundColor = [UIColor clearColor];
    }
}

//OnTabTapDelegate
- (void)onTabTapAction:(NSInteger)index {
    if(_tabIndex == index){
        return;
    }
    _tabIndex = index;
    _pageIndex = 1;
    
    [UIView setAnimationsEnabled:NO];
    [self.collectionView performBatchUpdates:^{
        
        if([self.collectionView numberOfItemsInSection:1]) {
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }
    } completion:^(BOOL finished) {
        [UIView setAnimationsEnabled:YES];
        
        [self.loadMore reset];
        [self.loadMore startLoading];
        [self receiveListData];
    }];
    
}
//网络状态发送变化
-(void)onNetworkStatusChange:(NSNotification *)notification {
//    if(![NetworkHelper isNotReachableStatus:[NetworkHelper networkStatus]]) {
//        if(_user == nil) {
//            [self loadUserData];
//        }
//        if(_favoriteAwemes.count == 0 && _workAwemes.count == 0) {
//            [self loadData:_pageIndex pageSize:_pageSize];
//        }
//    }
}

//HTTP data request
-(void)loadUserData {
    __weak typeof (self) wself = self;
   
    [wself.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
   
}

- (void)loadData:(NSInteger)pageIndex pageSize:(NSInteger)pageSize {
    __weak typeof (self) wself = self;
    
//    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
//    for(NSInteger row = 0; row<_tabIndex == 0?self.collectsArr.count:self.dataArray.count; row++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
//        [indexPaths addObject:indexPath];
//    }
//    [wself.collectionView insertItemsAtIndexPaths:indexPaths];
    
    [self.collectionView reloadData];
    
    [self.loadMore endLoading];
   

}
-(void)jumpWithType:(FunctionType)type{
    if (type == FunctionType_Wallet) {
        //我的钱包
        
        WH_MyWallet_WHViewController *moneyVC = [[WH_MyWallet_WHViewController alloc] init];
        [g_navigation pushViewController:moneyVC animated:YES];
        
        
    }else if (type == FunctionType_Safe) {
        //安全设置
        WH_JXSecuritySetting_WHVC *vc = [[WH_JXSecuritySetting_WHVC alloc] init];
        [g_navigation pushViewController:vc animated:YES];
        
    }else if (type == FunctionType_Prive) {
        //隐私设置
        [g_server WH_getFriendSettingsWithUserId:[NSString stringWithFormat:@"%ld",g_server.user_id] toView:self];
        
    }else if (type == FunctionType_Other) {
        //其他设置
        WH_JXSetting_WHVC* vc = [[WH_JXSetting_WHVC alloc]init];
        [g_navigation pushViewController:vc animated:YES];
    }else if (type == FunctionType_Order){
        
       
        
    }else if (type == FunctionType_Editor){
        
        WH_PersonalData_WHViewController *pdVC = [[WH_PersonalData_WHViewController alloc] init];
        pdVC.wh_headImage = [_userInfoHeader.avatar.image copy];
        pdVC.user = g_myself;
        g_myself.userNickname = g_myself.userNickname;
        NSRange range = [g_myself.telephone rangeOfString:@"86"];
        if (range.location != NSNotFound) {
            g_myself.telephone = [g_myself.telephone substringFromIndex:range.location + range.length];
        }
        [g_navigation pushViewController:pdVC animated:YES];
        
    }else if (type == FunctionType_Head){
        [self imageTapAction];
    }
}
#pragma mark - 头像点击方法
-(void)imageTapAction{
    
    WH_JXImageScroll_WHVC * imageVC = [[WH_JXImageScroll_WHVC alloc]init];
    
    imageVC.imageSize = CGSizeMake(JX_SCREEN_WIDTH, JX_SCREEN_WIDTH);
    
    imageVC.iv = [[WH_JXImageView alloc] initWithFrame:CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_WIDTH)];
    
    imageVC.iv.center = imageVC.view.center;
    
    [g_server WH_getHeadImageLargeWithUserId:MY_USER_ID userName:kMY_USER_NICKNAME imageView:imageVC.iv];
    if (@available(iOS 13.0, *)) {
        imageVC.modalPresentationStyle = UIModalPresentationFullScreen;
    }else{
        [self WH_addTransition:imageVC];
    }
    
    
    [self presentViewController:imageVC animated:YES completion:^{
        
    }];
}
//添加VC转场动画
- (void) WH_addTransition:(WH_JXImageScroll_WHVC *) siv
{
    DMScaleTransition *_scaleTransition = [[DMScaleTransition alloc]init];
    [siv setTransitioningDelegate:_scaleTransition];
    
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1 {
    [_wait hide];
    
    if( [aDownload.action isEqualToString:wh_act_resumeList] ){
        
    }else if( [aDownload.action isEqualToString:wh_act_UserGet] ){
        [g_myself WH_getDataFromDict:dict];
        
        [_userInfoHeader setUserInfo];
        
    }else if ([aDownload.action isEqualToString:wh_act_getUserMoeny]) {
        g_App.myMoney = [dict[@"balance"] doubleValue];
        [_userInfoHeader setUserInfo];
    }else if ([aDownload.action isEqualToString:wh_act_Settings]){
        //跳转新的页面
        WH_JXSettings_WHViewController* vc = [[WH_JXSettings_WHViewController alloc]init];
        vc.dataSorce = dict;
        [g_navigation pushViewController:vc animated:YES];
        [_wait stop];
    }else if ([aDownload.action isEqualToString:wh_myvideos] || [aDownload.action isEqualToString:wh_mycollects] || [aDownload.action isEqualToString:wh_myLike] || [aDownload.action isEqualToString:wh_myviewed]){
        
        if(self.pageIndex == 1){
            if(_tabIndex == 0){
                [self.collectsArr removeAllObjects];
            }else{
                [self.dataArray removeAllObjects];
            }
        }
        
        for (int i = 0; i < array1.count; i++) {
            WH_GKDYVideoModel *model = [[WH_GKDYVideoModel alloc] init];
            [model WH_getDataFromDict:array1[i]];
            if(_tabIndex == 0){
                [self.collectsArr addObject:model];
            }else{
                [self.dataArray addObject:model];
            }
        }
        self.pageIndex++;
        [self loadData:self.pageIndex pageSize:self.pageSize];
        if(array1.count < 20){
            [self.loadMore loadingAll];
        }
    }
}
#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait hide];
    return WH_hide_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait hide];
    return WH_hide_error;
}

@end
