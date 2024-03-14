//
//  WH_JXFriendNew_WHCell.h
//  Tigase
//
//  Created by 1111 on 2024/3/13.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXFriendNew_WHCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *statueBtn;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic,strong) id target;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property(nonatomic,copy)void(^lookUserInfo)(void);

@property (nonatomic,strong) WH_JXFriendObject* user;

-(void)update;

@end

NS_ASSUME_NONNULL_END
