//
//  WH_JXGroundEnterAndOutVC.m
//  Tigase
//
//  Created by luan on 2023/7/8.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupEnterAndOutVC.h"
#import "WH_JXGroupEnterAndOutCell.h"

@interface WH_JXGroupEnterAndOutVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *operatorLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WH_JXGroupEnterAndOutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXGroupEnterAndOutCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXGroupEnterAndOutCell"];
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

- (IBAction)didTapSegmented:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.memberLabel.text = @"被邀请人";
        self.timeLabel.text = @"邀请时间";
        self.operatorLabel.text = @"邀请人";
    } else {
        self.memberLabel.text = @"群成员";
        self.timeLabel.text = @"操作时间";
        self.operatorLabel.text = @"操作人";
    }
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXGroupEnterAndOutCell *cell = (WH_JXGroupEnterAndOutCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXGroupEnterAndOutCell" forIndexPath:indexPath];
    cell.memberLabel.text = @"张三\n123";
    cell.timeLabel.text = @"2023-01-01\n00:00:00";
    cell.operatorLabel.text = @"李四\n321";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
