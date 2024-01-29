//
//  WH_JXRedPacketSecVC.m
//  Tigase
//
//  Created by 1111 on 2024/1/27.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXRedPacketSecVC.h"
#import "WH_JXRedPacketSecCell.h"
#import "BMChineseSort.h"
#import "WH_JXGroupRedPacketSetupMemberVC.h"
#import "UIAlertController+category.h"
#import "WH_UserRedData.h"

@interface WH_JXRedPacketSecVC ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>{
    ATMHud* _wait;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIButton *certainBtn;

@end

@implementation WH_JXRedPacketSecVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [g_server WH_HortcutGrabListWithRoomJId:self.room.roomJid toView:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _wait = [ATMHud sharedInstance];
    self.dataSource = [NSMutableArray array];
    self.tableView.rowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXRedPacketSecCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXRedPacketSecCell"];

    
    
    self.certainBtn.layer.cornerRadius = 8.0f;
}
- (IBAction)certainAction:(id)sender {
    NSString *memberIds = @"";
    NSString *delays = @"";
    
    for (memberData *dataUser in self.dataSource) {//总人数
        memberIds = [NSString stringWithFormat:@"%@%ld",memberIds.length > 0?@",":@"",dataUser.userId];
        delays = [NSString stringWithFormat:@"%@%@",delays.length > 0?@",":@"",dataUser.delays];
    }
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

- (IBAction)didTapConfirm {

    WH_JXGroupRedPacketSetupMemberVC *vc = [[WH_JXGroupRedPacketSetupMemberVC alloc] init];
    vc.room = self.room;
    vc.type = self.type;
    vc.direction = 2;
    vc.selectArray = self.dataSource;
    [g_navigation pushViewController:vc animated:YES];
    
}


#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXRedPacketSecCell *cell = (WH_JXRedPacketSecCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXRedPacketSecCell" forIndexPath:indexPath];
    WH_UserRedData *member = self.dataSource[indexPath.row];
    
    NSString *name = [NSString string];
    memberData *data = [self.room getMember:g_myself.userId];
    WH_JXUserObject *allUser = [[WH_JXUserObject alloc] init];
    allUser = [allUser getUserById:[NSString stringWithFormat:@"%@",member.userId]];
    name = member.memberName;
    
//    if (!self.room.allowSendCard && [data.role intValue] != 1 && [data.role intValue] != 2 && member.userId > 0) {
//        if (GroupMemberShowPlaceholderString) {
//            name = [name substringToIndex:[name length]-1];
//            name = [name stringByAppendingString:@"*"];
//        }
//    }
//    cell.selectImage.image = [UIImage imageNamed:member.isSelect?@"WH_addressbook_selected":@"WH_addressbook_unselected"];
    cell.nameLabel.text = name;
    [g_server WH_getHeadImageSmallWIthUserId:[NSString stringWithFormat:@"%@",member.userId] userName:name imageView:cell.avatarImage];
    cell.secField.text = member.delay;
    //设置时长
    __weak typeof (self)weakSelf = self;
    cell.textCountBlock = ^(NSString * _Nonnull count) {
        count = count.length > 0?count:@"0";
        [g_server WH_shortcutUpdatWithRoomJId:weakSelf.room.roomJid memberId:member.userId delay:count isDelete:NO toView:self];
        member.delay = count;
    };
    cell.longPressBlock = ^{
        [UIAlertController showAlertViewWithTitle:@"确定取消该成员的快抢功能吗" message:nil controller:weakSelf block:^(NSInteger buttonIndex) {
            if (buttonIndex==1) {
                
                [g_server WH_shortcutUpdatWithRoomJId:weakSelf.room.roomJid memberId:member.userId delay:@"0" isDelete:YES toView:self];
                
            }
        } cancelButtonTitle:Localized(@"JX_Cencal") otherButtonTitles:Localized(@"JX_Confirm")];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    memberData *member = self.dataSource[indexPath.row];
//    member.isSelect = !member.isSelect;
//    [self.tableView reloadData];
//
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];

    if([aDownload.action isEqualToString:wh_shortcut_grab]){
        [self.dataSource removeAllObjects];
        self.dataSource = [WH_UserRedData mj_objectArrayWithKeyValuesArray:array1];
        [self.tableView reloadData];
    }else if ([aDownload.action isEqualToString:wh_shortcut_delete]){
        [g_server showMsg:@"操作成功"];
        [g_server WH_HortcutGrabListWithRoomJId:self.room.roomJid toView:self];
    }else if ([aDownload.action isEqualToString:wh_shortcut_update]){
        [g_server showMsg:@"设置成功"];
    }
    
    
}
#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    return WH_show_error;
}
#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    [_wait start];
}


@end
