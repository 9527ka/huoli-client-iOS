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

@interface WH_AddAccountViewController ()<UITableViewDataSource, UITableViewDelegate>{
    ATMHud* _wait;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) UIImage *image;


@end

@implementation WH_AddAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 584;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
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
    cell.certainBlock = ^(NSString * _Nonnull name, NSString * _Nonnull account, NSString * _Nonnull password) {
        weakSelf.name = name;
        weakSelf.account = account;
        weakSelf.password = password;
        [weakSelf certainAction];
    };
    if(self.image){
        
        [cell.uploadBtn setTitle:@"" forState:UIControlStateNormal];
        [cell.uploadBtn setImage:self.image forState:UIControlStateNormal];
    }else if (self.qrCode.length > 0){
        [cell.uploadBtn setTitle:@"" forState:UIControlStateNormal];
        [cell.uploadBtn sd_setImageWithURL:[NSURL URLWithString:self.qrCode] forState:UIControlStateNormal];
    }
    cell.payTitleLab.text = self.type > 0?@"支付宝":@"微信支付";
    cell.line.backgroundColor = self.type > 0?[UIColor linkColor]:[UIColor greenColor];
    cell.payAccountLab.text = self.type > 0?@"支付宝账号":@"微信账号";
    
    if(cell.nameField.text.length == 0&&self.name.length > 0){
        cell.nameField.text = self.name;
    }
    if(cell.accountField.text.length == 0&&self.account.length > 0){
        cell.accountField.text = self.account;
    }
    
    return cell;
}
-(void)certainAction{
    if(!self.image && self.qrCode.length == 0){
        [g_server showMsg:@"请上传您的支付图片"];
        return;
    }
    
    if(self.image){
        //保存图片到本地
        NSString* file = [FileInfo getUUIDFileName:@"jpg"];
        [g_server WH_saveImageToFileWithImage:self.image file:file isOriginal:NO];
        //上传图片
        [g_server uploadFile:file validTime:@"-1" messageId:nil toView:self];
    }else if (!self.image && self.qrCode.length > 0){
        //修改账号
        [g_server WH_AddUserAccountWithName:self.name accountNo:self.account payPassword:self.password type:self.type + 1 roomJid:self.room.roomJid qrCode:self.qrCode addId:self.accountId toView:self];
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
    WH_SetGroupHeads_WHView *setGroupHeadsview = [[WH_SetGroupHeads_WHView alloc] initWithFrame:CGRectMake(0, 0, JX_SCREEN_WIDTH, viewH) titleArray:@[@"微信",@"支付宝",@"取消"]];
    [setGroupHeadsview showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:0.5 needEffectView:NO];
    
    __weak typeof(setGroupHeadsview) weakShare = setGroupHeadsview;
    __weak typeof(self) weakSelf = self;
    [setGroupHeadsview setWh_selectActionBlock:^(NSInteger buttonTag) {
        if (buttonTag == 2) {
            //取消
            [weakShare hideView];
        }else {
            
            weakSelf.type = buttonTag;
            
            [weakShare hideView];
            [weakSelf.tableView reloadData];
        }
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
            ipc.allowsEditing = YES;
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
    self.image = [ImageResize image:[info objectForKey:@"UIImagePickerControllerEditedImage"] fillSize:CGSizeMake(JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT)];
    
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
        [g_server WH_AddUserAccountWithName:self.name accountNo:self.account payPassword:self.password type:self.type + 1 roomJid:self.room.roomJid qrCode:fileUrl addId:self.accountId toView:self];
        
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
