//
//  WH_JXRecordCodeModel.h
//  Tigase
//
//  Created by 1111 on 2024/3/1.
//  Copyright © 2024 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXRecordCodeModel : NSObject

@property(nonatomic,strong)NSNumber *contextType;
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,strong)NSNumber *endMoney;
@property(nonatomic,strong)NSNumber *endTime;
@property(nonatomic,strong)NSNumber *toUserId;
@property(nonatomic,copy)NSString *billId;
@property(nonatomic,strong)NSNumber *money;
@property(nonatomic,strong)NSNumber *orderTime;
@property(nonatomic,strong)NSNumber *payType;
@property(nonatomic,strong)NSNumber *startMoney;
@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,strong)NSNumber *time;
@property(nonatomic,copy)NSString *tradeNo;
@property(nonatomic,strong)NSNumber *type;//type  类型  1:用户充值, 2:用户提现, 3:后台充值, 4:发红包, 5:领取红包,6:红包退款  7:转账   8:接受转账   9:转账退回   10:付款码付款 11:付款码到账   12:二维码付款  13:二维码到账  14:第三方调取IM支付通知
@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,copy)NSString *participantName;//对方昵称
@property(nonatomic,copy)NSString *referenceData;// 4:发红包:5:领取红包 6:红包退款 表示红包类型1普通红包2手气红包3口令红包4专属红包(原红包没有这个类型,这里是为了显示端方便判断,加了一个４返回)

@property(nonatomic,copy)NSString *referenceId;//红包id


@end

NS_ASSUME_NONNULL_END

