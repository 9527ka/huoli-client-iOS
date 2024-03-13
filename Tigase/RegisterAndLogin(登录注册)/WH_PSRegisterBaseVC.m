//
//  WH_PSRegisterBaseVC.m
//  wahu_im
//
//  Created by flyeagleTang on 14-6-10.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "WH_PSRegisterBaseVC.h"
//#import "WH_selectTreeVC_WHVC.h"
#import "WH_selectValue_WHVC.h"
#import "WH_selectProvince_WHVC.h"
#import "ImageResize.h"
#import "WH_ResumeData.h"
#import "WH_JXActionSheet_WHVC.h"
#import "WH_JXCamera_WHVC.h"
#import "WH_SettingHeadImgViewController.h"
#import "WH_SetGroupHeads_WHView.h"
#import "UIView+CustomAlertView.h"
#import "OBSHanderTool.h"
#import "WH_PwsSecSettingViewController.h"
#import "WH_RoundCornerCell.h"
#import "WH_JXUserObject+GetCurrentUser.h"



@interface WH_PSRegisterBaseVC ()<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,WH_JXActionSheet_WHVCDelegate,WH_JXCamera_WHVCDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UITableView *basicInfoTable;
    BOOL isMale; //!< YES 男,NO 女
    __block UIImage* selectedHeadImage;
    BOOL hasSetPassSec;//!<密保设置状态
    NSString *passSecurityString; //!< 设置好的密保字符串
    WH_ResumeBaseData* resume;
    NSString *cityStr;
}
@end
static NSString *HeadImgCellIdentifier = @"HeadImgCellIdentifier";
static NSString *NameCellIdentifier = @"NameCellIdentifier";
static NSString *ButtonCellIdentifier = @"ButtonCellIdentifier";
//static NSString *InviteCodeCellIdentifier = @"InviteCodeCellIdentifier";
static NSString *PassCellIdentifier = @"PassCellIdentifier";

@implementation WH_PSRegisterBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isMale = YES;
    [self customHeader];
    [self loadTableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tap.numberOfTapsRequired = 1;
    tap.cancelsTouchesInView = NO;
    [basicInfoTable addGestureRecognizer:tap];
}
- (void)customHeader {
    resume.telephone   = _user.telephone;
    self.wh_heightFooter = 0;
    self.wh_heightHeader = JX_SCREEN_TOP;
    self.wh_isGotoBack = YES;
    self.wh_isNotCreatewh_tableBody = NO;
    self.title = Localized(@"JX_BaseInfo");
    _user.sex = @(1);
    [self createHeadAndFoot];
    NSArray *maleImages = @[@(3), @(4), @(5), @(10), @(11), @(12), @(14), @(16)];
    int headImageIndex = arc4random() % 8;
    NSString *defaultImageString = [NSString stringWithFormat:@"headimage_%@",maleImages[headImageIndex]];
    selectedHeadImage = [UIImage imageNamed:defaultImageString];
        
}
- (void)loadTableView {
    basicInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, JX_SCREEN_TOP, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT-JX_SCREEN_TOP) style:UITableViewStylePlain];
    basicInfoTable.delegate = self;
    basicInfoTable.dataSource = self;
    basicInfoTable.backgroundColor = g_factory.globalBgColor;
    basicInfoTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    basicInfoTable.tableFooterView = [UIView new];
    basicInfoTable.separatorColor = HEXCOLOR(0xF8F8F7);
    [self.view addSubview:basicInfoTable];
}

#pragma mark --- UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = 3;
    if (self.registType == 1 && [g_config.isQestionOpen boolValue]) {
        number += 1;
    }
    
    return number;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 1;
    if (section == 1) {
        number += 1;
        if (g_config.isOpenPositionService) {
            //number += 1;//现在不论位置服务是否开启,注册时的居住地全部不显示
        }
    }
    return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 55;
    if (indexPath.section == 0) {
        cellHeight = 75;
    }
    NSInteger sections = [tableView numberOfSections];
    if (indexPath.section == sections-1) {
        cellHeight = 48;
    }
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_RoundCornerCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [self getHeadImageCell:indexPath];
    }else if (indexPath.section == 1) {
        cell = [self getInfoCell:indexPath];
    }else if (indexPath.section == 2) {
        if (self.registType == 1 && [g_config.isQestionOpen boolValue]) {
            cell = [self getPasswordSecCell:indexPath];
        }else {
            cell = [self getButtonCell:indexPath];
        }
    }else {
        cell = [self getButtonCell:indexPath];
    }
//    if (g_config.registerInviteCode != 0) {
//        if (self.registType == 1 && indexPath.section == 3) {
//            cell = [self getInviteCodeCell:indexPath];
//        }else if(indexPath.section == 2) {
//            cell = [self getInviteCodeCell:indexPath];
//        }
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }else {
        cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    }
    
    cell.cellIndexPath = indexPath;
    return cell;
}
- (WH_RoundCornerCell *)getHeadImageCell:(NSIndexPath *)indexPath {
    WH_RoundCornerCell *cell = [basicInfoTable dequeueReusableCellWithIdentifier:HeadImgCellIdentifier];
    if (!cell) {
        cell = [[WH_RoundCornerCell alloc] initWithReuseIdentifier:HeadImgCellIdentifier tableView:basicInfoTable indexPath:indexPath];
        WH_JXImageView *headImgView = [[WH_JXImageView alloc]initWithFrame:CGRectMake(40, (75-44)/2, 44, 44)];
        headImgView.layer.cornerRadius = 44/2;
        headImgView.layer.masksToBounds = YES;
        headImgView.wh_delegate = self;
        headImgView.image = [UIImage imageNamed:@"avatar_normal"];
        headImgView.tag = 100;
        [cell.contentView addSubview:headImgView];
        
        UILabel *setHeadLabel = [[UILabel alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH - 20 - 20 - 70 - 12-7, 0, 70, 75)];
        [setHeadLabel setText:Localized(@"New_set_avatar")];
        [setHeadLabel setTextAlignment:NSTextAlignmentRight];
        [setHeadLabel setTextColor:HEXCOLOR(0xBABABA)];
        [setHeadLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 15]];
        [cell.contentView addSubview:setHeadLabel];
        
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emarrow"]];
        arrowImage.frame = CGRectMake(JX_SCREEN_WIDTH - 20 - 10 - 12, (75-7)/2, 7, 12);
        arrowImage.centerY = setHeadLabel.centerY;
        [cell.contentView addSubview:arrowImage];
    }
    WH_JXImageView *headImgView = [cell.contentView viewWithTag:100];
    if (selectedHeadImage) {
        headImgView.image = selectedHeadImage;
    }else if (!IsStringNull(_user.userId)) {
        [g_server WH_getHeadImageSmallWIthUserId:_user.userId userName:_user.userNickname imageView:headImgView];
    }
    return cell;
}
- (WH_RoundCornerCell *)getInfoCell:(NSIndexPath *)indexPath {
    WH_RoundCornerCell *cell = [basicInfoTable dequeueReusableCellWithIdentifier:NameCellIdentifier];
    if (!cell) {
        cell = [[WH_RoundCornerCell alloc] initWithReuseIdentifier:NameCellIdentifier tableView:basicInfoTable indexPath:indexPath];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 50, 55)];
        titleLabel.textColor = HEXCOLOR(0x3A404C);
        titleLabel.font = pingFangRegularFontWithSize(15);
        titleLabel.backgroundColor = UIColor.whiteColor;
        titleLabel.tag = 101;
        [cell.contentView addSubview:titleLabel];
        
        UITextField *nickTextField = [[UITextField alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH-40-12-200, 0, 200, 55)];
        nickTextField.textAlignment = NSTextAlignmentRight;
        nickTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"JX_NickName") attributes:@{NSFontAttributeName:pingFangRegularFontWithSize(15), NSForegroundColorAttributeName:HEXCOLOR(0xBABABA)}];
        nickTextField.delegate = self;
        nickTextField.tag = 10;
        [cell.contentView addSubview:nickTextField];
    
        UISegmentedControl *sexSegment = [[UISegmentedControl alloc] initWithItems:@[Localized(@"JX_Man"), Localized(@"JX_Wuman")]];
        [sexSegment addTarget:self action:@selector(segmentClicked:) forControlEvents:UIControlEventValueChanged];
        sexSegment.frame = CGRectMake(JX_SCREEN_WIDTH - 80 - 12 - 20,INSETS+3, 80, 55-2*13);
        sexSegment.selectedSegmentIndex = 0;
        sexSegment.tintColor = HEXCOLOR(0x2BAF67);
        sexSegment.layer.cornerRadius = 5;
        sexSegment.layer.borderWidth = 1.5;
        sexSegment.layer.borderColor = [HEXCOLOR(0x2BAF67) CGColor];
        sexSegment.clipsToBounds = YES;
        //设置文字属性
        sexSegment.selectedSegmentIndex = [_user.sex boolValue];
        sexSegment.apportionsSegmentWidthsByContent = NO;
        sexSegment.tag = 103;
        [cell.contentView addSubview:sexSegment];
    
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emarrow"]];
        arrowImage.frame = CGRectMake(JX_SCREEN_WIDTH - 10 - 10 - 12, (55-7)/2, 7, 12);
        arrowImage.tag = 104;
        [cell.contentView addSubview:arrowImage];
        
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH - 32 - 10 - 80, 0, 80, 55)];
        [cityLabel setTextAlignment:NSTextAlignmentRight];
        [cityLabel setTextColor:HEXCOLOR(0x969696)];
        [cityLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 15]];
        cityLabel.tag = 102;
        [cell.contentView addSubview:cityLabel];
    }
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:101];
    UITextField *nickTextField = (UITextField *)[cell.contentView viewWithTag:10];
    nickTextField.text = _user.userNickname;
    UISegmentedControl *sexSegment = [cell.contentView viewWithTag:103];
    sexSegment.selectedSegmentIndex = isMale ? 0 : 1;
    UILabel *cityLabel = (UILabel *)[cell.contentView viewWithTag:102];
    UIImageView *arrowImage = (UIImageView *)[cell.contentView viewWithTag:104];
    if (indexPath.row == 0) {//手机号注册
        titleLabel.text = Localized(@"JX_NickName");
        [nickTextField setHidden:NO];
        [sexSegment setHidden:YES];
        [cityLabel setHidden:YES];
        [arrowImage setHidden:YES];
    } else if (indexPath.row == 1){
        titleLabel.text = Localized(@"JX_Sex");
        [nickTextField setHidden:YES];
        [sexSegment setHidden:NO];
        [cityLabel setHidden:YES];
        [arrowImage setHidden:YES];
    } else {
        titleLabel.text = Localized(@"JX_Address");
        [nickTextField setHidden:YES];
        [sexSegment setHidden:YES];
        [cityLabel setHidden:NO];
        [arrowImage setHidden:NO];
        CGSize citySize = [cityStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size: 15]}];
        cityLabel.left = JX_SCREEN_WIDTH - 32-10-citySize.width;
        cityLabel.width = citySize.width;
        cityLabel.text = cityStr;
    }
    
    return cell;
}
- (WH_RoundCornerCell *)getPasswordSecCell:(NSIndexPath *)indexPath {
    WH_RoundCornerCell *cell = [basicInfoTable dequeueReusableCellWithIdentifier:PassCellIdentifier];
    if (!cell) {
        cell = [[WH_RoundCornerCell alloc] initWithReuseIdentifier:PassCellIdentifier tableView:basicInfoTable indexPath:indexPath];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+g_factory.globelEdgeInset, 0, 100, 55)];
        titleLabel.textColor = HEXCOLOR(0x3A404C);
        titleLabel.font = pingFangRegularFontWithSize(15);
        titleLabel.backgroundColor = UIColor.whiteColor;
        titleLabel.text = Localized(@"New_security_question");
        [cell.contentView addSubview:titleLabel];
        
        UILabel *passSecStatus = [[UILabel alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH-20-12-100-10, 0, 100, 55)];
        passSecStatus.textColor = HEXCOLOR(0xBABABA);
        passSecStatus.font = pingFangRegularFontWithSize(15);
        passSecStatus.textAlignment = NSTextAlignmentRight;
        passSecStatus.tag = 102;
        [cell.contentView addSubview:passSecStatus];
        
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emarrow"]];
        arrowImage.frame = CGRectMake(JX_SCREEN_WIDTH - 10 - 10 - 12, (55-7)/2, 7, 12);
        arrowImage.centerY = passSecStatus.centerY;
        [cell.contentView addSubview:arrowImage];
    }
    UILabel *passSecStatus = (UILabel *)[cell.contentView viewWithTag:102];
    passSecStatus.text = hasSetPassSec ? Localized(@"PassHasSet") : Localized(@"SetPassSecurity");
    return cell;
}

- (WH_RoundCornerCell *)getButtonCell:(NSIndexPath *)indexPath {
    WH_RoundCornerCell *cell = [basicInfoTable dequeueReusableCellWithIdentifier:ButtonCellIdentifier];
    if (!cell) {
        cell = [[WH_RoundCornerCell alloc] initWithReuseIdentifier:ButtonCellIdentifier tableView:basicInfoTable indexPath:indexPath];
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:Localized(@"JX_Confirm") forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 24.0f;
        button.custom_acceptEventInterval = 1.5f;
        button.clipsToBounds = YES;
        button.enabled = NO;
        button.tag = 202;
        button.frame = CGRectMake(37,  0, JX_SCREEN_WIDTH - 74, 48);
        [button setBackgroundColor:HEXCOLOR(0x2BAF67)];
        [cell.contentView addSubview:button];
        cell.bgView.hidden = YES;
    }
    UIButton *button = (UIButton *)[cell.contentView viewWithTag:202];
    button.enabled = [self shouldConfirm];
    button.backgroundColor = button.enabled ? HEXCOLOR(0x2BAF67) : HEXCOLOR(0x88D5AB);
    return cell;
}
#pragma mark ----- UITapGesture
- (void)tapGestureAction:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}


/**
 检查必要信息是否填写完整，刷新确定按钮的状态
 */
- (BOOL)shouldConfirm {
    if (self.registType == 0) {
        if (IsStringNull(_user.password)) {
            return NO;
        }
    }else {
        if (!hasSetPassSec && [g_config.isQestionOpen boolValue]) {
            return NO;
        }
    }
    if (selectedHeadImage && !IsStringNull(_user.userNickname)) {
        return YES;
    }
    return NO;
}
#pragma mark ---- UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRoxwAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        [self pickImage];
    }else if (indexPath.section == 2 && [tableView numberOfSections] == 4) {
        [self setUpPasswordSecurity];
    }else if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            [self selectAddress];
        }
    }
}

#pragma mark ----- UITableView HeaderView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSInteger lastSection = (self.registType == 0 && [g_config.isQestionOpen boolValue]) ? 2 : 3;
    return (section == lastSection) ? 20 : 12;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark ---- UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 10) {
//        nickName = textField.text;
        //去掉空格
        _user.userNickname = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }else {
        self.inviteCode = textField.text;
    }
    [basicInfoTable reloadData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
- (void)textFieldEditChanged:(UITextField *)textField {
    [g_factory setTextFieldInputLengthLimit:textField maxLength:NAME_INPUT_MAX_LENGTH];
}
#pragma mark ---------- 设置密保问题
- (void)setUpPasswordSecurity {
    WH_PwsSecSettingViewController* vc = [[WH_PwsSecSettingViewController alloc] init];
    vc.isRegist = YES;
    vc.questionBlock = ^(NSString * _Nonnull questions) {
        passSecurityString = questions;
        if (!IsStringNull(passSecurityString)) {
            hasSetPassSec = YES;
            [basicInfoTable reloadData];
        }
    };
    [g_navigation pushViewController:vc animated:YES];
}

-(void)dealloc{
//    //NSLog(@"WH_PSRegisterBaseVC.dealloc");
//    [_image release];
    self.user = nil;
//    resume = nil;
    
//    [_date removeFromSuperview];
//    [_date release];
//    [super dealloc];
}

- (void)segmentClicked:(UISegmentedControl *)segment {
    isMale = segment.selectedSegmentIndex != 1;
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
//    [_wait stop];
    
    if( [aDownload.action isEqualToString:wh_act_Config]){
        
        [g_config didReceive:dict];
        [_wait start];
        [g_server registerUser:_user inviteCode:self.inviteCode  isSmsRegister:self.isSmsRegister registType:self.registType passSecurity:passSecurityString smsCode:self.smsCode  toView:self];
    }else if( [aDownload.action isEqualToString:wh_act_Register] ){
        [g_default setBool:NO forKey:kTHIRD_LOGIN_AUTO];
        
        //注册成功杀死程序重新进程序不会自动登录问题
        [g_default setBool:YES forKey:kIsAutoLogin];
        
        g_config.lastLoginType = [NSNumber numberWithInteger:self.registType];
        [g_server doLoginOK:dict user:_user];
//        self.user = g_myself;

        self.resumeId   = [[dict objectForKey:@"cv"] objectForKey:@"resumeId"];
//        [g_server autoLogin:self];
        [_wait start];
//        [g_server getUser:[[dict objectForKey:@"userId"] stringValue] toView:self];
        [[WH_JXUserObject sharedUserInstance] getCurrentUser];
        
        //注册完成头像没有BUG
        __block NSString *userId = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"userId"] stringValue]];
        _user.userId = userId;
        
        [WH_JXUserObject sharedUserInstance].complete = ^(HttpRequestStatus status, NSDictionary * _Nullable userInfo, NSError * _Nullable error) {
            /*直接上传服务器,改为上传obs*/
            [OBSHanderTool WH_handleUploadOBSHeadImage:userId image:selectedHeadImage toView:self success:^(int code) {
                if (code == 1) {
                    [self postRegistSuccessNotification];
                } else {
                    [self postRegistSuccessNotification];
                }
            } failed:^(NSError * _Nonnull error) {
                [self postRegistSuccessNotification];
            }];
        };
        
        
    }else if([aDownload.action isEqualToString:wh_act_UserGet]){
        g_config.lastLoginType = [NSNumber numberWithInteger:self.registType];
        [g_default setBool:NO forKey:WH_ThirdPartyLogins];
         [g_server doLoginOK:dict user:_user];
        
        /*直接上传服务器,改为上传obs*/
        [OBSHanderTool WH_handleUploadOBSHeadImage:_user.userId image:selectedHeadImage toView:self success:^(int code) {
            if (code == 1) {
                [self postRegistSuccessNotification];
            }
        } failed:^(NSError * _Nonnull error) {
            [self postRegistSuccessNotification];
        }];
        
    }else if( [aDownload.action isEqualToString:wh_act_UploadHeadImage] ){
        selectedHeadImage = nil;
       [self postRegistSuccessNotification];
    }else if( [aDownload.action isEqualToString:wh_act_resumeUpdate] ){
        if(selectedHeadImage) {
            /*直接上传服务器,改为上传obs*/
//            [g_server uploadHeadImage:g_myself.userId image:_image toView:self];
            [OBSHanderTool WH_handleUploadOBSHeadImage:_user.userId image:selectedHeadImage toView:self success:^(int code) {
                if (code == 1) {
                    [basicInfoTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self postRegistSuccessNotification];
                }
            } failed:^(NSError * _Nonnull error) {

            }];
        } else{
//            g_myself.userNickname = nickName;
//            g_myself.sex = isMale ? @(1) : @(0);
//            g_myself.birthday = _date.date;
//            g_myself.cityId = [NSNumber numberWithInt:[_city.text intValue]];
            [GKMessageTool showSuccess:Localized(@"JXAlert_UpdateOK")];
            [g_notify postNotificationName:kUpdateUser_WHNotifaction object:self userInfo:nil];
            [self actionQuit];
        }
    }else if ([aDownload.action isEqualToString:wh_act_RegisterSDK]) {
        [g_default setBool:YES forKey:kTHIRD_LOGIN_AUTO];
//        g_server.openId = nil;
        g_config.lastLoginType = [NSNumber numberWithInteger:self.registType];
        [g_server doLoginOK:dict user:_user];
        self.user = g_myself;
        
        self.resumeId   = [[dict objectForKey:@"cv"] objectForKey:@"resumeId"];
        [_wait start];
        [g_server getUser:[[dict objectForKey:@"userId"] stringValue] toView:self];
       
//        //绑定账号
//        if (self.iswWxinLogin) {
//              [g_server thirdLogin:user type:[self.iswWxinLogin integerValue] openId:g_server.openId isLogin:NO toView:self];
//        }
    }
}

#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    if( [aDownload.action isEqualToString:wh_act_resumeUpdate] ){
        if(selectedHeadImage) {
            /*直接上传服务器,改为上传obs*/
            [OBSHanderTool WH_handleUploadOBSHeadImage:_user.userId image:selectedHeadImage toView:self success:^(int code) {
                if (code == 1) {
                    [basicInfoTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self postRegistSuccessNotification];
                }
            } failed:^(NSError * _Nonnull error) {
                
            }];
        }
    }else if( [aDownload.action isEqualToString:wh_act_Config] ){
        
    }else if( [aDownload.action isEqualToString:wh_act_UploadHeadImage] ){
        selectedHeadImage = nil;
        [self postRegistSuccessNotification];
    }
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    if( [aDownload.action isEqualToString:wh_act_UploadHeadImage] ){
        [self postRegistSuccessNotification];
    }
    return WH_show_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    [_wait start];
}


#pragma mark ----- 图片选择
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    selectedHeadImage = [ImageResize image:[info objectForKey:@"UIImagePickerControllerEditedImage"] fillSize:CGSizeMake(640, 640)];
    [basicInfoTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) pickImage
{
    [self.view endEditing:YES];
    WH_SettingHeadImgViewController *settingHeadVC = [[WH_SettingHeadImgViewController alloc] init];
    settingHeadVC.defaultImage = selectedHeadImage;
    settingHeadVC.user = self.user;
    settingHeadVC.isNeedRegistFirst = YES;
    settingHeadVC.changeHeadImageBlock = ^(UIImage * _Nonnull headImage) {
        selectedHeadImage = headImage;
        [basicInfoTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [g_navigation pushViewController:settingHeadVC animated:YES];

}

- (void)actionSheet:(WH_JXActionSheet_WHVC *)actionSheet didButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        //选择图片模式
        ipc.modalPresentationStyle = UIModalPresentationCurrentContext;
        //    [g_window addSubview:ipc.view];
        if (IS_PAD) {
            UIPopoverController *pop =  [[UIPopoverController alloc] initWithContentViewController:ipc];
            [pop presentPopoverFromRect:CGRectMake((self.view.frame.size.width - 320) / 2, 0, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else {
            [self presentViewController:ipc animated:YES completion:nil];
        }
        
    }else {
        WH_JXCamera_WHVC *vc = [WH_JXCamera_WHVC alloc];
        vc.cameraDelegate = self;
        vc.isPhoto = YES;
        vc = [vc init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)cameraVC:(WH_JXCamera_WHVC *)vc didFinishWithImage:(UIImage *)image {
    selectedHeadImage = [ImageResize image:image fillSize:CGSizeMake(640, 640)];
    [basicInfoTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    [picker.view removeFromSuperview];
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker release];
    //	[self dismissModalViewControllerAnimated:YES];
}

-(void)onUpdate{
    if(![self getInputValue])
        return;
    NSString* s = [[resume setDataToDict] mj_JSONString];
    [g_server updateResume:self.resumeId nodeName:@"p" text:s toView:self];
}
#pragma mark ----- 城市选择
-(void)selectAddress {
    [self.view endEditing:YES];
    
    WH_selectProvince_WHVC* vc = [WH_selectProvince_WHVC alloc];
    vc.delegate = self;
    vc.didSelect = @selector(WH_onSelCity:);
    vc.showCity = YES;
    vc.showArea = NO;
    vc.parentId = 1;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
}

-(void)WH_onSelCity:(WH_selectProvince_WHVC*)sender{
    //    resume.cityId = sender.cityId;
    //    resume.provinceId = sender.provinceId;
    //    resume.areaId = sender.areaId;
    //    resume.countryId = 1;
    
    _user.areaId = [NSNumber numberWithInt:sender.areaId];
    _user.provinceId = [NSNumber numberWithInt:sender.provinceId];
    _user.provinceId = [NSNumber numberWithInt:sender.provinceId];
    _user.cityId = [NSNumber numberWithInt:sender.cityId];
    cityStr = sender.selValue;
    [basicInfoTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark ----- 注册
-(void)confirmButtonAction {
    if(![self getInputValue])
        return;
    [_wait start];
    [g_server getSetting:self];
}

-(BOOL)getInputValue{
    if(selectedHeadImage==nil){
        [GKMessageTool showTips:Localized(@"JX_SetHead")];
        return NO;
    }
    if(IsStringNull(_user.userNickname)){
        [GKMessageTool showTips:Localized(@"JX_InputName")];
        return NO;
    }
//    if(!self.isRegister){
//        if(resume.workexpId<=0){
//            [GKMessageTool showTips:Localized(@"JX_InputWorking")];
//            return NO;
//        }
//        if(resume.diplomaId<=0){
//            [GKMessageTool showTips:Localized(@"JX_School")];
//            return NO;
//        }
//        if(resume.cityId<=0){
//            [GKMessageTool showTips:Localized(@"JX_Live")];
//            return NO;
//        }
//    }else {
//        if ([g_config.registerInviteCode intValue] == 1) {
//            if (IsStringNull(self.inviteCode)) {
//                [GKMessageTool showTips:Localized(@"JX_EnterInvitationCode")];
//                return NO;
//            }
//        }
//    }
//    resume.name = _user.userNickname;
//    resume.birthday = [_date.date timeIntervalSince1970];
//    resume.sex = isMale;
    return  YES;
}
- (void)postRegistSuccessNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [g_server WH_delHeadImageWithUserId:_user.userId];
        [GKMessageTool showSuccess:Localized(@"JX_RegOK")];
        [g_notify postNotificationName:kUpdateUser_WHNotifaction object:self userInfo:nil];
        [g_notify postNotificationName:kRegistSuccessNotifaction object:self userInfo:nil];

        [g_App showMainUI];
    });
}

@end
