//
//  WH_GroupRechargeCell.h
//  Tigase
//
//  Created by 1111 on 2023/12/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_GroupRechargeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *countField;
@property (weak, nonatomic) IBOutlet UILabel *limitCountLab;
@property (weak, nonatomic) IBOutlet UIView *zfbBgView;
@property (weak, nonatomic) IBOutlet UILabel *payCountLab;
@property (weak, nonatomic) IBOutlet UIView *vxBgView;
@property (weak, nonatomic) IBOutlet UIImageView *zfbChooseImage;
@property (weak, nonatomic) IBOutlet UIImageView *vxChooseImage;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLab;
@property (weak, nonatomic) IBOutlet UIButton *certainBtn;
@property (weak, nonatomic) IBOutlet UIView *payBgView;
@property (weak, nonatomic) IBOutlet UILabel *zfbPayLab;
@property (weak, nonatomic) IBOutlet UILabel *vxPayLab;
@property (weak, nonatomic) IBOutlet UILabel *rulerLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vxViewTopConstant;// 128 24

@property(nonatomic,strong)NSArray *payArray;

@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)void(^certainBlock)(NSString *count,NSInteger type);



@end

NS_ASSUME_NONNULL_END
