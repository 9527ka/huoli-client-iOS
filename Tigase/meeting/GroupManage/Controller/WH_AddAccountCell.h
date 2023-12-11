//
//  WH_AddAccountCell.h
//  Tigase
//
//  Created by 1111 on 2023/12/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_AddAccountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *payTypeBgView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *payTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *payAccountLab;


@property(nonatomic,copy)void(^chooseTypeBlock)(void);
@property(nonatomic,copy)void(^chooseImageBlock)(void);
@property(nonatomic,copy)void(^certainBlock)(NSString *name,NSString *account);

@end

NS_ASSUME_NONNULL_END
