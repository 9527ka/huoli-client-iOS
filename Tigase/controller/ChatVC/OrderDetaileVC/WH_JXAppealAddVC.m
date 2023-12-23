//
//  WH_JXAppealAddVC.m
//  Tigase
//
//  Created by 1111 on 2023/12/22.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXAppealAddVC.h"
#import "WH_JXAppealAddCell.h"
#import "RITLPhotosViewController.h"
#import "WH_JXMediaObject.h"

@interface WH_JXAppealAddVC ()<UITableViewDataSource, UITableViewDelegate,RITLPhotosViewControllerDelegate>
{
    ATMHud* _wait;
//    WH_admob_WHViewController* _pSelf;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *fileList;
@property (nonatomic,strong)NSMutableArray *images;
@property (nonatomic,copy) NSString *wh_videoFile;
@property (nonatomic,strong)UIImage *videoImage;
@property (nonatomic,copy) NSString *contentStr;
@property (nonatomic,strong)NSNumber *timeLen;


@end

@implementation WH_JXAppealAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 844.0f;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXAppealAddCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXAppealAddCell"];
    
    _fileList = [NSMutableArray array];
    _images = [NSMutableArray array];
    _wait = [ATMHud sharedInstance];
    
}

- (IBAction)goBackAction:(id)sender {
    [self.view endEditing:YES];
    
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
// MARK: -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXAppealAddCell *cell = (WH_JXAppealAddCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXAppealAddCell" forIndexPath:indexPath];
    __weak typeof (self)weakSelf = self;
    cell.addVideoBlock = ^{
        [weakSelf lookVideoAction];
    };
    cell.addImageBlock = ^{
        [weakSelf pickImages:YES];
    };
    cell.lookImageBlock = ^(NSInteger tag) {
        [weakSelf lookImageWithTag:tag];
    };
    cell.certainBlock = ^(NSString * _Nonnull text) {
        weakSelf.contentStr = text;
        
        if(weakSelf.images.count > 0 || self.videoImage){
            
            [g_server uploadFile:_images audio:@"" video:weakSelf.wh_videoFile file:@"" type:weibo_dataType_image validTime:@"-1" timeLen:weakSelf.timeLen.intValue toView:self];
            
        }else{
            [g_server WH_orderAppealWithId:self.orderId content:self.contentStr items:@"" toView:self];
        }
        
    };
    cell.images = self.images;
    if(self.videoImage){
        [cell.videoAddBtn setBackgroundImage:self.videoImage forState:UIControlStateNormal];
        [cell.videoAddBtn setImage:[UIImage imageNamed:@"开始"] forState:UIControlStateNormal];
        cell.videoCountLab.text = @"1/1";
    }else{
        [cell.videoAddBtn setBackgroundImage:[UIImage imageNamed:@"addfriend_room"] forState:UIControlStateNormal];
        [cell.videoAddBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        cell.videoCountLab.text = @"0/1";
    }
   
    return cell;
}

//查看视频
-(void)lookVideoAction{
    if(!self.videoImage){
        [self pickImages:NO];
    }else{
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *typeArray = @[@"更新", @"删除"];
        for (int i = 0; i < typeArray.count; i++) {
            NSString *type = typeArray[i];
            [actionSheet addAction:[UIAlertAction actionWithTitle:type style:[type isEqualToString:@"删除"] ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(i == 0){//更新
                    [self pickImages:NO];
                }else{//删除
                    self.videoImage = nil;
                    self.wh_videoFile = @"";
                    [self.tableView reloadData];
                }
            }]];
        }
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
        [self presentViewController:actionSheet animated:YES completion:NULL];
    }
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
                [self.images removeObjectAtIndex:tag];
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
        photoController.configuration.maxCount = 5 - _images.count;//最大的选择数目
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
    [_images addObjectsFromArray:images.mutableCopy];
    [self.tableView reloadData];
}
#pragma mark - 发送缩略图
- (void)photosViewController:(UIViewController *)viewController thumbnailImages:(NSArray *)thumbnailImages infos:(NSArray<NSDictionary *> *)infos {
    [_images addObjectsFromArray:thumbnailImages.mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - 发送图片
- (void)photosViewController:(UIViewController *)viewController datas:(NSArray <id> *)datas; {
    
}
#pragma mark - 发送视频
- (void)photosViewController:(UIViewController *)viewController media:(WH_JXMediaObject *)media {
    //判断是否视频过长
    if(media.timeLen.floatValue > 60.0f){
        [g_server showMsg:@"请选择60秒内视频"];
        return;
    }
    NSString* file = media.fileName;
    UIImage *image = [FileInfo getFirstImageFromVideo:file];
    self.videoImage = image;
    self.timeLen = media.timeLen;
    self.wh_videoFile = [file copy];
    
    [self.tableView reloadData];    
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

        NSMutableArray *imageList = [NSMutableArray array];
        NSString *videoUrl;
        if(self.videoImage){
            NSArray *videos = dict[@"videos"];
            NSDictionary *videoDic = videos.firstObject;
            videoUrl = [NSString stringWithFormat:@"%@",videoDic[@"oUrl"]];
        }
        if(self.images.count > 0){
            NSArray *images = dict[@"images"];
            for (NSDictionary *imageDict in images) {
                [imageList addObject:[NSString stringWithFormat:@"%@",imageDict[@"oUrl"]]];
            }
        }
        NSMutableString *items = [NSMutableString string];
        for (NSString *url in imageList) {
            if(items.length > 0){
                [items appendFormat:@"おお%@", url];
            }else{
                [items appendFormat:@"%@", url];
            }
        }
        if(videoUrl.length > 0){
            if(items.length > 0){
                [items appendFormat:@"おお%@", videoUrl];
            }else{
                [items appendFormat:@"%@", videoUrl];
            }
        }
        
        NSString *resultString = [items copy];
        
        [g_server WH_orderAppealWithId:self.orderId content:self.contentStr items:resultString toView:self];
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
