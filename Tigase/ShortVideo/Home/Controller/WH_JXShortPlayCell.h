//
//  WH_JXShortPlayCell.h
//  Tigase
//
//  Created by 1111 on 2024/4/19.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXShortPlayCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIButton *playCountBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLab;

@end

NS_ASSUME_NONNULL_END
