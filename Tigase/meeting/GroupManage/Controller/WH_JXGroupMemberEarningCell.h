//
//  WH_JXGroupMemberEarningCell.h
//  Tigase
//
//  Created by 1111 on 2024/3/25.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXGroupMemberEarningCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveLab;
@property (weak, nonatomic) IBOutlet UILabel *sendLab;


@end

NS_ASSUME_NONNULL_END
