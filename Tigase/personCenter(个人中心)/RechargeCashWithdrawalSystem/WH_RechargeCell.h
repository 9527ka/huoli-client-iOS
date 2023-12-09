//
//  WH_RechargeCell.h
//  Tigase
//
//  Created by 1111 on 2023/12/7.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface WH_RechargeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgTopView;
@property (weak, nonatomic) IBOutlet UIView *bgBottomView;
@property (weak, nonatomic) IBOutlet UITextField *monyField;//充值金额
@property (weak, nonatomic) IBOutlet UILabel *monyCountLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;//充值地址
@property (weak, nonatomic) IBOutlet UITextField *orderNoField;//交易hash
@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;//图片上传
@property (weak, nonatomic) IBOutlet UIButton *certainBtn;
@property (weak, nonatomic) IBOutlet UIButton *numCopyBtn;
@property (nonatomic,copy) void(^chooseImageBlock)(void);
@property (nonatomic,copy) void(^certainBlock)(NSString *amountStr,NSString *orderNoStr);


@end

NS_ASSUME_NONNULL_END
