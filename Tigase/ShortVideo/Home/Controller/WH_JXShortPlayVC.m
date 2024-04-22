//
//  WH_JXShortPlayVC.m
//  Tigase
//
//  Created by 1111 on 2024/4/19.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXShortPlayVC.h"
#import "WH_JXShortPlayCell.h"
#import "WH_ShortVideoModel.h"
#import "WH_Player_WHVC.h"
#import "WH_GKDYVideoModel.h"

@interface WH_JXShortPlayVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    ATMHud *_wait;
}

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger pageIndex;
@property(nonatomic,assign)BOOL isEnd;
@property(nonatomic,assign)BOOL isAll;

@end

@implementation WH_JXShortPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 1;
    self.isEnd = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(JX_SCREEN_TOP);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-JX_SCREEN_BOTTOM);
    }];
    //请求数据
    [self receiveListData];
}
-(void)receiveListData{
    [g_server WH_receiveShortListWithIndex:self.pageIndex toView:self];
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
    WH_JXShortPlayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (indexPath.item < self.dataArray.count) {
        WH_ShortVideoModel *model = self.dataArray[indexPath.item];
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:model.album]];
        [cell.playCountBtn setTitle:[NSString stringWithFormat:@"%@",model.play] forState:UIControlStateNormal];
        cell.nameLab.text = model.title;
        cell.totalCountLab.text = [NSString stringWithFormat:@"%@集",model.totalSeries];
    }
    
    return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float wide = (JX_SCREEN_WIDTH - 32 - 16)/3;
    return  CGSizeMake(wide,wide + 80);
}
#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,16,0,16);//（上、左、下、右）
}
#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}
#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}
#pragma mark  点击CollectionView触发事件eishiren
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return;
    }
    if (indexPath.item < self.dataArray.count) {
        WH_ShortVideoModel *model = self.dataArray[indexPath.item];
        //获取全集
        [g_server WH_VideoAllWithId:model.videoId toView:self];
    }
}
#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // 列表中是否存在更多数据
    if (!self.isEnd || self.isAll) {
        return;
    }
    if (indexPath.item > self.dataArray.count * 0.8) {//加载数据
        [self receiveListData];
    }
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        float wide = (JX_SCREEN_WIDTH - 32 - 16)/3;
        layout.itemSize = CGSizeMake((JX_SCREEN_WIDTH - 32 - 16)/3,wide + 80);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        //设置CollectionView的属性
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,JX_SCREEN_TOP,JX_SCREEN_WIDTH,JX_SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.clipsToBounds = YES;
//        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
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
        [_collectionView registerNib:[UINib nibWithNibName:@"WH_JXShortPlayCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    self.isEnd = YES;
    //    [_wait hide];
    if([aDownload.action isEqualToString:wh_act_ShortList]){
        NSArray *list = [WH_ShortVideoModel mj_objectArrayWithKeyValuesArray:array1];
        [self.dataArray addObjectsFromArray:list];
        self.pageIndex++;
        [self.collectionView reloadData];
        
        self.isAll = array1.count<20?YES:NO;
        
    }else if ([aDownload.action isEqualToString:wh_series_info]){
        NSMutableArray *list = [NSMutableArray array];
        for (int i = 0; i < array1.count; i++) {
            WH_GKDYVideoModel *model = [[WH_GKDYVideoModel alloc] init];
            [model WH_getDataFromDict:array1[i]];
           
            [list addObject:model];
        }
        WH_Player_WHVC *vc = [[WH_Player_WHVC alloc] init];
        vc.pageIndex = 0;
        vc.type = 7;
        vc.selectIndex = 0;
        vc.dataArray = list;
        [g_navigation pushViewController:vc animated:YES];
    }
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


@end
