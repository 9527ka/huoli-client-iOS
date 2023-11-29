//
//  WH_ComplaintViewController.m
//  Tigase
//
//  Created by Apple on 2019/8/21.
//  Copyright © 2019 Reese. All rights reserved.
//

#import "WH_ComplaintViewController.h"
#import "WH_webpage_WHVC.h"

@interface WH_ComplaintViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UIButton * finishBtn;

// 背景视图
@property (weak, nonatomic) UIView *bgView;
// 文字内容输入框
@property (weak, nonatomic) UITextView *textView;
// 灰色占位符
@property (weak, nonatomic) UILabel *placeHolderLabel;
@end

@implementation WH_ComplaintViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.wh_isGotoBack   = YES;
        self.title = @"投诉与建议";
        self.wh_heightFooter = 0;
        self.wh_heightHeader = JX_SCREEN_TOP;
        [self createHeadAndFoot];
        self.wh_tableBody.backgroundColor = g_factory.globalBgColor;
        
        [self.wh_tableHeader addSubview:self.finishBtn];
        
        // 设置子视图的一些属性
        [self ww_setSubViewsInSelfView];
        
    }
    return self;
}

#pragma mark - 设置子视图的一些属性
- (void)ww_setSubViewsInSelfView {
    
    // 背景视图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 10, JX_SCREEN_WIDTH-24, 240)];
    bgView.backgroundColor = [UIColor whiteColor];
    self.bgView = bgView;
    [self.wh_tableBody addSubview:bgView];
    [bgView radiusWithAngle:10];
    // 文字内容输入框
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 7, bgView.width - 2 * 8, bgView.height - 2 * 7)];
    textView.font = sysFontWithSize(12);
    self.textView = textView;
    textView.delegate = self;
    textView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    [bgView addSubview:textView];
    
    
    // 灰色占位符
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 200, 21)];
    self.placeHolderLabel = placeHolderLabel;
    placeHolderLabel.font = [UIFont systemFontOfSize:12];
    placeHolderLabel.textColor = HEXCOLOR(0x999999);
    placeHolderLabel.text = @"请输入您的投诉或举报内容";
    [bgView addSubview:placeHolderLabel];
    
    // 指引按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, CGRectGetMaxY(bgView.frame) + 5, bgView.width, 21);
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitle:[NSString stringWithFormat:@"《%@》",@"Tigase违规行为投诉或举报指引"] forState:UIControlStateNormal];
    [button setTitleColor:HEXCOLOR(0x0097ff) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.wh_tableBody addSubview:button];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.frame = CGRectMake(JX_SCREEN_WIDTH-50-8, JX_SCREEN_TOP - 38, 50, 31);
        [_finishBtn setTitle:Localized(@"JX_Finish") forState:UIControlStateNormal];
        [_finishBtn setTitle:Localized(@"JX_Finish") forState:UIControlStateHighlighted];
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _finishBtn.layer.cornerRadius = CGRectGetHeight(_finishBtn.frame) / 2.f;
        _finishBtn.layer.masksToBounds = YES;
        _finishBtn.backgroundColor = HEXCOLOR(0x0093FF);
        _finishBtn.titleLabel.font = sysFontWithSize(14);
        
        [_finishBtn addTarget:self action:@selector(ww_sendButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

// 导航条上的"发送"按钮 的点击事件
- (void)ww_sendButtonOnClick {
    if ([self.textView.text isEqualToString:@""]) {
        
        [GKMessageTool showText:@"请输入您的投诉或建议内容"];
        return;
    }
    [self.view endEditing:YES];
    
    
    [GKMessageTool showText:@"提交成功!"];
    [self actionQuit];
    
    
}


#pragma mark - 协议 UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    // 隐藏占位符
    self.placeHolderLabel.hidden = textView.text.length ? YES : NO;
}


// 指引按钮 - 被点击
- (void)buttonOnClick:(UIButton *)button {
    WH_webpage_WHVC * webVC = [WH_webpage_WHVC alloc];
    webVC.url = [self protocolUrl1];
    webVC.isSend = NO;
    webVC = [webVC init];
    webVC.isGoBack = YES;
    [g_navigation pushViewController:webVC animated:YES];
}

#pragma mark 获取协议
-(NSString *)protocolUrl1{
    NSString * protocolStr = [NSString stringWithFormat:@"http://%@/agreement/privacyProtectGuide.html",PrivacyAgreementBaseApiUrl];
    //    NSString * lange = g_constant.sysLanguage;
    //    if (![lange isEqualToString:ZHHANTNAME] && ![lange isEqualToString:NAME]) {
    //        lange = ENNAME;
    //    }
    //    return [NSString stringWithFormat:@"%@%@.html",protocolStr,lange];
    return protocolStr;
}

@end
