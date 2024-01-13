//
//  WH_JXRoomDiamoundRechargeVC.m
//  Tigase
//
//  Created by 1111 on 2024/1/12.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXRoomDiamoundRechargeVC.h"

@interface WH_JXRoomDiamoundRechargeVC ()
@property (weak, nonatomic) IBOutlet UILabel *shouldPayTitle;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (strong, nonatomic) UIButton *selectBtn;

@property (strong, nonatomic) NSArray *titleArray;

@end

@implementation WH_JXRoomDiamoundRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = @[@"2000",@"2500",@"3000",@"3500"];
    //创建UI
    [self creatUI];
    
}

-(void)creatUI{
    self.rechargeBtn.layer.cornerRadius = 8.0f;
    
    for (int i = 300; i < 304; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        btn.layer.cornerRadius = 8.0f;
        btn.layer.borderColor = [UIColor systemBlueColor].CGColor;
        btn.layer.borderWidth = 1.0f;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.backgroundColor = [UIColor whiteColor];
        if(i == 300){
            btn.selected = YES;
            btn.backgroundColor = [UIColor systemBlueColor];
//            HEXCOLOR(0x4174f2);
            self.selectBtn = btn;
        }
    }
}



- (IBAction)countChooseAction:(UIButton *)sender {
    
    self.selectBtn.backgroundColor = [UIColor whiteColor];
    self.selectBtn.selected = NO;
    
    self.selectBtn = sender;
    self.selectBtn.selected = YES;
    self.selectBtn.backgroundColor = [UIColor systemBlueColor];
    

    self.shouldPayTitle.text = [NSString stringWithFormat:@"应付：%@ HOTC",self.titleArray[sender.tag - 300]];
}
- (IBAction)goBackAction:(id)sender {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
//立即充值
- (IBAction)rechargeAction:(id)sender {
    
}



@end
