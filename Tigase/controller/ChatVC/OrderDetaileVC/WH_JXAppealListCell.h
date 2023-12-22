//
//  WH_JXAppealListCell.h
//  Tigase
//
//  Created by 1111 on 2023/12/22.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXAppealListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *picBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picBgViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;



@end

NS_ASSUME_NONNULL_END
