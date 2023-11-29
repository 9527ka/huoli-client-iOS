//
//  WH_JXGroupDiamondCell.h
//  Tigase
//
//  Created by luan on 2023/5/31.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WH_JXGroupDiamondCell_Delegate <NSObject>

- (void)updateDiamondNumber:(NSInteger)row type:(NSInteger)type;

@end

@interface WH_JXGroupDiamondCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *medalIcon;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *diamondLabel;
@property (weak, nonatomic) id<WH_JXGroupDiamondCell_Delegate>delegate;

@end

NS_ASSUME_NONNULL_END
