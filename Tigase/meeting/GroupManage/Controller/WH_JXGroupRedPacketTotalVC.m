//
//  WH_JXGroupRedPacketTotalVC.m
//  Tigase
//
//  Created by 1111 on 2024/3/26.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXGroupRedPacketTotalVC.h"
#import "WH_JXGroupRedPacketVC.h"

@interface WH_JXGroupRedPacketTotalVC (){
    BOOL isSelectStartDate;
    ATMHud* _wait;
}

@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
@property (weak, nonatomic) IBOutlet UIView *dateContentView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic,copy)NSString *startTime;//yyyy-MM-dd HH:mm:ss
@property (nonatomic,copy)NSString *endTime;//yyyy-MM-dd HH:mm:ss
@property (nonatomic,assign)NSInteger type;//红包类型：0:全部 1：普通红包 2：拼手气红包 3:口令红包
@property (nonatomic, assign) NSInteger selIndex;
@property (weak, nonatomic) IBOutlet UIView *timeBgView;

@property (weak, nonatomic) IBOutlet UILabel *sendAllMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *sendLuckMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *sendExclusiveMoneyLab;

@property (weak, nonatomic) IBOutlet UILabel *receiveAllMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *receiveLuckMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *receiveExclusiveMoneyLab;



@end

@implementation WH_JXGroupRedPacketTotalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _wait = [ATMHud sharedInstance];
    self.timeBgView.layer.cornerRadius = 10.0f;
    self.timeBgView.layer.borderColor = HEXCOLOR(0xF6D2A0).CGColor;
    self.timeBgView.layer.borderWidth = 0.5;
    
    self.startDateBtn.layer.cornerRadius = self.endDateBtn.layer.cornerRadius = 14.0f;
    
    //设置展示样式
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.datePicker setMaximumDate:[NSDate date]];
    [self.startDateBtn setTitle:[NSDate date].xmppDateString forState:UIControlStateNormal];
    [self.endDateBtn setTitle:[NSDate date].xmppDateString forState:UIControlStateNormal];
    
    self.type = 0;
    //开始时间
    NSString *startTimeStr = [NSString stringWithFormat:@"%@ 00:00:00",[NSDate date].xmppDateString];
    self.startTime = startTimeStr;
    
    //结束时间
    NSString *endTimeStr = [NSString stringWithFormat:@"%@ 23:59:59",[NSDate date].xmppDateString];
    self.endTime = endTimeStr;
    
    //添加圆角
    for (int i = 600; i<603; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        btn.layer.cornerRadius = 13.0f;
    }
    
    for (int i = 700; i<703; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        btn.layer.cornerRadius = 13.0f;
    }
    
    [self WH_getServerData];
}

- (void) WH_getServerData {
    [g_server WH_redPacketTotalWithRoomJId:self.room.roomJid startTime:self.startTime endTime:self.endTime toView:self];
}
//发出的红包 600+
- (IBAction)sendLookAction:(UIButton *)sender {
    self.type = sender.tag - 600;
    self.selIndex = 0;
    [self lookListAction];
}
//收到的红包 700+
- (IBAction)receiveLookAction:(UIButton *)sender {
    self.type = sender.tag - 700;
    self.selIndex = 1;
    [self lookListAction];
}
-(void)lookListAction{
    WH_JXGroupRedPacketVC *vc = [[WH_JXGroupRedPacketVC alloc] init];
    vc.room = self.room;
    vc.startTime = self.startTime;
    vc.endTime = self.endTime;
    vc.type = self.type;
    vc.selIndex = self.selIndex;
    [g_navigation pushViewController:vc animated:YES];
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

- (IBAction)didTapStartDate {
    isSelectStartDate = YES;
    [self.datePicker setDate:[NSDate dateWithXmppDateString:self.startDateBtn.currentTitle]];
    self.dateContentView.hidden = NO;
}

- (IBAction)didTapEndDate {
    isSelectStartDate = NO;
    [self.datePicker setDate:[NSDate dateWithXmppDateString:self.endDateBtn.currentTitle]];
    self.dateContentView.hidden = NO;
}

- (IBAction)didTapCancelDate:(id)sender {
    self.dateContentView.hidden = YES;
}

- (IBAction)didTapConfirmDate:(id)sender {
    if (isSelectStartDate) {
        if ([self.datePicker.date timeIntervalSinceDate:[NSDate dateWithXmppDateHHMMString:self.endDateBtn.currentTitle]] > 0) {
            [GKMessageTool showError:@"开始时间不能比结束时间大"];
            return;
        }
        [self.startDateBtn setTitle:self.datePicker.date.xmppDateString forState:UIControlStateNormal];
        self.startTime = [NSString stringWithFormat:@"%@:00",self.datePicker.date.xmppDateSSString];
        
    } else {
        if ([self.datePicker.date timeIntervalSinceDate:[NSDate dateWithXmppDateHHMMString:self.startDateBtn.currentTitle]] < 0) {
            [GKMessageTool showError:@"结束时间不能比开始时间小"];
            return;
        }
        [self.endDateBtn setTitle:self.datePicker.date.xmppDateString forState:UIControlStateNormal];
        self.endTime = [NSString stringWithFormat:@"%@:00",self.datePicker.date.xmppDateSSString];
    }
    self.dateContentView.hidden = YES;
    [self WH_getServerData];
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    
    if([aDownload.action isEqualToString:wh_act_redPacketSummary_outline]){
        //遍历数组
        float sendTotal = 0.00;
        float receiveTotal = 0.00;
        for (NSDictionary *dic in array1) {
            NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
            if(type.intValue == 1){//专属红包
                NSString *sendAmount = [NSString stringWithFormat:@"%@",dic[@"sendAmount"]];
                self.sendExclusiveMoneyLab.text = [NSString stringWithFormat:@"￥%.2f",sendAmount.floatValue];
                sendTotal += sendAmount.floatValue;
                
                NSString *receiveAmount = [NSString stringWithFormat:@"%@",dic[@"receiveAmount"]];
                self.receiveExclusiveMoneyLab.text = [NSString stringWithFormat:@"￥%.2f",receiveAmount.floatValue];
                receiveTotal+=receiveAmount.floatValue;
                
            }else if (type.intValue == 2){//手气红包
                
                NSString *sendAmount = [NSString stringWithFormat:@"%@",dic[@"sendAmount"]];
                self.sendLuckMoneyLab.text = [NSString stringWithFormat:@"￥%.2f",sendAmount.floatValue];
                sendTotal += sendAmount.floatValue;
                
                NSString *receiveAmount = [NSString stringWithFormat:@"%@",dic[@"receiveAmount"]];
                self.receiveLuckMoneyLab.text = [NSString stringWithFormat:@"￥%.2f",receiveAmount.floatValue];
                receiveTotal+=receiveAmount.floatValue;
                
            }
        }
        
        self.sendAllMoneyLab.text = [NSString stringWithFormat:@"￥%.2f",sendTotal];
        self.receiveAllMoneyLab.text = [NSString stringWithFormat:@"￥%.2f",receiveTotal];
        
//        "diff": -40,
//              "receiveAmount": 0,    //接收总金额
//              "receiveCount": 0,     //抢包次数
//              "sendAmount": 40,   //发送总金额
//              "sendCount": 11,    //红包个数
//              "type": 3,    //1-专属红包,2-手气红包,3-口令红包
//              "userId": 0
    }
    
}
#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
   
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
