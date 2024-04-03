//
//  WH_JXRedInputView.m
//  Tigase_imChatT
//
//  Created by 1 on 17/8/15.
//  Copyright © 2019年 YanZhenKui. All rights reserved.
//

#import "WH_JXRedInputView.h"
#import "NSString+ContainStr.h"

#define RowHeight 55
#define RowMargin 12

@interface WH_JXRedInputView (){
    CGFloat _greetY;
    CGFloat _countY;
    CGFloat _moneyY;
    CGFloat _canClaimY;
}

@end


@implementation WH_JXRedInputView

-(instancetype)initWithFrame:(CGRect)frame type:(NSUInteger)type isRoom:(BOOL)isRoom delegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.type = type;
        self.delegate = delegate;
        self.isRoom = isRoom;
        
        [self customSubViews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame type:(NSUInteger)type isRoom:(BOOL)isRoom isDiamond:(BOOL)isDiamond roomMemebers:(NSString *)members delegate:(id)delegate {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.type = type; //红包类型 1：普通红包 2：手气红包 3：口令红包 4：z专属钻石
        self.count = members;
        self.delegate = delegate;
        self.isRoom = isRoom;
        self.isDiamond = isDiamond;
        
        [self customSubViews];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        [self customSubViews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self customSubViews];
    }
    return self;
}

-(void)layoutSubviews{
    CGFloat noticeTitleTop = 8;
    CGFloat noticeTitleH = 20;
    CGFloat noticeTitleY = (RowMargin+RowHeight)*2 + noticeTitleTop;
    CGFloat sendBtnY = 0;
    CGFloat totalMoneyTitleY = 0;
    CGFloat totalMoneyTitleH = 56.f;
    if(_isRoom){
        _moneyY = RowMargin;
        _countY = _moneyY + RowMargin + RowHeight;
        if (self.type == 4) {
//            _canClaimY = _countY + RowMargin + RowHeight + noticeTitleTop + noticeTitleH;
            //去掉了一栏 红包个数
            _canClaimY = _countY;
            _greetY = _canClaimY + RowMargin + RowHeight + 30;
        }else{
           _greetY = _countY + RowMargin + RowHeight + noticeTitleTop + noticeTitleH;
        }
        
        totalMoneyTitleY = _greetY + RowHeight + 20;
        sendBtnY = totalMoneyTitleY + totalMoneyTitleH + 20;
    } else {
        _moneyY = RowMargin;
        _greetY = _moneyY + RowMargin + RowHeight;
        
        totalMoneyTitleY = (RowHeight+RowMargin)*2 + noticeTitleTop + noticeTitleH + 16;
        sendBtnY = totalMoneyTitleY + RowHeight + 16;
    }
    
    if(_isRoom){
        _wh_countView.frame = CGRectMake(INSETS, _countY, self.frame.size.width-INSETS*2, self.type == 4?0:RowHeight);
        _wh_countView.hidden = self.type == 4?YES:NO;
        
        _wh_countUnit.frame = CGRectMake(CGRectGetWidth(_wh_countView.frame)-40, 0, 40, RowHeight);
        _wh_countTextField.frame = CGRectMake(CGRectGetMaxX(_wh_countTitle.frame), 0, CGRectGetMinX(_wh_countUnit.frame)-CGRectGetMaxX(_wh_countTitle.frame), RowHeight);
        
        if (self.type == 4) {
            //有专属红包  
            _wh_canClaimView.frame = CGRectMake(INSETS, _canClaimY, self.frame.size.width-INSETS*2, RowHeight);
            _wh_canclaimBtn.frame = CGRectMake(CGRectGetMaxX(self.wh_canClaimTitle.frame) + 10, 0, CGRectGetWidth(_wh_canClaimView.frame)- CGRectGetMaxX(self.wh_canClaimTitle.frame) - 10, RowHeight);
            _wh_canclaimBtn.tag = _type;
            _wh_canClaimMark.frame = CGRectMake(CGRectGetWidth(_wh_canclaimBtn.frame) - 19, (CGRectGetHeight(_wh_canclaimBtn.frame) - 14)*0.5, 14, 14);
            _wh_canClaimPeoples.frame = CGRectMake(0, 0, CGRectGetWidth(_wh_canclaimBtn.frame) - 29, CGRectGetHeight(_wh_canclaimBtn.frame));
            
            _receiveNoticeLabel.frame = CGRectMake(25, CGRectGetMaxY(_wh_canClaimView.frame) + 8, self.frame.size.width - 50, 20);
            if (self.type == 4) {
                _wh_countTextField.userInteractionEnabled = NO;
                _wh_countTextField.text = @"1";
            }
        }
    }
    _wh_moneyView.frame = CGRectMake(INSETS, _moneyY, self.frame.size.width-INSETS*2, RowHeight);
    _wh_moneyUnit.frame = CGRectMake(CGRectGetWidth(_wh_moneyView.frame)-15-45, 0, 50, RowHeight);
    _wh_moneyTextField.frame = CGRectMake(CGRectGetMaxX(_wh_moneyTitle.frame), 0, CGRectGetMinX(_wh_moneyUnit.frame)-8.f-CGRectGetMaxX(_wh_moneyTitle.frame), RowHeight);
    
    _wh_sendButton.frame = CGRectMake(37, sendBtnY, CGRectGetWidth(_wh_moneyView.frame) - 74, 48);
    _wh_sendButton.tag = _type;
    
    _wh_noticeTitle.frame = CGRectMake(25, noticeTitleY, CGRectGetWidth(_wh_moneyView.frame), 20);
    
    _wh_greetView.frame = CGRectMake(CGRectGetMinX(_wh_moneyView.frame), _greetY, CGRectGetWidth(_wh_moneyView.frame), RowHeight);
    _wh_greetTextField.frame = CGRectMake(CGRectGetMaxX(_wh_greetTitle.frame), 0, CGRectGetWidth(_wh_greetView.frame) - 15 -CGRectGetMaxX(_wh_greetTitle.frame), RowHeight);
    
    _wh_totalMoneyTitle.frame = CGRectMake(CGRectGetMinX(_wh_greetView.frame), totalMoneyTitleY, CGRectGetWidth(_wh_greetView.frame), totalMoneyTitleH);
    
    _wh_promptTitle.frame = CGRectMake(0,CGRectGetMaxY(_wh_sendButton.frame) + 20,CGRectGetWidth(self.frame),23);
    
    [self viewLocalized];
}

-(void)viewLocalized{
    _wh_countTitle.text = self.isDiamond ? @"钻石个数" : Localized(@"JXRed_numberPackets");// @"红包个数";//
    _wh_moneyTitle.text = self.isDiamond ? @"总数量" : Localized(@"JXRed_totalAmount");//@"总金额";//
    _wh_countUnit.text = self.isDiamond ? @"个" : Localized(@"JXRed_A");//@"个";//
    _wh_moneyUnit.text = self.isDiamond ? @"钻石" : @"元";//@"元";//
    
    if (self.type == 4) {
        _wh_canClaimTitle.text = @"谁可以领";
        _receiveNoticeLabel.text = [NSString stringWithFormat:@"群人数%@人" ,_count];
        _wh_canClaimPeoples.text = (self.type == 4) ? @"请选择" : @"群内所有人";
    }
    
//    [_wh_sendButton setTitle:self.isDiamond ? @"发送钻石" : Localized(@"JXRed_send") forState:UIControlStateNormal];//@"塞钱进红包"
//    [_wh_sendButton setTitle:self.isDiamond ? @"发送钻石" : Localized(@"JXRed_send") forState:UIControlStateHighlighted];
    _wh_moneyTextField.placeholder = self.isDiamond ? @"输入钻石数量" : Localized(@"JXRed_inputAmount");//@"输入金额";//
    _wh_countTextField.placeholder = self.isDiamond ? @"请输入钻石个数" : Localized(@"JXRed_inputNumPackets");//@"请输入红包个数";//
    _wh_totalMoneyTitle.text = self.isDiamond ? @"钻石0.00" : @"￥0.00";
    
    _wh_totalMoneyTitle.attributedText = [NSString changeSpecialWordColor:HEXCOLOR(0x161819) AllContent:_wh_totalMoneyTitle.text SpcWord:self.isDiamond ? @"钻石" :@"￥" font:14];
    
    _wh_promptTitle.text = self.isDiamond ? @"未领取的钻石，将于24小时后退回您的账号" : Localized(@"New_unclaimed_red");
    switch (_type) {
        case 1:{
            _wh_noticeTitle.text = Localized(@"JXRed_sameAmount");//@"小伙伴领取的金额相同";//
            _wh_greetTextField.placeholder = self.isDiamond ? @"悦介全开" : @"大吉大利 恭喜发财";
            _wh_greetTitle.text = Localized(@"New_hold_message");
            break;
        }
        case 2:{
            _wh_noticeTitle.text = self.isDiamond ? @"小伙伴领取的数量随机" : Localized(@"JXRed_ARandomAmount");//@"小伙伴领取的金额随机";//
            _wh_greetTextField.placeholder = self.isDiamond ? @"悦介全开" : @"大吉大利 恭喜发财";
            _wh_greetTitle.text = Localized(@"New_hold_message");
            break;
        }
        case 3:{
            _wh_noticeTitle.text = Localized(@"JXRed_NoticeOrder");//@"小伙伴需回复口令抢红包";//
            _wh_greetTextField.placeholder = Localized(@"JXRed_orderPlace");//@"如“我真帅”";// eg."I'm so handsome";
            _wh_greetTitle.text = Localized(@"JXRed_setOrder");//@"设置口令";//
            break;
        }
        case 4:{
//            _wh_noticeTitle.text = self.isDiamond? @"小伙伴专属钻石":@"小伙伴专属红包";//@"小伙伴需回复口令抢红包";//
            _wh_noticeTitle.text = @"";
            _wh_greetTextField.placeholder = @"悦介全开";//@"如“我真帅”";// eg."I'm so handsome";
            _wh_greetTitle.text = Localized(@"New_hold_message");//@"设置口令";//
            break;
        }
        default:
            break;
    }
}

-(void)customSubViews{
    self.backgroundColor = g_factory.globalBgColor;
    if(_isRoom){
        [self addSubview:self.wh_countView];
        
        if (self.type == 4) {
            [self addSubview:self.wh_canClaimView];
            [self addSubview:self.receiveNoticeLabel];
        }
    }
    
    [self addSubview:self.wh_moneyView];
    [self addSubview:self.wh_greetView];
    [self addSubview:self.wh_noticeTitle];
    
    [self addSubview:self.wh_sendButton];
    [self addSubview:self.wh_totalMoneyTitle];
    [self addSubview:self.wh_promptTitle];
}

- (UILabel *)wh_totalMoneyTitle{
    if (!_wh_totalMoneyTitle) {
        _wh_totalMoneyTitle = [UILabel new];
        _wh_totalMoneyTitle.textColor = HEXCOLOR(0x3A404C);
        _wh_totalMoneyTitle.font = [UIFont systemFontOfSize:50];
        _wh_totalMoneyTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _wh_totalMoneyTitle;
}

-(UIView *)wh_countView{
    if (!_wh_countView) {
        _wh_countView = [[UIView alloc] init];
            _wh_countView.backgroundColor = [UIColor whiteColor];
        [_wh_countView addSubview:self.wh_countTitle];
        [_wh_countView addSubview:self.wh_countTextField];
        [_wh_countView addSubview:self.wh_countUnit];
        _wh_countView.layer.cornerRadius = g_factory.cardCornerRadius;
        _wh_countView.layer.masksToBounds = YES;
//        _wh_countView.layer.borderWidth = g_factory.cardBorderWithd;
//        _wh_countView.layer.borderColor = g_factory.cardBorderColor.CGColor;
    }
    return _wh_countView;
}

- (UIView *)wh_canClaimView {
    if (!_wh_canClaimView) {
        _wh_canClaimView = [[UIView alloc] init];
        [_wh_canClaimView setBackgroundColor:[UIColor whiteColor]];
        [_wh_canClaimView addSubview:self.wh_canClaimTitle];
        [_wh_canClaimView addSubview:self.wh_canclaimBtn];
        _wh_canClaimView.layer.cornerRadius = g_factory.cardCornerRadius;
        _wh_canClaimView.layer.masksToBounds = YES;
//        _wh_canClaimView.layer.borderWidth = g_factory.cardBorderWithd;
//        _wh_canClaimView.layer.borderColor = g_factory.cardBorderColor.CGColor;
    }
    return _wh_canClaimView;
}

- (UIButton *)wh_canclaimBtn {
    if (!_wh_canclaimBtn) {
        _wh_canclaimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wh_canclaimBtn setBackgroundColor:[UIColor whiteColor]];
        [_wh_canclaimBtn addSubview:self.wh_canClaimPeoples];
        [_wh_canclaimBtn addSubview:self.wh_canClaimMark];
    }
    return _wh_canclaimBtn;
}

- (UIImageView *)wh_canClaimMark {
    if (!_wh_canClaimMark) {
        _wh_canClaimMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WH_Back"]];
    }
    return _wh_canClaimMark;
}

- (UILabel *)wh_canClaimPeoples {
    if (!_wh_canClaimPeoples) {
        _wh_canClaimPeoples = [[UILabel alloc] init];
        [_wh_canClaimPeoples setBackgroundColor:[UIColor whiteColor]];
        [_wh_canClaimPeoples setTextColor:HEXCOLOR(0xBABABA)];
        [_wh_canClaimPeoples setFont:sysFontWithSize(14)];
        [_wh_canClaimPeoples setTextAlignment:NSTextAlignmentRight];
        _wh_canClaimPeoples.alpha = 0.5;
    }
    return _wh_canClaimPeoples;
}

- (UILabel *)receiveNoticeLabel {
    if (!_receiveNoticeLabel) {
        _receiveNoticeLabel = [[UILabel alloc] init];
        _receiveNoticeLabel.font = sysFontWithSize(14);
        _receiveNoticeLabel.textColor = HEXCOLOR(0xBABABA);
    }
    return _receiveNoticeLabel;
}

- (UILabel *)wh_canClaimTitle {
    if (!_wh_canClaimTitle) {
        _wh_canClaimTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, RowHeight)];
        _wh_canClaimTitle.font = sysFontWithSize(14);
        _wh_canClaimTitle.textColor = HEXCOLOR(0x161819);
    }
    return _wh_canClaimTitle;
}

-(UIView *)wh_moneyView{
    if (!_wh_moneyView) {
        _wh_moneyView = [[UIView alloc] init];
        _wh_moneyView.backgroundColor = [UIColor whiteColor];
        _wh_moneyView.layer.cornerRadius = g_factory.cardCornerRadius;
        _wh_moneyView.layer.masksToBounds = YES;
//        _wh_moneyView.layer.borderColor = g_factory.cardBorderColor.CGColor;
//        _wh_moneyView.layer.borderWidth = g_factory.cardBorderWithd;
        [_wh_moneyView addSubview:self.wh_moneyTitle];
        [_wh_moneyView addSubview:self.wh_moneyTextField];
        [_wh_moneyView addSubview:self.wh_moneyUnit];
    }
    return _wh_moneyView;
}

-(UIView *)wh_greetView{
    if (!_wh_greetView) {
        _wh_greetView = [[UIView alloc] init];
        _wh_greetView.backgroundColor = [UIColor whiteColor];
        _wh_greetView.layer.cornerRadius = g_factory.cardCornerRadius;
        _wh_greetView.layer.masksToBounds = YES;
//        _wh_greetView.layer.borderColor = g_factory.cardBorderColor.CGColor;
//        _wh_greetView.layer.borderWidth = g_factory.cardBorderWithd;
        [_wh_greetView addSubview:self.wh_greetTitle];
        [_wh_greetView addSubview:self.wh_greetTextField];
    }
    return _wh_greetView;
}

-(UIButton *)wh_sendButton{
    if (!_wh_sendButton) {
        _wh_sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_sendButton setBackgroundImage:[g_theme themeTintImage:@"feaBtn_backImg_sel"] forState:UIControlStateNormal];
        _wh_sendButton.backgroundColor = THEMECOLOR;
        _wh_sendButton.layer.cornerRadius = 24.0f;
        _wh_sendButton.layer.masksToBounds = YES;
        [_wh_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_wh_sendButton setTitle:@"塞钱进优惠券" forState:UIControlStateNormal];
        [_wh_sendButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        
    }
    return _wh_sendButton;
}

-(UILabel *)wh_noticeTitle{
    if (!_wh_noticeTitle) {
        _wh_noticeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, 200, 20)];
        _wh_noticeTitle.font = sysFontWithSize(14);
        _wh_noticeTitle.textColor = HEXCOLOR(0xBABABA);
    }
    return _wh_noticeTitle;
}

- (UILabel *)wh_promptTitle{
    if (!_wh_promptTitle) {
        _wh_promptTitle = [UILabel new];
        _wh_promptTitle.font = sysFontWithSize(14);
        _wh_promptTitle.textColor = HEXCOLOR(0xBABABA);
        _wh_promptTitle.textAlignment = NSTextAlignmentCenter;
        _wh_promptTitle.hidden = YES;
    }
    return _wh_promptTitle;
}

-(UILabel *)wh_countTitle{
    if (!_wh_countTitle) {
        _wh_countTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, RowHeight)];
        _wh_countTitle.font = sysFontWithSize(14);
        _wh_countTitle.textColor = HEXCOLOR(0x161819);
//        _countTitle.text = @"红包个数";
    }
    return _wh_countTitle;
}
-(UILabel *)wh_moneyTitle{
    if (!_wh_moneyTitle) {
        _wh_moneyTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, RowHeight)];
        _wh_moneyTitle.font = sysFontWithSize(14);
        _wh_moneyTitle.textColor = HEXCOLOR(0x161819);
//        _moneyTitle.text = @"总金额";
    }
    return _wh_moneyTitle;
}
-(UILabel *)wh_greetTitle{
    if (!_wh_greetTitle) {
        _wh_greetTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, RowHeight)];
        _wh_greetTitle.font = sysFontWithSize(14);
        _wh_greetTitle.textColor = HEXCOLOR(0x161819);
    }
    return _wh_greetTitle;
}


-(UITextField *)wh_countTextField{
    if (!_wh_countTextField) {
        _wh_countTextField = [UIFactory WH_create_WHTextFieldWith:CGRectZero delegate:self returnKeyType:UIReturnKeyNext secureTextEntry:NO placeholder:nil font:sysFontWithSize(14)];
//        _wh_countTextField.text = @"1";    // 红包默认最少为1个
        _wh_countTextField.clearButtonMode = UITextFieldViewModeNever;
        _wh_countTextField.textAlignment = NSTextAlignmentRight;
        _wh_countTextField.borderStyle = UITextBorderStyleNone;
        _wh_countTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _wh_countTextField;
}
-(UITextField *)wh_moneyTextField{
    if (!_wh_moneyTextField) {
        _wh_moneyTextField = [UIFactory WH_create_WHTextFieldWith:CGRectZero delegate:self returnKeyType:UIReturnKeyNext secureTextEntry:NO placeholder:nil font:sysFontWithSize(14)];
        _wh_moneyTextField.clearButtonMode = UITextFieldViewModeNever;
        _wh_moneyTextField.textAlignment = NSTextAlignmentRight;
        _wh_moneyTextField.borderStyle = UITextBorderStyleNone;
        _wh_moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
        if (@available(iOS 10, *)) {
            _wh_moneyTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xBABABA)}];
        } else {
            [_wh_moneyTextField setValue:HEXCOLOR(0xBABABA) forKeyPath:@"_placeholderLabel.textColor"];
        }
        [_wh_moneyTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _wh_moneyTextField;
}
-(UITextField *)wh_greetTextField{
    if (!_wh_greetTextField) {
        _wh_greetTextField = [UIFactory WH_create_WHTextFieldWith:CGRectZero delegate:self returnKeyType:UIReturnKeyNext secureTextEntry:NO placeholder:nil font:sysFontWithSize(14)];
        _wh_greetTextField.textAlignment = NSTextAlignmentRight;
        _wh_greetTextField.borderStyle = UITextBorderStyleNone;
        _wh_greetTextField.keyboardType = UIKeyboardTypeDefault;
        if (@available(iOS 10, *)) {
            _wh_greetTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xBABABA)}];
        } else {
            [_wh_greetTextField setValue:HEXCOLOR(0xBABABA) forKeyPath:@"_placeholderLabel.textColor"];
        }
    }
    return _wh_greetTextField;
}


-(UILabel *)wh_countUnit{
    if (!_wh_countUnit) {
        _wh_countUnit = [[UILabel alloc] initWithFrame:CGRectZero];
        _wh_countUnit.font = sysFontWithSize(14);
        _wh_countUnit.textColor = HEXCOLOR(0x797979);
        _wh_countUnit.textAlignment = NSTextAlignmentCenter;
    }
    return _wh_countUnit;
}
-(UILabel *)wh_moneyUnit{
    if (!_wh_moneyUnit) {
        _wh_moneyUnit = [[UILabel alloc] initWithFrame:CGRectZero];
        _wh_moneyUnit.font = sysFontWithSize(14);
        _wh_moneyUnit.textColor = HEXCOLOR(0x797979);
        _wh_moneyUnit.textAlignment = NSTextAlignmentCenter;
    }
    return _wh_moneyUnit;
}
- (void)textFieldEditChanged:(UITextField *)textField{
    if (self.isDiamond) {
        _wh_totalMoneyTitle.text = [NSString stringWithFormat:@"钻石%.2f",textField.text.doubleValue];
    } else {
        _wh_totalMoneyTitle.text = [NSString stringWithFormat:@"￥%.2f",textField.text.doubleValue];
    }
    //富文本
    _wh_totalMoneyTitle.attributedText = [NSString changeSpecialWordColor:HEXCOLOR(0x161819) AllContent:_wh_totalMoneyTitle.text SpcWord:self.isDiamond ? @"钻石" :@"￥" font:14];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([textField isEqual:_wh_moneyTextField]) {
        // 首位不能输入 .
        if (IsStringNull(textField.text) && [string isEqualToString:@"."]) {
            return NO;
        }
        //限制.后面最多有两位，且不能再输入.
        if ([textField.text rangeOfString:@"."].location != NSNotFound) {
            //有.了 且.后面输入了两位  停止输入
            if (toBeString.length > [toBeString rangeOfString:@"."].location+3) {
                return NO;
            }
            //有.了，不允许再输入.
            if ([string isEqualToString:@"."]) {
                return NO;
            }
        }
        //限制首位0，后面只能输入. 和 删除
        if ([textField.text isEqualToString:@"0"]) {
            if (![string isEqualToString:@"."] && ![string isEqualToString:@""]) {
                return NO;
            }
        }
        //限制只能输入：1234567890.
        NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
        NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return YES;
}

-(void)stopEdit{
    [_wh_countTextField resignFirstResponder];
    [_wh_moneyTextField resignFirstResponder];
    [_wh_greetTextField resignFirstResponder];
}


- (void)sp_checkNetWorking:(NSString *)mediaInfo {
    //NSLog(@"Get Info Failed");
}
@end
