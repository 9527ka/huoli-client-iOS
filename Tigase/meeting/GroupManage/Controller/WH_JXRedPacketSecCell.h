//
//  WH_JXRedPacketSecCell.h
//  Tigase
//
//  Created by 1111 on 2024/1/27.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXRedPacketSecCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *secField;

@property(nonatomic,copy)void(^textCountBlock)(NSString *count);
@property(nonatomic,copy)void(^longPressBlock)(void);

@end

NS_ASSUME_NONNULL_END
