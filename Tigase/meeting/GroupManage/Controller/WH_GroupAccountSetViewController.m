//
//  WH_GroupAccountSetViewController.m
//  Tigase
//
//  Created by 1111 on 2023/12/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_GroupAccountSetViewController.h"
#import "WH_GroupAccountSetCell.h"
#import "WH_AddAccountViewController.h"

@interface WH_GroupAccountSetViewController ()<UITableViewDataSource, UITableViewDelegate>{
    ATMHud* _wait;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nodataLab;
@property (weak, nonatomic) IBOutlet UIImageView *noDataImage;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *noticeLab;

@end

@implementation WH_GroupAccountSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_GroupAccountSetCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_GroupAccountSetCell"];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.noticeLab.text attributes:attributes];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:227/255.0 green:66/255.0 blue:68/255.0 alpha:1.0] range:NSMakeRange(1, 16)];
    self.noticeLab.attributedText = att;
    
}
- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
#pragma mark--添加账号
- (IBAction)addAcountAction:(UIButton *)sender {
    WH_AddAccountViewController *vc = [[WH_AddAccountViewController alloc] init];
    [g_navigation pushViewController:vc animated:YES];
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_GroupAccountSetCell *cell = (WH_GroupAccountSetCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_GroupAccountSetCell" forIndexPath:indexPath];

        
    return cell;
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    if ([aDownload.action isEqualToString:wh_user_transferToAdmin]){
        [g_server showMsg:@"提交成功，请等待核实"];
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



@end
