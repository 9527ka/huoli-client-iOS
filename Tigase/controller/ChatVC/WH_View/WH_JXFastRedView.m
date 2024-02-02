//
//  WH_JXFastRedView.m
//  Tigase
//
//  Created by 1111 on 2024/2/1.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXFastRedView.h"
#import "WH_JXFastRedSetVC.h"
#import "WH_FastRedModel.h"
#import "WH_JXVerifyPay_WHVC.h"
#import "BindTelephoneChecker.h"

@interface WH_JXFastRedView(){
    ATMHud *_wait;
}
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *zzView;
@property(nonatomic,strong)UIView *greatBgView;
@property (nonatomic,strong)UILabel *remarkTitleLab;
@property (nonatomic,strong)UITextField *greetsField;
@property (nonatomic,strong)UIButton *changeBtn;
@property (nonatomic,strong)UIButton *sendBtn;
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic, strong) WH_JXVerifyPay_WHVC * verVC;

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIImageView *iconImage;


@end

@implementation WH_JXFastRedView

-(instancetype)init{
    self = [super init];
    if(self){
        _wait = [ATMHud sharedInstance];
        self.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
        [self makeUI];
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.cornerRadius = 8.0f;
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self.greetsField becomeFirstResponder];
        //更改随机数
        [self setGreetContent];
    }
    return self;
}
-(void)setRoom:(WH_RoomData *)room{
    _room = room;
}
-(void)makeUI{
    [self addSubview:self.zzView];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.closeBtn];
    [self.bgView addSubview:self.titleLab];
    [self.bgView addSubview:self.iconImage];
    [self.bgView addSubview:self.greatBgView];
    [self.greatBgView addSubview:self.remarkTitleLab];
    [self.greatBgView addSubview:self.greetsField];
    [self.bgView addSubview:self.changeBtn];
    [self.bgView addSubview:self.sendBtn];
    
    [self.zzView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-40);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(240);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.bgView);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.closeBtn).offset(26);
        make.centerX.equalTo(self.bgView).offset(12);
    }];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab);
        make.centerX.equalTo(self.bgView).offset(-28);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(44);
    }];
        
    [self.greatBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(16);
        make.right.equalTo(self.bgView).offset(-16);
        make.top.equalTo(self.bgView).offset(76);
        make.height.mas_equalTo(44);
    }];
    [self.remarkTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.greatBgView);
        make.left.equalTo(self.greatBgView).offset(20);
    }];
    [self.greetsField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.greatBgView);
        make.right.equalTo(self.greatBgView).offset(-20);
        make.width.mas_equalTo(160);
    }];
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.bgView).offset(-12);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(42);
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.greatBgView.mas_bottom).offset(24);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(160);
    }];
}

-(UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc] init];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 8.0f;
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderColor = g_factory.cardBorderColor.CGColor;
        _bgView.layer.borderWidth = 0.5f;
    }
    return _bgView;
}
-(UIView *)zzView{
    if(!_zzView){
        _zzView = [[UIView alloc] init];
        _zzView.alpha = 0.4;
        _zzView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAction)];
        [_zzView addGestureRecognizer:tap];
    }
    return _zzView;
}
-(void)hiddenAction{
    [self removeFromSuperview];
}
-(UIButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"WH_CloseBtn"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(hiddenAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
-(UIView *)greatBgView{
    if(!_greatBgView){
        _greatBgView = [[UIView alloc] init];
        _greatBgView.layer.masksToBounds = YES;
        _greatBgView.layer.cornerRadius = 8.0f;
        _greatBgView.layer.borderColor = g_factory.cardBorderColor.CGColor;
        _greatBgView.layer.borderWidth = 0.5f;
    }
    return _greatBgView;
}
-(UILabel *)remarkTitleLab{
    if(!_remarkTitleLab){
        _remarkTitleLab = [[UILabel alloc] init];
        _remarkTitleLab.font = [UIFont systemFontOfSize:14];
        _remarkTitleLab.text = @"留言：";
        _remarkTitleLab.textColor = [UIColor blackColor];
    }
    return _remarkTitleLab;
}
-(UITextField *)greetsField{
    if(!_greetsField){
        _greetsField = [[UITextField alloc] init];
        _greetsField.font = [UIFont systemFontOfSize:14];
        _greetsField.textColor = [UIColor blackColor];
        _greetsField.placeholder = @"恭喜发财 大吉大利";
        _greetsField.textAlignment = NSTextAlignmentRight;
    }
    return _greetsField;
}
-(UIButton *)changeBtn{
    if(!_changeBtn){
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setTitle:@"设置" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_changeBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
        _changeBtn.layer.masksToBounds = YES;
        _changeBtn.layer.cornerRadius = 14.0f;
        _changeBtn.layer.borderColor = [UIColor systemBlueColor].CGColor;
        _changeBtn.layer.borderWidth = 0.5f;
    }
    return _changeBtn;
}
-(void)changeAction:(UIButton *)sender{
    WH_JXFastRedSetVC *vc = [[WH_JXFastRedSetVC alloc] init];
    [g_navigation pushViewController:vc animated:YES];
    
    [self removeFromSuperview];
}
-(UIButton *)sendBtn{
    if(!_sendBtn){
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送红包" forState:UIControlStateNormal];
//        _sendBtn.backgroundColor = HEXCOLOR(0xFF4C28);
        _sendBtn.backgroundColor = [UIColor systemBlueColor];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 8.0f;
    }
    return _sendBtn;
}
-(UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.text = @"极速红包";
        _titleLab.textColor = [UIColor blackColor];
    }
    return _titleLab;
}
-(UIImageView *)iconImage{
    if(!_iconImage){
        _iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redpack_small"]];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImage;
}

-(void)sendAction:(UIButton *)senders{
    //判断需不需要密码
    WH_FastRedModel *model = [JXServer receiveFastRed];
    if(model.isNoPas.boolValue){
        NSString *payPass = [NSString stringWithFormat:@"%@",model.passWord];
        [self sendRedPackWithPass:payPass];
    }else{
        g_myself.isPayPassword = [g_default objectForKey:PayPasswordKey];
        if ([g_myself.isPayPassword boolValue]) {
            self.verVC = [WH_JXVerifyPay_WHVC alloc];
            self.verVC.type =  JXVerifyTypeSendReadPacket;
            self.verVC.wh_RMB = model.amount;
            self.verVC.delegate = self;
            self.verVC.didDismissVC = @selector(WH_dismiss_WHVerifyPayVC);
            self.verVC.didVerifyPay = @selector(WH_didVerifyPay:);
            self.verVC = [self.verVC init];
            
            [self addSubview:self.verVC.view];
        } else {
            [g_server showMsg:@"请先设置支付密码"];
        }
    }
    
}
- (void)WH_dismiss_WHVerifyPayVC {
    [self.verVC.view removeFromSuperview];
    
}
- (void)WH_didVerifyPay:(NSString *)sender {

    [self sendRedPackWithPass:sender];
    
   
}
-(void)sendRedPackWithPass:(NSString *)pass{
    self.sendBtn.userInteractionEnabled = NO;
    
    long time = (long)[[NSDate date] timeIntervalSince1970] + (g_server.timeDifference / 1000);
    WH_FastRedModel *model = [JXServer receiveFastRed];
//    NSString *payPass = [NSString stringWithFormat:@"%@",model.passWord];
    NSString *secret = [self getSecretWithText:pass time:time];
   
    ////1是普通红包，2是手气红包，3是口令红包
    [g_server WH_sendRedPacketV1WithMoneyNum:[model.amount doubleValue] type:2 count:[model.count intValue] greetings:self.greetsField.text.length > 0?self.greetsField.text:self.greetsField.placeholder roomJid:self.room.roomJid toUserId:nil time:time secret:secret toView:self];
}
- (NSString *)getSecretWithText:(NSString *)text time:(long)time {
    WH_FastRedModel *model = [JXServer receiveFastRed];
    NSMutableString *str1 = [NSMutableString string];
    [str1 appendString:APIKEY];
    [str1 appendString:[NSString stringWithFormat:@"%ld",time]];
    [str1 appendString:[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:[model.amount doubleValue]]]];
    str1 = [[g_server WH_getMD5StringWithStr:str1] mutableCopy];
    
    [str1 appendString:g_myself.userId];
    [str1 appendString:g_server.access_token];
    NSMutableString *str2 = [NSMutableString string];
    str2 = [[g_server WH_getMD5StringWithStr:text] mutableCopy];
    [str1 appendString:str2];
    str1 = [[g_server WH_getMD5StringWithStr:str1] mutableCopy];
    
    return [str1 copy];

}
//服务端返回数据
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
     if ([aDownload.action isEqualToString:act_sendRedPacket] || [aDownload.action isEqualToString:wh_act_sendRedPacketV1] || [aDownload.action isEqualToString:act_diamond_send]) {
        NSMutableDictionary * muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
         WH_FastRedModel *model = [JXServer receiveFastRed];
         model.greet = self.greetsField.text.length > 0?self.greetsField.text:self.greetsField.placeholder;
         [JXServer setFastRedWithDic:model.mj_keyValues];
         
        [muDict setObject:self.greetsField.text.length > 0?self.greetsField.text:self.greetsField.placeholder forKey:@"greet"];
         [muDict setObject:@(0) forKey:@"isDiamound"];
         
         [self WH_dismiss_WHVerifyPayVC];
         
        //成功创建红包，发送一条含红包Id的消息
         if (_delegate && [_delegate respondsToSelector:@selector(sendRedPacketDelegate:)]) {
             [_delegate performSelector:@selector(sendRedPacketDelegate:) withObject:muDict];
         }
         
         [self.sendBtn setTitle:@"红包冷却中..." forState:UIControlStateNormal];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(model.timeInter.floatValue * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             // 让选中的item位于中间
            [self.sendBtn setTitle:@"发送红包" forState:UIControlStateNormal];
             self.sendBtn.userInteractionEnabled = YES;
         });
         [g_server showMsg:@"发送成功"];
         
         //更改随机数
         [self setGreetContent];
         
         [self hiddenAction];
    }

}
-(void)setGreetContent{
    //判断是什么类型的留言方式
    WH_FastRedModel *model = [JXServer receiveFastRed];
    self.greetsField.placeholder = @"恭喜发财 大吉大利";
    //随机 固定 循环
    if(model.isRandow.boolValue){
        //设置随机位数
        NSString *remark = [self receiveRandowWithCount:model.randowCount];
        self.greetsField.placeholder = remark;
        
    }else if (model.isRmarkOn.boolValue){//固定
        self.greetsField.placeholder = model.remark;
    }else if (model.isCirclekOn.boolValue){//循环
        NSArray *array = [model.circle componentsSeparatedByString:@"/"];
        NSInteger index = 0;
        for (int i = 0; i < array.count; i++) {
            NSString *content = array[i];
            if([content isEqualToString:model.greet]){
                index = i;
                break;
            }
        }
        if(array.count > index + 1){
            index = index + 1;
        }
        if(index == array.count - 1){
            index = 0;
        }
        NSString *remark = [NSString stringWithFormat:@"%@",array[index]];
        self.greetsField.placeholder = remark;
        
    }
    [self.greetsField becomeFirstResponder];
}
-(NSString *)receiveRandowWithCount:(NSString *)count{
    int numDigits = count.intValue; // 可以修改这个值来设置随机数的位数
    // 创建并初始化数字数组
    NSMutableArray *digits = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        [digits addObject:@(i)];
    }
    
    // 使用Fisher-Yates洗牌算法打乱数组
    digits = [self shuffleArrayWithArray:digits];
    
    // 构建随机数
    NSMutableString *randomNumber = [NSMutableString stringWithCapacity:numDigits];
    for (int i = 0; i < numDigits; i++) {
        [randomNumber appendString:[[digits objectAtIndex:i] stringValue]];
    }
    
    NSLog(@"Generated unique random number: %@", randomNumber);
    return randomNumber;
}
-(NSMutableArray *)shuffleArrayWithArray:(NSMutableArray *)array{
    NSUInteger count = array.count;
    for (NSUInteger i = count - 1; i > 0; i--) {
        NSUInteger n = arc4random_uniform((u_int32_t)i + 1);
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return array;
}
#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    if ([aDownload.action isEqualToString:act_sendRedPacket] || [aDownload.action isEqualToString:wh_act_sendRedPacketV1] || [aDownload.action isEqualToString:act_diamond_send]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        });
    }
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    return WH_show_error;
}
#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    [_wait start];
}

@end
