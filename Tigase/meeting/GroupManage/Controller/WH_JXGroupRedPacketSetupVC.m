//
//  WH_JXGroupRedPacketSetupVC.m
//  Tigase
//
//  Created by luan on 2023/7/8.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupRedPacketSetupVC.h"
#import "WH_JXGroupRedPacketSetupMemberVC.h"

@interface WH_JXGroupRedPacketSetupVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *fortuneLabel;
@property (weak, nonatomic) IBOutlet UILabel *fortuneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *exclusiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *exclusiveNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *robLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;

@end

@implementation WH_JXGroupRedPacketSetupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == 0) {
        self.titleLabel.text = @"群红包设置";
        self.fortuneLabel.text = @"手气红包金额";
        self.exclusiveLabel.text = @"专属红包金额";
    } else {
        self.titleLabel.text = @"群钻石设置";
        self.fortuneLabel.text = @"手气钻石金额";
        self.exclusiveLabel.text = @"专属钻石金额";
    }
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

- (IBAction)didTapEditFortune {
    [self editType:0];
}

- (IBAction)didTapEditExclusive {
    [self editType:1];
}

- (IBAction)didTapRob {
    WH_JXGroupRedPacketSetupMemberVC *vc = [[WH_JXGroupRedPacketSetupMemberVC alloc] init];
    vc.room = self.room;
    vc.type = self.type;
    vc.direction = 0;
    [g_navigation pushViewController:vc animated:YES];
}

- (IBAction)didTapSend {
    WH_JXGroupRedPacketSetupMemberVC *vc = [[WH_JXGroupRedPacketSetupMemberVC alloc] init];
    vc.room = self.room;
    vc.type = self.type;
    vc.direction = 1;
    [g_navigation pushViewController:vc animated:YES];
}

- (void)editType:(NSInteger)editType {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"修改%@%@金额", ((editType == 0) ? @"手气" : @"专属"), ((self.type == 0) ? @"红包" : @"钻石")] message:[NSString stringWithFormat:@"当前金额:%@", (editType == 0) ? @"1000" : @"5000"] preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"请输入金额数量"];
        [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
