//
//  WH_JXChatDefaultBgVC.m
//  Tigase
//
//  Created by 1111 on 2024/2/28.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXChatDefaultBgVC.h"
#import "WH_JXChatDefaultBgCell.h"

@interface WH_JXChatDefaultBgVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation WH_JXChatDefaultBgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wh_isGotoBack = YES;
    self.title = @"选择背景图";
    self.wh_heightHeader = JX_SCREEN_TOP;
    self.wh_heightFooter = 0;
    //self.view.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
    [self createHeadAndFoot];
    _dataArray = [NSMutableArray arrayWithArray:@[@"chat_bg_1",@"chat_bg_2",@"chat_bg_3",@"chat_bg_4",@"chat_bg_5",@"chat_bg_6",@"chat_bg_7",@"chat_bg_8",@"chat_bg_9"]];
    [self creatUI];
}

-(void)creatUI{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(NAV_INSETS-6, JX_SCREEN_TOP - 38-6, NAV_BTN_SIZE+12, NAV_BTN_SIZE+12)];
    [btn setImage:[UIImage imageNamed:@"title_back"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(actionQuit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self.view addSubview:self.collectionView];
}
-(void)actionQuit{
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
    
}
#pragma 多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
#pragma 多少个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
#pragma 每一个的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = (self.view.frame.size.width - 8*2 - 32)/3;
    return CGSizeMake(itemWidth, itemWidth);
}
#pragma 每一个边缘留白
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(12, 16, 12, 16);
}
#pragma 最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8.0;
}
#pragma 最小竖间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8.0;
}
#pragma 返回每个单元格是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
#pragma 创建单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        
    WH_JXChatDefaultBgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WH_JXChatDefaultBgCell class]) forIndexPath:indexPath];
    if(indexPath.item < self.dataArray.count){
        NSString *name = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.item]];
        cell.bgImage.image = [UIImage imageNamed:name];
    }
  
    return cell;
}
#pragma 点击单元格
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    if(indexPath.item < self.dataArray.count){
        NSString *name = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.item]];
        UIImage *image = [UIImage imageNamed:name];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        BOOL isSuccess = NO;
        if (self.userId.length > 0) {
   
            [g_constant.userBackGroundImage setObject:imageData forKey:[NSString stringWithFormat:@"%@_%@" ,MY_USER_ID ,self.userId]];
            isSuccess = [g_constant.userBackGroundImage writeToFile:backImage atomically:YES];
            [g_notify postNotificationName:kSetBackGroundImageView_WHNotification object:image];

        }else {
            [g_constant.chatBackgrounImage setObject:imageData forKey:MY_USER_ID];
            [g_constant.chatBackgrounImage writeToFile:ChatBackgroundImage atomically:YES];
            isSuccess = [imageData writeToFile:kChatBackgroundImagePath atomically:YES];
            [g_notify postNotificationName:kSetBackGroundImageView_WHNotification object:image];
            
        }
        if (isSuccess) {
            [g_App showAlert:Localized(@"JX_SetUpSuccess")];
        }else {
            [g_App showAlert:Localized(@"JX_SettingFailure")];
        }
        
    }
}


-(UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, JX_SCREEN_TOP, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT-JX_SCREEN_TOP) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceHorizontal = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[WH_JXChatDefaultBgCell class] forCellWithReuseIdentifier:NSStringFromClass([WH_JXChatDefaultBgCell class])];
    }
    return _collectionView;
}


@end
