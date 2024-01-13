//
//  WH_JXBuyAndPayListCell.h
//  Tigase
//
//  Created by 1111 on 2024/1/2.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WH_JXBuyAndPayListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXBuyAndPayListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *onlineLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *orderCountLab;
@property (weak, nonatomic) IBOutlet UIView *zfbBgView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UILabel *headTitleLab;

@property (weak, nonatomic) IBOutlet UILabel *protectLab;
@property(nonatomic,copy)void(^buyBlock)(void);

@property (strong, nonatomic)WH_JXBuyAndPayListModel *model;

@end

NS_ASSUME_NONNULL_END
