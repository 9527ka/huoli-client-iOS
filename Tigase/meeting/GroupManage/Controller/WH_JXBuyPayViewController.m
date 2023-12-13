//
//  WH_JXBuyPayViewController.m
//  Tigase
//
//  Created by 1111 on 2023/12/12.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXBuyPayViewController.h"

@interface WH_JXBuyPayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *payTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *oneLab;
@property (weak, nonatomic) IBOutlet UILabel *twoLab;
@property (weak, nonatomic) IBOutlet UILabel *threeLab;
@property (weak, nonatomic) IBOutlet UILabel *monyLab;
@property (weak, nonatomic) IBOutlet UIView *infoBgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (weak, nonatomic) IBOutlet UILabel *detaileLab;
@property (weak, nonatomic) IBOutlet UIButton *notificationBtn;

@end

@implementation WH_JXBuyPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
-(void)initUI{
    self.infoBgView.layer.cornerRadius = self.notificationBtn.layer.cornerRadius = 8.0f;
    self.oneLab.layer.cornerRadius = self.twoLab.layer.cornerRadius = self.threeLab.layer.cornerRadius = 9.0f;
    self.monyLab.text = [NSString stringWithFormat:@"￥%.2f",self.room.count.doubleValue];
    //富文本
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.detaileLab.text attributes:attributes];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:227/255.0 green:66/255.0 blue:68/255.0 alpha:1.0] range:NSMakeRange(1, 13)];
    self.detaileLab.attributedText = att;
    
    self.payTitleLab.text = [NSString stringWithFormat:@"请使用%@转账",self.room.type > 0?@"微信":@"支付宝"];
    
    //添加倒计时
    __block NSInteger second = 1199;
       //(1)
       dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
       //(2)
       dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
       //(3)
       dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
       //(4)
       dispatch_source_set_event_handler(timer, ^{
           dispatch_async(dispatch_get_main_queue(), ^{
               if (second == 0) {
                   self.timeLab.text = @"已超时";
                   second = 1199;
                   //(6)
                   dispatch_cancel(timer);
               } else {
                   NSInteger min = second/60.0f;
                   NSInteger sec = second%60;
                   self.timeLab.text = [NSString stringWithFormat:@"%02ld:%02lds",(long)min,(long)sec];
                   
                   
                   second--;
               }
           });
       });
       //(5)
    dispatch_resume(timer);
}
- (IBAction)notificationAction:(id)sender {
    
}

- (IBAction)copyAction:(id)sender {
    
}


@end
