//
//  WH_JXOrderListCell.h
//  Tigase
//
//  Created by 1111 on 2023/12/21.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXOrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *buyTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *statueLab;

@end

NS_ASSUME_NONNULL_END
