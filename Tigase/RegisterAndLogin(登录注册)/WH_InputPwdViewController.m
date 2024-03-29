//
//  WH_inputPwd_WHVC.m
//  wahu_im
//
//  Created by flyeagleTang on 14-6-10.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "WH_InputPwdViewController.h"
#import "WH_PSRegisterBaseVC.h"
#import "WH_LoginTextField.h"
#import "WH_ResumeData.h"

@interface WH_InputPwdViewController ()<UITextFieldDelegate>
{
    NSString *newPwd;
    NSString *confirmPwd;
}
@end

@implementation WH_InputPwdViewController
@synthesize telephone;

- (id)init
{
    self = [super init];
    if (self) {
        self.wh_isGotoBack   = YES;
        self.title = self.resetPass ? Localized(@"SetLoginPwd") : Localized(@"JX_PassWord");
        self.wh_heightFooter = 0;
        self.wh_heightHeader = JX_SCREEN_TOP;
        self.wh_isNotCreatewh_tableBody = YES;
    }
    return self;
}

- (void)loadSubViews {
    
    //        if (self.resetPass) {
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(g_factory.globelEdgeInset, JX_SCREEN_TOP+20, JX_SCREEN_WIDTH-g_factory.globelEdgeInset*2, 0)];
    tipsLabel.textColor = HEXCOLOR(0x8F9CBB);
    tipsLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    tipsLabel.text = Localized(@"LoginPassDes");
//    [self.view addSubview:tipsLabel];
    //        }
    
    
    WH_LoginTextField *pwdField = [[WH_LoginTextField alloc] initWithFrame:CGRectMake(g_factory.globelEdgeInset,  tipsLabel.bottom+12, tipsLabel.width, 55)];
    pwdField.fieldType = LoginFieldPassWordType;
    pwdField.delegate = self;
    pwdField.tag = 10;
    pwdField.clipsToBounds = YES;
    pwdField.layer.cornerRadius = g_factory.cardCornerRadius;
    pwdField.layer.borderColor = g_factory.cardBorderColor.CGColor;
    pwdField.layer.borderWidth = g_factory.cardBorderWithd;
    [pwdField setCustomAttributePlaceHolder:self.resetPass ? Localized(@"SetNewPass") : Localized(@"JX_InputPassWord")];
    [self.view addSubview:pwdField];
    
    WH_LoginTextField *rePwdField = [[WH_LoginTextField alloc] initWithFrame:CGRectMake(g_factory.globelEdgeInset,  pwdField.bottom+12, tipsLabel.width, 55)];
    rePwdField.fieldType = LoginFieldPassWordType;
    rePwdField.delegate = self;
    rePwdField.tag = 11;
    rePwdField.clipsToBounds = YES;
    rePwdField.layer.cornerRadius = g_factory.cardCornerRadius;
    rePwdField.layer.borderColor = g_factory.cardBorderColor.CGColor;
    rePwdField.layer.borderWidth = g_factory.cardBorderWithd;
    [rePwdField setCustomAttributePlaceHolder:self.resetPass ? Localized(@"ConfirmLoginPwd") : Localized(@"JX_ConfirmPassWord")];
    [self.view addSubview:rePwdField];
    
    
    
    UIButton* _btn = [[UIButton alloc] initWithFrame:CGRectMake(37, rePwdField.bottom+20, JX_SCREEN_WIDTH - 74, 48)];
    _btn.custom_acceptEventInterval = .25f;
    [_btn setTitle:Localized(self.resetPass? @"JX_Confirm" : @"JX_NextStep") forState:UIControlStateNormal];
    _btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [_btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    _btn.clipsToBounds = YES;
    _btn.layer.cornerRadius = 24;
//    _btn.layer.borderColor = g_factory.cardBorderColor.CGColor;
//    _btn.layer.borderWidth = g_factory.cardBorderWithd;
    _btn.backgroundColor = HEXCOLOR(0x2BAF67);
    [self.view addSubview:_btn];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createHeadAndFoot];
    [self loadSubViews];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}
#pragma mark ---- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 10) {
        newPwd = textField.text;
    }else {
        confirmPwd = textField.text;
    }
}

-(void)onClick{
    [self.view endEditing:YES];
    if(IsStringNull(newPwd) || IsStringNull(confirmPwd)){
        [GKMessageTool showTips:Localized(IsStringNull(newPwd) ? @"JX_InputPassWord" : @"JX_ConfirmPassWord")];
        return;
    }
   
    if(![newPwd isEqualToString:confirmPwd]){
        [GKMessageTool showTips:Localized(@"JX_PasswordFiled")];
        return;
    }
    
    if (self.resetPass) {
        [_wait start];
        [g_server resetPwd:self.telephone areaCode:@"" randcode:@"" newPwd:newPwd registerType:1 toView:self];
    }else {
        [self setUserInfo];
    }
}
- (void)setUserInfo {
    WH_JXUserObject* user = [WH_JXUserObject sharedUserInstance];
    user.telephone = telephone;
    user.password  = [g_server WH_getMD5StringWithStr:newPwd];
    user.companyId = [NSNumber numberWithInt:self.isCompany];
    
    WH_PSRegisterBaseVC* vc = [WH_PSRegisterBaseVC alloc];
    vc.registType = self.registTYpe;
    vc.user       = user;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
    
    [self actionQuit];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}



#pragma mark ------ 网络请求
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [GKMessageTool showText:Localized(@"JX_UpdatePassWordOK")];
    [_wait stop];
    [g_default setBool:YES forKey:@"PasswordHasModifyed"];
    [g_navigation popToRootViewController];
}

#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict {
    [_wait stop];
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    
    
    [_wait stop];
    return WH_show_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
  
}


@end
