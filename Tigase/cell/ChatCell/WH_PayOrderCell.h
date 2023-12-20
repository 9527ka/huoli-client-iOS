//
//  WH_PayOrderCell.h
//  Tigase
//
//  Created by 1111 on 2023/12/19.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WH_JXMessageObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WH_PayOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detaileLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *certainBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic,copy)void(^certainBlock)(NSInteger tag,NSString *orderId);

@property (nonatomic,strong) WH_JXMessageObject * msg;

@end

NS_ASSUME_NONNULL_END
