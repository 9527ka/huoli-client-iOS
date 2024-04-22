//
//  AwemeListController.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "AwemeListController.h"

typedef NS_ENUM(NSUInteger, AwemeType) {
    AwemeColoct    = 3,
    AwemeMyLike        = 4,
    AwemeMyShort        = 5,
    AwemeMyLookShort        = 8,
   
};

@class Aweme;
@interface AwemeListController : UIViewController

@property (nonatomic, strong) UITableView                       *tableView;
@property (nonatomic, assign) NSInteger                         currentIndex;

@property(nonatomic,assign)NSInteger type;

- (void)applicationEnterBackground;
- (void)applicationBecomeActive;

-(instancetype)initWithVideoData:(NSMutableArray *)data currentIndex:(NSInteger)currentIndex pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize awemeType:(AwemeType)type uid:(NSString *)uid;

@end
