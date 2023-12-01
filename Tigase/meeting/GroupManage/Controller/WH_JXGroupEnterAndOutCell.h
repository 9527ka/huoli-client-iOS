//
//  WH_JXGroupEnterAndOutCell.h
//  Tigase
//
//  Created by luan on 2023/7/8.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXGroupEnterAndOutCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *operatorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *memberImage;//被邀请人头像
@property (weak, nonatomic) IBOutlet UIImageView *operatorImage;//邀请人头像

@end

NS_ASSUME_NONNULL_END
