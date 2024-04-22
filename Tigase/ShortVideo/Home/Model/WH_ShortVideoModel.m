//
//  WH_ShortVideoModel.m
//  Tigase
//
//  Created by 1111 on 2024/4/22.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_ShortVideoModel.h"

@implementation WH_ShortVideoModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"videoId":@"id"};
}

@end
