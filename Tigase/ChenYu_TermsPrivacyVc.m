//
//  ChenYu_TermsPrivacyVc.m
//  YiNiao_im
//
//  Created by os on 2021/1/11.
//  Copyright © 2021 Reese. All rights reserved.
//

#import "ChenYu_TermsPrivacyVc.h"

@interface ChenYu_TermsPrivacyVc()

@property (weak, nonatomic) IBOutlet UILabel *temPrivacyLab;

@end
@implementation ChenYu_TermsPrivacyVc

-(void)awakeFromNib{
    [super awakeFromNib];
   //_temPrivacyLab.text = @"你可阅读 《用户协议》 和 《隐私政策》 了解详细信息。如你同意，请点击 “同意” 开始接受我们的服务。";
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"你可阅读 %@和%@  了解详细信息。如你同意，请点击 “%@” 开始接受我们的服务。",@"《用户协议》",@"《隐私政策》",@"同意"]];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1=[[hintString string]rangeOfString:@"《用户协议》"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
    
    NSRange range2 = [[hintString string]rangeOfString:@"《隐私政策》"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
    
    NSRange range3 = [[hintString string]rangeOfString:@"同意"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range3];
    
    
    _temPrivacyLab.attributedText = hintString;
     
}

- (IBAction)cancleBtn:(id)sender {
    
    exit(0);
}

- (IBAction)sureButton:(UIButton *)sender {
    
    if (sender.tag == 3) {
        [[NSUserDefaults standardUserDefaults] setObject:@"tongyi" forKey:@"tongyi"];
        [self removeFromSuperview];
        return;
    }
    if (_blockBtn) {
        _blockBtn(sender);
    }
}

+(instancetype)XIBChenYu_TermsPrivacyVc{
    
    return [[NSBundle mainBundle]loadNibNamed:@"ChenYu_TermsPrivacyVc" owner:self options:nil].firstObject;
}

@end
