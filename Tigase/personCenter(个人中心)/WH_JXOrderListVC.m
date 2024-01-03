//
//  WH_JXOrderListVC.m
//  Tigase
//
//  Created by 1111 on 2023/12/21.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXOrderListVC.h"
#import "WH_JXOrderListCell.h"
#import "WH_JXCertainOrderVC.h"
#import "WH_JXOrderDetaileVC.h"
#import "WH_JXOrderSearchVC.h"

@interface WH_JXOrderListVC ()<UITableViewDataSource, UITableViewDelegate> {
    BOOL isSelectStartDate;
    ATMHud* _wait;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeight;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *dateContentView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIImageView *nodataImage;
@property (weak, nonatomic) IBOutlet UILabel *nodataLab;

@property (nonatomic,copy)NSString *startTime;//yyyy-MM-dd HH:mm:ss
@property (nonatomic,copy)NSString *endTime;//yyyy-MM-dd HH:mm:ss
@property (nonatomic,assign)NSInteger type;//

@property (nonatomic,assign)NSInteger page;

@property (nonatomic, copy) NSString *statue;//0-订单初始化 １-买家己付款 ２-取消订单 ３-订单有争议,处理中 ４-订单支付完成,己确认
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation WH_JXOrderListVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.page = 0;
    [self WH_getServerData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _wait = [ATMHud sharedInstance];
    
    self.dataSource = [NSMutableArray array];
    //设置展示样式
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    self.navHeight.constant = JX_SCREEN_TOP;
    
    self.tableView.rowHeight = 120.0f;
    
    [self.datePicker setMaximumDate:[NSDate date]];
    
    //获取开始时间
    //获取前一个月的时间

    NSDate *monthagoData = [self getPriousorLaterDateWithMonth:-1];

    NSString *agoString = monthagoData.xmppDateString;

  
    
    [self.startDateBtn setTitle:agoString forState:UIControlStateNormal];
    
    [self.endDateBtn setTitle:[NSDate date].xmppDateString forState:UIControlStateNormal];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXOrderListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXOrderListCell"];
    
    self.type = 0;
    self.statue = @"0,1,3";
    //开始时间
    NSString *startTimeStr = [NSString stringWithFormat:@"%@ 00:00:00",agoString];
    self.startTime = startTimeStr;
    
    //结束时间
    NSString *endTimeStr = [NSString stringWithFormat:@"%@ 23:59:59",[NSDate date].xmppDateString];
    self.endTime = endTimeStr;
    
//    [self WH_getServerData];
    
    
    
}
//获取几个月前
- (NSDate*)getPriousorLaterDateWithMonth:(int)month{
    NSDate*currentDate = [NSDate date];
   
    NSDateComponents *comps = [[NSDateComponents alloc] init];

    [comps setMonth:month];

    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar

    NSDate *mDate = [calender dateByAddingComponents:comps toDate:currentDate options:0];

    return mDate;

}

- (void) WH_getServerData {
    [g_server WH_OrderListIndex:self.page startTime:self.startTime endTime:self.endTime status:self.statue type:self.type keyword:@"" pageIndex:self.page toView:self];
    
}
- (IBAction)didTapSegmented:(UISegmentedControl *)sender {
    self.page = 0;

    if(sender.selectedSegmentIndex == 0){//未完成
        self.statue = @"0,1,3";
    }else if (sender.selectedSegmentIndex == 1){//已完成
        self.statue = @"4,5";
    }else if (sender.selectedSegmentIndex == 2){//已取消
        self.statue = @"2";
    }

    [self WH_getServerData];
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

- (IBAction)didTapType {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *typeArray = @[@"全部", @"出售", @"购买"];
    NSArray *tagArray = @[@(0),@(1),@(2)];
    
    for (int i = 0; i < typeArray.count; i++) {
        NSString *type = typeArray[i];
        NSNumber *chooseType = tagArray[i];
        [actionSheet addAction:[UIAlertAction actionWithTitle:type style:[type isEqualToString:self.typeBtn.currentTitle] ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.typeBtn setTitle:type forState:UIControlStateNormal];
            self.type = chooseType.integerValue;
            self.page = 0;
            //刷新接口
            [self WH_getServerData];
        }]];
    }
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:actionSheet animated:YES completion:NULL];
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
        if ([self.datePicker.date timeIntervalSinceDate:[NSDate dateWithXmppDateString:self.endDateBtn.currentTitle]] > 0) {
            [GKMessageTool showError:@"开始时间不能比结束时间大"];
            return;
        }
        [self.startDateBtn setTitle:self.datePicker.date.xmppDateString forState:UIControlStateNormal];
        self.startTime = [NSString stringWithFormat:@"%@:00",self.datePicker.date.xmppDateSSString];
        
    } else {
        if ([self.datePicker.date timeIntervalSinceDate:[NSDate dateWithXmppDateString:self.startDateBtn.currentTitle]] < 0) {
            [GKMessageTool showError:@"结束时间不能比开始时间小"];
            return;
        }
        [self.endDateBtn setTitle:self.datePicker.date.xmppDateString forState:UIControlStateNormal];
        self.endTime = [NSString stringWithFormat:@"%@:00",self.datePicker.date.xmppDateSSString];
    }
    self.dateContentView.hidden = YES;
    self.page = 0;
    [self WH_getServerData];
}

// MARK: -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXOrderListCell *cell = (WH_JXOrderListCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXOrderListCell" forIndexPath:indexPath];
    if(self.dataSource.count > indexPath.row){
        NSDictionary *dic = self.dataSource[indexPath.row];
        cell.orderNoLab.text = [NSString stringWithFormat:@"订单编号：%@",dic[@"no"]];
        NSString *payeeUID = [NSString stringWithFormat:@"%@",dic[@"payeeUID"]];//出售
//        NSString *payerUID = [NSString stringWithFormat:@"%@",dic[@"payerUID"]];//购买
        if([payeeUID isEqualToString:MY_USER_ID]){//出售
            cell.buyTypeLab.text = @"出售";
            cell.buyTypeLab.textColor = [UIColor redColor];
            cell.nameLab.text = [NSString stringWithFormat:@"交易对象：%@",dic[@"payerName"]];
        }else{//购买
            cell.buyTypeLab.text = @"购买";
            cell.buyTypeLab.textColor = HEXCOLOR(0x23B525);
            cell.nameLab.text = [NSString stringWithFormat:@"交易对象：%@",dic[@"payeeNickName"]];
        }
        NSString *payAmount = [NSString stringWithFormat:@"%@",dic[@"payAmount"]];
        cell.moneyLab.text = [NSString stringWithFormat:@"￥%.2f",payAmount.doubleValue];
        
        NSString *time = [NSString stringWithFormat:@"%@",dic[@"createTime"]];
        //时间
        cell.timeLab.text = [self getTimeFrom:time.doubleValue/1000];
        NSInteger status = [NSString stringWithFormat:@"%@",dic[@"status"]].intValue;
        //0-订单初始化 １-买家己付款 ２-取消订单 ３-订单有争议,处理中 ４-订单支付完成,己确认
        if(status == 0){
            cell.statueLab.text = @"待支付";
        }else if (status == 1){
            cell.statueLab.text = @"待确认";
        }else if (status == 2){
            cell.statueLab.text = @"取消订单";
        }else if (status == 3){
            cell.statueLab.text = @"申诉中";
        }else if (status == 4){
            cell.statueLab.text = @"交易完成";
        }else if (status == 5){
            cell.statueLab.text = @"申诉结束";
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataSource.count > indexPath.row){
        NSDictionary *dic = self.dataSource[indexPath.row];
        
        NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        NSString *payeeUID = [NSString stringWithFormat:@"%@",dic[@"payeeUID"]];//出售
        NSString *orderId = [NSString stringWithFormat:@"%@",dic[@"no"]];

        if (status.intValue == 1 && [payeeUID isEqualToString:MY_USER_ID]) {//确认
            WH_JXCertainOrderVC *orderVC = [[WH_JXCertainOrderVC alloc] init];
            orderVC.dict = dic;
            orderVC.orderId = orderId;
            [g_navigation pushViewController:orderVC animated:YES];
        }else{//详情
            WH_JXOrderDetaileVC *orderVC = [[WH_JXOrderDetaileVC alloc] init];
            orderVC.dict = dic;
            orderVC.orderId = orderId;
            [g_navigation pushViewController:orderVC animated:YES];
            
        }
    }
}
/**
 *根据时间戳 转时间
 */
-(NSString *)getTimeFrom:(double)second{
    //将对象类型的时间转换为NSDate类型
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:second];
        
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter2 stringFromDate:date];
        
    return dateString;
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if (self.page == 0) {
        [self.dataSource removeAllObjects];
       
        self.nodataImage.hidden = self.nodataLab.hidden = array1.count > 0?YES:NO;
    }
    [self.dataSource addObjectsFromArray:array1];
    
    [self.tableView reloadData];
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
//搜索
- (IBAction)searchAction:(id)sender {
    WH_JXOrderSearchVC *vc = [[WH_JXOrderSearchVC alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}


@end
