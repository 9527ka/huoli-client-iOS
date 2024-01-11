//
//  WH_JXOrderCertainVC.m
//  Tigase
//
//  Created by 1111 on 2024/1/10.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXOrderCertainVC.h"
#import "WH_JXChooseAccountVC.h"
#import "JXNavigation.h"

@interface WH_JXOrderCertainVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *detaileBgView;
@property (weak, nonatomic) IBOutlet UILabel *detaileLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UIButton *certainBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *zzView;

@property (nonatomic,strong)WH_JXChooseAccountVC *vc;

@end

@implementation WH_JXOrderCertainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.detaileBgView.layer.cornerRadius = 4.0f;
    self.bgView.layer.cornerRadius = 8.0f;
    self.certainBtn.layer.cornerRadius = 8.0f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAction)];
    [self.zzView addGestureRecognizer:tap];
    
}

-(void)hiddenAction{
    self.view.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, JX_SCREEN_HEIGHT, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
    }];
}

- (IBAction)closeAction:(id)sender {
    [self hiddenAction];
}
//账号设置
- (IBAction)accountAction:(id)sender {
        
    self.vc.view.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.vc.view.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
    }];
}
//确定按钮
- (IBAction)certainAction:(id)sender {
    
}
-(WH_JXChooseAccountVC *)vc{
    if(!_vc){
        _vc = [[WH_JXChooseAccountVC alloc] init];
        _vc.view.frame = CGRectMake(0, JX_SCREEN_HEIGHT, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
        _vc.view.hidden = YES;
        [self.view addSubview:self.vc.view];
    }
    return _vc;
}


@end
