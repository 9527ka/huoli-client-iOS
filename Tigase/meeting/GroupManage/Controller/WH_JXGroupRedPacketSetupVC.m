//
//  WH_JXGroupRedPacketSetupVC.m
//  Tigase
//
//  Created by luan on 2023/7/8.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupRedPacketSetupVC.h"
#import "WH_JXGroupRedPacketSetupMemberVC.h"
#import "WH_JXRedPacketSecVC.h"

@interface WH_JXGroupRedPacketSetupVC (){
    ATMHud* _wait;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *fortuneLabel;
@property (weak, nonatomic) IBOutlet UILabel *fortuneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *exclusiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *exclusiveNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *robLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;

@property (weak, nonatomic) IBOutlet UILabel *fortuneMaxNumLab;
@property (weak, nonatomic) IBOutlet UILabel *exclusiveMaxNumLab;

@property (nonatomic,strong)UITextField *countField;
@property (nonatomic,assign)NSInteger editType;
@property (weak, nonatomic) IBOutlet UIView *greenBgView;


@end

@implementation WH_JXGroupRedPacketSetupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _wait = [ATMHud sharedInstance];
    if (self.type == 0) {
        self.titleLabel.text = @"群红包设置";
        self.fortuneLabel.text = @"手气红包金额";
        self.exclusiveLabel.text = @"专属红包金额";
        self.greenBgView.hidden = NO;
    } else {
        self.titleLabel.text = @"群钻石设置";
        self.fortuneLabel.text = @"手气钻石金额";
        self.exclusiveLabel.text = @"专属钻石金额";
    }
    [self saveData];
}
-(void)saveData{//群红包设置
    if (self.type == 0) {
        self.titleLabel.text = @"群红包设置";
        self.fortuneNumLabel.text = [NSString stringWithFormat:@"%ld",self.room.luckyRecPacketMax];
        self.exclusiveNumLabel.text = [NSString stringWithFormat:@"%ld",self.room.exclusiveRedPacketMax];
        
        //添加123你好i am fine
        NSMutableAttributedString *fortuneAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"（上限%ld）",self.room.luckyRecPacketMax]];
        //设置 redColor，
        [fortuneAtt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, [NSString stringWithFormat:@"%ld",self.room.luckyRecPacketMax].length)];
        
        self.fortuneMaxNumLab.attributedText = fortuneAtt;
        
        
        NSMutableAttributedString *exclusiveAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"（上限%ld）",self.room.exclusiveRedPacketMax]];
        //设置 redColor，
        [fortuneAtt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, [NSString stringWithFormat:@"%ld",self.room.exclusiveRedPacketMax].length)];
        
        self.exclusiveMaxNumLab.attributedText = fortuneAtt;
        
       
    } else {//群钻石设置
        self.titleLabel.text = @"群钻石设置";
        
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
- (IBAction)greenRoadAction:(id)sender {
    WH_JXRedPacketSecVC *vc = [[WH_JXRedPacketSecVC alloc] init];
    vc.room = self.room;
    vc.type = self.type;
    vc.direction = 2;
    [g_navigation pushViewController:vc animated:YES];
}

- (void)editType:(NSInteger)editType {
    self.editType = editType;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"修改%@%@金额", ((editType == 0) ? @"手气" : @"专属"), ((self.type == 0) ? @"红包" : @"钻石")] message:[NSString stringWithFormat:@"当前金额:%@", (editType == 0) ? [NSString stringWithFormat:@"%ld",self.room.luckyRecPacketMax] : [NSString stringWithFormat:@"%ld",self.room.exclusiveRedPacketMax]] preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"请输入金额数量"];
        [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        self.countField = textField;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //(editType == 0) ? @"手气" : @"专属"
    
        [g_server updateRoom:self.room key:editType == 0?@"luckyRecPacketMax":@"exclusiveRedPacketMax" value:self.countField.text.length > 0?self.countField.text:@"1000" toView:self];
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if(self.editType == 0){
        self.room.luckyRecPacketMax = self.countField.text.length > 0?self.countField.text.integerValue:1000;
    }else{
        self.room.exclusiveRedPacketMax = self.countField.text.length > 0?self.countField.text.integerValue:1000;
    }
    [g_server showMsg:@"设置成功"];
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait stop];
    return WH_show_error;
}
#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    [_wait start];
}

@end
