//
//  WH_JXAgentCell.h
//  Tigase
//
//  Created by 1111 on 2024/1/19.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXAgentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumField;
@property (weak, nonatomic) IBOutlet UIButton *carFrondBtn;
@property (weak, nonatomic) IBOutlet UIButton *carBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *carHandBtn;

//0 正面照   1反面照   2视频
@property(nonatomic,copy)void(^chooseImageBlock)(NSInteger tag);
@property(nonatomic,copy)void(^commitBlock)(NSString *name,NSString *phone,NSString *carNum);

@end

NS_ASSUME_NONNULL_END
