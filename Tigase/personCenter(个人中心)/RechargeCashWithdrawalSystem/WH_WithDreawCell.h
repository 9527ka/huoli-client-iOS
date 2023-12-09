//
//  WH_WithDreawCell.h
//  Tigase
//
//  Created by 1111 on 2023/12/8.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_WithDreawCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgTopView;
@property (weak, nonatomic) IBOutlet UIView *bgBottomView;
@property (weak, nonatomic) IBOutlet UITextField *monyField;//提现金额
@property (weak, nonatomic) IBOutlet UILabel *monyCountLab;
@property (weak, nonatomic) IBOutlet UITextField *orderNoField;//交易hash
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *certainBtn;
@property (nonatomic,copy) void(^certainBlock)(NSString *amountStr,NSString *orderNoStr);

@end

NS_ASSUME_NONNULL_END
