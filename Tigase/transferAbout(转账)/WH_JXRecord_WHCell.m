//
//  WH_JXRecord_WHCell.m
//  Tigase_imChatT
//
//  Created by 1 on 2019/4/20.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import "WH_JXRecord_WHCell.h"
#import "WH_JXRecordModel.h"

@interface WH_JXRecord_WHCell ()
@property (nonatomic, strong) UILabel *desc;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *money;
@property (nonatomic, strong) UILabel *status;

@end

@implementation WH_JXRecord_WHCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.desc = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 18)];
        self.desc.font = sysFontWithSize(15);
        [self.contentView addSubview:self.desc];
        
        self.time = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.desc.frame)+5, 100, 15)];
        self.time.font = sysFontWithSize(14);
        self.time.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.time];

        self.money = [[UILabel alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH-110, 10, 100, 18)];
        self.money.font = sysFontWithSize(15);
        self.money.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.money];

        self.status = [[UILabel alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH-110, CGRectGetMaxY(self.money.frame)+5, 100, 15)];
        self.status.font = sysFontWithSize(14);
        self.status.textColor = [UIColor grayColor];
        self.status.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.status];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 57.5, JX_SCREEN_WIDTH, .5)];
        line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [self.contentView addSubview:line];
    }
    return self;
}


- (void)setData:(WH_JXRecordModel *)model {
    self.desc.text = [self getTogetherType:model.type];
    self.money.text = [NSString stringWithFormat:@"%.2f",model.money];
    self.time.text = [self stringToDate:model.time withDateFormat:@"yyyy-MM-dd"];
    self.status.text = [self getPayType:model.status];
}

- (NSString *)getPayType:(int)status {
    NSString *str = [NSString string];
    if (status == 0) {
        str= Localized(@"JX_Create");
    }
    else if (status == 1) {
        str= Localized(@"JX_PayToComplete");
    }
    else if (status == 2) {
        str= Localized(@"JX_CompleteTheTransaction");
    }
    else if (status == -1) {
        str= Localized(@"JX_TradingClosed");
    }

    return str;
}


- (NSString *)getTogetherType:(NSInteger)type{
    
    switch (type) {
        case 1:  /// 用户充值
            {
                return Localized(@"New_user_recharge");
            }
            break;
        case 2:  /// 用户提现
            {
                return Localized(@"New_user_withdrawal");
            }
            break;
        case 3:  /// 后台充值
            {
                return Localized(@"New_background_recharge");
            }
            break;
        case 4:  /// 发红包
            {
                return Localized(@"New_red_envelopes");
            }
            break;
        case 5:  /// 领取红包
            {
                return Localized(@"New_receive_red_envelopes");
            }
            break;
        case 6:  /// 红包退款
            {
                return Localized(@"New_red_envelope_refund");
            }
            break;
        case 7:  /// 转账
            {
                return Localized(@"New_transfer");
            }
            break;
        case 8:  /// 接受转账
            {
                return Localized(@"New_accept_transfers");
            }
            break;
        case 9:  /// 转账退回
            {
                return Localized(@"New_transfer_back");
            }
            break;
        case 10:  /// 付款码付款
            {
                return Localized(@"New_payment_code_payment");
            }
            break;
        case 11:  /// 付款码收款
            {
                return Localized(@"New_payment_code_collection");
            }
            break;
        case 12:  /// 二维码收款 付款方
            {
                return Localized(@"New_qrcode_receipt_payer");
            }
            break;
        case 13:  /// 二维码收款 收款方
            {
                return Localized(@"New_qrcode_payment_recipient");
            }
            break;
        case 14:  /// 签到红包
            {
                return Localized(@"New_sign_red_envelope");
            }
            break;
        case 15:  /// 提现到后台审核
            {
                return Localized(@"New_withdraw_background_review");
            }
            break;
        case 16:  /// 提现到后台审核
            {
                return Localized(@"New_background_debit");
            }
            break;
        case 17:  /// 黑马充值
            {
                return Localized(@"New_dark_horse_recharge");
            }
            break;
        default:
        {
            return @"";
        }
            break;
    }
}


//字符串转日期格式
- (NSString *)stringToDate:(long)date withDateFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    NSDate*timeDate = [[NSDate alloc] initWithTimeIntervalSince1970:date];
    return [dateFormatter stringFromDate:timeDate];
}


@end
