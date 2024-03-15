//
//  WH_AddFriend_WHCell.m
//  Tigase
//
//  Created by Apple on 2019/7/4.
//  Copyright © 2019 Reese. All rights reserved.
//

#import "WH_AddFriend_WHCell.h"

@implementation WH_AddFriend_WHCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.verticalEdge = 5.f;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    _bgView = [UIView new];
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.bottom.offset(0);
    }];
    _bgView.backgroundColor = [UIColor whiteColor];
    
    _iconImageView = [UIImageView new];
    [self.bgView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.centerY.offset(0);
    }];
    [_iconImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    _accessoryImageView = [UIImageView new];
    [self.bgView addSubview:_accessoryImageView];
    [_accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-12);
        make.centerY.offset(0);
    }];
    _accessoryImageView.image = [UIImage imageNamed:@"WH_Back"];
    
    [_accessoryImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    _contentLabel = [UILabel new];
    [self.bgView addSubview:_contentLabel];
    _contentLabel.textColor = HEXCOLOR(0x969696);
    _contentLabel.font = sysFontWithSize(12);
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(15);
        make.bottom.offset(-_verticalEdge);
        make.right.equalTo(_accessoryImageView.mas_left).offset(-15);
    }];
    
    _titleLabel = [UILabel new];
    [self.bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contentLabel);
        make.top.offset(_verticalEdge);
        make.bottom.equalTo(_contentLabel.mas_top);
    }];
    _titleLabel.textColor = HEXCOLOR(0x3A404C);
    _titleLabel.font = sysFontWithSize(15);
    
    _textField = [[UITextField alloc] init];
    [self.bgView addSubview:_textField];
    if (@available(iOS 10, *)) {
           _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xBABABA)}];
       } else {
           [_textField setValue:HEXCOLOR(0xBABABA) forKeyPath:@"_placeholderLabel.textColor"];
       }
    _textField.font = sysFontWithSize(15);
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_contentLabel);
        make.top.bottom.offset(0);
    }];
    _textField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(_onTextFieldReturnKeyPress){
        _onTextFieldReturnKeyPress(self,textField);
    }
    return YES;
}

- (void)setType:(WHSettingCellType)type{
    if (_type != type) {
        _type = type;
        if (type == WHSettingCellTypeCommon) {
            _accessoryImageView.hidden = NO;
            _textField.hidden = YES;
            [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_iconImageView.mas_right).offset(15);
                make.bottom.offset(-_verticalEdge);
                make.right.equalTo(_accessoryImageView.mas_left).offset(-15);
                make.height.equalTo(_titleLabel);
            }];
        } else if(type == WHSettingCellTypeIconWithTitle) {
            _accessoryImageView.hidden = YES;
            _textField.hidden = YES;
            [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_iconImageView.mas_right).offset(15);
                make.bottom.offset(-_verticalEdge);
                make.right.equalTo(_accessoryImageView.mas_left).offset(-15);
                make.height.offset(0);
            }];
        } else if(type == WHSettingCellTypeIconWithTextField) {
            _accessoryImageView.hidden = YES;
            _textField.hidden = NO;
                        
        } else if(type == WHSettingCellTypeTitleWithContent){
            _accessoryImageView.hidden = YES;
            _textField.hidden = YES;
            _iconImageView.hidden = YES;
            
            [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(20);
                make.bottom.offset(-_verticalEdge);
                make.right.offset(-20);
            }];
            [_contentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        }
        
        if(type == WHSettingCellTypeTitleWithRightContent) {
            _accessoryImageView.hidden = NO;
            _textField.hidden = YES;
            _iconImageView.hidden = YES;
            
            [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_accessoryImageView.mas_left).offset(-15);
                make.centerY.offset(0);
                
            }];
            
            [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(20);
                make.centerY.offset(0);
            }];
            
        } else {
            [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_contentLabel);
                make.top.offset(_verticalEdge);
                make.bottom.equalTo(_contentLabel.mas_top);
            }];
        }
    }
}

- (void)setBgRoundType:(WHSettingCellBgRoundType)bgRoundType{
    if (_bgRoundType != bgRoundType) {
        if (_bgRoundType != 0) {
            //移除mask
            _bgView.layer.mask = nil;
        }
        _bgRoundType = bgRoundType;
        
        CGRect frame = CGRectMake(0, 0, JX_SCREEN_WIDTH-30, bgRoundType == WHSettingCellBgRoundTypeFour?36:56.f);
        UIRectCorner rectCorner = bgRoundType == WHSettingCellBgRoundTypeTop ? UIRectCornerTopLeft | UIRectCornerTopRight : bgRoundType == WHSettingCellBgRoundTypeBottom ? UIRectCornerBottomLeft | UIRectCornerBottomRight : UIRectCornerAllCorners;
        
        float round = bgRoundType == WHSettingCellBgRoundTypeFour?18.0f:10;
        
        UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:rectCorner cornerRadii:CGSizeMake(round, round)];
        CGSize cornerRadii = CGSizeZero;
        CGFloat lineWidth = .0f;
        if (bgRoundType == WHSettingCellBgRoundTypeNone) {
            cornerRadii = CGSizeZero;
            lineWidth = g_factory.cardBorderWithd;
        } else {
            CAShapeLayer *roundLayer = [[CAShapeLayer alloc] init];
            roundLayer.frame = frame;
            roundLayer.path = roundPath.CGPath;
            _bgView.layer.mask = roundLayer;
            
            cornerRadii = CGSizeMake(round, round);
            lineWidth = g_factory.cardBorderWithd*2;
        }
        
    }
}


@end
