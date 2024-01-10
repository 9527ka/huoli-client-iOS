//
//  WH_JXNoticeModel.h
//  Tigase
//
//  Created by 1111 on 2024/1/10.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXNoticeModel : NSObject

@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,strong)NSNumber *type;

@end

NS_ASSUME_NONNULL_END
