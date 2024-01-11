//
//  WH_JXChooseAccountVC.m
//  Tigase
//
//  Created by 1111 on 2024/1/10.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXChooseAccountVC.h"
#import "WH_JXChooseAccountCell.h"
#import "WH_GroupAccountSetViewController.h"

@interface WH_JXChooseAccountVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *managerBtn;
@property (weak, nonatomic) IBOutlet UIView *zzView;

@end

@implementation WH_JXChooseAccountVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgView.layer.cornerRadius = 8.0f;
    self.tableView.rowHeight = 88;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXChooseAccountCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXChooseAccountCell"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAction)];
    [self.zzView addGestureRecognizer:tap];
}
//账号管理
- (IBAction)managerBtnAction:(id)sender {
    WH_GroupAccountSetViewController *vc = [[WH_GroupAccountSetViewController alloc] init];
   
    [g_navigation pushViewController:vc animated:YES];
}

-(void)hiddenAction{
    self.view.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, JX_SCREEN_HEIGHT, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
    }];
}

- (IBAction)backAction:(id)sender {
    [self hiddenAction];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WH_JXChooseAccountCell *cell = (WH_JXChooseAccountCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXChooseAccountCell" forIndexPath:indexPath];
   
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
