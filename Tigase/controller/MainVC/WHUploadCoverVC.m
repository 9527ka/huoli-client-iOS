//
//  WHUploadCoverVC.m
//  Tigase
//
//  Created by 1111 on 2024/4/3.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WHUploadCoverVC.h"
#import "FileInfo.h"
#import "OBSHanderTool.h"

@interface WHUploadCoverVC ()

@end

@implementation WHUploadCoverVC

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self performSelector:@selector(uploadAction) withObject:nil afterDelay:5];
}

-(void)uploadAction{
    
    int cout = 82;
    
    for (int i = 8; i < 10; i++) {
        for (int j = i==8?cout:1; j < 101; j++) {
            
            NSString *videoUrl = [NSString stringWithFormat:@"https://huoli-1324081351.cos.ap-hongkong.myqcloud.com/videos/short/%02d/%d.mp4",i,j];
            UIImage *coverImage = [FileInfo getVideoFirstViewImage:[NSURL URLWithString:videoUrl]];
            if(coverImage){
                
                NSString *name = @"jpg";
                NSString *imagefile = [FileInfo getUUIDFileName:name];
                //图片存储到本地
                [g_server WH_saveImageToFileWithImage:coverImage file:imagefile isOriginal:YES];
                
                [OBSHanderTool handleUploadFile:@[imagefile] audio:@"" video:videoUrl file:@"" type:1 validTime:@"-1" timeLen:0 toView:self success:^(int code, NSDictionary * _Nonnull dict) {
                    if (code == 1) {

                        NSDictionary *dataD = dict;
                                                
                        //回到主线程
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 需要在主线程执行的代码
                           
                        });
                    }
                } failed:^(NSError * _Nonnull error) {

                }];
                
            }
        }
        
    }
}

- (IBAction)backAction:(UIButton *)sender {
    
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

- (IBAction)startAction:(id)sender {
//    "https://huoli-1324081351.cos.ap-hongkong.myqcloud.com/videos/short/01/1.mp4"
    
    [self uploadAction];
    
    
    
}

@end
