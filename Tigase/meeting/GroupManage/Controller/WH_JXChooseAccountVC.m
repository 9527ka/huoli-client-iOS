//
//  WH_JXChooseAccountVC.m
//  Tigase
//
//  Created by 1111 on 2024/1/10.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXChooseAccountVC.h"
#import "WH_JXChooseAccountCell.h"
#import "WH_GroupAccountSetViewController.h"

@interface WH_JXChooseAccountVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *managerBtn;
@property (weak, nonatomic) IBOutlet UIView *zzView;


@end

@implementation WH_JXChooseAccountVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgView.layer.cornerRadius = 8.0f;
    self.tableView.rowHeight = 88;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_JXChooseAccountCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WH_JXChooseAccountCell"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAction)];
    [self.zzView addGestureRecognizer:tap];
    
    self.managerBtn.hidden = !self.isMySelf;
}
//账号管理
- (IBAction)managerBtnAction:(id)sender {
    WH_GroupAccountSetViewController *vc = [[WH_GroupAccountSetViewController alloc] init];
    __weak typeof (&*self)weakSelf = self;
    vc.dataBlock = ^(NSArray * _Nonnull dataArray) {
        weakSelf.dataArray = dataArray;
        //判断之前选中的是否还存在
        BOOL isAt = NO;
        for (WH_FinancialInfosModel *model in dataArray) {
            if([model.payId isEqualToString:self.payModel.payId]){
                isAt = YES;
                break;;
            }
        }
        if(!isAt){
            weakSelf.payModel = dataArray.firstObject;
        }
        
        [weakSelf.tableView reloadData];
    };
    [g_navigation pushViewController:vc animated:YES];
}

-(void)hiddenAction{
    self.view.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, JX_SCREEN_HEIGHT, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
    }];
}

- (IBAction)backAction:(id)sender {
    [self hiddenAction];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WH_JXChooseAccountCell *cell = (WH_JXChooseAccountCell *)[tableView dequeueReusableCellWithIdentifier:@"WH_JXChooseAccountCell" forIndexPath:indexPath];
    if(self.dataArray.count > indexPath.row){
        WH_FinancialInfosModel *model = self.dataArray[indexPath.row];
        
        NSString *typeStr = @"";
        UIColor *lineColor = HEXCOLOR(0xf7984a);
        cell.tipTitle.hidden = NO;
        if(model.type.intValue == 1){//1.微信  2.支付宝  3银行卡
            lineColor = HEXCOLOR(0x23B525);
            typeStr = @"微信支付";
        }else if (model.type.intValue == 2){
            lineColor = HEXCOLOR(0x4174f2);
            typeStr = @"支付宝";
        }else if (model.type.intValue == 3){
            lineColor = HEXCOLOR(0xf7984a);
            typeStr = @"银行卡";
            cell.tipTitle.hidden = YES;
        }
        cell.lineLab.backgroundColor = lineColor;
        cell.payTypeLab.text = typeStr;
        cell.accountLab.text = model.accountNo;
        cell.chooseImage.image = [UIImage imageNamed:[model.accountNo isEqualToString:self.payModel.accountNo]?@"WH_addressbook_selected":@"WH_addressbook_unselected"];
        
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if(self.dataArray.count > indexPath.row){
        self.payModel.isChoose = NO;
        WH_FinancialInfosModel *model = self.dataArray[indexPath.row];
        model.isChoose = YES;
        self.payModel = model;
        [self.tableView reloadData];
        
        if(self.certainBlock){
            self.certainBlock(self.payModel);
        }
        [self hiddenAction];
    }
    
}


@end
