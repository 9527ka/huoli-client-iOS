//
//  WH_JXGroupMemberRedPacketCell.h
//  Tigase
//
//  Created by luan on 2023/6/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXGroupMemberRedPacketCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *medalIcon;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

NS_ASSUME_NONNULL_END
