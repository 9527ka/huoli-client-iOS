//
//  WH_CommonCell.m
//  Tigase
//
//  Created by 齐科 on 2019/8/18.
//  Copyright © 2019 Reese. All rights reserved.
//

#import "WH_RoundCornerCell.h"
@interface WH_RoundCornerCell()
{
    UITableView *cellTable;
}

@end
@implementation WH_RoundCornerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        cellTable = tableView;
        [self.contentView addSubview:self.bgView];
        self.cellIndexPath = indexPath;
        [self setUpCellProperties];
        [self autoSetCellType];
        
    }
    return self;
}

- (void)setUpCellProperties {
    self.backgroundColor = g_factory.globalBgColor;
    self.contentView.backgroundColor = g_factory.globalBgColor;
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
   
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(20, 0, JX_SCREEN_WIDTH - 40, self.frame.size.height);
    
    
}
- (void)setCellIndexPath:(NSIndexPath *)cellIndexPath {
    _cellIndexPath = cellIndexPath;
    [self autoSetCellType];
    [self setNeedsDisplay];
}

- (void)autoSetCellType {
    NSInteger number = [cellTable numberOfRowsInSection:_cellIndexPath.section];
    if (number == 1) {
        self.cellType = RoundCornerCellTypeAll;
    } else if (_cellIndexPath.row == 0) {
        self.cellType = RoundCornerCellTypeTop;
    } else if (_cellIndexPath.row == number - 1) {
        self.cellType = RoundCornerCellTypeBottom;
    } else {
        self.cellType = RoundCornerCellTypeNone;
    }
}

-(UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 6.0f;
    }
    return _bgView;
}


@end
