//
//  WH_JXRecordTB_WHCell.h
//  Tigase_imChatT
//
//  Created by Apple on 16/9/6.
//  Copyright © 2016年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WH_JXRecordTB_WHCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *refundLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;


- (void)sp_getUserFollowSuccess;
@end
