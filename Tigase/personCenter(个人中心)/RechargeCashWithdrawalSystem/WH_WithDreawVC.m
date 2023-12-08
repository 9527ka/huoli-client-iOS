//
//  WH_WithDreawVC.m
//  Tigase
//
//  Created by 1111 on 2023/12/8.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_WithDreawVC.h"
#import "WH_WithDreawCell.h"

@interface WH_WithDreawVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WH_WithDreawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 584;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_WithDreawCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_WithDreawCell"];
    
}
- (IBAction)didTapBack {
    [g_navigation WH_dismiss_WHViewController:self animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_WithDreawCell *cell = (WH_WithDreawCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_WithDreawCell" forIndexPath:indexPath];
//    __weak typeof (self)weakSelf = self;
    
        
    return cell;
}


@end
