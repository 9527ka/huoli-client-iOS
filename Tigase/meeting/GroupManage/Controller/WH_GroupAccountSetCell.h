//
//  WH_GroupAccountSetCell.h
//  Tigase
//
//  Created by 1111 on 2023/12/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_GroupAccountSetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *paytypeLab;//支付方式
@property (weak, nonatomic) IBOutlet UILabel *unitLab;//支付类型
@property (weak, nonatomic) IBOutlet UILabel *rightPayLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

@property (nonatomic,copy)void(^deleteBlock)(void);

@end

NS_ASSUME_NONNULL_END
