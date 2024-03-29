//
//  WH_PwsSecSettingViewController.m
//  Tigase
//
//  Created by Apple on 2019/8/12.
//  Copyright © 2019 Reese. All rights reserved.
//

#import "WH_PwsSecSettingViewController.h"
#import "WH_JXUserObject+GetCurrentUser.h"
#import "DMDropDownMenu.h"

#define HEIGHT 56

@interface WH_PwsSecSettingViewController ()<DMDropDownMenuDelegate,UITextFieldDelegate>
{
    CGFloat textFieldBottom;
    NSArray *questionArray;
    NSArray *resultArray;
}
@end

@implementation WH_PwsSecSettingViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.wh_isGotoBack   = YES;
        
        self.title = Localized(@"New_security_question");
        self.wh_heightFooter = 0;
        self.wh_heightHeader = JX_SCREEN_TOP;
        [self createHeadAndFoot];
        self.wh_tableBody.backgroundColor = g_factory.globalBgColor;
        self.wh_tableBody.scrollEnabled = YES;
        
        WH_JXImageView* iv;
        iv = [[WH_JXImageView alloc]init];
        iv.frame = self.wh_tableBody.bounds;
        iv.wh_delegate = self;
        iv.didTouch = @selector(hideKeyboard);
        [self.wh_tableBody addSubview:iv];
        
        
        UILabel *bgLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, JX_SCREEN_WIDTH, 40)];
        bgLab.backgroundColor = HEXCOLOR(0xF3FFF8);
        [self.wh_tableBody addSubview:bgLab];
        
        UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, JX_SCREEN_WIDTH - 2*20, 40)];
        desLabel.numberOfLines = 0;
        desLabel.textColor = HEXCOLOR(0x2BAF67);
        desLabel.text = Localized(@"New_remeber_answer");
        desLabel.font = [UIFont systemFontOfSize:12];
        [self.wh_tableBody addSubview:desLabel];
        
        //创建整体背景
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(desLabel.frame)+20, JX_SCREEN_WIDTH - 40, 317)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 6.0f;
        bgView.layer.masksToBounds = YES;
        [self.wh_tableBody addSubview:bgView];
        
        
        DMDropDownMenu *dm1 = [[DMDropDownMenu alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(desLabel.frame)+20, JX_SCREEN_WIDTH - 2*20, 44)];
        dm1.delegate = self;
        dm1.tag = 501;
        self.dm1 = dm1;
        [self.wh_tableBody addSubview:dm1];
        
        
        iv = [[WH_JXImageView alloc] init];
        iv.backgroundColor = [UIColor whiteColor];
        iv.userInteractionEnabled = YES;
        iv.didTouch = @selector(hideKeyboard);
        iv.wh_delegate = self;
        iv.frame = CGRectMake(40, CGRectGetMaxY(dm1.frame)+3, JX_SCREEN_WIDTH - 80, 44);
        [self.wh_tableBody addSubview:iv];

        iv.layer.masksToBounds = YES;
        iv.layer.cornerRadius = g_factory.cardCornerRadius;
        iv.layer.borderWidth = g_factory.cardBorderWithd;
        iv.layer.borderColor = g_factory.cardBorderColor.CGColor;
        
        self.question1TF = [self MiXin_createMiXinTextField:iv defaultString:nil hint:Localized(@"New_input_answer")];
        

        //问题二
        DMDropDownMenu *dm2 = [[DMDropDownMenu alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(iv.frame)+6, JX_SCREEN_WIDTH - 2*20, 44)];
        self.dm2 = dm2;
        dm2.tag = 502;
        dm2.delegate = self;
        [self.wh_tableBody addSubview:dm2];
        
        iv = [[WH_JXImageView alloc] init];
        iv.backgroundColor = [UIColor whiteColor];
        iv.userInteractionEnabled = YES;
        iv.didTouch = @selector(hideKeyboard);
        iv.wh_delegate = self;
        iv.frame = CGRectMake(40, CGRectGetMaxY(dm2.frame)+3, JX_SCREEN_WIDTH - 2*40, 44);
        [self.wh_tableBody addSubview:iv];
        
        iv.layer.masksToBounds = YES;
        iv.layer.cornerRadius = g_factory.cardCornerRadius;
        iv.layer.borderWidth = g_factory.cardBorderWithd;
        iv.layer.borderColor = g_factory.cardBorderColor.CGColor;
        
        self.question2TF = [self MiXin_createMiXinTextField:iv defaultString:nil hint:Localized(@"New_input_answer")];
        
        //问题三
        DMDropDownMenu *dm3 = [[DMDropDownMenu alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(iv.frame)+6, JX_SCREEN_WIDTH - 2*20, 44)];
        self.dm3 = dm3;
        dm3.tag = 503;
        dm3.delegate = self;
        
        [self.wh_tableBody addSubview:dm3];
        
        
        iv = [[WH_JXImageView alloc] init];
        iv.backgroundColor = [UIColor whiteColor];
        iv.userInteractionEnabled = YES;
        iv.didTouch = @selector(hideKeyboard);
        iv.wh_delegate = self;
        iv.frame = CGRectMake(40, CGRectGetMaxY(dm3.frame)+3, JX_SCREEN_WIDTH - 2*40, 44);
        [self.wh_tableBody addSubview:iv];
        
        iv.layer.masksToBounds = YES;
        iv.layer.cornerRadius = g_factory.cardCornerRadius;
        iv.layer.borderWidth = g_factory.cardBorderWithd;
        iv.layer.borderColor = g_factory.cardBorderColor.CGColor;
        
        self.question3TF = [self MiXin_createMiXinTextField:iv defaultString:nil hint:Localized(@"New_input_answer")];
        
        //完成按钮
        UIButton* _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:Localized(@"JX_Confirm") forState:UIControlStateNormal];
        [_btn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _btn.layer.cornerRadius = 24.0f;
        _btn.custom_acceptEventInterval = .25f;
        _btn.clipsToBounds = YES;
        _btn.frame = CGRectMake(37, CGRectGetMaxY(bgView.frame) + 50, JX_SCREEN_WIDTH - 2*37, 48);
        [_btn setBackgroundColor:HEXCOLOR(0x2BAF67)];
        [self.wh_tableBody addSubview:_btn];
        
        self.wh_tableBody.contentSize = CGSizeMake(JX_SCREEN_WIDTH, _btn.bottom+20);
        
//        [_wait start];
        [g_server getPasswordSecListData:self];
    
    }
    return self;
}

#pragma mark ---------- actionClick
- (void)doneBtnClick
{
    [self.view endEditing:YES];
    if (!self.question1TF.text.length || !self.question2TF.text.length || !self.question3TF.text.length) {
        [GKMessageTool showText:Localized(@"New_input_complete")];
    }
    for (int i = 0; i < resultArray.count; i ++) {
        NSDictionary *tempDic = resultArray[i];
        if (i == 0) {
            [tempDic setValue:self.question1TF.text forKey:@"a"];
        }else if (i == 1) {
            [tempDic setValue:self.question2TF.text forKey:@"a"];
        }else if (i == 2) {
            [tempDic setValue:self.question3TF.text forKey:@"a"];
        }
    }
    
    
    NSString *dataStr = [resultArray mj_JSONString];
    if (self.isRegist) {
        [self actionQuit];
        if (self.questionBlock) {
            self.questionBlock(dataStr);
        }
    }else {
        [_wait start];
        [g_server setPasswordSecQuesAns:dataStr toView:self];
    }
}

-(UITextField*)MiXin_createMiXinTextField:(UIView*)parent defaultString:(NSString*)s hint:(NSString*)hint{
    UITextField* p = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, parent.frame.size.width - 20, parent.frame.size.height)];
    p.delegate = self;
    p.autocorrectionType = UITextAutocorrectionTypeNo;
    p.autocapitalizationType = UITextAutocapitalizationTypeNone;
    p.enablesReturnKeyAutomatically = YES;
    p.borderStyle = UITextBorderStyleNone;
    p.returnKeyType = UIReturnKeyDone;
    p.clearButtonMode = UITextFieldViewModeAlways;
    p.textAlignment = NSTextAlignmentLeft;
    p.userInteractionEnabled = YES;
    p.text = s;
    p.placeholder = hint;
    p.font = sysFontWithSize(15);
    [parent addSubview:p];
    return p;
}


- (UILabel*)MiXin_createLabel:(UIView*)parent default:(NSString*)s{
    UILabel* p = [[UILabel alloc] initWithFrame:CGRectZero];
    p.numberOfLines = 0;
    p.text = s;
    p.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    p.textAlignment = NSTextAlignmentLeft;
    p.textColor = [UIColor colorWithRed:143/255.0 green:156/255.0 blue:187/255.0 alpha:1.0];
    [parent addSubview:p];
    return p;
}


-(void)hideKeyboard{
    
    [self.view endEditing:YES];
    
}

#pragma mark --- UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect covertRect = [self.wh_tableBody convertRect:textField.superview.frame toView:self.view];
    textFieldBottom = CGRectGetMaxY(covertRect);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


- (void)textFieldEditChanged:(UITextField *)textField{
//    if (_name == textField) {
//        [g_factory setTextFieldInputLengthLimit:textField maxLength:NAME_INPUT_MAX_LENGTH];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    resultArray = @[[NSMutableDictionary new], [NSMutableDictionary new], [NSMutableDictionary new]];
    [g_notify addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [g_notify addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - DMDropDelelge
- (void)selectIndex:(NSInteger)index AtDMDropDownMenu:(DMDropDownMenu *)dmDropDownMenu
{
//    if (resultArray.count >= 3) {
        NSDictionary *tempDic = dmDropDownMenu.listArr[index];
        NSMutableDictionary *resDic = resultArray[dmDropDownMenu.tag - 501];
        [resDic setValue:tempDic[@"id"] forKey:@"q"];
//    }
}
- (void)getCurrentUserInfo {
    [[WH_JXUserObject sharedUserInstance] getCurrentUser];
    [WH_JXUserObject sharedUserInstance].complete = ^(HttpRequestStatus status, NSDictionary * _Nullable userInfo, NSError * _Nullable error) {
        switch (status) {
            case HttpRequestSuccess:
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.questionBlock) {
                        self.questionBlock(@"questions");
                    }
                    [self actionQuit];
                });
            }
                break;
            case HttpRequestFailed:
            {
                
            }
                break;
            case HttpRequestError:
            {
                
            }
                break;
                
            default:
                break;
        }
    };
}
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if( [aDownload.action isEqualToString:act_pwsSecList]){
        if (array1.count > 0) {
            questionArray = [NSMutableArray arrayWithArray:array1];
            [self configDropViewData:array1];
        }
    }else if ([aDownload.action isEqualToString:act_pwsSecSet]){
        [GKMessageTool showText:Localized(@"JXAlert_SetOK")];
//        [g_server getUser:MY_USER_ID toView:self];
        [self getCurrentUserInfo];
    }else if ([aDownload.action isEqualToString:wh_act_UserGet]) {
        if (dict) {
            [g_myself WH_getDataFromDict:dict];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self actionQuit];
        });
    }
}



#pragma mark - 请求失败回调
- (int)WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    [g_App showAlert:dict[@"resultMsg"]];
    return WH_show_error;
}
-(int) WH_didServerConnect_MiXinError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    [_wait hide];
    return WH_show_error;
}

#pragma mark ---- UIKeyBoardNotification
- (void)keyboardDidShow:(NSNotification *)notifi {
    NSDictionary *userInfo = notifi.userInfo;
    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [value CGRectValue];
    CGFloat keyboardHeight = rect.size.height;
    CGFloat offset = ((JX_SCREEN_HEIGHT-keyboardHeight)-textFieldBottom-20) > 0 ? 0 :  (JX_SCREEN_HEIGHT-keyboardHeight)-textFieldBottom-20;
    [UIView animateWithDuration:0.3 animations:^{
        [self.wh_tableBody setContentOffset:CGPointMake(0, -offset) animated:YES];
    }];
}
- (void)keyboardWillHide:(NSNotification *)notifi {
    [UIView animateWithDuration:0.3 animations:^{
        [self.wh_tableBody setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
}

#pragma mark   ----- Data Handler
- (void)setQuestions {
    [self setUpDropMenuSelectedWithIndex:0];
    [self setUpDropMenuSelectedWithIndex:1];
    [self setUpDropMenuSelectedWithIndex:2];
}
- (void)setUpDropMenuSelectedWithIndex:(NSInteger)index {
    DMDropDownMenu *dm = index == 0 ? self.dm1 : (index == 1 ? self.dm2 : self.dm3);
    UITextField *questionTF = index == 0 ? self.question1TF : (index == 1 ? self.question2TF : self.question3TF);
    NSDictionary *questionDic = g_myself.questions[index];
    NSMutableDictionary *mutDic = resultArray[index];
    for (int i=0; i<dm.listArr.count; i++) {
        NSDictionary *temDic = dm.listArr[i];
        if ([questionDic[@"q"] isEqualToString:temDic[@"id"]]) {
            dm.currentIndex = i;
            questionTF.text = questionDic[@"a"];
            [mutDic setObject:temDic[@"id"] forKey:@"q"];
            break;
        }
    }
}
- (NSArray *)questionArrayForDropView:(NSArray *)array {
    int count = (int)array.count/3;
    count = array.count%3 == 0 ? (int)array.count/3 : count+1;
    NSMutableArray *tempMut = [NSMutableArray new];
    for (int i = 0; i<3; i++) {
        NSMutableArray *interMut = [NSMutableArray new];
        for (int j = count*i; j<count*(i+1); j++) {
            if (j<array.count) {
                [interMut addObject:array[j]];
            }
        }
        [tempMut addObject:interMut];
    }
    return [NSArray arrayWithArray:tempMut];
}
- (void)configDropViewData:(NSArray *)dataArray {
    NSMutableArray *tempArr = [NSMutableArray array];
    
    NSString *lang = g_constant.sysLanguage;

    for (NSDictionary *obj in dataArray) {
        
        if ([lang isEqualToString:@"zh"]) {
            [tempArr addObject:obj[@"question"]];
        }
        else if ([lang isEqualToString:@"big6"]) {
            [tempArr addObject:obj[@"arabic"]];
        }
        else if ([lang isEqualToString:@"big7"]) {
            [tempArr addObject:obj[@"french"]];
        }
        else {
            [tempArr addObject:obj[@"en"]];
        }
        
        
    }
    NSArray *threeArrs = [self questionArrayForDropView:dataArray];
    if (threeArrs.count > 0) {
        [self.dm1 setListArr:threeArrs[0]];
    }
    
    if (threeArrs.count > 1) {
        [self.dm2 setListArr:threeArrs[1]];
    }
    
    if (threeArrs.count > 2) {
        [self.dm3 setListArr:threeArrs[2]];
    }
    
    NSMutableDictionary *mutDic;
    if (resultArray.count > 0) {
        mutDic = resultArray[0];
    }
    if (self.dm1.listArr.count > 0) {
        [mutDic setObject:self.dm1.listArr[0][@"id"] forKey:@"q"];
    }
    
    if (resultArray.count > 1) {
        mutDic = resultArray[1];
    }
    if (self.dm2.listArr.count > 0) {
        [mutDic setObject:self.dm2.listArr[0][@"id"] forKey:@"q"];
    }
    if (resultArray.count > 2) {
        mutDic = resultArray[2];
    }
    if (self.dm3.listArr.count > 0) {
        [mutDic setObject:self.dm3.listArr[0][@"id"] forKey:@"q"];
    }
    
    if (g_myself.questions.count > 0 && !self.isRegist) {
        [self performSelector:@selector(setQuestions) withObject:nil afterDelay:0.3];
    }
    
    //    [self.dm1 setListArr:tempArr];
    //    self.dm1.currentIndex = 0;
    //    [self.dm2 setListArr:tempArr];
    //    [self.dm3 setListArr:tempArr];
    //    if (dataArray.count < 4) {
    //        if (dataArray.count > 1) {
    //            self.dm2.currentIndex = 1;
    //        }
    //        if (dataArray.count <= 2) {
    //            self.dm3.currentIndex = arc4random() % ((int)dataArray.count);
    //        }else {
    //            self.dm3.currentIndex = 2;
    //        }
    //    }else {
    //        //随机选择不重复的三条
    //        self.dm1.currentIndex = arc4random() % ((int)tempArr.count);
    //        [tempArr removeObjectAtIndex:self.dm1.currentIndex];
    //        self.dm2.currentIndex = arc4random() % ((int)tempArr.count);
    //        [tempArr removeObjectAtIndex:self.dm2.currentIndex];
    //        self.dm3.currentIndex = arc4random() % ((int)tempArr.count);
    //    }
}
@end
