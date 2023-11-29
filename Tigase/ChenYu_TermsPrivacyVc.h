//
//  ChenYu_TermsPrivacyVc.h
//  YiNiao_im
//
//  Created by os on 2021/1/11.
//  Copyright © 2021 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(UIButton *sender);
NS_ASSUME_NONNULL_BEGIN

@interface ChenYu_TermsPrivacyVc : UIView
+(instancetype)XIBChenYu_TermsPrivacyVc;
 

@property (nonatomic,copy) ButtonBlock blockBtn;
@end

NS_ASSUME_NONNULL_END
