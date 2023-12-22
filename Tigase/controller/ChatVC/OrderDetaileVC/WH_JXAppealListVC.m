//
//  WH_JXAppealListVC.m
//  Tigase
//
//  Created by 1111 on 2023/12/22.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXAppealListVC.h"
#import "WH_JXAppealListCell.h"

@interface WH_JXAppealListVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UILabel *reasonLab;
@property (weak, nonatomic) IBOutlet UILabel *statueLab;
@property (weak, nonatomic) IBOutlet UILabel *detaileLab;

@end

@implementation WH_JXAppealListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXAppealListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXAppealListCell"];
    
}
//联系对方
- (IBAction)connectAction:(id)sender {
    
}
//提交申诉
- (IBAction)commitAction:(id)sender {
    
}
- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}
// MARK: -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataSource.count;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_JXAppealListCell *cell = (WH_JXAppealListCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXAppealListCell" forIndexPath:indexPath];
    if(self.dataSource.count > indexPath.row){
        NSDictionary *dic = self.dataSource[indexPath.row];
        
    }
    return cell;
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
//    if (self.page == 0) {
//        [self.dataSource removeAllObjects];
//
//        self.nodataImage.hidden = self.nodataLab.hidden = array1.count > 0?YES:NO;
//    }
//    [self.dataSource addObjectsFromArray:array1];
//
//    [self.tableView reloadData];
}
#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    return WH_show_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
//    [_wait start];
}



@end
