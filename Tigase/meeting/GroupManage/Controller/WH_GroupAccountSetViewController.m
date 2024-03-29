//
//  WH_GroupAccountSetViewController.m
//  Tigase
//
//  Created by 1111 on 2023/12/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_GroupAccountSetViewController.h"
#import "WH_GroupAccountSetCell.h"
#import "WH_AddAccountViewController.h"
#import "UIAlertController+category.h"

@interface WH_GroupAccountSetViewController ()<UITableViewDataSource, UITableViewDelegate>{
    ATMHud* _wait;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nodataLab;
@property (weak, nonatomic) IBOutlet UIImageView *noDataImage;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (strong, nonatomic) UILabel *noticeLab;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation WH_GroupAccountSetViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.dataBlock){
        self.dataBlock(self.dataArray);
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(!self.room){
        [g_server WH_UserAccount:self];
    }else{
        [g_server WH_ReceiveAccountListWithRoomJid:self.room.roomJid toView:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addBtn.layer.cornerRadius = 24.0f;
    
    self.addBtn.hidden = NO;
    
    self.dataArray = [NSMutableArray array];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_GroupAccountSetCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_GroupAccountSetCell"];
    
    _noticeLab = [[UILabel alloc] init];
//    _noticeLab.backgroundColor = HEXCOLOR(0xF3FFF8);
//    _noticeLab.layer.cornerRadius = 6.0f;
//    _noticeLab.layer.masksToBounds = YES;
    _noticeLab.text = @"*请确保您设置的账户为本人实名账户，非本人实名账户付款会导致订单失败且账户冻结。\n\n*向买家仅展示已开启的收款账号。\n\n*买家将直接使用您选择的收款方式付款。交易时，请始终检查您的收款账户已确认您已收到全额付款。";
    _noticeLab.numberOfLines = 0;
    _noticeLab.font = [UIFont systemFontOfSize:12];
    _noticeLab.textColor = HEXCOLOR(0x797979);
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JX_SCREEN_WIDTH - 40, 140)];
    headView.backgroundColor = HEXCOLOR(0xF3FFF8);
    headView.layer.cornerRadius = 6.0f;
    headView.layer.masksToBounds = YES;
    [headView addSubview:self.noticeLab];
    
    [self.noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(20);
        make.right.equalTo(headView).offset(-20);
        make.top.equalTo(headView).offset(20);
    }];
    self.tableView.tableFooterView = headView;
    
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.noticeLab.text attributes:attributes];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:227/255.0 green:66/255.0 blue:68/255.0 alpha:1.0] range:NSMakeRange(1, 16)];
    self.noticeLab.attributedText = att;
    
}
- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
#pragma mark--添加账号
- (IBAction)addAcountAction:(UIButton *)sender {
    WH_AddAccountViewController *vc = [[WH_AddAccountViewController alloc] init];
    vc.room = self.room;
    vc.type = 1;
    [g_navigation pushViewController:vc animated:YES];
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_GroupAccountSetCell *cell = (WH_GroupAccountSetCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_GroupAccountSetCell" forIndexPath:indexPath];
    __weak typeof (self)weakSelf = self;
    cell.deleteBlock = ^{
        NSDictionary *dic = self.dataArray[indexPath.row];
        NSString *recordId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        
        [weakSelf showAlertAction:recordId];
    };
    if(self.dataArray.count > indexPath.row){
        NSDictionary *dic = self.dataArray[indexPath.row];
        NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
        
        NSString *typeStr = @"";
        NSString *typeImage = @"";
        if(type.intValue == 1){//1.微信  2.支付宝  3银行卡
            typeImage = @"pay_type_1";
            typeStr = @"微信支付";
        }else if (type.intValue == 2){
            typeImage = @"pay_type_2";
            typeStr = @"支付宝";
        }else if (type.intValue == 3){
            typeImage = @"pay_type_3";
            typeStr = @"银行卡";
            cell.rightPayLab.hidden = YES;
        }
        
        cell.paytypeLab.text = typeStr;
        cell.unitLab.text = [NSString stringWithFormat:@"%@账号：",typeStr];
        cell.nameLab.text = [NSString stringWithFormat:@"%@ %@",dic[@"accountName"],dic[@"accountNo"]];
        cell.typeImage.image = [UIImage imageNamed:typeImage];
        
    }
    return cell;
}
-(void)showAlertAction:(NSString *)recordId{
    [UIAlertController showAlertViewWithTitle:@"确定删除该条记录吗" message:nil controller:self block:^(NSInteger buttonIndex) {
        if (buttonIndex==1) {//删除
            [g_server WH_DeleteAccountWithId:recordId toView:self];
        }
    } cancelButtonTitle:Localized(@"JX_Cencal") otherButtonTitles:Localized(@"JX_Confirm")];
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    NSString *url = [NSString stringWithFormat:@"%@%@",wh_List_userAccount,self.room.roomJid];
    if ([aDownload.action isEqualToString:url] || [aDownload.action isEqualToString:wh_user_account]){
        self.dataArray = [NSMutableArray arrayWithArray:array1];
        [self.tableView reloadData];
        self.nodataLab.hidden = self.noDataImage.hidden = array1.count > 0?YES:NO;
//        self.addBtn.hidden = array1.count > 1?YES:NO;
    }else if ([aDownload.action isEqualToString:wh_delete_userAccount]){//
        [g_server showMsg:@"删除成功"];
        if(!self.room){
            [g_server WH_UserAccount:self];
        }else{
            [g_server WH_ReceiveAccountListWithRoomJid:self.room.roomJid toView:self];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.dataArray.count > indexPath.row){
        NSDictionary *dic = self.dataArray[indexPath.row];
        WH_AddAccountViewController *vc = [[WH_AddAccountViewController alloc] init];
        vc.room = self.room;
        vc.name = [NSString stringWithFormat:@"%@",dic[@"accountName"]];
        vc.account = [NSString stringWithFormat:@"%@",dic[@"accountNo"]];
        vc.type = [NSString stringWithFormat:@"%@",dic[@"type"]].intValue - 1;
        vc.accountId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        vc.qrCode = [NSString stringWithFormat:@"%@",dic[@"qrCode"]];
        vc.phone = [NSString stringWithFormat:@"%@",dic[@"telNumber"]];
        vc.bankName = [NSString stringWithFormat:@"%@",vc.type == 2?dic[@"qrCode"]:@""];
        
        [g_navigation pushViewController:vc animated:YES];
    }
}

#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait hide];
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait hide];
    return WH_show_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    if ([aDownload.action isEqualToString:wh_act_UploadFile]) {
        [_wait start:Localized(@"JXFile_uploading")];
    }else{
        [_wait start];
    }
}



@end
