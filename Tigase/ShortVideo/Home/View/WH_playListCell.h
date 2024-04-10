//
//  WH_playListCell.h
//  Tigase
//
//  Created by 1111 on 2024/4/7.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_playListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *likeCount;

@end

NS_ASSUME_NONNULL_END
