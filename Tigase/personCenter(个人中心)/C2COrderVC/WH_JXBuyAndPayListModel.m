//
//  WH_JXBuyAndPayListModel.m
//  Tigase
//
//  Created by 1111 on 2024/1/3.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXBuyAndPayListModel.h"

@implementation WH_JXBuyAndPayListModel

// 在.m文件里面添加
+(NSDictionary *)mj_objectClassInArray {
    return @{
              @"financialInfos" : @"WH_FinancialInfosModel"
             };
}

@end



@implementation WH_FinancialInfosModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"payId" : @"id"};
}

@end
