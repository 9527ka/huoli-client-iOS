//
//  WH_JXGroupDiamondVC.m
//  Tigase
//
//  Created by luan on 2023/5/31.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupDiamondVC.h"
#import "WH_JXGroupDiamondCell.h"

@interface WH_JXGroupDiamondVC () <UITextFieldDelegate, WH_JXGroupDiamondCell_Delegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) UILabel *totalNumberLabel;
@property (nonatomic, strong) UITextField *seekTextField;

@end

@implementation WH_JXGroupDiamondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wh_heightHeader = JX_SCREEN_TOP;
    self.wh_heightFooter = 0;
    self.wh_isGotoBack   = YES;
    [self WH_createHeadAndFoot];
    
    self.dataSource = (NSMutableArray *)[memberData fetchAllMembers:self.room.roomId sortByName:NO];
    self.searchArray = [NSMutableArray array];
    
    [self.tableView setBackgroundColor:g_factory.globalBgColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXGroupDiamondCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXGroupDiamondCell"];
    
    [self customSearchTextField];
}

- (void)customSearchTextField {
    //搜索输入框
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, JX_SCREEN_TOP, JX_SCREEN_WIDTH, 81)];
    backView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:backView];
    
    self.totalNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, JX_SCREEN_WIDTH - 30, 25)];
    self.totalNumberLabel.font = [UIFont systemFontOfSize:16];
    self.totalNumberLabel.textColor = [UIColor blackColor];
    self.totalNumberLabel.text = @"群内总钻石:3000";
    [backView addSubview:self.totalNumberLabel];
    
    _seekTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 41, backView.frame.size.width - 20, 30)];
    _seekTextField.placeholder = [NSString stringWithFormat:@"%@", Localized(@"JX_EnterKeyword")];
    _seekTextField.backgroundColor = g_factory.inputBackgroundColor;
    if (@available(iOS 10, *)) {
        _seekTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", Localized(@"JX_EnterKeyword")] attributes:@{NSForegroundColorAttributeName:g_factory.inputDefaultTextColor}];
    } else {
        [_seekTextField setValue:g_factory.inputDefaultTextColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    [_seekTextField setFont:g_factory.inputDefaultTextFont];
    _seekTextField.textColor = HEXCOLOR(0x333333);
    _seekTextField.layer.borderWidth = 0.5;
    _seekTextField.layer.borderColor = g_factory.inputBorderColor.CGColor;
    _seekTextField.layer.backgroundColor = [UIColor colorWithRed:250/255.0 green:251/255.0 blue:252/255.0 alpha:1.0].CGColor;
    _seekTextField.layer.cornerRadius = 15;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search"]];
    UIView *leftView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.center = leftView.center;
    [leftView addSubview:imageView];
    _seekTextField.leftView = leftView;
    _seekTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _seekTextField.leftViewMode = UITextFieldViewModeAlways;
    _seekTextField.borderStyle = UITextBorderStyleNone;
    _seekTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _seekTextField.delegate = self;
    _seekTextField.returnKeyType = UIReturnKeyGoogle;
    [backView addSubview:_seekTextField];
    [_seekTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.tableView.tableHeaderView = backView;
}

- (void)allocationDiamond:(memberData *)data number:(NSString *)number {
    long time = (long)[[NSDate date] timeIntervalSince1970] + (g_server.timeDifference / 1000);
    [g_server allocationGroupMemberDiamondNumber:self.room.roomId memberId:data.userId diamondNumber:number time:[NSString stringWithFormat:@"%ld", time] toDelegate:self];
}

// MARK: -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXGroupDiamondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WH_JXGroupDiamondCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.tag = indexPath.row;
    
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

// MARK: -- WH_JXGroupDiamondCell_Delegate
- (void)updateDiamondNumber:(NSInteger)row type:(NSInteger)type {
    memberData *data = (memberData *)(self.dataSource[row]);
    WH_JXUserObject *user = [[WH_JXUserObject alloc] init];
    user = [user getUserById:[NSString stringWithFormat:@"%ld",data.userId]];
    NSString *nickname = data.lordRemarkName.length > 0 ? data.lordRemarkName : user.remarkName.length > 0  ? user.remarkName : data.userNickName;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@钻石数量", (type == 1) ? @"增加" : @"减少"] message:[NSString stringWithFormat:@"成员:%@,当前数量:1000", nickname] preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"请输入修改数量"];
        [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (alert.textFields.firstObject.text.doubleValue == 0) {
            [g_server showMsg:@"请输入正确的数量"];
        } else {
            [self allocationDiamond:data number:[NSString stringWithFormat:@"%s%@", ((type == 1) ? "" : "-"), alert.textFields.firstObject.text]];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

// MARK: -- UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length <= 0) {
        [self.tableView reloadData];
        return;
    }
    [self.searchArray removeAllObjects];

    for (NSInteger i = 0; i < self.dataSource.count; i ++) {
        memberData *data = self.dataSource[i];
        WH_JXUserObject *allUser = [[WH_JXUserObject alloc] init];
        allUser = [allUser getUserById:[NSString stringWithFormat:@"%ld",data.userId]];
        NSString *name = [NSString string];
        if ([[NSString stringWithFormat:@"%ld",_room.userId] isEqualToString:MY_USER_ID]) {
            name = data.lordRemarkName ? data.lordRemarkName : allUser.remarkName.length > 0  ? allUser.remarkName : data.userNickName;
        } else {
            name = allUser.remarkName.length > 0  ? allUser.remarkName : data.userNickName;
        }
        NSString *userStr = [name lowercaseString];
        NSString *textStr = [textField.text lowercaseString];
        if ([userStr rangeOfString:textStr].location != NSNotFound) {
            [self.searchArray addObject:data];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
   if([aDownload.action isEqualToString:act_diamond_allocation]){
       NSLog(@"请求成功");
   }
}

#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
   [_wait stop];
   return WH_show_error;
}

#pragma mark - 请求出错回调
-(int)WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error {//error为空时，代表超时
   [_wait stop];
   return WH_show_error;
}

#pragma mark - 开始请求服务器回调
-(void)WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload {
      [_wait start];
}

@end
