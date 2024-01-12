//
//  WH_JXOrderCertainVC.m
//  Tigase
//
//  Created by 1111 on 2024/1/10.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXOrderCertainVC.h"
#import "WH_JXChooseAccountVC.h"
#import "JXNavigation.h"
#import "WH_JXBuyAndPayListModel.h"

@interface WH_JXOrderCertainVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *detaileBgView;
@property (weak, nonatomic) IBOutlet UILabel *detaileLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UIButton *certainBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *zzView;

@property (nonatomic,strong)WH_JXChooseAccountVC *vc;

@property (nonatomic,strong)WH_FinancialInfosModel *payModel;

@end

@implementation WH_JXOrderCertainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.detaileBgView.layer.cornerRadius = 4.0f;
    self.bgView.layer.cornerRadius = 8.0f;
    self.certainBtn.layer.cornerRadius = 8.0f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAction)];
    [self.zzView addGestureRecognizer:tap];
    
    
    
}

-(void)setModel:(WH_JXBuyAndPayListModel *)model{
    _model = model;
}
-(void)setRoom:(WH_RoomData *)room{
    _room = room;
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    [self creatUI];
}

-(void)creatUI{
    NSString *titleStr = (self.model && !self.model.isBuy)?@"确认出售":@"确认购买";
    self.titleLab.text = titleStr;
    
    NSString *detaileStr = @"*请使用本人实名账户进行收款，否则会导致订单失败且账号存在被冻结风险";
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:detaileStr attributes:[NSMutableDictionary dictionary]];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(1, 13)];
    
    self.detaileLab.attributedText =  att;
    //数量
    self.countLab.text = self.room.count.intValue > 0?self.room.count:self.model.count;
    self.moneyLab.text = [NSString stringWithFormat:@"￥%.2f",self.room.count.intValue > 0?self.room.count.floatValue:self.model.sellCharge.floatValue];

    //收款账号 默认第一个
    WH_FinancialInfosModel *payModel = self.dataArray.firstObject;
    
    [self.certainBtn setTitle:(self.model && !self.model.isBuy)?@"卖出":@"购买" forState:UIControlStateNormal];
    
    self.payModel = payModel;
    
    [self setPayTypeShow];
}

-(void)setPayTypeShow{
    NSString *typeStr = @"";
    UIColor *lineColor = HEXCOLOR(0xf7984a);
    
    if(self.payModel.type.intValue == 1){//1.微信  2.支付宝  3银行卡
        lineColor = HEXCOLOR(0x23B525);
        typeStr = [NSString stringWithFormat:@"微信支付（%@） ›",self.payModel.accountNo];
    }else if (self.payModel.type.intValue == 2){
        lineColor = HEXCOLOR(0x4174f2);
        typeStr = [NSString stringWithFormat:@"支付宝（%@） ›",self.payModel.accountNo];
    }else if (self.payModel.type.intValue == 3){
        lineColor = HEXCOLOR(0xf7984a);
        typeStr = [NSString stringWithFormat:@"银行卡（%@） ›",self.payModel.accountNo];
    }
    
    self.lineLab.backgroundColor = lineColor;
    self.payTypeLab.text = typeStr;
}

-(void)hiddenAction{
    self.view.hidden = YES;
//    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, JX_SCREEN_HEIGHT, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
//    }];
}

- (IBAction)closeAction:(id)sender {
    [self hiddenAction];
}
//账号设置
- (IBAction)accountAction:(id)sender {
        
    self.vc.view.hidden = NO;
    self.vc.dataArray = self.dataArray;
    self.vc.payModel = self.payModel;
    self.vc.isMySelf = (self.model && !self.model.isBuy)?YES:NO;
//    [UIView animateWithDuration:0.1 animations:^{
        self.vc.view.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
//    }];
}
//确定按钮
- (IBAction)certainAction:(id)sender {
    if (self.certainBlock) {
        self.certainBlock(self.payModel);
    }
    [self hiddenAction];
}
-(WH_JXChooseAccountVC *)vc{
    if(!_vc){
        _vc = [[WH_JXChooseAccountVC alloc] init];
        _vc.view.frame = CGRectMake(0, JX_SCREEN_HEIGHT, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
        _vc.view.hidden = YES;
        __weak typeof (&*self)weakSelf = self;
        _vc.certainBlock = ^(WH_FinancialInfosModel * _Nonnull payModel) {
            weakSelf.payModel = payModel;
            [weakSelf setPayTypeShow];
        };
        [self.view addSubview:self.vc.view];
    }
    return _vc;
}


@end
