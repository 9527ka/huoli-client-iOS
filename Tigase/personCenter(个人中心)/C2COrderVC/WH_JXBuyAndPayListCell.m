//
//  WH_JXBuyAndPayListCell.m
//  Tigase
//
//  Created by 1111 on 2024/1/2.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXBuyAndPayListCell.h"

@implementation WH_JXBuyAndPayListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImage.layer.cornerRadius = 4.0f;
    self.onlineLab.layer.cornerRadius = 6.0f;
    self.buyBtn.layer.cornerRadius = 14.0f;
    
}
- (IBAction)buyAction:(id)sender {
    if(self.buyBlock){
        self.buyBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(WH_JXBuyAndPayListModel *)model{
    _model = model;
    self.nameLab.text = model.name;

    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar_normal"]];
    self.onlineLab.hidden = !model.online;
    
    //创建收款方式
    [self.zfbBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < model.financialInfos.count; i++) {
        
        WH_FinancialInfosModel *payModel = model.financialInfos[i];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(92*i, 0, 80, 28)];
        bgView.backgroundColor = [UIColor systemGray6Color];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 4.0f;
        [self.zfbBgView addSubview:bgView];
        
        NSString *typeStr = @"";
        UIColor *lineColor = HEXCOLOR(0xf7984a);
        
        if(payModel.type.intValue == 1){//1.微信  2.支付宝  3银行卡
            lineColor = HEXCOLOR(0x23B525);
            typeStr = @"微信支付";
        }else if (payModel.type.intValue == 2){
            lineColor = HEXCOLOR(0x4174f2);
            typeStr = @"支付宝";
        }else if (payModel.type.intValue == 3){
            lineColor = HEXCOLOR(0xf7984a);
            typeStr = @"银行卡";
        }
        
        UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(4, 6, 3, 16)];
        lineLab.backgroundColor = lineColor;
        [bgView addSubview:lineLab];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 74, 28)];
        titleLab.text = typeStr;
        titleLab.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:titleLab];
    }
}

@end
