//
//  WH_GroupRechargeViewController.m
//  Tigase
//
//  Created by 1111 on 2023/12/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_GroupRechargeViewController.h"
#import "WH_GroupRechargeCell.h"

@interface WH_GroupRechargeViewController ()<UITableViewDataSource, UITableViewDelegate>{
    ATMHud* _wait;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WH_GroupRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 784;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_GroupRechargeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_GroupRechargeCell"];
}

- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_GroupRechargeCell *cell = (WH_GroupRechargeCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_GroupRechargeCell" forIndexPath:indexPath];
    __weak typeof (self)weakSelf = self;
    
    
        
    return cell;
}

#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait hide];
    if ([aDownload.action isEqualToString:wh_act_UploadFile]){
        
        
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