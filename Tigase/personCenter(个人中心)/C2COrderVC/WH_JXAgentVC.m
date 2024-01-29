//
//  WH_JXAgentVC.m
//  Tigase
//
//  Created by 1111 on 2024/1/19.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXAgentVC.h"
#import "RITLPhotosViewController.h"
#import "WH_JXMediaObject.h"
#import "WH_JXAgentCell.h"
#import "OBSHanderTool.h"

@interface WH_JXAgentVC ()<UITableViewDataSource, UITableViewDelegate,RITLPhotosViewControllerDelegate>{
    ATMHud* _wait;
//    WH_admob_WHViewController* _pSelf;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy) NSString *wh_videoFile;
@property (nonatomic,strong)UIImage *videoImage;
@property (nonatomic,strong)UIImage *carFrondImage;
@property (nonatomic,strong)UIImage *carBackImage;

@property (nonatomic,copy) NSString *carFrondUrl;
@property (nonatomic,copy) NSString *carBackUrl;
@property (nonatomic,copy) NSString *carHandUrl;


@property (nonatomic,strong)NSNumber *timeLen;
@property (nonatomic,assign)NSInteger tag;

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *carNum;


@end

@implementation WH_JXAgentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 944.0f;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXAgentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXAgentCell"];
    
    _wait = [ATMHud sharedInstance];
    
}

- (IBAction)didTapBack {
    [self.view endEditing:YES];
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
// MARK: -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXAgentCell *cell = (WH_JXAgentCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXAgentCell" forIndexPath:indexPath];
    __weak typeof (self)weakSelf = self;
    cell.chooseImageBlock = ^(NSInteger tag) {
        weakSelf.tag = tag;
        if(tag == 0 && weakSelf.carFrondImage){
            [weakSelf lookImageWithTag:tag];
        }else if (tag == 1&&weakSelf.carBackImage){
            [weakSelf lookImageWithTag:tag];
        }else if (tag == 2&&weakSelf.videoImage){
            [weakSelf lookImageWithTag:tag];
        }else{
            [weakSelf pickImages:YES];
        }
    };
    cell.commitBlock = ^(NSString * _Nonnull name, NSString * _Nonnull phone, NSString * _Nonnull carNum) {
        if(!weakSelf.carFrondImage){
            [g_server showMsg:@"请上传身份证正面照片"];
            return;
        }
        if(!weakSelf.carBackImage){
            [g_server showMsg:@"请上传身份证反面照片"];
            return;
        }
        if(!weakSelf.videoImage){
            [g_server showMsg:@"请上传手持身份证照片"];
            return;
        }
        
        weakSelf.name = name;
        weakSelf.phone = phone;
        weakSelf.carNum = carNum;
        
        [g_server WH_AgentAddWithName:name telNumber:phone carId:carNum foreside:weakSelf.carFrondUrl backside:weakSelf.carBackUrl withHuman:weakSelf.carHandUrl toView:self];
    };

    if(self.carFrondImage){
        [cell.carFrondBtn setBackgroundImage:self.carFrondImage forState:UIControlStateNormal];
    }else{
        [cell.carFrondBtn setBackgroundImage:[UIImage imageNamed:@"addfriend_room"] forState:UIControlStateNormal];
    }
    if(self.carBackImage){
        [cell.carBackBtn setBackgroundImage:self.carBackImage forState:UIControlStateNormal];
    }else{
        [cell.carBackBtn setBackgroundImage:[UIImage imageNamed:@"addfriend_room"] forState:UIControlStateNormal];
    }
    if(self.videoImage){
           [cell.carHandBtn setBackgroundImage:self.videoImage forState:UIControlStateNormal];
       }else{
           [cell.carHandBtn setBackgroundImage:[UIImage imageNamed:@"addfriend_room"] forState:UIControlStateNormal];
       }
   
    return cell;
}
//查看图片的点击事件
-(void)lookImageWithTag:(NSInteger)tag{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *typeArray = @[@"更新", @"删除"];
    for (int i = 0; i < typeArray.count; i++) {
        NSString *type = typeArray[i];
        [actionSheet addAction:[UIAlertAction actionWithTitle:type style:[type isEqualToString:@"删除"] ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(i == 0){//更新
                [self pickImages:YES];
            }else{//删除
                if(tag == 0){
                    self.carFrondImage = nil;
                }else if (tag == 1){
                    self.carBackImage = nil;
                }else{
                    self.videoImage = nil;
                }
                [self.tableView reloadData];
            }
            
        }]];
    }
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:actionSheet animated:YES completion:NULL];
}
#pragma mark - 选择图库
-(void)pickImages:(BOOL)Multi{
    RITLPhotosViewController *photoController = RITLPhotosViewController.photosViewController;
    if(Multi){//图片
        photoController.configuration.maxCount = 1;//最大的选择数目
        photoController.configuration.containVideo = NO;//选择类型，目前只选择图片不选择视频
    }else{//视频
        photoController.configuration.maxCount = 1;//最大的选择数目
        photoController.configuration.containVideo = YES;//选择类型，目前只选择视频
        photoController.configuration.containImage = NO;//选择类型，目前只选择视频不选择图片
    }
   
    photoController.photo_delegate = self;
    photoController.thumbnailSize = CGSizeMake(320, 320);//缩略图的尺寸
    //    photoController.defaultIdentifers = self.saveAssetIds;//记录已经选择过的资源
    photoController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:photoController animated:true completion:^{}];
}

#pragma mark - 发送原图
- (void)photosViewController:(UIViewController *)viewController images:(NSArray<UIImage *> *)images infos:(NSArray<NSDictionary *> *)infos {
    if(self.tag == 0){
        self.carFrondImage = images.firstObject;
    }else if (self.tag == 1){
        self.carBackImage = images.firstObject;
    }else{
        self.videoImage = images.firstObject;
    }
    
    UIImage *image = images.firstObject;
    NSString* filePath = [FileInfo getUUIDFileName:@"jpg"];
       [g_server WH_saveImageToFileWithImage:image file:filePath isOriginal:YES];
    [OBSHanderTool handleUploadFile:filePath validTime:@"-1" messageId:@"" toView:self success:^(int code, NSString * _Nonnull fileUrl, NSString * _Nonnull fileName) {
        if (code == 1) {
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                // 需要在主线程执行的代码
                self.carBackUrl = fileUrl;
            });
            
        }
    } failed:^(NSError * _Nonnull error) {

    }];
    
    
//       [g_server uploadFile:filePath validTime:@"-1" messageId:nil toView:self];
    
    [self.tableView reloadData];
}
#pragma mark - 发送缩略图
- (void)photosViewController:(UIViewController *)viewController thumbnailImages:(NSArray *)thumbnailImages infos:(NSArray<NSDictionary *> *)infos {
    if(self.tag == 0){
        self.carFrondImage = thumbnailImages.firstObject;
    }else if (self.tag == 1){
        self.carBackImage = thumbnailImages.firstObject;
    }else{
        self.videoImage = thumbnailImages.firstObject;
    }
    UIImage *image = thumbnailImages.firstObject;
    NSString* filePath = [FileInfo getUUIDFileName:@"jpg"];
    [g_server WH_saveImageToFileWithImage:image file:filePath isOriginal:NO];
    
    [OBSHanderTool handleUploadFile:filePath validTime:@"-1" messageId:@"" toView:self success:^(int code, NSString * _Nonnull fileUrl, NSString * _Nonnull fileName) {
        if (code == 1) {
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                // 需要在主线程执行的代码
                self.carBackUrl = fileUrl;
            });
            
        }
    } failed:^(NSError * _Nonnull error) {

    }];
    
//       [g_server uploadFile:filePath validTime:@"-1" messageId:nil toView:self];
    [self.tableView reloadData];
}

#pragma mark - 发送图片
- (void)photosViewController:(UIViewController *)viewController datas:(NSArray <id> *)datas; {
    
}
#pragma mark - 发送视频
- (void)photosViewController:(UIViewController *)viewController media:(WH_JXMediaObject *)media {
    //判断是否视频过长
//    if(media.timeLen.floatValue > 60.0f){
//        [g_server showMsg:@"请选择60秒内视频"];
//        return;
//    }
//    NSString* file = media.fileName;
//    UIImage *image = [FileInfo getFirstImageFromVideo:file];
//    self.videoImage = image;
//    self.timeLen = media.timeLen;
//    self.wh_videoFile = [file copy];
//
//    [self.tableView reloadData];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    if([aDownload.action isEqualToString:wh_act_UploadFile]){

        NSArray *images = dict[@"images"];
        NSDictionary *imageDict = images.firstObject;
        NSString *url = [NSString stringWithFormat:@"%@",imageDict[@"oUrl"]];
        if(self.tag == 0){
            self.carFrondUrl = url;
        }else if (self.tag == 1){
            self.carBackUrl = url;
        }else{
            self.carHandUrl = url;
        }
        
    }else{
        [g_server showMsg:@"提交成功"];
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
    [_wait start];
}

@end
