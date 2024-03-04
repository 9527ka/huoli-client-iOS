//
//  WH_JXRecordCodeDetaileVC.m
//  Tigase
//
//  Created by 1111 on 2024/3/1.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXRecordCodeDetaileVC.h"


@interface WH_JXRecordCodeDetaileVC ()
@property (weak, nonatomic) IBOutlet UILabel *formeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *orderStatueLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation WH_JXRecordCodeDetaileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formeLab.text = self.model.referenceData.length > 0?self.model.referenceData:self.model.desc;

    float endMoney = self.model.endMoney.floatValue;

    float startMoney = self.model.startMoney.floatValue;
    
    NSString *iconStr = endMoney > startMoney?@"+":@"-";
    
    NSString *addStr = (startMoney == 0.00 && endMoney == 0.00)?@"":iconStr;
    
    self.moneyLab.text = [NSString stringWithFormat:@"%@%.2f HOTC",addStr,self.model.money.floatValue];
    
    self.orderStatueLab.text = self.model.desc;
    
    self.orderNumLab.text = self.model.tradeNo;
    //转换为日期
    NSTimeInterval  creatTime = self.model.time.doubleValue;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:creatTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];//中国专用
    self.timeLab.text = [dateFormatter stringFromDate:date];
    
    
//    WH_JXRecordCodeModel
    
}
- (IBAction)gobackAction:(id)sender {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}



@end
