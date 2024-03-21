//
//  JX_WHNoDataView.h
//  Tigase
//
//  Created by 1111 on 2024/3/21.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JX_WHNoDataView : UIView

@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UILabel *nodataTitle;
@property(nonatomic,strong)UIButton *commentBtn;
@property(nonatomic,copy)void(^commentBlock)(void);

@end

NS_ASSUME_NONNULL_END
