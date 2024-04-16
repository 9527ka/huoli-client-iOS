//
//  WH_PopularVideoVC.m
//  Tigase
//
//  Created by 1111 on 2024/4/9.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_PopularVideoVC.h"
#import "WH_PopularVideoCell.h"
# import <AlipaySDK/AlipaySDK.h>
#import "WH_GKDYVideoModel.h"
#import "WH_Player_WHVC.h"

@interface WH_PopularVideoVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *selectCountLab;
@property (weak, nonatomic) IBOutlet UIView *chooseBgView;
@property (weak, nonatomic) IBOutlet UIView *recommendBgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *wantBgView;
@property (weak, nonatomic) IBOutlet UIButton *accountBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;
@property (weak, nonatomic) IBOutlet UIView *likeBgView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *likeTitleLab;
@property (weak, nonatomic) IBOutlet UIView *fansBgView;
@property (weak, nonatomic) IBOutlet UIButton *fansBtn;
@property (weak, nonatomic) IBOutlet UILabel *fansTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (nonatomic,strong) UIButton *selectBtn;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIView *dayBgView;
@property (weak, nonatomic) IBOutlet UITextField *daysField;
@property (nonatomic,copy)NSString *type;//:1点赞,　2收藏
@property (nonatomic,copy)NSString *titleStr;//title:1帐号经营,2视频加热

@end

@implementation WH_PopularVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self creatUI];
    self.type = @"1";
    self.titleStr = @"1";
    //数据请求
    [g_server WH_LookMyVideoWithUserId:self.userId videoId:self.videoId toView:self];
    
}
-(void)creatUI{
    self.payBtn.layer.cornerRadius = 6.0f;
    self.recommendBgView.layer.cornerRadius = 11.0f;
    self.wantBgView.layer.cornerRadius = 11.0f;
    self.dayBgView.layer.cornerRadius = 11.0f;
    self.accountBtn.layer.cornerRadius = 4.0f;
    self.accountBtn.layer.borderColor = THEMECOLOR.CGColor;
    self.accountBtn.layer.borderWidth = 1.0f;
    self.accountBtn.selected = YES;
    self.accountBtn.backgroundColor = HEXCOLOR(0xEFFFF6);
    self.selectBtn = self.accountBtn;
    
    self.videoBtn.layer.cornerRadius = 4.0f;
    self.videoBtn.layer.borderColor = HEXCOLOR(0xD9D9D9).CGColor;
    self.videoBtn.layer.borderWidth = 1.0f;
    
    UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTapAction)];
    [self.likeBgView addGestureRecognizer:likeTap];
    self.likeBgView.layer.cornerRadius = 4.0f;
    self.likeBgView.layer.borderColor = THEMECOLOR.CGColor;
    self.likeBgView.layer.borderWidth = 1.0f;
    self.likeBtn.selected = YES;
    self.likeBgView.backgroundColor = HEXCOLOR(0xEFFFF6);
    self.likeTitleLab.textColor = THEMECOLOR;
    
    
    UITapGestureRecognizer *fansTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fansTapAction)];
    [self.fansBgView addGestureRecognizer:fansTap];
    self.fansBgView.layer.cornerRadius = 4.0f;
    self.fansBgView.layer.borderColor = HEXCOLOR(0xD9D9D9).CGColor;
    self.fansBgView.layer.borderWidth = 1.0f;
    
    [self.chooseBgView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.chooseBgView);
    }];
    [self.daysField addTarget:self action:@selector(textchangeAction:) forControlEvents:UIControlEventEditingChanged];
    
}
-(void)textchangeAction:(UITextField *)textField{
    self.moneyLab.text = [NSString stringWithFormat:@"￥%.2f",g_config.unit.floatValue*self.daysField.text.integerValue];
}
//700+
- (IBAction)daysAction:(UIButton *)sender {
    NSInteger days = self.daysField.text.integerValue;
    if(sender.tag == 700){//-
        days--;
    }else{//+
        days++;
    }
    if(days < 1){
        days = 1;
    }
    self.daysField.text = [NSString stringWithFormat:@"%ld",days];
    self.moneyLab.text = [NSString stringWithFormat:@"￥%.2f",g_config.unit.floatValue*self.daysField.text.integerValue];
}

//点赞评论量点击事件
-(void)likeTapAction{
    self.type = @"1";
    self.likeBgView.layer.borderColor = THEMECOLOR.CGColor;
    self.likeBtn.selected = YES;
    self.likeBgView.backgroundColor = HEXCOLOR(0xEFFFF6);
    self.likeTitleLab.textColor = THEMECOLOR;
    
    self.fansBgView.layer.borderColor = HEXCOLOR(0xD9D9D9).CGColor;
    self.fansBtn.selected = NO;
    self.fansBgView.backgroundColor = HEXCOLOR(0xFFFFFF);
    self.fansTitleLab.textColor = HEXCOLOR(0x161819);
    
}
//粉丝量点击事件
-(void)fansTapAction{
    self.type = @"2";
    self.fansBgView.layer.borderColor = THEMECOLOR.CGColor;
    self.fansBtn.selected = YES;
    self.fansBgView.backgroundColor = HEXCOLOR(0xEFFFF6);
    self.fansTitleLab.textColor = THEMECOLOR;
    
    self.likeBgView.layer.borderColor = HEXCOLOR(0xD9D9D9).CGColor;
    self.likeBtn.selected = NO;
    self.likeBgView.backgroundColor = HEXCOLOR(0xFFFFFF);
    self.likeTitleLab.textColor = HEXCOLOR(0x161819);
}

//账号经营 视频加热 500+
- (IBAction)typeAction:(UIButton *)sender {
    self.selectBtn.layer.borderColor = HEXCOLOR(0xD9D9D9).CGColor;
    self.selectBtn.backgroundColor = HEXCOLOR(0xFFFFFF);
    self.selectBtn.selected = NO;
    self.selectBtn = sender;
    self.selectBtn.layer.borderColor = THEMECOLOR.CGColor;
    self.selectBtn.selected = YES;
    self.selectBtn.backgroundColor = HEXCOLOR(0xEFFFF6);
    
    self.titleStr = sender.tag ==500?@"1":@"2";
    
}

//支付的点击事件
- (IBAction)payAction:(id)sender {
    //组装数据 title:1帐号经营,2视频加热
    NSDictionary *dic = @{@"day":self.daysField.text,@"type":self.type,@"title":self.titleStr};
    NSString *content = [dic mj_JSONString];
    NSString *videoIds = @"";
    for (WH_GKDYVideoModel *model in self.dataArray) {
        videoIds = [NSString stringWithFormat:@"%@%@%@",videoIds,videoIds.length > 0?@",":@"",model.msgId];
    }
    NSString *amount = [NSString stringWithFormat:@"%.2f",g_config.unit.floatValue*self.daysField.text.integerValue];
    [g_server WH_VideoHotWithVideoIds:videoIds amount:amount content:content toView:self];

}
- (IBAction)goBackAction:(id)sender {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
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
    WH_PopularVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (indexPath.item < self.dataArray.count) {
        WH_GKDYVideoModel *model = self.dataArray[indexPath.item];
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail_url]];
        [cell.likeCountBtn setTitle:model.agree_num forState:UIControlStateNormal];
        cell.chooseBtn.selected = model.isSelect;
        cell.bgView.layer.borderWidth = model.isSelect?2.0f:0.0f;
        
        __weak typeof (&*self)weakSelf = self;
        cell.chooseVideoBlock = ^{
            model.isSelect = !model.isSelect;
            NSInteger count = weakSelf.selectCountLab.text.integerValue;
            if(model.isSelect){
                count++;
            }else{
                count--;
            }
            if(count < 0){
                count = 0;
            }
            weakSelf.selectCountLab.text = [NSString stringWithFormat:@"%ld",count];
            if(count == 1){
                weakSelf.contentLab.text = model.title;
            }else{
                weakSelf.contentLab.text = @"";
            }
            [weakSelf.collectionView reloadData];
        };
    }
    
    
    return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(105,140);
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
    return 8;
}
#pragma mark  点击CollectionView触发事件eishiren
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return;
    }
    if (indexPath.item < self.dataArray.count) {
        WH_GKDYVideoModel *model = self.dataArray[indexPath.item];
        WH_Player_WHVC *vc = [[WH_Player_WHVC alloc] init];
        vc.pageIndex = 0;
        vc.type = 6;
        vc.selectIndex = indexPath.item;
        vc.dataArray = self.dataArray;
        [g_navigation pushViewController:vc animated:YES];
    }
}
#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(105,140);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        //设置CollectionView的属性
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,JX_SCREEN_WIDTH - 32,140) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.clipsToBounds = YES;

        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
                self.automaticallyAdjustsScrollViewInsets = NO;
        }
        //注册Cell
        [_collectionView registerNib:[UINib nibWithNibName:@"WH_PopularVideoCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    //    [_wait hide];
    if([aDownload.action isEqualToString:wh_seriesVideos]){
        for (int i = 0; i < array1.count; i++) {
            WH_GKDYVideoModel *model = [[WH_GKDYVideoModel alloc] init];
            [model WH_getDataFromDict:array1[i]];
            if(i == 0){
                model.isSelect = YES;
                self.contentLab.text = model.title;
            }
            [self.dataArray addObject:model];
        }
        [self.collectionView reloadData];
    }else if ([aDownload.action isEqualToString:wh_hotPlan]){
        
        [self startPayWithOrderInfo:[NSString stringWithFormat:@"%@",dict[@"orderInfo"]]];
    }
}
-(void)startPayWithOrderInfo:(NSString *)orderInfo{
    NSString *appScheme = @"comyuejiecn";
    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = orderInfo;
    
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        NSLog(@"reslut = %@",resultDic);
        NSInteger resultStatus = [resultDic[@"resultStatus"]integerValue];
        
        switch (resultStatus) {
            case 9000:{//订单支付成功
                [g_server showMsg:@"支付成功"];
            }
                break;
            case 8000:{//正在处理中，支付结果未知
                [g_server showMsg:@"正在处理中..."];
                
            }
                break;
            case 4000:{//订单支付失败
                [g_server showMsg:@"支付失败"];
                
            }
                break;
            case 5000:{//重复请求
                [g_server showMsg:@"重复请求"];
            }
                break;
            case 6001:{//用户中途取消
                [g_server showMsg:@"中途取消"];
            }
                break;
            case 6002:{//网络连接出错
                [g_server showMsg:@"网络连接出错"];
            }
                break;
            case 6004:{//支付结果未知
                [g_server showMsg:@"支付结果未知"];
            }
                break;
                
            default:{//其他支付错误
                [g_server showMsg:@"支付出错了"];
                
            }
                break;
        }
    }];
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
#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    //    [_wait star];
}



@end
