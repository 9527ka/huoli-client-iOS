//
//  WH_JXSendRedPacket_WHViewController.m
//  Tigase_imChatT
//
//  Created by 1 on 17/8/14.
//  Copyright © 2019年 YanZhenKui. All rights reserved.
//

#import "WH_JXSendRedPacket_WHViewController.h"
#import "WH_JXTopSiftJobView.h"
#import "WH_JXRedInputView.h"
#import "WH_JXRecharge_WHViewController.h"
#import "WH_JXVerifyPay_WHVC.h"
#import "WH_JXPayPassword_WHVC.h"
#import "WH_SegmentSwitch.h"
#import "WH_RechargeVC.h"
#import "BindTelephoneChecker.h"

#import "WH_SelectReceiveRedPacket_ViewController.h"

//#define TopHeight 40

@interface WH_JXSendRedPacket_WHViewController ()<UITextFieldDelegate,UIScrollViewDelegate,RechargeDelegate>
@property (nonatomic, strong) WH_JXTopSiftJobView * topSiftView;

@property (nonatomic, strong) WH_JXRedInputView * luckyView;
@property (nonatomic, strong) WH_JXRedInputView * nomalView;
@property (nonatomic, strong) WH_JXRedInputView * orderView;
@property (nonatomic, strong) WH_JXRedInputView * exclusiveDiamondView;
@property (nonatomic, strong) WH_JXRedInputView * exclusiveView;//专属红包
@property (nonatomic, strong) WH_JXVerifyPay_WHVC * verVC;
@property (nonatomic, strong) NSArray * vcList;


@property (nonatomic, copy) NSString * moneyText;
@property (nonatomic, copy) NSString * countText;
@property (nonatomic, copy) NSString * greetText;

@property (nonatomic, assign) NSInteger indexInt;

@property (nonatomic, strong) WH_SegmentSwitch *redPacketSwitch;

@end

@implementation WH_JXSendRedPacket_WHViewController

-(instancetype)init{
    if (self = [super init]) {
        self.wh_isGotoBack = YES;
        self.wh_heightHeader = JX_SCREEN_TOP;
        self.wh_heightFooter = 0;
    }
    return self;
}

// 控制器生命周期方法(view加载完成)
- (void)viewDidLoad{
    [super viewDidLoad];
    [self createHeadAndFoot];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit:)];
    [self.wh_tableBody addGestureRecognizer:tap];

    if (_isRoom) {
        self.wh_tableBody.contentSize = CGSizeMake(self.isDiamond ? JX_SCREEN_WIDTH * 4 : JX_SCREEN_WIDTH * 3, self.wh_tableBody.frame.size.height);
    } else {
        self.wh_tableBody.contentSize = CGSizeMake(JX_SCREEN_WIDTH * 2, self.wh_tableBody.frame.size.height);
    }
    
    self.wh_tableBody.delegate = self;
    self.wh_tableBody.pagingEnabled = YES;
    self.wh_tableBody.showsHorizontalScrollIndicator = NO;
    self.wh_tableBody.backgroundColor = g_factory.globalBgColor;
    
    [self buildTopView];
    
    if(_isRoom){
        [self.wh_tableBody addSubview:self.luckyView];//手气红包
        [_luckyView.wh_sendButton addTarget:self action:@selector(WH_sendRedPacketWithMoneyNum:) forControlEvents:UIControlEventTouchUpInside];
        [_luckyView.wh_canclaimBtn addTarget:self action:@selector(wh_canCalimRedPacketPeopleNum:) forControlEvents:UIControlEventTouchUpInside];
        [_luckyView.wh_moneyTextField becomeFirstResponder];
    }
    if (self.isDiamond) {
        [self.wh_tableBody addSubview:self.exclusiveDiamondView];
        [_exclusiveDiamondView.wh_sendButton addTarget:self action:@selector(WH_sendRedPacketWithMoneyNum:) forControlEvents:UIControlEventTouchUpInside];
        [_exclusiveDiamondView.wh_canclaimBtn addTarget:self action:@selector(wh_canCalimRedPacketPeopleNum:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.wh_tableBody addSubview:self.orderView];//口令
    
    if(_isRoom){
        //专属红包
        [self.wh_tableBody addSubview:self.exclusiveView];//手气红包
        [_exclusiveView.wh_sendButton addTarget:self action:@selector(WH_sendRedPacketWithMoneyNum:) forControlEvents:UIControlEventTouchUpInside];
        [_exclusiveView.wh_canclaimBtn addTarget:self action:@selector(wh_canCalimRedPacketPeopleNum:) forControlEvents:UIControlEventTouchUpInside];
    }else{//不是群聊才有普通红包
        [self.wh_tableBody addSubview:self.nomalView];//普通
        [self.orderView.wh_moneyTextField becomeFirstResponder];
    }
   
    [_nomalView.wh_sendButton addTarget:self action:@selector(WH_sendRedPacketWithMoneyNum:) forControlEvents:UIControlEventTouchUpInside];
    [_nomalView.wh_canclaimBtn addTarget:self action:@selector(wh_canCalimRedPacketPeopleNum:) forControlEvents:UIControlEventTouchUpInside];
    
    [_orderView.wh_sendButton addTarget:self action:@selector(WH_sendRedPacketWithMoneyNum:) forControlEvents:UIControlEventTouchUpInside];
    [_orderView.wh_canclaimBtn addTarget:self action:@selector(wh_canCalimRedPacketPeopleNum:) forControlEvents:UIControlEventTouchUpInside];
    
    //判断是不是专属红包，是的话直接选中专属模块并赋值
    if(self.selectIds.count > 0){
        [self exclusiveData];
    }
}
//专属红包赋值
-(void)exclusiveData{
    
    self.redPacketSwitch.wh_currentIndex = self.isDiamond?1:2;
    self.indexInt = 4;
    self.wh_tableBody.contentOffset = CGPointMake(self.isDiamond?JX_SCREEN_WIDTH:JX_SCREEN_WIDTH * 2, 0);
    [self performSelector:@selector(setExclusiveData) withObject:nil afterDelay:0.2];
    
}
-(void)setExclusiveData{
    if(self.isDiamond){
        [_exclusiveDiamondView.wh_canClaimPeoples setTextColor:HEXCOLOR(0x333333)];
        NSString *name = [NSString stringWithFormat:@"%@",self.selectNames.firstObject];
        [_exclusiveDiamondView.wh_canClaimPeoples setText:name];
        _exclusiveDiamondView.wh_canClaimPeoples.alpha = 1;
        [_exclusiveDiamondView.receiveNoticeLabel setText:[NSString stringWithFormat:@"群人数%@人，已选定%lu人可领" ,self.memberCount ,(unsigned long)self.selectIds.count]];
        [_exclusiveDiamondView.wh_moneyTextField becomeFirstResponder];
    }else{
        [_exclusiveView.wh_canClaimPeoples setTextColor:HEXCOLOR(0x333333)];
        NSString *name = [NSString stringWithFormat:@"%@",self.selectNames.firstObject];
        [_exclusiveView.wh_canClaimPeoples setText:name];
        _exclusiveView.wh_canClaimPeoples.alpha = 1;
        [_exclusiveView.receiveNoticeLabel setText:[NSString stringWithFormat:@"群人数%@人，已选定%lu人可领" ,self.memberCount ,(unsigned long)self.selectIds.count]];
        [_exclusiveView.wh_moneyTextField becomeFirstResponder];
    }
   
}

- (void)buildTopView{
//    NSArray *titles = _isDiamond ? @[@"手气钻石", @"专属钻石", @"口令钻石", @"普通钻石"] : (_isRoom ? @[Localized(@"JX_LuckGift"),Localized(@"JX_MesGift"),Localized(@"JX_UsualGift")] : @[Localized(@"JX_MesGift"),Localized(@"JX_UsualGift")]);
    
    
    NSArray *titles = _isDiamond ? @[@"手气钻石", @"专属钻石", @"口令钻石"] : (_isRoom ? @[Localized(@"JX_LuckGift"),Localized(@"JX_MesGift"),@"专属红包"] : @[Localized(@"JX_MesGift"),Localized(@"JX_UsualGift")]);
    
    _vcList = _isDiamond ? @[self.luckyView, self.exclusiveDiamondView, self.orderView] : (_isRoom ? @[self.luckyView,self.orderView,self.exclusiveView] : @[self.orderView,self.nomalView]);
    
    if (self.isDiamond) {
//        _redPacketSwitch = [[WH_SegmentSwitch alloc] initWithFrame:CGRectMake(60, JX_SCREEN_TOP - 8 - 28, 256, 28) titles:titles slideColor:HEXCOLOR(0xED6350)];
        _redPacketSwitch = [[WH_SegmentSwitch alloc] initWithFrame:CGRectMake((JX_SCREEN_WIDTH - 192)/2, JX_SCREEN_TOP - 8 - 28, 192, 28) titles:titles slideColor:HEXCOLOR(0xED6350)];
        
        
    } else {
//        _redPacketSwitch = [[WH_SegmentSwitch alloc] initWithFrame:CGRectMake(_isRoom ? 92 : 110, JX_SCREEN_TOP - 8 - 28, _isRoom ? 192 : 155, 28) titles:titles slideColor:HEXCOLOR(0xED6350)];
        
        _redPacketSwitch = [[WH_SegmentSwitch alloc] initWithFrame:CGRectMake(_isRoom ? (JX_SCREEN_WIDTH -192)/2 : (JX_SCREEN_WIDTH -155)/2, JX_SCREEN_TOP - 8 - 28, _isRoom ? 192 : 155, 28) titles:titles slideColor:HEXCOLOR(0xED6350)];
        
    }
    [self.wh_tableHeader addSubview:_redPacketSwitch];

    __weak typeof(self) weakSelf = self;
    _redPacketSwitch.WH_onClickBtn = ^(NSInteger index) {
        [weakSelf checkAfterScroll:index];
    };
}

-(WH_JXRedInputView *)luckyView {
    if (!_luckyView) {
        _luckyView = [[WH_JXRedInputView alloc] initWithFrame:CGRectMake(0, 0, JX_SCREEN_WIDTH, self.wh_tableBody.contentSize.height) type:2 isRoom:_isRoom isDiamond:_isDiamond roomMemebers:self.memberCount delegate:self];
//        _luckyView.wh_countTextField.text = @"";
    }
    return _luckyView;
}
-(WH_JXRedInputView *)exclusiveView {
    if (!_exclusiveView) {
        _exclusiveView = [[WH_JXRedInputView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_orderView.frame), 0, JX_SCREEN_WIDTH, self.wh_tableBody.contentSize.height) type:4 isRoom:_isRoom isDiamond:_isDiamond roomMemebers:self.memberCount delegate:self];
    }
    return _exclusiveView;
}
-(WH_JXRedInputView *)exclusiveDiamondView {
    if (!_exclusiveDiamondView) {
        _exclusiveDiamondView = [[WH_JXRedInputView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_luckyView.frame), 0, JX_SCREEN_WIDTH, self.wh_tableBody.contentSize.height) type:4 isRoom:_isRoom isDiamond:_isDiamond roomMemebers:self.memberCount delegate:self];
    }
    return _exclusiveDiamondView;
}
-(WH_JXRedInputView *)nomalView {
    if (!_nomalView) {
        _nomalView = [[WH_JXRedInputView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_orderView.frame), 0, JX_SCREEN_WIDTH, self.wh_tableBody.contentSize.height) type:1 isRoom:_isRoom isDiamond:_isDiamond roomMemebers:self.memberCount delegate:self];
    }
    return _nomalView;
}
-(WH_JXRedInputView *)orderView {
    if (!_orderView) {
        _orderView = [[WH_JXRedInputView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.isDiamond ? _exclusiveDiamondView.frame : _luckyView.frame), 0, JX_SCREEN_WIDTH, self.wh_tableBody.contentSize.height) type:3 isRoom:_isRoom isDiamond:_isDiamond roomMemebers:self.memberCount delegate:self];
    }
    return _orderView;
}

-(WH_JXTopSiftJobView *)topSiftView{
    if (!_topSiftView) {
        _topSiftView = [[WH_JXTopSiftJobView alloc] initWithFrame:CGRectMake(0, JX_SCREEN_TOP, JX_SCREEN_WIDTH, 40)];
        _topSiftView.wh_delegate = self;
        _topSiftView.wh_isShowMoreParaBtn = NO;
        _topSiftView.wh_preferred = 0;
        NSArray * itemsArray;
        if (_isRoom) {
            itemsArray = [[NSArray alloc] initWithObjects:Localized(@"JX_LuckGift"),@"专属红包",Localized(@"JX_MesGift"), nil];
        }else{
            itemsArray = [[NSArray alloc] initWithObjects:Localized(@"JX_UsualGift"),Localized(@"JX_MesGift"), nil];
        }
        _topSiftView.wh_dataArray = itemsArray;
    }
    return _topSiftView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)topItemBtnClick:(UIButton *)btn{
    [self checkAfterScroll:(btn.tag-100)];
}

- (void)checkAfterScroll:(CGFloat)offsetX{
    [self.wh_tableBody setContentOffset:CGPointMake(offsetX*JX_SCREEN_WIDTH, 0) animated:YES];
    [self endEdit:nil];
}

-(void)endEdit:(UIGestureRecognizer *)ges{
    [_luckyView stopEdit];
    [_nomalView stopEdit];
    [_orderView stopEdit];
    [_exclusiveView stopEdit];
    [_exclusiveDiamondView stopEdit];
}

#pragma mark -------------ScrollDelegate----------------

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self endEdit:nil];
    int page = (int)(scrollView.contentOffset.x/JX_SCREEN_WIDTH);
    
    _redPacketSwitch.wh_currentIndex = page;
    
    WH_JXRedInputView *view = (WH_JXRedInputView *)self.vcList[page];
    [view.wh_moneyTextField becomeFirstResponder];
    
    [self.view endEditing:YES];
    
    
}

#pragma mark 选择能领取红包的人
- (void)wh_canCalimRedPacketPeopleNum:(UIButton *)button {
    NSLog(@"button.tag:%li" ,(long)button.tag);
    WH_SelectReceiveRedPacket_ViewController *selectVC = [[WH_SelectReceiveRedPacket_ViewController alloc] init];
    selectVC.roomId = self.wh_roomId;
    selectVC.roomData = self.room;
    selectVC.isExclusive = (button.tag == 4);
    [g_navigation pushViewController:selectVC animated:YES];
    [selectVC setSelectcClaimBlock:^(NSMutableArray * _Nonnull ids, NSMutableArray * _Nonnull names) {
        if (_selectIds) {
            [_selectIds removeAllObjects];
        }
        if (_selectNames) {
            [_selectNames removeAllObjects];
        }
        _selectIds = ids;
        _selectNames = names;
        
        NSString *ns = [names componentsJoinedByString:@"、"];
        if (button.tag == 1) {
            [_nomalView.wh_canClaimPeoples setText:ns];
            [_nomalView.wh_canClaimPeoples setTextColor:HEXCOLOR(0x333333)];
            _nomalView.wh_canClaimPeoples.alpha = 1;
            [_nomalView.receiveNoticeLabel setText:[NSString stringWithFormat:@"群人数%@人，已选定%lu人可领" ,self.memberCount ,(unsigned long)ids.count]];
        } else if (button.tag == 2) {
            [_luckyView.wh_canClaimPeoples setText:ns];
            [_luckyView.wh_canClaimPeoples setTextColor:HEXCOLOR(0x333333)];
            _luckyView.wh_canClaimPeoples.alpha = 1;
            [_luckyView.receiveNoticeLabel setText:[NSString stringWithFormat:@"群人数%@人，已选定%lu人可领" ,self.memberCount ,(unsigned long)ids.count]];
        } else if (button.tag == 3) {
            [_orderView.wh_canClaimPeoples setTextColor:HEXCOLOR(0x333333)];
            [_orderView.wh_canClaimPeoples setText:ns];
            _orderView.wh_canClaimPeoples.alpha = 1;
            [_orderView.receiveNoticeLabel setText:[NSString stringWithFormat:@"群人数%@人，已选定%lu人可领" ,self.memberCount ,(unsigned long)ids.count]];
        } else {
            if(self.isDiamond){
                [_exclusiveDiamondView.wh_canClaimPeoples setTextColor:HEXCOLOR(0x333333)];
                [_exclusiveDiamondView.wh_canClaimPeoples setText:ns];
                _exclusiveDiamondView.wh_canClaimPeoples.alpha = 1;
                [_exclusiveDiamondView.receiveNoticeLabel setText:[NSString stringWithFormat:@"群人数%@人，已选定%lu人可领" ,self.memberCount ,(unsigned long)ids.count]];
            }else{
                [_exclusiveView.wh_canClaimPeoples setTextColor:HEXCOLOR(0x333333)];
                [_exclusiveView.wh_canClaimPeoples setText:ns];
                _exclusiveView.wh_canClaimPeoples.alpha = 1;
                [_exclusiveView.receiveNoticeLabel setText:[NSString stringWithFormat:@"群人数%@人，已选定%lu人可领" ,self.memberCount ,(unsigned long)ids.count]];
            }
            
        }
    }];
}

-(void)WH_sendRedPacketWithMoneyNum:(UIButton *)button{
    //1是普通红包，2是手气红包，3是口令红包
    if (button.tag == 1) {
        _moneyText = _nomalView.wh_moneyTextField.text;
        _countText = _nomalView.wh_countTextField.text;
        _greetText = _nomalView.wh_greetTextField.text;
    } else if(button.tag == 2){
        _moneyText = _luckyView.wh_moneyTextField.text;
        _countText = _luckyView.wh_countTextField.text;
        _greetText = _luckyView.wh_greetTextField.text;
    } else if(button.tag == 3){
        _moneyText = _orderView.wh_moneyTextField.text;
        _countText = _orderView.wh_countTextField.text;
        _greetText = _orderView.wh_greetTextField.text;//口令
    } else if(button.tag == 4){//专属红包
        //判断是否有指定人
        if(_selectIds.count == 0){
            [g_server showMsg:@"请选择指定领取人"];
            return;
        }
        
        if(self.isDiamond){
            _moneyText = _exclusiveDiamondView.wh_moneyTextField.text;
            _countText = _exclusiveDiamondView.wh_countTextField.text;
            _greetText = _exclusiveDiamondView.wh_greetTextField.text;
        }else{
            _moneyText = _exclusiveView.wh_moneyTextField.text;
            _countText = _exclusiveView.wh_countTextField.text;
            _greetText = _exclusiveView.wh_greetTextField.text;
        }
       
    }
    if (_moneyText == nil || [_moneyText isEqualToString:@""]) {
        [g_App showAlert:self.isDiamond ? @"请输入钻石数量" : Localized(@"JX_InputGiftCount")];
        return;
    }
    
    if (!_isRoom) {
        _countText = @"1";
    }
    
    if (_isRoom && (_countText == nil|| [_countText isEqualToString:@""] || [_countText intValue] <= 0)) {
        [g_App showAlert:self.isDiamond ? @"请输入钻石个数" : Localized(@"JXGiftForRoomVC_InputGiftCount")];
        return;
    }
    
    if (([_moneyText doubleValue]/[_countText intValue]) < 0.01) {
        [g_App showAlert:self.isDiamond ? @"单个钻石必须大于0.01个" : Localized(@"JXRedPaket_001")];
        return;
    }
    NSString *purseMoney = [NSString stringWithFormat:@"%.2lf",g_App.myMoney];
    NSString *sendMoney = [NSString stringWithFormat:@"%.2lf",[_moneyText doubleValue]];
//    if ([sendMoney doubleValue] > [purseMoney doubleValue]) {
//        [g_App showAlert:Localized(@"JX_NotEnough") delegate:self tag:2000 onlyConfirm:NO];
//        return;
//    }
    
//    NSString *str = [NSString stringWithFormat:@"%@" ,g_config.maxSendRedPagesAmount];
        
    NSString *str = [NSString stringWithFormat:@"%ld" ,self.room.luckyRecPacketMax];
    
    if (_selectIds.count > 0) {
        str = [NSString stringWithFormat:@"%ld" ,self.room.exclusiveRedPacketMax];
    }
    
    NSString *maxSendMoney = IsStringNull(str)?@"1000":str;
    
    if(maxSendMoney.floatValue <= 0.00){
        maxSendMoney = @"10000";
    }
    
    if ([maxSendMoney doubleValue] >= [_moneyText doubleValue]&&[_moneyText doubleValue] > 0) {
        
        if (button.tag == 3 && [_greetText isEqualToString:@""]) {
            [g_App showAlert:Localized(@"JXGiftForRoomVC_InputGiftWord")];
            return;
        }
        //祝福语
        if ([_greetText isEqualToString:@""]) {
            _greetText = @"大吉大利 恭喜发财";
        }
        self.indexInt = button.tag;
        g_myself.isPayPassword = [g_default objectForKey:PayPasswordKey];
        if ([g_myself.isPayPassword boolValue]) {
            self.verVC = [WH_JXVerifyPay_WHVC alloc];
            self.verVC.type = self.isDiamond ? JXVerifyTypeSendDiamond : JXVerifyTypeSendReadPacket;
            self.verVC.wh_RMB = _moneyText;
            self.verVC.delegate = self;
            self.verVC.didDismissVC = @selector(WH_dismiss_WHVerifyPayVC);
            self.verVC.didVerifyPay = @selector(WH_didVerifyPay:);
            self.verVC = [self.verVC init];
            
            [self.view addSubview:self.verVC.view];
        } else {
            [BindTelephoneChecker checkBindPhoneWithViewController:self entertype:JXEnterTypeSendRedPacket];
        }
    }else{
//        [g_App showAlert:Localized(@"JX_InputMoneyCount")];
        [g_App showAlert:[NSString stringWithFormat:@"请输入0~%.2fHOTC" ,[maxSendMoney doubleValue]]];
    }
    
}

- (void)WH_didVerifyPay:(NSString *)sender {
    long time = (long)[[NSDate date] timeIntervalSince1970] + (g_server.timeDifference / 1000);
    NSString *secret = [self getSecretWithText:sender time:time];
    if (_selectIds.count > 0) {
        NSString *str = [_selectIds componentsJoinedByString:@","];
        [g_server WH_sendRedPacketV1WithMoneyNum:[_moneyText doubleValue] type:(int)self.indexInt count:[_countText intValue] greetings:_greetText roomJid:self.wh_roomJid toUserId:self.wh_toUserId toUserIds:str time:time secret:secret isDiamound:self.isDiamond toView:self];
    }else{
        if (self.isDiamond) {
            [g_server sendDiamond:self.wh_roomJid diamondNumber:self.moneyText count:self.countText type:self.indexInt greetings:self.greetText toUserId:self.wh_toUserId time:[NSString stringWithFormat:@"%ld", time] secret:secret toDelegate:self];
        } else {
            [g_server WH_sendRedPacketV1WithMoneyNum:[_moneyText doubleValue] type:(int)self.indexInt count:[_countText intValue] greetings:_greetText roomJid:self.wh_roomJid toUserId:self.wh_toUserId time:time secret:secret toView:self];
        }
    }
    

}

- (void)WH_dismiss_WHVerifyPayVC {
    [self.verVC.view removeFromSuperview];
    
}

//服务端返回数据
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if ([aDownload.action isEqualToString:wh_act_getUserMoeny]) {
        g_App.myMoney = [dict[@"balance"] doubleValue];
        if (g_App.myMoney <= 0) {
            [g_App showAlert:Localized(@"JX_NotEnough") delegate:self tag:2000 onlyConfirm:NO];
        }
    } else if ([aDownload.action isEqualToString:act_sendRedPacket] || [aDownload.action isEqualToString:wh_act_sendRedPacketV1] || [aDownload.action isEqualToString:act_diamond_send]) {
        NSMutableDictionary * muDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [muDict setObject:_greetText forKey:@"greet"];
        
        if (_selectIds.count > 0) {
            NSString *str = [_selectIds componentsJoinedByString:@","];
            [muDict setObject:str forKey:@"toUserIds"];
            
            NSString *name = [_selectNames componentsJoinedByString:@","];
            [muDict setObject:name forKey:@"toUserNames"];
        }
        
        if([aDownload.action isEqualToString:act_diamond_send]){
            [muDict setObject:@(1) forKey:@"isDiamound"];
        }else{
            [muDict setObject:@(0) forKey:@"isDiamound"];
        }
        
        [self WH_dismiss_WHVerifyPayVC];  // 销毁支付密码界面
        //成功创建红包，发送一条含红包Id的消息
        if (self.selectIds.count > 0) {
            if (_delegate && [_delegate respondsToSelector:@selector(sendReceiveRedPacketDelegate:)]) {
                [_delegate performSelector:@selector(sendReceiveRedPacketDelegate:) withObject:muDict];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(sendRedPacketDelegate:)]) {
                [_delegate performSelector:@selector(sendRedPacketDelegate:) withObject:muDict];
            }
        }
        [self actionQuit];
    }
//    else if ([aDownload.action isEqualToString:act_diamond_send]) {
//
//
//    }
}
#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    if ([aDownload.action isEqualToString:act_sendRedPacket] || [aDownload.action isEqualToString:wh_act_sendRedPacketV1] || [aDownload.action isEqualToString:act_diamond_send]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.verVC WH_clearUpPassword];
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

#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2000){
        if (buttonIndex == 1) {
            [self rechargeButtonAction];
        }
    }
}

//跳转充值界面
-(void)rechargeButtonAction{
//    WH_JXRecharge_WHViewController * rechargeVC = [[WH_JXRecharge_WHViewController alloc]init];
//    rechargeVC.rechargeDelegate = self;
//    rechargeVC.isQuitAfterSuccess = YES;
////    [g_window addSubview:rechargeVC.view];
//    [g_navigation pushViewController:rechargeVC animated:YES];
    
    if ([g_config.aliPayStatus integerValue] != 1 && [g_config.wechatPayStatus integerValue] != 1 && [g_config.yunPayStatus integerValue] != 1) {
        //aliPayStatus;  //支付宝充值状态 1:开启 2：关闭 wechatWithdrawStatus; //微信提现状态1：开启 2：关闭
        [GKMessageTool showText:Localized(@"New_temporarily_closed")];
        return;
        
    }else {
        
        WH_RechargeVC *rechargeVC = [[WH_RechargeVC alloc] init];
        [g_navigation pushViewController:rechargeVC animated:YES];
        
//        WH_Recharge_WHViewController *rechargeVC = [[WH_Recharge_WHViewController alloc] init];
//        [g_navigation pushViewController:rechargeVC animated:YES];
        
        //            WH_NewRecharge_WHViewController *rechargeVC = [[WH_NewRecharge_WHViewController alloc] init];
        //            [g_navigation pushViewController:rechargeVC animated:YES];
    }
    
}

#pragma mark - RechargeDelegate
-(void)rechargeSuccessed{
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    WH_JXRedInputView * inputView = (WH_JXRedInputView *)textField.superview.superview;
    if (textField.returnKeyType == UIReturnKeyDone) {
        [inputView stopEdit];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {//删除
        return YES;
    }
    WH_JXRedInputView * inputView = (WH_JXRedInputView *)textField.superview.superview;
    if (textField == inputView.wh_countTextField && [textField.text intValue] > 1000) {
        return NO;
    }
//    if (textField == inputView.moneyTextField) {
//        NSString * moneyStr = [textField.text stringByAppendingString:string];
//        if ([moneyStr floatValue] > 500.0f) {
//            return NO;
//        }
//    }
    if (textField == inputView.wh_greetTextField && range.length > 0 && range.location + string.length > 15) {
        NSString *textStr = [textField.text substringToIndex:range.location];
        NSString *str = [textStr stringByAppendingString:string];
        textField.text = [str substringToIndex:15];
        
        return NO;
    }
    return YES;
}

- (NSString *)getSecretWithText:(NSString *)text time:(long)time {
    NSMutableString *str1 = [NSMutableString string];
    [str1 appendString:APIKEY];
    [str1 appendString:[NSString stringWithFormat:@"%ld",time]];
    [str1 appendString:[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:[_moneyText doubleValue]]]];
    str1 = [[g_server WH_getMD5StringWithStr:str1] mutableCopy];
    
    [str1 appendString:g_myself.userId];
    [str1 appendString:g_server.access_token];
    NSMutableString *str2 = [NSMutableString string];
    str2 = [[g_server WH_getMD5StringWithStr:text] mutableCopy];
    [str1 appendString:str2];
    str1 = [[g_server WH_getMD5StringWithStr:str1] mutableCopy];
    
    return [str1 copy];

}


- (void)sp_getMediaData:(NSString *)isLogin {
    NSLog(@"Get User Succrss");
}
@end
