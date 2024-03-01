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
    self.iOSBgView.layer.borderColor = g_factory.cardBorderColor.CGColor;
    self.iOSBgView.layer.borderWidth = g_factory.cardBorderWithd;
    
    self.androdBgView.layer.cornerRadius = g_factory.cardCornerRadius;
    self.androdBgView.layer.borderColor = g_factory.cardBorderColor.CGColor;
    self.androdBgView.layer.borderWidth = g_factory.cardBorderWithd;
    
    self.download1Btn.layer.cornerRadius = g_factory.cardCornerRadius;
    self.download2Btn.layer.cornerRadius = g_factory.cardCornerRadius;
    
}
- (IBAction)backAction:(id)sender {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
//600+
- (IBAction)downloadAction:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:sender.tag == 600?@"https://testflight.apple.com/join/9fLIIk8x":@"https://wwv.lanzouh.com/liehuoapp"];
    
    [g_server showMsg:@"复制成功"];
}



@end
