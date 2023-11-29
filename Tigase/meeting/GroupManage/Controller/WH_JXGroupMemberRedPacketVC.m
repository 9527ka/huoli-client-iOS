//
//  WH_JXGroupMemberRedPacketVC.m
//  Tigase
//
//  Created by luan on 2023/6/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupMemberRedPacketVC.h"
#import "WH_JXGroupMemberRedPacketCell.h"

@interface WH_JXGroupMemberRedPacketVC ()<UITableViewDataSource, UITableViewDelegate> {
    BOOL isSelectStartDate;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *dateContentView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation WH_JXGroupMemberRedPacketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.datePicker setMaximumDate:[NSDate date]];
    [self.startDateBtn setTitle:[NSDate date].xmppDateString forState:UIControlStateNormal];
    [self.endDateBtn setTitle:[NSDate date].xmppDateString forState:UIControlStateNormal];
    self.dataSource = (NSMutableArray *)[memberData fetchAllMembers:self.room.roomId sortByName:NO];
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXGroupMemberRedPacketCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXGroupMemberRedPacketCell"];
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

- (IBAction)didTapSegmented:(UISegmentedControl *)sender {
    
}

- (IBAction)didTapType {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *typeArray = @[@"全部", @"手气红包", @"口令红包", @"专属红包"];
    for (NSString *type in typeArray) {
        [actionSheet addAction:[UIAlertAction actionWithTitle:type style:[type isEqualToString:self.typeBtn.currentTitle] ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.typeBtn setTitle:type forState:UIControlStateNormal];
        }]];
    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:actionSheet animated:YES completion:NULL];
}

- (IBAction)didTapStartDate {
    isSelectStartDate = YES;
    [self.datePicker setDate:[NSDate dateWithXmppDateString:self.startDateBtn.currentTitle]];
    self.dateContentView.hidden = NO;
}

- (IBAction)didTapEndDate {
    isSelectStartDate = NO;
    [self.datePicker setDate:[NSDate dateWithXmppDateString:self.endDateBtn.currentTitle]];
    self.dateContentView.hidden = NO;
}

- (IBAction)didTapCancelDate:(id)sender {
    self.dateContentView.hidden = YES;
}

- (IBAction)didTapConfirmDate:(id)sender {
    if (isSelectStartDate) {
        if ([self.datePicker.date timeIntervalSinceDate:[NSDate dateWithXmppDateString:self.endDateBtn.currentTitle]] > 0) {
            [GKMessageTool showError:@"开始时间不能比结束时间大"];
            return;
        }
        [self.startDateBtn setTitle:self.datePicker.date.xmppDateString forState:UIControlStateNormal];
    } else {
        if ([self.datePicker.date timeIntervalSinceDate:[NSDate dateWithXmppDateString:self.startDateBtn.currentTitle]] < 0) {
            [GKMessageTool showError:@"结束时间不能比开始时间小"];
            return;
        }
        [self.endDateBtn setTitle:self.datePicker.date.xmppDateString forState:UIControlStateNormal];
    }
    self.dateContentView.hidden = YES;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXGroupMemberRedPacketCell *cell = (WH_JXGroupMemberRedPacketCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXGroupMemberRedPacketCell" forIndexPath:indexPath];
    memberData *data = (memberData *)(self.dataSource[indexPath.row]);
    [g_server WH_getHeadImageSmallWIthUserId:[NSString stringWithFormat:@"%ld", data.userId] userName:data.userNickName imageView:cell.avatarImage];
    
    WH_JXUserObject *user = [[WH_JXUserObject alloc] init];
    user = [user getUserById:[NSString stringWithFormat:@"%ld",data.userId]];
    cell.nicknameLabel.text = data.lordRemarkName.length > 0 ? data.lordRemarkName : user.remarkName.length > 0  ? user.remarkName : data.userNickName;
    if (indexPath.row < 3) {
        cell.medalIcon.hidden = NO;
        cell.medalIcon.image = [UIImage imageNamed:@[@"gold_medal", @"silver_medal", @"bronze_medal"][indexPath.row]];
        cell.numberLabel.text = @"";
    } else {
        cell.medalIcon.hidden = YES;
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    }
    return cell;
}

@end
