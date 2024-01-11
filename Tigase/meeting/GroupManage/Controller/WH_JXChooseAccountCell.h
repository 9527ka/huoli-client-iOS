//
//  WH_JXChooseAccountCell.h
//  Tigase
//
//  Created by 1111 on 2024/1/10.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXChooseAccountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *tipTitle;
@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImage;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLab;

@end

NS_ASSUME_NONNULL_END
