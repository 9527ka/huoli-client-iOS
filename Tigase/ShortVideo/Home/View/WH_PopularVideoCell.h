//
//  WH_PopularVideoCell.h
//  Tigase
//
//  Created by 1111 on 2024/4/11.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_PopularVideoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIButton *likeCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@property (nonatomic,copy)void(^chooseVideoBlock)(void);

@end

NS_ASSUME_NONNULL_END
