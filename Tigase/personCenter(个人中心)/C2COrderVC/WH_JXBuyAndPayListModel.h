//
//  WH_JXBuyAndPayListModel.h
//  Tigase
//
//  Created by 1111 on 2024/1/3.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXBuyAndPayListModel : NSObject

@property(nonatomic,copy)NSString *alipayCode;//支付宝收款码
@property(nonatomic,copy)NSString *buyCharge;//买币手续费百分比
@property(nonatomic,copy)NSString *createTime;//创建时间,单位毫秒
@property(nonatomic,copy)NSString *id;//主键ID
@property(nonatomic,copy)NSString *name;//商户名称
@property(nonatomic,copy)NSString *score;//商户信誉分
@property(nonatomic,copy)NSString *sellCharge;//卖币手续费百分比
@property(nonatomic,copy)NSString *status;//状态,1 表示正常,返回到前端的都是1,都 应该是正常的,前端不用关注此栏位
@property(nonatomic,copy)NSString *userId;//商户的IM中用户ID
@property(nonatomic,copy)NSString *sellVolume;//销售成交量
@property(nonatomic,copy)NSString *buyVolume;//购买 成交量
@property(nonatomic,copy)NSString *wechatCode;//微信收款码
@property(nonatomic,copy)NSString *avatar;//
@property(nonatomic,assign)BOOL online;//
@property(nonatomic,assign)BOOL isBuy;//是否是购买


@end

NS_ASSUME_NONNULL_END
