//
//  WH_JXOrderSearchVC.m
//  Tigase
//
//  Created by 1111 on 2023/12/21.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXOrderSearchVC.h"
#import "WH_JXOrderListCell.h"
#import "WH_JXCertainOrderVC.h"
#import "WH_JXOrderDetaileVC.h"

@interface WH_JXOrderSearchVC ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate> {
    BOOL isSelectStartDate;
    ATMHud* _wait;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *nodataImage;
@property (weak, nonatomic) IBOutlet UILabel *nodataLab;
@property (weak, nonatomic) IBOutlet UITextField *serachField;

@property (nonatomic,assign)NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation WH_JXOrderSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    self.tableView.rowHeight = 120.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXOrderListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXOrderListCell"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingAction)];
    [self.view addGestureRecognizer:tap];
    
//    [self WH_getServerData];
    
}
-(void)endEditingAction{
    [self.view endEditing:YES];
}
- (void) WH_getServerData {
    
    [self.view endEditing:YES];
    
    [g_server WH_OrderListIndex:self.page startTime:@"" endTime:@"" status:@"0,1,2,3,4" type:0 keyword:self.serachField.text pageIndex:self.page toView:self];
    
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
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
        NSString *payerUID = [NSString stringWithFormat:@"%@",dic[@"payerUID"]];//购买
        if([payeeUID isEqualToString:MY_USER_ID]){//出售
            cell.buyTypeLab.text = @"出售";
            cell.buyTypeLab.textColor = [UIColor redColor];
            cell.nameLab.text = [NSString stringWithFormat:@"交易对象：%@",dic[@"payerName"]];
        }else{//购买
            cell.buyTypeLab.text = @"购买";
            cell.buyTypeLab.textColor = [UIColor greenColor];
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
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.text.length == 0){
        [g_server showMsg:@"请输入搜索内容"];
        return NO;
    }
    [self WH_getServerData];
    
    return YES;
}


@end
