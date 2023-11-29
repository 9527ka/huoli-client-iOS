//
//  WH_JXGroupMemberRedPacketUnclaimedVC.m
//  Tigase
//
//  Created by luan on 2023/6/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupMemberRedPacketUnclaimedVC.h"
#import "WH_JXGroupMemberRedPacketUnclaimedCell.h"

@interface WH_JXGroupMemberRedPacketUnclaimedVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WH_JXGroupMemberRedPacketUnclaimedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXGroupMemberRedPacketUnclaimedCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXGroupMemberRedPacketUnclaimedCell"];
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXGroupMemberRedPacketUnclaimedCell *cell = (WH_JXGroupMemberRedPacketUnclaimedCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXGroupMemberRedPacketUnclaimedCell" forIndexPath:indexPath];
    [g_server WH_getHeadImageSmallWIthUserId:g_myself.userId userName:g_myself.userNickname imageView:cell.avatarImage];
    return cell;
}

@end
