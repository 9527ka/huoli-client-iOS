//
//  WH_JXRoomDiamoundRechargeVC.m
//  Tigase
//
//  Created by 1111 on 2024/1/12.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXRoomDiamoundRechargeVC.h"
#import "WH_JXRoomDiamoundRechargeModel.h"
#import "WH_JXVerifyPay_WHVC.h"
#import "BindTelephoneChecker.h"

@interface WH_JXRoomDiamoundRechargeVC (){
    ATMHud *_wait;
}
@property (weak, nonatomic) IBOutlet UILabel *shouldPayTitle;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (strong, nonatomic) UIButton *selectBtn;

@property (strong, nonatomic) NSArray *titleArray;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeightConstint;

@property (strong, nonatomic)WH_JXRoomDiamoundRechargeModel *model;
@property (nonatomic, strong) WH_JXVerifyPay_WHVC * verVC;
@property (weak, nonatomic) IBOutlet UILabel *noticeLab;

@end

@implementation WH_JXRoomDiamoundRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _wait = [ATMHud sharedInstance];
    
    //获取充值列表
    [g_server WH_Roomlevel_listWithRoomJid:self.wh_room.roomJid toView:self];
    
}

-(void)creatUI{
    
    self.bgViewHeightConstint.constant = 60*self.titleArray.count + 60;
    self.rechargeBtn.layer.cornerRadius = 8.0f;
        
    for (int i = 0; i < self.titleArray.count; i++) {
        WH_JXRoomDiamoundRechargeModel *model = self.titleArray[i];
        UIButton *btn = (UIButton *)[self creatBtnWithModel:model tag:i];
        btn.frame = CGRectMake(16, 72*i, JX_SCREEN_WIDTH-32, 60);
        btn.tag = i + 300;
        [self.bgView addSubview:btn];
                
        if((model.level.intValue == self.wh_room.level && self.wh_room.level > 0) || (i==0 && self.wh_room.level==0)){
            self.model = model;
            UIButton *selectBtn = (UIButton *)[btn viewWithTag:666];
            selectBtn.selected = YES;
            self.selectBtn = selectBtn;
            self.shouldPayTitle.text = [NSString stringWithFormat:@"应付：%@ 元",self.model.subPrice];
            
        }
    }
}

- (void)countChooseAction:(UIButton *)sender {
    //判断当前等级是否低于现有等级
    WH_JXRoomDiamoundRechargeModel *selectModel = self.titleArray[sender.tag - 300];
    if(selectModel.level.integerValue < self.wh_room.level){
        [g_server showMsg:@"不能选择低于当前等级类型哦~"];
        return;
    }
    
    self.selectBtn.selected = NO;
    
    UIButton *selectBtn = (UIButton *)[sender viewWithTag:666];
    selectBtn.selected = YES;
    self.selectBtn = selectBtn;
    
    self.model = self.titleArray[sender.tag - 300];
    self.shouldPayTitle.text = [NSString stringWithFormat:@"应付：%@ 元",self.model.subPrice];
    self.noticeLab.text = [NSString stringWithFormat:self.model.level.intValue > self.wh_room.level?@"升级成功之后，时效为30天":@"续费成功之后，时效新增30天"];
}

-(UIButton *)creatBtnWithModel:(WH_JXRoomDiamoundRechargeModel *)model tag:(NSInteger)tag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(countChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = g_factory.cardCornerRadius;
    btn.layer.borderWidth = g_factory.cardBorderWithd;
    btn.layer.borderColor = g_factory.cardBorderColor.CGColor;
    
    UILabel *leverLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, 60)];
    leverLab.font = [UIFont systemFontOfSize:14];
    leverLab.text = [NSString stringWithFormat:@"%@(额度：%@ 钻石)",model.name,model.quotaValue];
    [btn addSubview:leverLab];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:[UIImage imageNamed:@"WH_addressbook_selected"] forState:UIControlStateSelected];
    [selectBtn setImage:[UIImage imageNamed:@"WH_addressbook_unselected"] forState:UIControlStateNormal];
    selectBtn.tag = 666;
    selectBtn.frame = CGRectMake(JX_SCREEN_WIDTH - 60 - 16, 0, 60, 60);
    selectBtn.userInteractionEnabled = NO;
    [btn addSubview:selectBtn];
    
    
    return btn;
    
}

- (IBAction)goBackAction:(id)sender {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
//立即充值
- (IBAction)rechargeAction:(id)sender {
    if(self.model.level.integerValue < self.wh_room.level){
        [g_server showMsg:@"不能选择低于当前等级类型哦~"];
        return;
    }
//输入密码
    //输入密码
    g_myself.isPayPassword = [g_default objectForKey:PayPasswordKey];
    if ([g_myself.isPayPassword boolValue]) {
        self.verVC = [WH_JXVerifyPay_WHVC alloc];
        self.verVC.type = JXVerifyTypeGroupManager;
        self.verVC.wh_RMB = self.model.subPrice;
        self.verVC.delegate = self;
        self.verVC.didDismissVC = @selector(WH_dismiss_WHVerifyPayVC);
        self.verVC.didVerifyPay = @selector(WH_didVerifyPay:);
        self.verVC = [self.verVC init];
        
        [self.view addSubview:self.verVC.view];
    } else {
        [BindTelephoneChecker checkBindPhoneWithViewController:self entertype:JXEnterTypeSendRedPacket];
    }
}
- (void)WH_didVerifyPay:(NSString *)sender{
    
    long time = (long)[[NSDate date] timeIntervalSince1970] + (g_server.timeDifference / 1000);
    
    NSString *secret = [self getSecretWithText:sender time:time];
    
    [g_server WH_RoomRenewalWithRoomJid:self.wh_room.roomJid amount:self.model.subPrice secret:secret level:self.model.level time:[NSString stringWithFormat:@"%ld", time] isActive:self.wh_room.level ==0?YES:NO toView:self];
}
- (NSString *)getSecretWithText:(NSString *)text time:(long)time {
    NSMutableString *str1 = [NSMutableString string];
    [str1 appendString:APIKEY];
    [str1 appendString:[NSString stringWithFormat:@"%ld",time]];
    [str1 appendString:[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:[self.model.subPrice doubleValue]]]];
    str1 = [[g_server WH_getMD5StringWithStr:str1] mutableCopy];
    
    [str1 appendString:g_myself.userId];
    [str1 appendString:g_server.access_token];
    NSMutableString *str2 = [NSMutableString string];
    str2 = [[g_server WH_getMD5StringWithStr:text] mutableCopy];
    [str1 appendString:str2];
    str1 = [[g_server WH_getMD5StringWithStr:str1] mutableCopy];
    
    return [str1 copy];

}

- (void)WH_dismiss_WHVerifyPayVC {
    [self.verVC.view removeFromSuperview];
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];

    if([aDownload.action isEqualToString:wh_room_active] || [aDownload.action isEqualToString:wh_room_renewal]){
        //移除掉密码界面
        [self WH_dismiss_WHVerifyPayVC];
        [g_server showMsg:@"操作成功"];
//        expiryTime  过期时间
//        level        群的级别
//        quota       群的额度
//        ownerMemberBalance   群主的群中额度
        
//        NSDictionary *dataDic = [dict objectForKey:@"data"];
        
        self.wh_room.expiryTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"expiryTime"]];
        self.wh_room.level = [NSString stringWithFormat:@"%@",[dict objectForKey:@"level"]].intValue;
        self.wh_room.quota = [NSString stringWithFormat:@"%@",[dict objectForKey:@"quota"]];
        self.wh_room.amount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ownerMemberBalance"]];
        self.wh_room.currentTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"currentTime"]];
        
        [g_navigation WH_dismiss_WHViewController:self animated:YES];
        
    }else if ([aDownload.action isEqualToString:wh_room_leveList]){//列表
        self.titleArray = [NSMutableArray arrayWithArray:[WH_JXRoomDiamoundRechargeModel mj_objectArrayWithKeyValuesArray:array1]];
        //创建UI
        [self creatUI];
    }
}

#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
   [_wait stop];
   return WH_show_error;
}

#pragma mark - 请求出错回调
-(int)WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error {//error为空时，代表超时
   [_wait stop];
   return WH_show_error;
}

#pragma mark - 开始请求服务器回调
-(void)WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload {
      [_wait start];
}


@end
