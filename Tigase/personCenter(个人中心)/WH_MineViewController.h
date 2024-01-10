//
//  WH_MineViewController.h
//  Tigase
//
//  Created by Apple on 2019/6/27.
//  Copyright © 2019 Reese. All rights reserved.
//

#import "WH_admob_WHViewController.h"

#import "WH_JXUserObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WH_MineViewController : WH_admob_WHViewController<UITableViewDelegate ,UITableViewDataSource>

typedef NS_ENUM(NSInteger, ClickButtonType) {
    ClickButtonType_Wallert = 100,
    ClickButtonType_Account,
    ClickButtonType_Order,
    ClickButtonType_Collect,
    ClickButtonType_LifeStatus,
    ClickButtonType_SecuritySettings,
    ClickButtonType_PrivacySettings,
    ClickButtonType_OtherSetting,
};

@property (nonatomic ,strong) UITableView *wh_tableView;

@property (nonatomic ,strong) NSArray *wh_dataArray;
@property (nonatomic ,strong) NSArray *wh_imgsArray;
@property (nonatomic ,strong) NSArray *wh_tagArray;

@property (nonatomic,assign) BOOL isRefresh;

@property (nonatomic ,strong) UIImageView *wh_headImgView; //头像
@property (nonatomic ,strong) UILabel *wh_nameLabel; //用户名称
@property (nonatomic ,strong) UILabel *userId; //用户ID


NS_ASSUME_NONNULL_END
- (void)sp_didUserInfoFailed;

- (void)sp_getUsersMostLiked:(NSString *)string;
@end
