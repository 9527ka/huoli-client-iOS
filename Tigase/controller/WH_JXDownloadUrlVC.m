//
//  WH_JXDownloadUrlVC.m
//  Tigase
//
//  Created by 1111 on 2024/2/29.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXDownloadUrlVC.h"

@interface WH_JXDownloadUrlVC ()
@property (weak, nonatomic) IBOutlet UIView *iOSBgView;
@property (weak, nonatomic) IBOutlet UIView *androdBgView;
@property (weak, nonatomic) IBOutlet UIButton *download1Btn;
@property (weak, nonatomic) IBOutlet UIButton *download2Btn;

@end

@implementation WH_JXDownloadUrlVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.iOSBgView.layer.cornerRadius = g_factory.cardCornerRadius;
    
    self.androdBgView.layer.cornerRadius = g_factory.cardCornerRadius;

    
    self.download1Btn.layer.cornerRadius = 24.0f;
    self.download2Btn.layer.cornerRadius = 24.0f;
    
}
- (IBAction)backAction:(id)sender {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
//600+
- (IBAction)downloadAction:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:sender.tag == 600?@"https://testflight.apple.com/join/d6QcK52T":@"https://wwv.lanzouh.com/liehuoapp"];
    
    [g_server showMsg:@"复制成功"];
}



@end
