//
//  WH_JXBuyAndPayListModel.h
//  Tigase
//
//  Created by 1111 on 2024/1/3.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class WH_FinancialInfosModel;

@interface WH_JXBuyAndPayListModel : NSObject

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
@property(nonatomic,copy)NSString *avatar;//
@property(nonatomic,assign)BOOL online;//
@property(nonatomic,assign)BOOL isBuy;//是否是购买

@property(nonatomic,copy)NSString *count;//购买数量
@property(nonatomic,copy)NSString *sellCount;//代理商出售或者购买应得金额

@property(nonatomic,strong)NSArray *financialInfos;//代理商收款方式


@end




@interface WH_FinancialInfosModel : NSObject


@property(nonatomic,copy)NSString *accountName;//
@property(nonatomic,copy)NSString *accountNo;//
@property(nonatomic,copy)NSString *createTime;//
@property(nonatomic,copy)NSString *payId;//
@property(nonatomic,copy)NSString *qrCode;//
@property(nonatomic,copy)NSString *roomJid;//
@property(nonatomic,copy)NSString *status;//
@property(nonatomic,copy)NSString *telNumber;//
@property(nonatomic,copy)NSString *type;// 1.微信  2.支付宝  3银行卡
@property(nonatomic,copy)NSString *userId;//
@property(nonatomic,copy)NSString *priority;//

@property(nonatomic,assign)BOOL isChoose;//


@end

NS_ASSUME_NONNULL_END
