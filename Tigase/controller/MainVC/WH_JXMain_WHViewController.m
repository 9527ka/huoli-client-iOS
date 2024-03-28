//
//  WH_JXMain_WHViewController.m
//
//  Created by flyeagleTang on 14-4-3.
//  Copyright (c) 2019年 YZK. All rights reserved.
//

#import "WH_JXMain_WHViewController.h"
#import "WH_JXTabMenuView.h"
#import "WH_JXMsg_WHViewController.h"
#import "WH_Addressbook_WHController.h"
#import "AppDelegate.h"
#import "WH_JXNewFriend_WHViewController.h"
#import "WH_JXFriendObject.h"
#import "WH_JXRecordVideo_WHVC.h"
#ifdef Live_Version
//#import "WH_JXLive_WHViewController.h"
#endif

#import "WH_WeiboViewControlle.h"
#import "JXSquareViewController.h"
#import "WH_JXProgress_WHVC.h"
#import "WH_JXGroup_WHViewController.h"
#import "WH_OrganizTree_WHViewController.h"
#import "WH_JXLabelObject.h"
#import "JXBlogRemind.h"

#import "WH_FindViewController.h"
#import "WH_MineVC.h"
#import "WH_webpage_WHVC.h"

#import "WH_WKWebView_JXViewController.h"

#import "TFJunYou_desiPageVc.h"
#import "WH_Player_WHVC.h"

@implementation WH_JXMain_WHViewController
@synthesize tb=_tb;

@synthesize btn=_btn,mainView=_mainView;
@synthesize IS_HR_MODE;

@synthesize psMyviewVC=_psMyviewVC;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.view.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
        self.view.backgroundColor = [UIColor clearColor];
        
//        g_navigation.lastVC = nil;
//        [g_navigation.subViews removeAllObjects];
//        [g_navigation pushViewController:self animated:YES];
//
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_TOP)];
        //        [self.view addSubview:_topView];

        
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT-JX_SCREEN_BOTTOM)];
        [self.view addSubview:_mainView];

        
        //底部TabBar的(容器)
        _bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, JX_SCREEN_HEIGHT-JX_SCREEN_BOTTOM, JX_SCREEN_WIDTH, JX_SCREEN_BOTTOM)];
        _bottomView.userInteractionEnabled = YES;
        [self.view addSubview:_bottomView];

        
        [self buildTop];
        
        [g_notify addObserver:self selector:@selector(WH_onXmppLoginChanged:) name:kXmppLogin_WHNotifaction object:nil];
        [g_notify addObserver:self selector:@selector(hasLoginOther:) name:kXMPPLoginOther_WHNotification object:nil];
        
        
#ifdef IS_SHOW_MENU
//        _squareVC = [[JXSquareViewController alloc] init];
        
        self.homeVC = [[WH_Player_WHVC alloc] init];
//        self.findVC = [[WH_FindViewController alloc] init];///发现
#else
        _weiboVC = [WeiboViewControlle alloc];
        _weiboVC.user = g_myself;
        _weiboVC = [_weiboVC init];
#endif
        _groupVC = [[WH_JXGroup_WHViewController alloc]init];
        _msgVc = [[WH_JXMsg_WHViewController alloc] init];
        _addressbookVC = [[WH_Addressbook_WHController alloc] init];
        
        _mineVC = [[WH_MineVC alloc] init];
        _desipageVc = [[TFJunYou_desiPageVc alloc]init];
#ifdef IS_OPEN_CUSTOM_TAB
        NSDictionary *tabBarConfig = g_config.tabBarConfigList;
        if (tabBarConfig) {
            //有自定义tab
            
            self.wkWebViewVC = [[WH_WKWebView_JXViewController alloc] init];
            NSString *tabBarLinkUrl = tabBarConfig[@"tabBarLinkUrl"];
            self.wkWebViewVC.url = tabBarLinkUrl;
        }
#endif
//#ifdef Live_Version
//        _liveVC = [[WH_JXLive_WHViewController alloc]init];
//#else
//        _organizVC = [[WH_OrganizTree_WHViewController alloc] init];
//#endif
//
        
        [self doSelected:0];

        [g_notify addObserver:self selector:@selector(loginSynchronizeFriends:) name:kXmppClickLogin_WHNotifaction object:nil];
        [g_notify addObserver:self selector:@selector(appDidEnterForeground) name:kApplicationWillEnterForeground object:nil];
        
        [g_notify addObserver:self selector:@selector(tongBuQuanZu) name:kJinQianTaiTongBuQuanZu_WHNotifaction object:nil];
        
        
    }
    return self;
}

- (void)tongBuQuanZu
{
    [g_server WH_listHisRoomWithPage:0 pageSize:5000 toView:self];
}

-(void)dealloc{
    
    [g_notify  removeObserver:self name:kXmppLogin_WHNotifaction object:nil];
    [g_notify  removeObserver:self name:kSystemLogin_WHNotifaction object:nil];
    [g_notify  removeObserver:self name:kXmppClickLogin_WHNotifaction object:nil];
    [g_notify  removeObserver:self name:kXMPPLoginOther_WHNotification object:nil];
    [g_notify  removeObserver:self name:kApplicationWillEnterForeground object:nil];
    [g_notify removeObserver:self name:kJinQianTaiTongBuQuanZu_WHNotifaction object:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loginSynchronizeFriends:nil];
    
    //获取个人信息
    [g_server getUser:MY_USER_ID toView:self];
    
    // 同步标签
    [g_server WH_friendGroupListToView:self];
    // 获取服务器时间
    [g_server getCurrentTimeToView:self];
 
}
//获取当前时间戳 （以毫秒为单位）
-(long )getNowTimeTimestamp3{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return [timeSp longLongValue];
}
- (void)appDidEnterForeground {
    // 获取服务器时间
    [g_server getCurrentTimeToView:self];
}

- (void)loginSynchronizeFriends:(NSNotification*)notification{
    //判断服务器好友数量是否与本地一致
    _friendArray = [g_myself WH_fetchAllFriendsOrNotFromLocal];
//    //NSLog(@"%d -------%ld",[g_myself.friendCount intValue] , [_friendArray count]);
//    if ([g_myself.friendCount intValue] > [_friendArray count] && [g_myself.friendCount intValue] >0) {
//        [g_App showAlert:Localized(@"JXAlert_SynchFirendOK") delegate:self];
    if ([g_myself.isupdate intValue] == 1 || _friendArray.count <= 0) {
        [g_server WH_listAttentionWithPage:0 userId:MY_USER_ID toView:self];
    }else{
        
        [[JXXMPP sharedInstance] performSelector:@selector(login) withObject:nil afterDelay:2];//2秒后执行xmpp登录
    }
    
    [g_server WH_listBlacklistWithPage:0 toView:self];
//    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10002) {
        [g_server performSelector:@selector(showLogin) withObject:nil afterDelay:0.5];
        return;
    }else if (buttonIndex == 1) {
        [g_server WH_listAttentionWithPage:0 userId:MY_USER_ID toView:self];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)buildTop{
    
    _tb = [WH_JXTabMenuView alloc];
    //新界面不展示图片了
    _tb.wh_items = [NSArray arrayWithObjects:@"首页",@"消息",@"朋友",@"我的",nil];
    
    _tb.wh_delegate  = self;
//    _tb.wh_onDragout = @selector(wh_onDragout:);
    [_tb setWh_backgroundImageName:@"MessageListCellBkg"];
    _tb.wh_onClick  = @selector(actionSegment:);
    _tb = [_tb initWithFrame:CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_BOTTOM)];
    __weak typeof (&*self)weakSelf = self;
    _tb.publishBlock = ^{
        [weakSelf publishAction];
    };
    [_bottomView addSubview:_tb];
    
    
//    NSMutableArray *remindArray = [[JXBlogRemind sharedInstance] doFetchUnread];
//    [_tb wh_setBadge:_tb.wh_items.count == 5 ? 3 : 2 title:[NSString stringWithFormat:@"%lu",(unsigned long)remindArray.count]];
}
//发布的点击事件
-(void)publishAction{
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] <= 0) {
        [g_App showAlert:@"未检测到摄像头"];
        return;
    }
    
    WH_JXRecordVideo_WHVC *vc = [[WH_JXRecordVideo_WHVC alloc] init];
//    vc.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:vc animated:NO completion:nil];
    [g_navigation pushViewController:vc animated:NO];
}

-(void)actionSegment:(UIButton*)sender{
    [self doSelected:(int)sender.tag];
}

-(void)doSelected:(int)n{
    [_selectVC.view removeFromSuperview];
    
    [self noCustomTabSelectedHandler:n];
    
    [_tb wh_selectOne:n];
    [_mainView addSubview:_selectVC.view];
}



//无自定义tab
- (void)noCustomTabSelectedHandler:(int)n{
    switch (n){
        case 0:
            _selectVC = _homeVC;
            
            break;
        case 1:
            _selectVC = _desipageVc;
            break;
        case 2:
            _selectVC = _addressbookVC;
//#ifdef IS_SHOW_MENU
//            _selectVC = _findVC;
//#else
//            _selectVC = _weiboVC;
//#endif
            break;
        case 3:
            _selectVC = _mineVC;
            break;
    }
}

-(void)WH_onXmppLoginChanged:(NSNumber*)isLogin{
    if([JXXMPP sharedInstance].isLogined == login_status_yes)
        [self onAfterLogin];
    switch (_tb.wh_selected){
        case 0:
            _btn.hidden = [JXXMPP sharedInstance].isLogined;
            break;
        case 1:
            _btn.hidden = ![JXXMPP sharedInstance].isLogined;
            break;
        case 2:
            _btn.hidden = NO;
            break;
        case 3:
            _btn.hidden = ![JXXMPP sharedInstance].isLogined;
            break;
    }
}

-(void)onAfterLogin{
//    [_msgVc WH_scrollToPageUp];
}

-(void)hasLoginOther:(NSNotification *)notifcation{
    
    [g_App showAlert:Localized(@"JXXMPP_Other") delegate:self tag:10002 onlyConfirm:YES];
    //多端登录
    
}


#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    if ([aDownload.action isEqualToString:wh_act_UserGet]) {
        WH_JXUserObject* user = [[WH_JXUserObject alloc]init];
        [user WH_getDataFromDict:dict];
        [g_myself WH_getDataFromDict:dict];
        g_myself.officialCSUid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"officialCSUid"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"officialCSUid"]] forKey:@"officialCSUid"];
        
        g_constant.isAddFriend = user.isAddFirend;
    }
    //更新本地好友
    if ([aDownload.action isEqualToString:wh_act_AttentionList]) {
        WH_JXProgress_WHVC * pv = [WH_JXProgress_WHVC alloc];
        pv.dbFriends = (long)[_friendArray count];
        pv.dataArray = array1;
        pv = [pv init];
        if (array1.count > 300) {
            [g_navigation pushViewController:pv animated:YES];
        }
//        [self.view addSubview:pv.view];
        
    }
    
    if ([aDownload.action isEqualToString:wh_act_BlacklistList]) {
        for (int i = 0; i< [array1 count]; i++) {
            NSDictionary * dict = array1[i];
            WH_JXUserObject * user = [[WH_JXUserObject alloc]init];
            //数据转为一个好友对象
            [user WH_getDataFromDictSmall:dict];
            //访问数据库是否存在改好友，没有则写入数据库
            if (user.userId.length > 5) {
                [user insertFriend];
            }
        }
    }
    
    // 同步标签
    if ([aDownload.action isEqualToString:wh_act_FriendGroupList]) {
        
        for (NSInteger i = 0; i < array1.count; i ++) {
            NSDictionary *dict = array1[i];
            WH_JXLabelObject *labelObj = [[WH_JXLabelObject alloc] init];
            labelObj.groupId = dict[@"groupId"];
            labelObj.groupName = dict[@"groupName"];
            labelObj.userId = dict[@"userId"];
            
            NSArray *userIdList = dict[@"userIdList"];
            NSString *userIdListStr = [userIdList componentsJoinedByString:@","];
            if (userIdListStr.length > 0) {
                labelObj.userIdList = [NSString stringWithFormat:@"%@", userIdListStr];
            }
            [labelObj insert];
        }
        
        // 删除服务器上已经删除的
        NSArray *arr = [[WH_JXLabelObject sharedInstance] fetchAllLabelsFromLocal];
        for (NSInteger i = 0; i < arr.count; i ++) {
            WH_JXLabelObject *locLabel = arr[i];
            BOOL flag = NO;
            for (NSInteger j = 0; j < array1.count; j ++) {
                NSDictionary * dict = array1[j];
               
                if ([locLabel.groupId isEqualToString:dict[@"groupId"]]) {
                    flag = YES;
                    break;
                }
            }
            
            if (!flag) {
                [locLabel delete];
            }
        }
    }
    
    
    //保存所有进入过的房间
    if ([aDownload.action isEqualToString:wh_act_roomListHis]) {
        for (int i = 0; i < [array1 count]; i++) {
            NSDictionary *dict=array1[i];
            
            WH_JXUserObject* user = [[WH_JXUserObject alloc]init];
            user.userNickname = [dict objectForKey:@"name"];
            user.userId = [dict objectForKey:@"jid"];
            user.userDescription = [dict objectForKey:@"desc"];
            user.roomId = [dict objectForKey:@"id"];
            user.showRead = [dict objectForKey:@"showRead"];
            user.showMember = [dict objectForKey:@"showMember"];
            user.allowSendCard = [dict objectForKey:@"allowSendCard"];
            user.chatRecordTimeOut = [NSString stringWithFormat:@"%@", [dict objectForKey:@"chatRecordTimeOut"]];
            user.offlineNoPushMsg = [[dict objectForKey:@"member"] objectForKey:@"offlineNoPushMsg"];
            user.talkTime = [dict objectForKey:@"talkTime"];
            user.allowInviteFriend = [dict objectForKey:@"allowInviteFriend"];
            user.allowUploadFile = [dict objectForKey:@"allowUploadFile"];
            user.allowConference = [dict objectForKey:@"allowConference"];
            user.allowSpeakCourse = [dict objectForKey:@"allowSpeakCourse"];
            user.category = [dict objectForKey:@"category"];
            user.createUserId = [dict objectForKey:@"userId"];
            
            if (![user haveTheUser]){
                [user insertRoom];
            }else {
                [user WH_updateUserNickname];
            }
            
        }
        
        [g_notify postNotificationName:kJinQianTaiTongBuQuanZuComplete_WHNotifaction object:nil];
    }
    
    
}

#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    if ([aDownload.action isEqualToString:wh_act_roomListHis]){
        [g_notify postNotificationName:kJinQianTaiTongBuQuanZuComplete_WHNotifaction object:nil];
    }
    return WH_hide_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    if ([aDownload.action isEqualToString:wh_act_roomListHis]){
        [g_notify postNotificationName:kJinQianTaiTongBuQuanZuComplete_WHNotifaction object:nil];
    }
    return WH_hide_error;
}

- (WH_JXGroup_WHViewController *)getGroupVC {
    return _groupVC;
}


- (void)sp_getUsersMostLiked {
//    //NSLog(@"Check your Network");
}
@end
