//
//  WH_RechargeVC.m
//  Tigase
//
//  Created by 1111 on 2023/12/7.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_RechargeVC.h"
#import "WH_RechargeCell.h"
#import "ImageResize.h"
#import "WH_JXCamera_WHVC.h"
#import "WH_SetGroupHeads_WHView.h"

#import "UIView+WH_CustomAlertView.h"

@interface WH_RechargeVC ()<UITableViewDataSource, UITableViewDelegate,WH_JXCamera_WHVCDelegate ,UIImagePickerControllerDelegate>{
    ATMHud* _wait;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) UIImage *image;
@property(nonatomic,copy) NSString *amount;
@property(nonatomic,copy) NSString *context;


@end

@implementation WH_RechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 784;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_RechargeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_RechargeCell"];
    
}
- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_RechargeCell *cell = (WH_RechargeCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_RechargeCell" forIndexPath:indexPath];
    __weak typeof (self)weakSelf = self;
    cell.chooseImageBlock = ^{
        [weakSelf chooseImageAction];
    };
    cell.certainBlock = ^(NSString * _Nonnull amountStr, NSString * _Nonnull orderNoStr) {
        [weakSelf rechargeWithNum:amountStr context:orderNoStr];
    };
    if(self.image){
        cell.uploadImage.image = self.image;
    }
        
    return cell;
}
//确认的点击事件
-(void)rechargeWithNum:(NSString *)amount context:(NSString *)context{
    if(!self.image){
        [g_server showMsg:@"请上传您的交易凭证"];
        return;
    }
    self.amount = amount;
    self.context = context;
    //保存图片到本地
    NSString* file = [FileInfo getUUIDFileName:@"jpg"];
    [g_server WH_saveImageToFileWithImage:self.image file:file isOriginal:NO];
    //上传图片
    [g_server uploadFile:file validTime:@"-1" messageId:nil toView:self];
    
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
        
        [g_server WH_RechargeWithAmount:self.amount picUrl:fileUrl context:self.context toView:self];
    }else if ([aDownload.action isEqualToString:wh_user_offlineRechargeToAdmin]){
        [g_server showMsg:@"充值提交成功，请等待核实"];
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
//    self.image = [ImageResize image:[info objectForKey:@"UIImagePickerControllerEditedImage"] fillSize:CGSizeMake(JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT)];
    
    self.image = [ImageResize image:[info objectForKey:@"UIImagePickerControllerOriginalImage"] fillSize:CGSizeMake(JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT)];
    [self.tableView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
