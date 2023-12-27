//
//  WH_JXOrderDetaileVC.m
//  Tigase
//
//  Created by 1111 on 2023/12/20.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXOrderDetaileVC.h"
#import "WH_JXAppealListVC.h"
#import "WH_JXAppealAddVC.h"

@interface WH_JXOrderDetaileVC ()
@property (weak, nonatomic) IBOutlet UILabel *statueTitle;
@property (weak, nonatomic) IBOutlet UILabel *detaileLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLab;
@property (weak, nonatomic) IBOutlet UILabel *buyerNameLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLab;
@property (weak, nonatomic) IBOutlet UIButton *blackBtn;
@property (weak, nonatomic) IBOutlet UIButton *appealBtn;
@property(nonatomic,strong) WH_JXUserObject *wh_user;
@property (weak, nonatomic) IBOutlet UIButton *detaileBtn;

@end

@implementation WH_JXOrderDetaileVC

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [g_notify addObserver:self selector:@selector(newReceipt:) name:kXMPPReceipt_WHNotifaction object:nil];
    
    self.blackBtn.layer.cornerRadius = 4.0f;
    self.appealBtn.layer.cornerRadius = 4.0f;
    
    NSString *userId = [NSString stringWithFormat:@"%@",self.dict[@"payerUID"]];
    if([userId isEqualToString:MY_USER_ID]){
        userId = [NSString stringWithFormat:@"%@",self.dict[@"payeeUID"]];
    }
    
    //查看好友状态
    _wh_user = [[WH_JXUserObject sharedUserInstance] getUserById:userId];
    //-1:黑名单；0：陌生人；1:单方关注；2:互为好友；8:系统号；9:非显示系统号  10:本账号的其他端
    [self.blackBtn setTitle:[NSString stringWithFormat:@"%@",self.wh_user.status.intValue == -1?@"取消拉黑":@"拉黑"] forState:UIControlStateNormal];
    
    self.blackBtn.hidden = !self.wh_user?YES:NO;
    
    
    NSString *type = [NSString stringWithFormat:@"%@",self.dict[@"payType"]]; //1 微信  2支付宝
    //dict[@"payeeAccount"]
    self.payTypeLab.text = [NSString stringWithFormat:@"%@",type.intValue == 1?@"微信":@"支付宝"];
    self.moneyLab.text = [NSString stringWithFormat:@"￥%.2f",[NSString stringWithFormat:@"%@",self.dict[@"payAmount"]].doubleValue];
    self.orderNoLab.text = [NSString stringWithFormat:@"%@",self.dict[@"no"]];
    self.countLab.text = [NSString stringWithFormat:@"%@ HOTC",self.dict[@"payAmount"]];
    //卖家昵称
    self.sellerNameLab.text = [NSString stringWithFormat:@"%@",self.dict[@"payeeNickName"]];
    self.buyerNameLab.text = [NSString stringWithFormat:@"%@",self.dict[@"payerName"]];
    
    //转换为日期
    NSTimeInterval creatTime = [[NSString stringWithFormat:@"%@",self.dict[@"createTime"]] doubleValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:creatTime/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            
    self.timeLab.text = [dateFormatter stringFromDate:date];
    
    //订单状态
    //判断订单是否超时不能点击
    // status,
//    0-订单初始化
//    １-买家己付款
//    ２-取消订单
//    ３-订单有争议,处理中
//    ４-订单支付完成,己确认
    
    NSString *status = [NSString stringWithFormat:@"%@",self.dict[@"status"]];
    
    if(status.intValue == 0){
        self.statueTitle.text = @"订单已生成";
        self.detaileLab.text = [NSString stringWithFormat:@"等待买家付款"];
    }else if(status.intValue == 1){
        self.statueTitle.text = @"买家已付款";
        self.detaileLab.text = [NSString stringWithFormat:@"等待群主确认"];
    }else if(status.intValue == 3){
        self.statueTitle.text = @"订单申诉中";
        self.detaileLab.text = [NSString stringWithFormat:@""];
        self.detaileBtn.hidden = NO;
    }else if(status.intValue == 4){
        self.statueTitle.text = @"订单已完成";
        self.detaileLab.text = [NSString stringWithFormat:@"您已成功交易%@HOTC",self.dict[@"payAmount"]];
    }else if(status.intValue == 5){
        self.statueTitle.text = @"申诉已结束";
        self.detaileLab.text = @"申诉已结束";
        self.detaileBtn.hidden = NO;
    }else if(status.intValue == 2){
        self.statueTitle.text = @"交易已取消";
//        subStatus = 1 超时自动取消
//        　　　subStatus = 2 群成员发起的取消
//        　　　subStatus = 3 群主发起的取消
        //        　　　subStatus = 4 管咯元发起的取消
        NSString *subStatus = [NSString stringWithFormat:@"%@",self.dict[@"subStatus"]];
        
        NSString *reason = @"由于您超时未付款，订单已取消";
        if(subStatus.intValue == 2){
            reason = @"订单已被买家取消";
        }else if(subStatus.intValue == 3){
            reason = @"订单已被群主取消";
        }else if(subStatus.intValue == 4){
            reason = @"订单已被客服取消";
        }
        
        self.detaileLab.text = reason;
    }
}
//复制
- (IBAction)copyAction:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.orderNoLab.text;
    [g_server showMsg:@"复制成功"];
}
//申诉
- (IBAction)appealListAction:(id)sender {
    WH_JXAppealListVC *vc = [[WH_JXAppealListVC alloc] init];
    vc.orderId = [NSString stringWithFormat:@"%@",self.dict[@"no"]];
    vc.otherUserId = self.wh_user.userId;
    [g_navigation pushViewController:vc animated:YES];
}

//申诉
- (IBAction)appealAction:(id)sender {
    // status,
//    0-订单初始化
//    １-买家己付款
//    ２-取消订单
//    ３-订单有争议,处理中
//    ４-订单支付完成,己确认
    
//    NSString *status = [NSString stringWithFormat:@"%@",self.dict[@"status"]];
    //添加新增
    WH_JXAppealAddVC *vc = [[WH_JXAppealAddVC alloc] init];
    vc.orderId = self.orderId;
    [g_navigation pushViewController:vc animated:YES];
    
//    if(status.intValue != 3){//添加新增
//
//    }else{
//
//    }
}
//拉黑
- (IBAction)blackAction:(id)sender {
    
    if(self.wh_user.status.intValue == -1){//取消拉黑
        [g_server WH_delBlacklistWithToUserId:self.wh_user.userId toView:self];
    }else{//拉黑
        [g_server WH_addBlacklistWithToUserId:self.wh_user.userId toView:self];
    }
}
- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    //    [_wait hide];
    NSString *orderDetaileUrl = [NSString stringWithFormat:@"%@%@",wh_order_detaile,self.orderId];
    
    NSString *orderCancleUrl = [NSString stringWithFormat:@"%@%@",wh_order_cancle,self.orderId];
    
    if([aDownload.action isEqualToString:wh_act_BlacklistDel]){
        
        [self.wh_user doSendMsg:XMPP_TYPE_NOBLACK content:nil];
        self.wh_user.status = @(2);
        [self.blackBtn setTitle:@"拉黑" forState:UIControlStateNormal];
        
    }else if([aDownload.action isEqualToString:wh_act_BlacklistAdd]){//拉黑
                
        [self.wh_user doSendMsg:XMPP_TYPE_BLACK content:nil];
        self.wh_user.status = @(-1);
        [self.blackBtn setTitle:@"取消拉黑" forState:UIControlStateNormal];
        
    }else if( [aDownload.action isEqualToString:orderDetaileUrl] ){
        
        
        //"currentTime": 1703040327880,
//        "data": {
//          "createTime": 1703040216485,
//          "expiryTime": 1703040276485,
//          "fee": 0,
//          "jid": "419deba9887b4225adc2c9a4c25a5765",
//          "no": "T495222024110149",
//          "payAmount": 25,
//          "payCurrency": "CNY",
//          "payType": 2,
//          "payeeAccount": "137287969",
//          "payeeAccountImg": "http://192.168.1.88:8089/resources/u/10/10000010/202312/o/244a9f69f2244469a0986a7083662ebf.jpg",
//          "payeeName": "胡墨任静",
//          "payeeUID": 10000010,
//          "payerName": "No..1",
//          "payerUID": 10000022,
//          "rate": 1,
//          "remark": "",
//          "status": 1,
//          "subStatus": 0,
//          "targetAmount": 25,
//          "targetCurrency": "HOTC",
//          "type": 0,
//          "updateTime": 1703040241399
        
        
    }else if ([aDownload.action isEqualToString:wh_order_confirm] || [aDownload.action isEqualToString:orderCancleUrl]){
        [g_server showMsg:@"操作成功"];
        
        [g_navigation WH_dismiss_WHViewController:self animated:YES];
    }
}

#pragma mark - 请求失败回调
- (int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    //    [_wait hide];
    
    return WH_hide_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    //    [_wait hide];
    
    return WH_hide_error;
}

-(void)newReceipt:(NSNotification *)notifacation{//新回执
    //    NSLog(@"newReceipt");
    WH_JXMessageObject *msg     = (WH_JXMessageObject *)notifacation.object;
    if(msg == nil)
        return;
    if(![msg isAddFriendMsg])
        return;
    
    if([msg.type intValue] == XMPP_TYPE_NOBLACK){
        
        if (!self.wh_user) {
            return;
        }
        [[JXXMPP sharedInstance].blackList removeObject:self.wh_user.userId];
        [WH_JXMessageObject msgWithFriendStatus:self.wh_user.userId status:friend_status_friend];
    
    }
}


@end
