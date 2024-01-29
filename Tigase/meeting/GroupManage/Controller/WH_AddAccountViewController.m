//
//  WH_AddAccountViewController.m
//  Tigase
//
//  Created by 1111 on 2023/12/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_AddAccountViewController.h"
#import "WH_AddAccountCell.h"
#import "ImageResize.h"
#import "WH_JXCamera_WHVC.h"
#import "UIView+WH_CustomAlertView.h"
#import "WH_SetGroupHeads_WHView.h"
#import "UIButton+WebCache.h"
#import "WH_JXVerifyPay_WHVC.h"
#import "BindTelephoneChecker.h"
#import "OBSHanderTool.h"

@interface WH_AddAccountViewController ()<UITableViewDataSource, UITableViewDelegate>{
    ATMHud* _wait;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) UIImage *image;
@property (nonatomic, strong) WH_JXVerifyPay_WHVC *verVC;


@end

@implementation WH_AddAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _wait = [ATMHud sharedInstance];
//    //如果不存在才设置
//    self.type = 1;
    
//    self.tableView.estimatedRowHeight = 744;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.rowHeight = 744;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_AddAccountCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_AddAccountCell"];
}
- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WH_AddAccountCell *cell = (WH_AddAccountCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_AddAccountCell" forIndexPath:indexPath];
    __weak typeof (self)weakSelf = self;
    cell.chooseTypeBlock = ^{
        [weakSelf choosetypeAction];
    };
    cell.chooseImageBlock = ^{
        [weakSelf chooseImageAction];
    };
    cell.certainBlock = ^(NSString * _Nonnull name, NSString * _Nonnull account, NSString * _Nonnull password,NSString * _Nonnull phone,NSString * _Nonnull bankName) {
        
        weakSelf.name = name;
        weakSelf.account = account;
        weakSelf.phone = phone;
        weakSelf.bankName = bankName;
        
        if(!weakSelf.image && weakSelf.qrCode.length == 0 && self.type != 2){
            [g_server showMsg:@"请上传您的支付图片"];
            return;
        }
        
        if(!weakSelf.room && weakSelf.name.length == 0 && self.type == 2){
            [g_server showMsg:@"请输入银行卡帐号名！"];
            return;
        }
        
        //判断有没有添加账号
        if(weakSelf.account.length == 0){
            [g_server showMsg:@"请输入账号！"];
            return;
        }
        if(!weakSelf.room && weakSelf.phone.length != 11){
            [g_server showMsg:@"请输入正确的手机号码！"];
            return;
        }
        if(!weakSelf.room && weakSelf.bankName.length == 0 && self.type == 2){
            [g_server showMsg:@"请输入开户银行"];
            return;
        }
        [weakSelf passWordAction];
    };
    if(self.image){
        
        [cell.uploadBtn setTitle:@"" forState:UIControlStateNormal];
        [cell.uploadBtn setImage:self.image forState:UIControlStateNormal];
    }else if (self.qrCode.length > 0){
        [cell.uploadBtn setTitle:@"" forState:UIControlStateNormal];
        [cell.uploadBtn sd_setImageWithURL:[NSURL URLWithString:self.qrCode] forState:UIControlStateNormal];
    }
    cell.payTitleLab.text = [self payTitleLabStr];
    cell.line.backgroundColor = [self lineColorStr];
    cell.nameTitle.text = self.type == 2?@"银行卡姓名（必填）":@"姓名（选填）";
    cell.nameField.placeholder = self.type == 2?@"请输入银行卡姓名":@"请输入真实姓名";
    cell.payAccountLab.text = [self accountStr];
    cell.phoneTitle.text = [self phoneStr];
    cell.rightNowTitle.hidden = self.type == 2?YES:NO;
    
    if(cell.nameField.text.length == 0&&self.name.length > 0){
        cell.nameField.text = self.name;
    }
    if(cell.accountField.text.length == 0&&self.account.length > 0){
        cell.accountField.text = self.account;
    }
    if(cell.phoneField.text.length == 0&&self.phone.length > 0 &&!IsStringNull(self.phone)){
        cell.phoneField.text = self.phone;
    }
    if(cell.bankField.text.length == 0&&self.bankName.length > 0 &&!IsStringNull(self.bankName)){
        cell.bankField.text = self.bankName;
    }
    
    cell.codeBgView.hidden = self.type == 2?YES:NO;
    cell.codeBgViewHeight.constant = self.type == 2?0:175;
    
    cell.bankBgView.hidden = self.type == 2?NO:YES;
    cell.bankBgViewHeight.constant = self.type == 2?100:0;
    
    return cell;
}
-(NSString *)phoneStr{
    NSString *phoneStr = @"手机号码（选填）";
    if(!self.room){
        phoneStr = @"手机号码（必填）";
//        if (self.type == 2){
//            phoneStr = @"开户银行（必填）";
//        }
    }
    return phoneStr;
}
-(UIColor *)lineColorStr{
    UIColor *lineColor = HEXCOLOR(0xf7984a);
    if(self.type == 0){
        lineColor = HEXCOLOR(0x23B525);
    }else if (self.type == 1){
        lineColor = HEXCOLOR(0x4174f2);
    }else if (self.type == 2){
        lineColor = HEXCOLOR(0xf7984a);
    }
    return lineColor;
}
-(NSString *)payTitleLabStr{
    NSString *payTitleStr = @"微信支付";
    if(self.type == 0){
        payTitleStr = @"微信支付";
    }else if (self.type == 1){
        payTitleStr = @"支付宝";
    }else if (self.type == 2){
        payTitleStr = @"银行支付";
    }
    return payTitleStr;
}
-(NSString *)accountStr{
    NSString *accountStr = @"账号";
    if(self.type == 0){
        accountStr = @"微信账号（必填）";
    }else if (self.type == 1){
        accountStr = @"支付宝账号（必填）";
    }else if (self.type == 2){
        accountStr = @"银行卡号（必填）";
    }
    return accountStr;
}
//输入密码
-(void)passWordAction{
    
    if ([g_myself.isPayPassword boolValue]) {
        self.verVC = [WH_JXVerifyPay_WHVC alloc];
        self.verVC.type = JXVerifyTypeAdd;
        self.verVC.wh_RMB = @"";
        self.verVC.delegate = self;
        self.verVC.didDismissVC = @selector(WH_dismiss_WHVerifyPayVC);
        self.verVC.didVerifyPay = @selector(WH_didVerifyPay:);
        self.verVC = [self.verVC init];
        self.verVC.RMBLab.text = @"";
        
        [self.view addSubview:self.verVC.view];
        
    }else {//没有支付密码
        [BindTelephoneChecker checkBindPhoneWithViewController:self entertype:JXEnterTypeDefault];
    }
}
- (void)WH_didVerifyPay:(NSString *)sender {
    self.password = [NSString stringWithString:sender];
    
    [self certainAction];

}
- (void)WH_dismiss_WHVerifyPayVC {
    [self.verVC.view removeFromSuperview];
}
-(void)certainAction{
    
    if(self.image){
        //保存图片到本地
        NSString* file = [FileInfo getUUIDFileName:@"jpg"];
        [g_server WH_saveImageToFileWithImage:self.image file:file isOriginal:NO];
        
        [OBSHanderTool handleUploadFile:file validTime:@"-1" messageId:@"" toView:self success:^(int code, NSString * _Nonnull fileUrl, NSString * _Nonnull fileName) {
            if (code == 1) {
                //回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 需要在主线程执行的代码
                    //上传账号
                    [g_server WH_AddUserAccountWithName:self.name accountNo:self.account payPassword:self.password type:self.type + 1 roomJid:self.room.roomJid qrCode:self.type == 2?self.phone:fileUrl addId:self.accountId telNumber:self.phone toView:self];
                });
                
            }
        } failed:^(NSError * _Nonnull error) {

        }];
        
        //上传图片
//        [g_server uploadFile:file validTime:@"-1" messageId:nil toView:self];
                
    }else if (!self.image && self.qrCode.length > 0){
        //修改账号
        [g_server WH_AddUserAccountWithName:self.name accountNo:self.account payPassword:self.password type:self.type + 1 roomJid:self.room.roomJid qrCode:self.type == 2?self.phone:self.qrCode addId:self.accountId telNumber:self.phone toView:self];
    }else if(self.type == 2){//银行卡
        [g_server WH_AddUserAccountWithName:self.name accountNo:self.account payPassword:self.password type:self.type + 1 roomJid:self.room.roomJid qrCode:self.bankName addId:self.accountId telNumber:self.phone toView:self];
    }
}
//选择支付方式
-(void)choosetypeAction{
    if(self.accountId.length > 0){
        [g_server showMsg:@"不能更改支付类型"];
        return;
    }
    CGFloat viewH = 191;
    if (THE_DEVICE_HAVE_HEAD) {
        viewH = 191+24;
    }
    WH_SetGroupHeads_WHView *setGroupHeadsview = [[WH_SetGroupHeads_WHView alloc] initWithFrame:CGRectMake(0, 0, JX_SCREEN_WIDTH, viewH) titleArray:self.room?@[@"微信支付",@"支付宝"]: @[@"微信支付",@"支付宝",@"银行卡"] istype:YES];

    [setGroupHeadsview showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:0.5 needEffectView:NO];
    
    __weak typeof(setGroupHeadsview) weakShare = setGroupHeadsview;
    __weak typeof(self) weakSelf = self;
    [setGroupHeadsview setWh_selectActionBlock:^(NSInteger buttonTag) {
//        if ((buttonTag == 3 && !self.room) || (buttonTag == 2 && self.room)) {
//            //取消
//            [weakShare hideView];
//        }else {
            
            weakSelf.type = buttonTag;
            
            [weakShare hideView];
            [weakSelf.tableView reloadData];
//        }
    }];
}
//选择图片
-(void)chooseImageAction{
    CGFloat viewH = 191;
    if (THE_DEVICE_HAVE_HEAD) {
        viewH = 191+24;
    }
    
    WH_SetGroupHeads_WHView *setGroupHeadsview = [[WH_SetGroupHeads_WHView alloc] initWithFrame:CGRectMake(0, 0, JX_SCREEN_WIDTH, viewH)];
    [setGroupHeadsview showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:0.5 needEffectView:NO];
    
    __weak typeof(setGroupHeadsview) weakShare = setGroupHeadsview;
    __weak typeof(self) weakSelf = self;
    [setGroupHeadsview setWh_selectActionBlock:^(NSInteger buttonTag) {
        if (buttonTag == 2) {
            //取消
            [weakShare hideView];
        }else if (buttonTag == 0) {
            //拍摄照片
            WH_JXCamera_WHVC *vc = [WH_JXCamera_WHVC alloc];
            vc.cameraDelegate = weakSelf;
            vc.isPhoto = YES;
            vc = [vc init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:vc animated:YES completion:nil];
            [weakShare hideView];
        }else {
            //选择照片
            
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
            ipc.delegate = weakSelf;
//            ipc.allowsEditing = YES;
            //选择图片模式
//            ipc.modalPresentationStyle = UIModalPresentationCurrentContext;
            //    [g_window addSubview:ipc.view];
            if (IS_PAD) {
                UIPopoverController *pop =  [[UIPopoverController alloc] initWithContentViewController:ipc];
                [pop presentPopoverFromRect:CGRectMake((weakSelf.view.frame.size.width - 320) / 2, 0, 300, 300) inView:weakSelf.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }else {
                [weakSelf presentViewController:ipc animated:YES completion:nil];
            }
            
            [weakShare hideView];
            
        }
    }];
}
- (void)cameraVC:(WH_JXCamera_WHVC *)vc didFinishWithImage:(UIImage *)image {
    self.image = [ImageResize image:image fillSize:CGSizeMake(JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT)];
    [self.tableView reloadData];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.image = [ImageResize image:[info objectForKey:@"UIImagePickerControllerOriginalImage"] fillSize:CGSizeMake(JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT)];
    
    [self.tableView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    if ([aDownload.action isEqualToString:wh_act_UploadFile]){
        NSArray * listArray = @[@"audios",@"images",@"others",@"videos"];
        NSString * fileUrl = nil;
        NSString * fileName = nil;
        int tbreak = 0;
        for (int i = 0; i<listArray.count; i++) {
            NSArray * dataArray = [dict objectForKey:listArray[i]];
            if ([dataArray count]) {
                for (NSDictionary * dataDict in dataArray) {
                    fileUrl = dataDict[@"oUrl"];
                    fileName = dataDict[@"oFileName"];
                    tbreak = 1;
                }
            }
            if (tbreak == 1){
                break;
            }
        }
        //上传账号
        [g_server WH_AddUserAccountWithName:self.name accountNo:self.account payPassword:self.password type:self.type + 1 roomJid:self.room.roomJid qrCode:self.type == 2?self.phone:fileUrl addId:self.accountId telNumber:self.phone toView:self];
        
    }else if ([aDownload.action isEqualToString:wh_add_userAccount]){
        [g_server showMsg:@"添加成功"];
        [g_navigation WH_dismiss_WHViewController:self animated:YES];
    }else if ([aDownload.action isEqualToString:wh_change_userAccount]){
        [g_server showMsg:@"修改成功"];
        [g_navigation WH_dismiss_WHViewController:self animated:YES];
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
