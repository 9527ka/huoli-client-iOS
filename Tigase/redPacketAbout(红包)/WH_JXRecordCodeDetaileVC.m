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

@end

@implementation WH_JXRecordCodeDetaileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}
- (IBAction)gobackAction:(id)sender {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}



@end
