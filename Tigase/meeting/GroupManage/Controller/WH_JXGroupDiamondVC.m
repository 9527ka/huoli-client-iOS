//
//  WH_JXGroupDiamondVC.m
//  Tigase
//
//  Created by luan on 2023/5/31.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupDiamondVC.h"
#import "WH_JXGroupDiamondCell.h"
#import "WH_JXVerifyPay_WHVC.h"
#import "BindTelephoneChecker.h"

@interface WH_JXGroupDiamondVC () <UITextFieldDelegate, WH_JXGroupDiamondCell_Delegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
//@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) UILabel *totalNumberLabel;
@property (nonatomic, strong) UITextField *seekTextField;
@property (nonatomic, strong) WH_JXVerifyPay_WHVC * verVC;

@property (nonatomic, strong)memberData *currentMember;
@property (nonatomic, copy)NSString *diamoundCount;
@property (nonatomic, assign)NSInteger type;

@property (nonatomic, strong)UIImageView *noDataImage;//icon_not_found
@property (nonatomic, strong)UILabel *noDataLab;
@end

@implementation WH_JXGroupDiamondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wh_heightHeader = JX_SCREEN_TOP;
    self.wh_heightFooter = 0;
    self.wh_isGotoBack   = YES;
    [self WH_createHeadAndFoot];
    
//    self.dataSource = (NSMutableArray *)[memberData fetchAllMembers:self.room.roomId sortByName:NO];
    
//    self.searchArray = [NSMutableArray array];
    
    [self.tableView setBackgroundColor:g_factory.globalBgColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXGroupDiamondCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXGroupDiamondCell"];
    
    [self customSearchTextField];
    
    [self WH_getServerData];
}
//数据请求
-(void)WH_getServerData{
    [self.view endEditing:YES];
    [g_server WH_MemberSpecial:self.seekTextField.text roomId:self.room.roomId toView:self];
}

- (void)customSearchTextField {
    
    //搜索输入框
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, JX_SCREEN_TOP, JX_SCREEN_WIDTH, 81)];
    backView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:backView];
    
    self.totalNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, JX_SCREEN_WIDTH - 30, 25)];
    self.totalNumberLabel.font = [UIFont systemFontOfSize:16];
    self.totalNumberLabel.textColor = [UIColor blackColor];
    self.totalNumberLabel.text = [NSString stringWithFormat:@"群内总钻石:%@",self.room.quota];
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
//    [_seekTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.tableView.tableHeaderView = backView;
    
    
    
    _noDataImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_not_found"]];
    _noDataImage.frame = CGRectMake((JX_SCREEN_WIDTH - 120)/2, (JX_SCREEN_HEIGHT - 120)/2 - 80, 120, 120);
    self.noDataImage.hidden = YES;
    [self.tableView addSubview:self.noDataImage];
    
    _noDataLab = [[UILabel alloc] initWithFrame:CGRectMake((JX_SCREEN_WIDTH - 120)/2, (JX_SCREEN_HEIGHT - 120)/2 + 48, 120, 20)];
    _noDataLab.text = @"暂无数据";
    _noDataLab.textAlignment = NSTextAlignmentCenter;
    _noDataLab.textColor = [UIColor systemGray2Color];
    _noDataLab.hidden = YES;
    [self.tableView addSubview:self.noDataLab];
}

- (void)allocationDiamond:(memberData *)data number:(NSString *)number type:(NSInteger)type{
    
    self.currentMember = data;
    self.type = type;
    self.diamoundCount = number;
    
    //输入密码
    g_myself.isPayPassword = [g_default objectForKey:PayPasswordKey];
    if ([g_myself.isPayPassword boolValue]) {
        self.verVC = [WH_JXVerifyPay_WHVC alloc];
        self.verVC.type = JXVerifyTypeSendDiamond;
        self.verVC.wh_RMB = number;
        self.verVC.delegate = self;
        self.verVC.didDismissVC = @selector(WH_dismiss_WHVerifyPayVC);
        self.verVC.didVerifyPay = @selector(WH_didVerifyPay:);
        self.verVC = [self.verVC init];
        
        [self.view addSubview:self.verVC.view];
    } else {
        [BindTelephoneChecker checkBindPhoneWithViewController:self entertype:JXEnterTypeSendRedPacket];
    }
    
}
- (void)WH_didVerifyPay:(NSString *)sender{
    
    long time = (long)[[NSDate date] timeIntervalSince1970] + (g_server.timeDifference / 1000);
    
    NSString *secret = [self getSecretWithText:sender time:time];
    
    [g_server allocationGroupMemberDiamondNumber:self.room.roomJid memberId:self.currentMember.userId diamondNumber:self.diamoundCount time:[NSString stringWithFormat:@"%ld", time] type:self.type secret:secret toDelegate:self];
}
- (NSString *)getSecretWithText:(NSString *)text time:(long)time {
    NSMutableString *str1 = [NSMutableString string];
    [str1 appendString:APIKEY];
    [str1 appendString:[NSString stringWithFormat:@"%ld",time]];
    [str1 appendString:[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:[self.diamoundCount doubleValue]]]];
    str1 = [[g_server WH_getMD5StringWithStr:str1] mutableCopy];
    
    [str1 appendString:g_myself.userId];
    [str1 appendString:g_server.access_token];
    NSMutableString *str2 = [NSMutableString string];
    str2 = [[g_server WH_getMD5StringWithStr:text] mutableCopy];
    [str1 appendString:str2];
    str1 = [[g_server WH_getMD5StringWithStr:str1] mutableCopy];
    
    return [str1 copy];

}

- (void)WH_dismiss_WHVerifyPayVC {
    [self.verVC.view removeFromSuperview];
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
    [g_server WH_getHeadImageSmallWIthUserId:[NSString stringWithFormat:@"%ld", data.userId] userName:data.nickname imageView:cell.avatarImage];
    
    cell.diamondLabel.text = [NSString stringWithFormat:@"%ld",(long)data.amount.integerValue];
    
    if(data.userId == MY_USER_ID.integerValue){
        self.room.amount = data.amount;
    }
    
    WH_JXUserObject *user = [[WH_JXUserObject alloc] init];
    user = [user getUserById:[NSString stringWithFormat:@"%ld",data.userId]];
//    cell.nicknameLabel.text = data.lordRemarkName.length > 0 ? data.lordRemarkName : user.remarkName.length > 0  ? user.remarkName : data.userNickName;
    cell.nicknameLabel.text = data.nickname;
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
//    NSString *nickname = data.lordRemarkName.length > 0 ? data.lordRemarkName : user.remarkName.length > 0  ? user.remarkName : data.userNickName;
    
    NSString *nickname = data.nickname;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@钻石数量", (type == 1) ? @"增加" : @"减少"] message:[NSString stringWithFormat:@"成员:%@,当前数量:%ld", nickname,data.amount.integerValue] preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"请输入修改数量"];
        [textField setKeyboardType:UIKeyboardTypeDecimalPad];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (alert.textFields.firstObject.text.doubleValue <= 0) {
            [g_server showMsg:@"请输入正确的数量"];
        } else {
            if(type ==1){//增加
                NSString *count = [NSString stringWithFormat:@"%@", alert.textFields.firstObject.text];
                if(count.doubleValue > self.room.amount.doubleValue){
                    [g_server showMsg:@"余额不足"];
                    return;
                }
            }else{
                NSString *count = [NSString stringWithFormat:@"%@", alert.textFields.firstObject.text];
                if(count.doubleValue > data.amount.doubleValue){
                    [g_server showMsg:@"成员余额不足"];
                    return;
                }
            }
            //type 1增加
            [self allocationDiamond:data number:[NSString stringWithFormat:@"%@", alert.textFields.firstObject.text] type:type];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

// MARK: -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [self WH_getServerData];
    
    
    
//    [self.searchArray removeAllObjects];
//    if (textField.text.length <= 0) {
//
//        self.dataSource = (NSMutableArray *)[memberData fetchAllMembers:self.room.roomId sortByName:NO];
//
//        [self.tableView reloadData];
//        return YES;
//    }
//
//    for (NSInteger i = 0; i < self.dataSource.count; i ++) {
//        memberData *data = self.dataSource[i];
//        WH_JXUserObject *allUser = [[WH_JXUserObject alloc] init];
//        allUser = [allUser getUserById:[NSString stringWithFormat:@"%ld",data.userId]];
//        NSString *name = [NSString string];
//        if ([[NSString stringWithFormat:@"%ld",_room.userId] isEqualToString:MY_USER_ID]) {
//            name = data.lordRemarkName ? data.lordRemarkName : allUser.remarkName.length > 0  ? allUser.remarkName : data.userNickName;
//        } else {
//            name = allUser.remarkName.length > 0  ? allUser.remarkName : data.userNickName;
//        }
//        NSString *userStr = [name lowercaseString];
//        NSString *textStr = [textField.text lowercaseString];
//        if ([userStr rangeOfString:textStr].location != NSNotFound) {
//            [self.searchArray addObject:data];
//        }
//    }
//    self.dataSource = self.searchArray;
//    [self.tableView reloadData];
    
    return YES;
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if([aDownload.action isEqualToString:act_diamond_decrease] || [aDownload.action isEqualToString:act_diamond_increase]){
       //NSLog(@"请求成功");
        //移除掉密码界面
        [self WH_dismiss_WHVerifyPayVC];
        
        [g_server showMsg:@"操作成功"];
        self.seekTextField.text = @"";
    
        [self WH_getServerData];
        
    }else if ([aDownload.action isEqualToString:wh_member_special]){//成员列表
        self.dataSource = [NSMutableArray arrayWithArray:[memberData mj_objectArrayWithKeyValuesArray:array1]];
        self.noDataImage.hidden = self.noDataLab.hidden = array1.count > 0?YES:NO;
        [self.tableView reloadData];
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
