//
//  WH_PayOrderCell.m
//  Tigase
//
//  Created by 1111 on 2023/12/19.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_PayOrderCell.h"

@implementation WH_PayOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 8.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)certainAction:(id)sender {
    
    NSDictionary *dict = [self dictionaryWithJsonString:self.msg.content];
    
    if(self.certainBlock){
        self.certainBlock([self.msg.type intValue] == 4001?1:0,[NSString stringWithFormat:@"%@",dict[@"tradeNo"]]);
    }
}

-(void)setMsg:(WH_JXMessageObject *)msg{
    _msg = msg;
    self.detaileLab.text = @"";
    self.certainBtn.hidden = YES;
    
    NSDateFormatter* f=[[NSDateFormatter alloc]init];
    [f setDateFormat:@"MM-dd HH:mm"];
    self.timeLab.text = [f stringFromDate:msg.timeSend];
    
    NSDictionary *dict = [self dictionaryWithJsonString:msg.content];
    
    if ([msg.type intValue] == 4000){//买方已下单
        
        self.titleLab.text = @"您有一笔出售订单，等待对方支付";
        self.detaileLab.text = @"买家正在向您转账，请注意查收";
        
    }else if ([msg.type intValue] == 4001){//订单已支付
        self.titleLab.text = @"买家已付款，请确认收款";
        self.certainBtn.hidden = NO;
        [self.certainBtn setTitle:@"确认 >" forState:UIControlStateNormal];
        
    }else if ([msg.type intValue] == 4002){//订单已确认收款
        self.titleLab.text = @"交易完成";
        self.detaileLab.text = [NSString stringWithFormat:@"订单 %@ 已经完成交易",dict[@"tradeNo"]];
        
    }else if ([msg.type intValue] == 4003){//订单超时，已取消
        
        self.titleLab.text = @"订单已被买家取消";
        self.certainBtn.hidden = NO;
        [self.certainBtn setTitle:@"查看详情 >" forState:UIControlStateNormal];
        
    }else if ([msg.type intValue] == 4004){
        self.titleLab.text = @"申诉中-客服已介入";
        self.certainBtn.hidden = NO;
        [self.certainBtn setTitle:@"查看详情 >" forState:UIControlStateNormal];
    }
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
