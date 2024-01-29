//
//  WH_JXAgentManagerVC.m
//  Tigase
//
//  Created by 1111 on 2024/1/25.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXAgentManagerVC.h"
#import "UIAlertController+category.h"
#import "WH_JXBuyAndPayListModel.h"

@interface WH_JXAgentManagerVC (){
    BOOL isSelectStartDate;
    ATMHud* _wait;
}
@property (weak, nonatomic) IBOutlet UITextField *startField;
@property (weak, nonatomic) IBOutlet UITextField *endField;

@property (weak, nonatomic) IBOutlet UIView *dateContentView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *maxCountField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@end

@implementation WH_JXAgentManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.layer.cornerRadius = self.commitBtn.layer.cornerRadius = 8.0f;
    _wait = [ATMHud sharedInstance];
    //查询商户配置信息
    [g_server WH_MerchantGet:self];
    
}
- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

- (IBAction)switchAction:(UISwitch *)sender {
    
}


- (IBAction)didTapStartDate {
    isSelectStartDate = YES;
    [self.datePicker setDate:[NSDate dateWithXmppHourString:self.startField.text]];
    self.dateContentView.hidden = NO;
}

- (IBAction)didTapEndDate {
    isSelectStartDate = NO;
    [self.datePicker setDate:[NSDate dateWithXmppHourString:self.endField.text]];
    self.dateContentView.hidden = NO;
}
- (IBAction)didTapCancelDate:(id)sender {
    self.dateContentView.hidden = YES;
}

- (IBAction)didTapConfirmDate:(id)sender {
    if (isSelectStartDate) {

        self.startField.text = [NSString stringWithFormat:@"%@",self.datePicker.date.xmppDateHourString];
        
    } else {
        
        self.endField.text = [NSString stringWithFormat:@"%@",self.datePicker.date.xmppDateHourString];
    }
    self.dateContentView.hidden = YES;
    
}
//取消代理
- (IBAction)cancleAgentAction:(id)sender {
    [UIAlertController showAlertViewWithTitle:@"确认取消代理商吗？" message:nil controller:self block:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {
            
//            [g_server WH_orderCancleWithId:[NSString stringWithFormat:@"%@",self.dict[@"no"]] toView:self];
        }
    } cancelButtonTitle:Localized(@"JX_Cencal") otherButtonTitles:Localized(@"JX_Confirm")];
}

- (IBAction)commitAction:(id)sender {
    if(self.nameField.text.length == 0){
        [g_server showMsg:@"请输入商户名称"];
        return;
    }
    if(self.startField.text.length == 0){
        [g_server showMsg:@"请选择营业开始时间"];
        return;
    }
    if(self.endField.text.length == 0){
        [g_server showMsg:@"请选择营业结束时间"];
        return;
    }
    if(self.maxCountField.text.length == 0){
        [g_server showMsg:@"请输入单笔最大交易金额"];
        return;
    }
    [g_server WH_MerchantUpdateWithStartHour:self.startField.text endHour:self.endField.text amount:self.maxCountField.text flag:self.switchBtn.on name:self.nameField.text toView:self];
    
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
        [_wait hide];
    if( [aDownload.action isEqualToString:wh_merchant_get] ){//代理商信息
        WH_JXBuyAndPayListModel *model = [WH_JXBuyAndPayListModel mj_objectWithKeyValues:dict];
        //营业时间
        self.startField.text = model.startHour;
        self.endField.text = model.endHour;
        self.maxCountField.text = model.maxForBuy;
        self.switchBtn.on = model.flag.boolValue;
        self.nameField.text = model.name;
        
    }if( [aDownload.action isEqualToString:wh_merchant_update] ){//代理商信息
        [g_server showMsg:@"设置成功"];
        [g_navigation WH_dismiss_WHViewController:self animated:YES];
    }
    
    
    
}

#pragma mark - 请求失败回调
- (int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
        [_wait hide];
    
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
        [_wait hide];
    
    return WH_show_error;
}



@end
