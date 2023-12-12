//
//  WH_JXGroupRedPacketSetupMemberVC.m
//  Tigase
//
//  Created by luan on 2023/7/9.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupRedPacketSetupMemberVC.h"
#import "WH_JXGroupRedPacketSetupMemberCell.h"
#import "BMChineseSort.h"

@interface WH_JXGroupRedPacketSetupMemberVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<memberData *> *allMemberData;
@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation WH_JXGroupRedPacketSetupMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = (self.description == 0) ? @"谁不可以抢" : @"谁不可以发";
    
    self.textField.backgroundColor = g_factory.inputBackgroundColor;
    self.textField.layer.cornerRadius = 17;
    self.textField.layer.borderWidth = 0.5;
    self.textField.layer.borderColor = g_factory.inputBorderColor.CGColor;
    self.textField.layer.masksToBounds = YES;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search"]];
    UIView *leftView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.center = leftView.center;
    [leftView addSubview:imageView];
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXGroupRedPacketSetupMemberCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXGroupRedPacketSetupMemberCell"];
    [self getRoomMembersArray];
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

- (IBAction)didTapConfirm {
    
}

- (IBAction)textFieldDidChange:(UITextField *)textField {
    
}

- (void)getRoomMembersArray {
    if ([[NSString stringWithFormat:@"%ld",self.room.userId] isEqualToString:MY_USER_ID]) {
        self.allMemberData = [memberData fetchAllMembers:self.room.roomId sortByName:NO];
    }else {
        self.allMemberData = [memberData fetchAllMembersAndHideMonitor:self.room.roomId sortByName:NO];
    }
    //选择拼音 转换的 方法
    BMChineseSortSetting.share.sortMode = 2; // 1或2
    //排序 Person对象
    [BMChineseSort sortAndGroup:self.allMemberData key:@"userNickName" finish:^(bool isSuccess, NSMutableArray *unGroupArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
        if (isSuccess) {
            self.indexArray = sectionTitleArr;
            self.dataSource = sortedObjArr;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *list = [self.dataSource objectAtIndex:section];
    return list.count;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.indexArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXGroupRedPacketSetupMemberCell *cell = (WH_JXGroupRedPacketSetupMemberCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXGroupRedPacketSetupMemberCell" forIndexPath:indexPath];
    memberData *member = self.dataSource[indexPath.section][indexPath.row];
    
    NSString *name = [NSString string];
    memberData *data = [self.room getMember:g_myself.userId];
    WH_JXUserObject *allUser = [[WH_JXUserObject alloc] init];
    allUser = [allUser getUserById:[NSString stringWithFormat:@"%ld",member.userId]];
    if ([data.role intValue] == 1) {
        name = member.lordRemarkName ? member.lordRemarkName : allUser.remarkName.length > 0  ? allUser.remarkName : member.userNickName;
    } else {
        name = allUser.remarkName.length > 0  ? allUser.remarkName : member.userNickName;
    }
    if (!self.room.allowSendCard && [data.role intValue] != 1 && [data.role intValue] != 2 && member.userId > 0) {
        if (GroupMemberShowPlaceholderString) {
            name = [name substringToIndex:[name length]-1];
            name = [name stringByAppendingString:@"*"];
        }
    }
    cell.nameLabel.text = name;
    [g_server WH_getHeadImageSmallWIthUserId:[NSString stringWithFormat:@"%ld",member.userId] userName:name imageView:cell.avatarImage];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
