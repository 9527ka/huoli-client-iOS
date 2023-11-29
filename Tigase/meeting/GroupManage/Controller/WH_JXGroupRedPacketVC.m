//
//  WH_JXGroupRedPacketVC.m
//  Tigase
//
//  Created by luan on 2023/6/7.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXGroupRedPacketVC.h"
#import "WH_JXGroupRedPacketCell.h"

@interface WH_JXGroupRedPacketVC () <UITableViewDataSource, UITableViewDelegate> {
    BOOL isSelectStartDate;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeight;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *dateContentView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation WH_JXGroupRedPacketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navHeight.constant = JX_SCREEN_TOP;
    self.avatarImage.layer.cornerRadius = 35;
    
    [self.datePicker setMaximumDate:[NSDate date]];
    [self.startDateBtn setTitle:[NSDate date].xmppDateString forState:UIControlStateNormal];
    [self.endDateBtn setTitle:[NSDate date].xmppDateString forState:UIControlStateNormal];
    
    self.nickNameLabel.text = g_myself.userNickname;
    [g_server WH_getHeadImageSmallWIthUserId:g_myself.userId userName:g_myself.userNickname imageView:self.avatarImage];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXGroupRedPacketCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXGroupRedPacketCell"];
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

- (IBAction)didTapType {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *typeArray = @[@"全部", @"手气红包", @"口令红包", @"专属红包"];
    for (NSString *type in typeArray) {
        [actionSheet addAction:[UIAlertAction actionWithTitle:type style:[type isEqualToString:self.typeBtn.currentTitle] ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.typeBtn setTitle:type forState:UIControlStateNormal];
        }]];
    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:actionSheet animated:YES completion:NULL];
}

- (IBAction)didTapStartDate {
    isSelectStartDate = YES;
    [self.datePicker setDate:[NSDate dateWithXmppDateString:self.startDateBtn.currentTitle]];
    self.dateContentView.hidden = NO;
}

- (IBAction)didTapEndDate {
    isSelectStartDate = NO;
    [self.datePicker setDate:[NSDate dateWithXmppDateString:self.endDateBtn.currentTitle]];
    self.dateContentView.hidden = NO;
}

- (IBAction)didTapCancelDate:(id)sender {
    self.dateContentView.hidden = YES;
}

- (IBAction)didTapConfirmDate:(id)sender {
    if (isSelectStartDate) {
        if ([self.datePicker.date timeIntervalSinceDate:[NSDate dateWithXmppDateString:self.endDateBtn.currentTitle]] > 0) {
            [GKMessageTool showError:@"开始时间不能比结束时间大"];
            return;
        }
        [self.startDateBtn setTitle:self.datePicker.date.xmppDateString forState:UIControlStateNormal];
    } else {
        if ([self.datePicker.date timeIntervalSinceDate:[NSDate dateWithXmppDateString:self.startDateBtn.currentTitle]] < 0) {
            [GKMessageTool showError:@"结束时间不能比开始时间小"];
            return;
        }
        [self.endDateBtn setTitle:self.datePicker.date.xmppDateString forState:UIControlStateNormal];
    }
    self.dateContentView.hidden = YES;
}

// MARK: -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXGroupRedPacketCell *cell = (WH_JXGroupRedPacketCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXGroupRedPacketCell" forIndexPath:indexPath];
    return cell;
}

@end
