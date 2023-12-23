//
//  WH_JXAppealListCell.h
//  Tigase
//
//  Created by 1111 on 2023/12/22.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WH_JXAppealModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXAppealListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *picBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picBgViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic,strong)NSMutableArray *items;

@property (nonatomic,copy)NSString *videoUrl;

@property(nonatomic,strong)WH_JXAppealModel *model;

@property(nonatomic,copy)void(^lookImageBlock)(NSInteger tag,NSArray *items);
@property(nonatomic,copy)void(^lookVideoBlock)(NSString *videoUrl);

@end

NS_ASSUME_NONNULL_END
