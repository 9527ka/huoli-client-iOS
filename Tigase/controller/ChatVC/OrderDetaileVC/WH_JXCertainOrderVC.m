//
//  WH_JXCertainOrderVC.m
//  Tigase
//
//  Created by 1111 on 2023/12/20.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXCertainOrderVC.h"
#import "UIAlertController+category.h"

@interface WH_JXCertainOrderVC ()
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *certainBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;

@end

@implementation WH_JXCertainOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.openBtn.layer.cornerRadius = 4.0f;
    self.cancleBtn.layer.cornerRadius = 8.0f;
    self.certainBtn.layer.cornerRadius = 8.0f;
    
    NSString *type = [NSString stringWithFormat:@"%@",self.dict[@"payType"]]; //1 微信  2支付宝
    //dict[@"payeeAccount"]
    self.accountLab.text = [NSString stringWithFormat:@"%@",type.intValue == 1?@"微信":@"支付宝"];
    self.moneyLab.text = [NSString stringWithFormat:@"￥%.2f",[NSString stringWithFormat:@"%@",self.dict[@"payAmount"]].doubleValue];
    self.orderNoLab.text = [NSString stringWithFormat:@"%@",self.dict[@"no"]];
    
    self.lineLab.backgroundColor = type.intValue == 1?[UIColor greenColor]:[UIColor linkColor];
    
    
    
}
- (IBAction)openAction:(id)sender {
    //直接打开支付软件
    NSString *type = [NSString stringWithFormat:@"%@",self.dict[@"payType"]];
    [self isOpenApp:type.intValue == 1?@"com.tencent.xin":@"com.alipay.iphoneclient"];
}
- (BOOL)isOpenApp:(NSString*)appIdentifierName {
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:NSSelectorFromString(@"defaultWorkspace")];
    BOOL isOpenApp = [workspace performSelector:NSSelectorFromString(@"openApplicationWithBundleID:") withObject:appIdentifierName];
    
    return isOpenApp;
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
//600+
- (IBAction)functionAction:(UIButton *)sender {
    if(sender.tag == 600){//取消
        [UIAlertController showAlertViewWithTitle:@"确定取消该订单吗" message:nil controller:self block:^(NSInteger buttonIndex) {
            if (buttonIndex==1) {//取消订单
                [g_server WH_orderCancleWithId:self.orderId toView:self];
            }
        } cancelButtonTitle:Localized(@"JX_Cencal") otherButtonTitles:Localized(@"JX_Confirm")];
        
    }else{//确认
        [g_server WH_orderConfirmWithId:[NSString stringWithFormat:@"%@",self.dict[@"no"]] payerUID:[NSString stringWithFormat:@"%@",self.dict[@"payerUID"]] toView:self];
    }
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    //    [_wait hide];
    NSString *orderDetaileUrl = [NSString stringWithFormat:@"%@%@",wh_order_detaile,self.orderId];
    
    NSString *orderCancleUrl = [NSString stringWithFormat:@"%@%@",wh_order_cancle,self.orderId];
    
    if( [aDownload.action isEqualToString:orderDetaileUrl] ){
        
        
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
        [self performSelector:@selector(goBackAction) withObject:nil afterDelay:1.0];
    }
}
-(void)goBackAction{
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
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

@end
