//
//  WH_ShortVideoModel.h
//  Tigase
//
//  Created by 1111 on 2024/4/22.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_ShortVideoModel : NSObject
@property (nonatomic, copy) NSString        *album;
@property (nonatomic, assign) BOOL allowComment;
@property (nonatomic, copy) NSString        *artist;
@property (nonatomic, assign) BOOL collected;
@property (nonatomic, copy) NSString        *desc;
@property (nonatomic, copy) NSString        *hot;
@property (nonatomic, copy) NSString        *videoId;
@property (nonatomic, copy) NSString        *nickname;
@property (nonatomic, copy) NSString        *play;
@property (nonatomic, assign) BOOL praised;

@property (nonatomic, copy) NSString        *title;
@property (nonatomic, strong) NSNumber        *state;
@property (nonatomic, strong) NSNumber        *totalSeries;
@property (nonatomic, strong) NSNumber        *type;
@property (nonatomic, copy) NSString        *userId;


@end

NS_ASSUME_NONNULL_END

