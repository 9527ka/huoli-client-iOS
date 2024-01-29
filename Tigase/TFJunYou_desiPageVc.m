//
//  JXdesiPageVc.m
//  ZhouXinChat
//
//  Created by lifengye on 2021/10/24.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_desiPageVc.h"
#import "UIView+LK.h"
#import "XMGTitleButton.h"
#import "WH_JXMsg_WHViewController.h"
#import "WH_JXGroup_WHViewController.h"
#import "WH_JXMsgGroup_WHViewController.h"
#import "WH_AddFriend_WHController.h"
#import "WH_JXSelectFriends_WHVC.h"
#import "WH_JX_SelectMenuView.h"
#import "WH_JXFaceCreateRoom_WHVC.h"
#import "WH_JXNear_WHVC.h"
#import "WH_JXCollectMoney_WHVC.h"
#import "WH_JXScanQR_WHViewController.h"
#import "WH_JXNoticeView.h"

@interface TFJunYou_desiPageVc ()<UIScrollViewDelegate,JXSelectMenuViewDelegate,WH_JXScanQR_WHViewControllerDelegate>

/** 标签栏底部的红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, weak) UIButton *button_n;
@property (weak, nonatomic) UIView *sliderView;
@property (strong, nonatomic) MASConstraint *sliderViewCenterX;
@property (weak, nonatomic) UIButton *refreshButton;
@property (weak, nonatomic) UIButton *homeButton;
@property (strong, nonatomic) UIButton *moreBtn;

@property (strong, nonatomic) UIButton *groupBtn;
@property (strong, nonatomic) UIButton *searchBtn;

@property (strong, nonatomic) UILabel *msgNumberBtn ;

@property (strong, nonatomic)WH_JXNoticeView *noticeView;

@property(nonatomic,strong)UILabel *loginNameLab;

@end

@implementation TFJunYou_desiPageVc
  
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
  
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [g_notify addObserver:self selector:@selector(msgNumberBtnClick:) name:@"msgNumberBtnClickNa" object:nil];
    
    if(g_App.isShowRedPacket.intValue == 1 && !g_myself.isTestAccount){
        [self.noticeView receiveData];
    }
    
}

- (void)msgNumberBtnClick:(NSNotification *)note{
    NSString *countNum = note.object;
    if ([countNum intValue]>0) {
        _msgNumberBtn.text = [NSString stringWithFormat:@"%@（%@）",Localized(@"New_Message"),countNum];;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wh_heightHeader = JX_SCREEN_TOP;
    self.wh_heightFooter = 0;
    [self createHeadAndFoot];
        
    UILabel *msgNumberBtn = [[UILabel alloc] initWithFrame:CGRectMake(g_factory.globelEdgeInset+6, JX_SCREEN_TOP - 34-BTN_RANG_UP, JX_SCREEN_WIDTH-120, 24+BTN_RANG_UP*2)];
    msgNumberBtn.textColor = RGB(51, 51, 51);
    msgNumberBtn.font = [UIFont systemFontOfSize:26 weight:UIFontWeightBold];
    msgNumberBtn.text = Localized(@"WaHu_JXMain_WaHuViewController_Message");
    [self.wh_tableHeader addSubview:msgNumberBtn];
    _msgNumberBtn = msgNumberBtn;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH - NAV_INSETS - 24-BTN_RANG_UP*2, JX_SCREEN_TOP - 34-BTN_RANG_UP, 24+BTN_RANG_UP*2, 24+BTN_RANG_UP*2)];
    [btn setImage:[UIImage imageNamed:@"add_friend"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onMore1:) forControlEvents:UIControlEventTouchUpInside];
    [self.wh_tableHeader addSubview:btn];
    [btn addTarget:self action:@selector(onMore1:) forControlEvents:UIControlEventTouchUpInside];
    
    self.groupBtn = [[UIButton alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH - NAV_INSETS - 24-BTN_RANG_UP*2-CGRectGetWidth(btn.frame)-4, JX_SCREEN_TOP - 34-BTN_RANG_UP, 24+BTN_RANG_UP*2, 24+BTN_RANG_UP*2)];
    [self.groupBtn setImage:[UIImage imageNamed:@"group_add"] forState:UIControlStateNormal];
    [self.groupBtn addTarget:self action:@selector(onMore2:) forControlEvents:UIControlEventTouchUpInside];
    [self.wh_tableHeader addSubview:self.groupBtn];
    
    self.searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH - NAV_INSETS - 24-BTN_RANG_UP*2-CGRectGetWidth(btn.frame)*2-8, JX_SCREEN_TOP - 34-BTN_RANG_UP, 24+BTN_RANG_UP*2, 24+BTN_RANG_UP*2)];
    [self.searchBtn setImage:[UIImage imageNamed:@"msg_search"] forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(onMore3:) forControlEvents:UIControlEventTouchUpInside];
    [self.wh_tableHeader addSubview:self.searchBtn];

    [self setupNavBar];
    [self setupContentView];
    [self setupTitlesView];
    [self setupChildViewControllers];
}
 
- (void)onMore3:(UIButton *)btn{
    WH_AddFriend_WHController *vc = [[WH_AddFriend_WHController alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}

- (void)onMore2:(UIButton *)btn{
    [self onNewRoom];
    return;
    WH_AddFriend_WHController *vc = [[WH_AddFriend_WHController alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}
- (void)onMore1:(UIButton *)btn{
    
    NSMutableArray *titles ;
    NSMutableArray *images;
    NSMutableArray *sels ;
     
    if ([g_config.isOpenPositionService intValue] == 0) {
        titles = [NSMutableArray arrayWithArray:@[@"发起钻石群聊",Localized(@"JX_LaunchGroupChat"), Localized(@"JX_AddFriends"), Localized(@"JX_Scan"), Localized(@"WaHu_JXNear_WaHuVC_NearPer"),Localized(@"JX_Receiving"),Localized(@"JX_SearchPublicNumber")]];
        images = [NSMutableArray arrayWithArray:@[@"diamound_icon_group_chat_entry",@"icon_group_chat_entry", @"icon_add_friend", @"icon_scan",@"message_near_person_black", @"icon_payment_received",@"message_near_receiving",@"message_search_publicNumber"]];
        sels = [NSMutableArray arrayWithArray:@[@"onNewdiamoundRoom",@"onNewRoom", @"onSearch", @"showScanViewController", @"onNear",@"onReceiving",@"searchPublicNumber"]];
    }else {
        titles = [NSMutableArray arrayWithArray:@[@"发起钻石群聊",Localized(@"JX_LaunchGroupChat"), Localized(@"JX_AddFriends"), Localized(@"JX_Scan"), Localized(@"JX_Receiving")
//                                                  ,Localized(@"JX_SearchPublicNumber")
                                                ]];
        images = [NSMutableArray arrayWithArray:@[@"diamound_icon_group_chat_entry",@"icon_group_chat_entry",  @"icon_add_friend", @"icon_scan", @"icon_payment_received",@"message_near_receiving"
//                                                  ,@"message_search_publicNumber"
                                                ]];
        sels = [NSMutableArray arrayWithArray:@[@"onNewdiamoundRoom",@"onNewRoom", @"onSearch", @"showScanViewController",@"onReceiving"
//                                                ,@"searchPublicNumber"
                                              ]];
    }
    
    if ([g_App.isShowRedPacket intValue] == 0 || g_myself.isTestAccount) {//关闭
        [titles removeObject:@"发起钻石群聊"];
        [images removeObject:@"diamound_icon_group_chat_entry"];
        [sels removeObject:@"onNewdiamoundRoom"];
    }
    
    if ([g_config.hideSearchByFriends intValue] == 1 && ([g_config.isCommonFindFriends intValue] == 0 || g_myself.role.count > 0)) {
    }else {
        [titles removeObject:Localized(@"JX_AddFriends")];
        [images removeObject:@"message_add_friend_black"];
        [sels removeObject:@"onSearch"];
    }
    if ([g_config.isCommonCreateGroup intValue] == 1 && g_myself.role.count <= 0) {
        [titles removeObject:Localized(@"JX_LaunchGroupChat")];
        [images removeObject:@"message_creat_group_black"];
        [sels removeObject:@"onNewRoom"];
        
        
        [titles removeObject:@"发起钻石群聊"];
        [sels removeObject:@"onNewdiamoundRoom"];
        
    }
    if ([g_config.isOpenPositionService intValue] == 1) {
        [titles removeObject:Localized(@"WaHu_JXNear_WaHuVC_NearPer")];
        [images removeObject:@"message_near_person_black"];
        [sels removeObject:@"onNear"];
    }
    if ([g_App.isShowRedPacket intValue] == 0 || g_myself.isTestAccount) {
        [titles removeObject:Localized(@"JX_Receiving")];
        [images removeObject:@"message_near_receiving"];
        [sels removeObject:@"onReceiving"];
    }

    WH_JX_SelectMenuView *menuView = [[WH_JX_SelectMenuView alloc] initWithTitle:titles image:images cellHeight:45];
    menuView.sels = sels;
    menuView.delegate = self;
    [g_App.window addSubview:menuView];
    
}

#pragma mark - 点击右上角菜单
- (void)didMenuView:(WH_JX_SelectMenuView *)MenuView WithIndex:(NSInteger)index {
    
    NSString *method = MenuView.sels[index];
    SEL _selector = NSSelectorFromString(method);
    [self performSelectorOnMainThread:_selector withObject:nil waitUntilDone:YES];
}

- (void)needVerify:(WH_JXMessageObject *)msg {
    
}

- (void) moreListActionWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
            [self onNewRoom];
            break;
        case 1:
            [self onSearch];
            break;
        case 2:
            [self showScanViewController];
            break;
        case 3:
            [self onNear];
            break;
        default:
            break;
    }
}

-(void)showScanViewController{
//    button.enabled = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        button.enabled = YES;
//    });
    
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        [g_server showMsg:Localized(@"JX_CanNotopenCenmar")];
        return;
    }
    
    WH_JXScanQR_WHViewController * scanVC = [[WH_JXScanQR_WHViewController alloc] init];
    scanVC.delegate = self;
//    [g_window addSubview:scanVC.view];
    [g_navigation pushViewController:scanVC animated:YES];
}

#pragma mark - 添加好友
-(void)onSearch{
    WH_AddFriend_WHController *vc = [[WH_AddFriend_WHController alloc] init];
    [g_navigation pushViewController:vc animated:YES];
 
}
-(void)doSearch:(WH_SearchData*)p{

    WH_JXNear_WHVC *nearVC = [[WH_JXNear_WHVC alloc]init];
    nearVC.wh_isSearch = YES; 
    [g_navigation pushViewController:nearVC animated:YES];
    [nearVC doSearch:p];
}
//创建钻石群组
-(void)onNewdiamoundRoom{
    if ([g_config.isCommonCreateGroup intValue] == 1) {
        [g_App showAlert:Localized(@"JX_NotCreateNewRoom")];
        return;
    }
    
    
    WH_JXSelectFriends_WHVC* vc = [WH_JXSelectFriends_WHVC alloc];
    vc.room = [self receiveRoomData];
    vc.isNewRoom = YES;
    vc.forRoomUser = [self receiveUserData];
    vc.isDiamound = YES;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
}
-(WH_JXUserObject *)receiveUserData{
    WH_JXUserObject *user = [[WH_JXUserObject alloc] init];
    user.userId = g_myself.userId;
    user.userNickname = g_myself.userNickname;
    return user;
}
-(WH_RoomData *)receiveRoomData{
    WH_RoomData *createRoom = [[WH_RoomData alloc] init];
    
    memberData *member = [[memberData alloc] init];
    member.userId = (long)[g_myself.userId longLongValue];
    member.userNickName = MY_USER_NAME;
    member.role = @1;
    [createRoom.members addObject:member];
    
    return createRoom;
}
// 创建群组
-(void)onNewRoom{
//    WH_JXNewRoom_WHVC* vc = [[WH_JXNewRoom_WHVC alloc]init];
//    [g_navigation pushViewController:vc animated:YES];
    
    if ([g_config.isCommonCreateGroup intValue] == 1) {
        [g_App showAlert:Localized(@"JX_NotCreateNewRoom")];
        return;
    }
    
    WH_JXSelectFriends_WHVC* vc = [WH_JXSelectFriends_WHVC alloc];
    vc.room = [self receiveRoomData];
    vc.isNewRoom = YES;
    vc.forRoomUser = [self receiveUserData];
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
}

// 面对面建群
- (void)onFaceCreateRoom {
    
    WH_JXFaceCreateRoom_WHVC *vc = [[WH_JXFaceCreateRoom_WHVC alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}

// 附近的人
-(void)onNear{
    WH_JXNear_WHVC * nearVc = [[WH_JXNear_WHVC alloc] init];
    [g_navigation pushViewController:nearVc animated:YES];
}
// 收付款
- (void)onReceiving {
//    WH_JXPay_WHViewController *payVC = [[WH_JXPay_WHViewController alloc] init];
//    [g_navigation pushViewController:payVC animated:YES];
    
    WH_JXCollectMoney_WHVC * collVC = [[WH_JXCollectMoney_WHVC alloc] init];
    [g_navigation pushViewController:collVC animated:YES];
}

- (void)setupContentView {
    
    float topHeight = (g_App.isShowRedPacket.intValue == 1 && !g_myself.isTestAccount)?50:10;
    
    //模拟多端登录
//    topHeight += 50;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = CGRectMake(0, JX_SCREEN_TOP + topHeight, self.view.bounds.size.width, self.view.bounds.size.height-JX_SCREEN_TOP - topHeight);
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentView.delegate = self;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.pagingEnabled = YES;
    contentView.bounces=NO;
    contentView.scrollEnabled = NO;
    
    NSArray *lastUrl = @[@"消息",@"群组"];
    contentView.contentSize = CGSizeMake(contentView.xmg_width * lastUrl.count, 0);
    [self.view addSubview:contentView];
    self.contentView = contentView;
}
 
-(void)swipeAction:(UISwipeGestureRecognizer *)sender {
 
    if (sender.direction ==UISwipeGestureRecognizerDirectionLeft) {
       
        int index =1;
        [self titleClick:self.titlesView.subviews[index]];
        [self switchController:index];
        
    }else if(sender.direction ==UISwipeGestureRecognizerDirectionRight){
        
        int index =0;
        [self titleClick:self.titlesView.subviews[index]];
        [self switchController:index];
        
    }
}

 
 
- (void)setupTitlesView {
    UIView *backView = [[UIView alloc] init];
    backView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    backView.frame = CGRectMake(0, JX_SCREEN_TOP, self.view.frame.size.width, 40);
    backView.backgroundColor = [UIColor whiteColor];
    backView.userInteractionEnabled=YES;
    [self.view addSubview:backView];
  
    UIView *titlesView = [[UIView alloc] init];
    titlesView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    CGFloat top = THE_DEVICE_HAVE_HEAD ? 20 : 33;
    titlesView.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH/2, 40);
    titlesView.userInteractionEnabled = YES;
    [backView addSubview:titlesView];
    self.titlesView = titlesView;

    NSArray *lastUrl = @[Localized(@"WaHu_JXSearchUser_WaHuVC_All"),Localized(@"GROUP")];
    for (int i=0;i<lastUrl.count; i++) {
        XMGTitleButton *button = [[XMGTitleButton alloc]init];
        [button setTitle:lastUrl[i] forState:UIControlStateNormal];
        button.tag = i;
        [titlesView addSubview:button];
        button.frame = CGRectMake(i*(60+20)+g_factory.globelEdgeInset, 5, 60, 30);
        if (i==0) {
            button.enabled = NO;
            _selectedButton = button;
        }
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    float loginTop = JX_SCREEN_TOP + 40;
    
    if(g_App.isShowRedPacket.intValue == 1 && !g_myself.isTestAccount){
        //跑马灯的view
        _noticeView = [[WH_JXNoticeView alloc] initWithFrame:CGRectMake(0, JX_SCREEN_TOP + 40, JX_SCREEN_WIDTH, 40)];
        [self.view addSubview:self.noticeView];
        
        loginTop = JX_SCREEN_TOP + 90;
    }
    //多端登录
    _loginNameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, loginTop, JX_SCREEN_WIDTH, 40)];
    _loginNameLab.text = [NSString stringWithFormat:@"  %@ %@已登录",@"  Mac",APP_NAME];
    _loginNameLab.textColor = HEXCOLOR(0x666666);
    _loginNameLab.font = [UIFont systemFontOfSize:14];
    _loginNameLab.backgroundColor = g_factory.globalBgColor;
    _loginNameLab.hidden = YES;
    [self.view addSubview:self.loginNameLab];
}
 
- (void)onFreshRight{
    if (self.selectedButton.tag==0) {
        [g_notify postNotificationName:@"shuaxin1" object:nil];
    } else {
        [g_notify postNotificationName:@"shuaxin2" object:nil];
    }
}

- (void)onFreshLeft{
    if (self.selectedButton.tag==0) {
        [g_notify postNotificationName:@"shouye1" object:nil];
    } else {
        [g_notify postNotificationName:@"shouye2" object:nil];
    }
}

- (XMGTitleButton *)setupTitleButton:(NSString *)title {
    XMGTitleButton *button = [XMGTitleButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
 
    [self.titlesView addSubview:button];
    self.topButton=button;
 
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.titlesView.xmg_width/2);
        make.top.mas_equalTo(JX_SCREEN_HEIGHT>=812?0:0);
        NSUInteger index = self.titlesView.subviews.count - 1;
        if (index == 0) {
            make.left.mas_equalTo(self.titlesView);
        } else {
            make.left.mas_equalTo(self.titlesView.xmg_width/2);
            
        }
    }];
     
   
    return button;
}
 
- (void)titleClick:(UIButton *)button {
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 消除约束
    [self.sliderViewCenterX uninstall];
    self.sliderViewCenterX = nil;
    
    // 添加约束
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.sliderViewCenterX = make.centerX.equalTo(button);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.sliderView layoutIfNeeded];
    }];
    
     int index = (int)[self.titlesView.subviews indexOfObject:button];
     [self.contentView setContentOffset:CGPointMake(index * self.contentView.frame.size.width, self.contentView.contentOffset.y) animated:YES];
     
}

- (void)setupNavBar {
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupChildViewControllers {
    WH_JXMsg_WHViewController* videoVC = [WH_JXMsg_WHViewController alloc];
    videoVC = [videoVC init];
    [self addChildViewController:videoVC];
    
    WH_JXMsgGroup_WHViewController *mainVC = [WH_JXMsgGroup_WHViewController alloc];
    mainVC = [mainVC init];
    [self addChildViewController:mainVC];
     
    mainVC.view.xmg_y = 0;
    mainVC.view.xmg_width = self.contentView.xmg_width;
    mainVC.view.xmg_height = self.contentView.xmg_height;
    mainVC.view.xmg_x = mainVC.view.xmg_width * 1;
    [self.contentView addSubview:mainVC.view];
    
    videoVC.view.xmg_y = 0;
    videoVC.view.xmg_width = self.contentView.xmg_width;
    videoVC.view.xmg_height = self.contentView.xmg_height;
    videoVC.view.xmg_x = videoVC.view.xmg_width * 0;  
    [self.contentView addSubview:videoVC.view];
}

- (void)switchController:(int)index {
    if (self.childViewControllers.count>1) {
        
    }
}

 
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView
{
     
     int index = scrollView.contentOffset.x / scrollView.frame.size.width;
  
     [self titleClick:self.titlesView.subviews[index]];
     [self switchController:index];
    
}

- (void)scrollViewDidEndScrollingAnimation:(nonnull UIScrollView *)scrollView
{
     int a=(int)(scrollView.contentOffset.x / scrollView.frame.size.width);
     
     [self switchController:a];
   
}

  
@end








