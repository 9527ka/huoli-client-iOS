//
//  JXAVCallViewController.m
//  Tigase_imChatT
//
//  Created by p on 2017/12/26.
//  Copyright © 2019年 YanZhenKui. All rights reserved.
//

#import "JXAVCallViewController.h"
#import "WH_JXMediaObject.h"
//#import <ReplayKit/ReplayKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WH_JXSelectFriends_WHVC.h"



@interface JXAVCallViewController ()<UIAlertViewDelegate>

@property (nonatomic, assign) NSTimeInterval startTime;

@property (nonatomic, strong) UIView *localVideoView;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIButton *suspensionBtn;
@property (nonatomic, strong) UILabel *suspensionLabel;
@property (nonatomic, assign) CGRect subWindowFrame;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timerIndex;
@property (nonatomic, strong) UIButton *recorderBtn;
//@property (nonatomic, strong) RPPreviewViewController *previewVC;
@property (nonatomic, assign) BOOL isRecording;

@property (nonatomic, strong) NSTimer *pingTimer;
@property (nonatomic, assign) int pingTimerIndex;
@property (nonatomic, assign) int pingCount;
@property (nonatomic, assign) BOOL isOldVersion;
@property (nonatomic, strong) WH_JXSelectFriends_WHVC *selVC;

@end

@implementation JXAVCallViewController

// 控制器生命周期方法(view加载完成)
- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_pSelf) {
        return;
    }
    
    g_meeting.isMeeting = YES;

    _pSelf = self;
    [self createSuspensionView];
    //NSLog(@"g_config.jitsiServer:%@" ,g_config.jitsiServer);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self creatLocalVideoView];
        JitsiMeetView *view = (JitsiMeetView *)self.view;
        view.delegate = self;
//        view.welcomePageEnabled = NO;
        //    [view loadURL:nil];
        
//        NSString *url = [NSString stringWithFormat:@"https://www.pinba.co/%@",self.roomNum];
        __block BOOL audioMuted = NO;
        __block BOOL videoMuted = NO;
        NSString *serverStr;
        if (self.isGroup) {
            serverStr = g_config.jitsiServer;
        }else {
            if ([g_config.isOpenCluster integerValue] == 1 && [self.meetUrl length] > 0) {
                serverStr = self.meetUrl;
            }else {
                serverStr = g_config.jitsiServer;
            }
        }
        NSString *url = [NSString stringWithFormat:@"%@%@",serverStr,self.roomNum];
        if (self.isAudio && self.isGroup) {
            url = [NSString stringWithFormat:@"%@audio%@",serverStr,self.roomNum];
        }
        if (self.isAudio) {
            videoMuted = YES;
        }
        if (!_toUserName) {
            _toUserName = self.roomNum;
        }
        __block NSString *avatarURL = [self getMyHeadUrl];
//        if (avatarURL) {
//            view.avatarURL = avatarURL;
//        }
//        [view loadURLObject:@{
//                              @"config": @{
//                                      @"startWithAudioMuted": [NSNumber numberWithBool:audioMuted],
//                                      @"startWithVideoMuted": [NSNumber numberWithBool:videoMuted]
//                                      },
//                              @"nickName" : _toUserName,
//                              @"isVoiceVideoKuangJia" : g_App.uuid ? @NO : @YES,
//                              @"url": url
//                              /*@"url" : @"https://192.168.0.47/123"*/
//
//                              }];
        
        if (self.roomNum == nil) {
            //NSLog(@"Room is nul!");

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self actionQuit];
            });

            return;
        }
        
        __weak typeof(self) weakSelf = self;
        JitsiMeetConferenceOptions *options
            = [JitsiMeetConferenceOptions fromBuilder:^(JitsiMeetConferenceOptionsBuilder *builder) {
//                builder.serverURL = [NSURL URLWithString:url];
//                builder.welcomePageEnabled = NO;
                builder.room = weakSelf.roomNum;
                //NSLog(@"builder.room=%@",weakSelf.roomNum);
                JitsiMeetUserInfo *info = [[JitsiMeetUserInfo alloc] initWithDisplayName:weakSelf.toUserName andEmail:@"" andAvatar:[NSURL URLWithString:avatarURL]];
                builder.userInfo = info;
                builder.audioMuted = audioMuted;
                builder.videoMuted = videoMuted;
                
                
        }];
        [view join:options];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 38, 38)];
        [btn setImage:[UIImage imageNamed:@"callHide"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(hideAudioView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        _recorderBtn = [[UIButton alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(btn.frame) + 20, 30, 30)];
//        [_recorderBtn setTitle:Localized(@"JX_Recording") forState:UIControlStateNormal];
//        [_recorderBtn setTitle:Localized(@"STOP_IT") forState:UIControlStateSelected];
        [_recorderBtn setImage:[UIImage imageNamed:@"audio_invite"] forState:UIControlStateNormal];
//        [_recorderBtn setImage:[UIImage imageNamed:@"stoped"] forState:UIControlStateSelected];
//        [_recorderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 22, 0)];
//        [_recorderBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, -60, 0, 0)];
        [_recorderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_recorderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_recorderBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        _recorderBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_recorderBtn addTarget:self action:@selector(onInvite) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_recorderBtn];
        if (self.isGroup) {
            _recorderBtn.hidden = NO;
        }else {
            _recorderBtn.hidden = YES;
        }
    });
    
    [g_notify addObserver:self selector:@selector(newMsgCome:) name:kXMPPNewMsg_WHNotifaction object:nil];
    [g_notify addObserver:self selector:@selector(callEndNotification:) name:kCallEnd_WHNotification object:nil];
    
    _startTime = 0;
    [self networkStatusChange];
    self.isOldVersion = YES;
    if (!self.isGroup) {
        self.pingCount = 0;
        [self sendPing];
        self.pingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pingTimerAction:) userInfo:nil repeats:YES];
    }
}

- (NSString *)getMyHeadUrl {
    
    NSString* s;
    if([MY_USER_ID isKindOfClass:[NSNumber class]])
        s = [(NSNumber*)MY_USER_ID stringValue];
    else
        s = MY_USER_ID;
    if([s length]<=0)
        return nil;

    NSString* dir  = [NSString stringWithFormat:@"%d",[s intValue] % 10000];
    NSString* url  = [NSString stringWithFormat:@"%@avatar/o/%@/%@.jpg",g_config.downloadAvatarUrl,dir,s];
    
    return url;
}

- (void)pingTimerAction:(NSTimer *)timer {
    
    self.pingTimerIndex ++;
    if (self.pingTimerIndex >= 3) {
        self.pingTimerIndex = 0;
        [self sendPing];
        if (self.pingCount >= 0) {
            self.pingCount ++;
        }else {
            [timer invalidate];
            timer = nil;
            return;
        }
        //NSLog(@"timerPingCount = %d", self.pingCount);
        if (self.pingCount >= 10) {
            self.pingCount = -1;
            [timer invalidate];
            timer = nil;
            if (self.isOldVersion) {
                return;
            }
            if (g_xmpp.isLogined == login_status_yes) {

                if (!self.isGroup) {
                    //        int n = [[NSDate date] timeIntervalSince1970]-_startTime;
                    int type = kWCMessageTypeVideoChatEnd;
                    if (self.isAudio) {
                        type = kWCMessageTypeAudioChatEnd;
                    }
                    [g_meeting sendEnd:type toUserId:self.toUserId toUserName:self.toUserName timeLen:self.timerIndex];
                }
                [self actionQuit];
                [g_App showAlert:Localized(@"JX_AVAbnormalDisconnection") delegate:self tag:2457 onlyConfirm:YES];
            }else {
                [self actionQuit];
            }
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    dispatch_async(dispatch_get_main_queue(), ^{
//        if (!self.isGroup) {
//            //        int n = [[NSDate date] timeIntervalSince1970]-_startTime;
//            int type = kWCMessageTypeVideoChatEnd;
//            if (self.isAudio) {
//                type = kWCMessageTypeAudioChatEnd;
//            }
//            [g_meeting sendEnd:type toUserId:self.toUserId toUserName:self.toUserName timeLen:self.timerIndex];
//        }
        [self actionQuit];
    });
}

- (void)sendPing {
    WH_JXMessageObject *msg=[[WH_JXMessageObject alloc]init];
    msg.timeSend     = [NSDate date];
    msg.fromUserId   = MY_USER_ID;
    msg.fromUserName = MY_USER_NAME;
    msg.toUserName = self.toUserName;
    msg.toUserId     = self.toUserId;
    msg.isGroup = NO;
    msg.type         = [NSNumber numberWithInt:kWCMessageTypeAVPing];
    msg.isSend       = [NSNumber numberWithInt:transfer_status_ing];
    msg.isRead       = [NSNumber numberWithBool:NO];
    [g_xmpp sendMessage:msg roomName:nil];//发送消息
    
}

-(void)onInvite{
    
    WH_JXUserObject *user = [[WH_JXUserObject sharedUserInstance] getUserById:self.roomNum];
    
    NSDictionary * groupDict = [user toDictionary];
    WH_RoomData * roomdata = [[WH_RoomData alloc] init];
    [roomdata WH_getDataFromDict:groupDict];
    
    NSMutableSet* p = [[NSMutableSet alloc]init];
    
    _selVC = [WH_JXSelectFriends_WHVC alloc];
    _selVC.isAddWindow = YES;
    _selVC.isNewRoom = NO;
    _selVC.isShowMySelf = NO;
    if (self.isGroup && [self.roomNum isEqualToString:MY_USER_ID]) {
        _selVC.type = JXSelectFriendTypeSelFriends;
    } else {
        _selVC.type = JXSelectFriendTypeSelMembers;
    }
    _selVC.room = roomdata;
    _selVC.existSet = p;
    _selVC.delegate = self;
    _selVC.didSelect = @selector(meetingAddMember:);
    _selVC = [_selVC init];
    [g_window addSubview:_selVC.view];
//    [g_navigation pushViewController:vc animated:YES];
}

-(void)meetingAddMember:(WH_JXSelectFriends_WHVC*)vc{
    int type;
    if (self.isAudio) {
        type = kWCMessageTypeAudioMeetingInvite;
    }else {
        type = kWCMessageTypeVideoMeetingInvite;
    }
    for(NSNumber* n in vc.set){
        if (self.isGroup && [self.roomNum isEqualToString:MY_USER_ID]) {
            
            WH_JXUserObject *user;
            if (vc.seekTextField.text.length > 0) {
                user = vc.searchArray[[n intValue] % 1000];
            }else{
                user = [[vc.letterResultArr objectAtIndex:[n intValue] / 1000] objectAtIndex:[n intValue] % 1000];
            }
            NSString* s = [NSString stringWithFormat:@"%@",user.userId];
            [g_meeting sendMeetingInvite:s toUserName:user.userNickname roomJid:self.roomNum callId:@"0" type:type];
        }else {
            memberData *user;
            if (vc.seekTextField.text.length > 0) {
                user = vc.searchArray[[n intValue] % 1000];
            }else{
                user = [[vc.letterResultArr objectAtIndex:[n intValue] / 1000] objectAtIndex:[n intValue] % 1000];
            }
            NSString* s = [NSString stringWithFormat:@"%ld",user.userId];
            [g_meeting sendMeetingInvite:s toUserName:user.userName roomJid:self.roomNum callId:@"0" type:type];
        }
    }
}

//- (void)recorderBtnAction:(UIButton *)btn {
//
//    if (!btn.selected) {
//        self.isRecording = NO;
//        //如果还没有开始录制，判断系统是否支持
//        if ([RPScreenRecorder sharedRecorder].isAvailable && [[UIDevice currentDevice].systemVersion floatValue] > 9.0) {
//            //如果支持，就使用下面的方法可以启动录制回放
//            [btn setTitle:Localized(@"JX_Opening") forState:UIControlStateDisabled];
//            btn.enabled = NO;
//            [self startRecord];
//
//        } else {
//            [JXMyTools showTipView:Localized(@"JX_NotScreenRecording")];
//        }
//    }else {
//        [btn setTitle:Localized(@"JX_Stopping") forState:UIControlStateDisabled];
//        btn.enabled = NO;
//        [self stopRecord];
//    }
//}

//- (void)startRecord {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (!self.isRecording) {
//
//            [self startRecord];
//        }
//    });
//    //NSLog(@"recorder -- OK");
//    [[RPScreenRecorder sharedRecorder] startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
//        //NSLog(@"%@", error);
//        if (!error) {
//            //NSLog(@"recorder -- 已开启");
//            self.isRecording = YES;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                _recorderBtn.enabled = YES;
//                _recorderBtn.selected = YES;
//            });
//        }
//        //处理发生的错误，如设用户权限原因无法开始录制等
//    }];
//}

//- (void)stopRecord {
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        //NSLog(@"stopRecord");
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (self.isRecording) {
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    _recorderBtn.enabled = YES;
//                    _recorderBtn.selected = NO;
//                });
//
//                [JXMyTools showTipView:@"录屏失败，请重新录制"];
//
////                [self stopRecord];
//            }
//        });
//
//        //停止录制回放，并显示回放的预览，在预览中用户可以选择保存视频到相册中、放弃、或者分享出去
//        [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
//            _previewVC = previewViewController;
//
//            self.isRecording = NO;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                _recorderBtn.enabled = YES;
//                _recorderBtn.selected = NO;
//            });
//
//            //NSLog(@"recorder -- stop");
//            if (error) {
//                //NSLog(@"recorder -- errro:%@", error);
//                //处理发生的错误，如磁盘空间不足而停止等
//            }else {
//                NSURL *url = [_previewVC valueForKey:@"movieURL"];
//
//
////                [[NSFileManager defaultManager] copyItemAtURL:url toURL:[NSURL URLWithString:str] error:nil];
//////                [[NSFileManager defaultManager] moveItemAtURL:url toURL:[NSURL URLWithString:str] error:nil];
////
////                NSString *str = [FileInfo getUUIDFileName:@"mp4"];
////                WH_JXMediaObject* p = [[WH_JXMediaObject alloc]init];
////                p.userId = g_myself.userId;
////                p.fileName = str;
////                p.isVideo = [NSNumber numberWithBool:YES];
////                //                    p.timeLen = [NSNumber numberWithInteger:timeLen];
////                [p insert];
//
//                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//                [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
//                    
//                    if (error) {
//                        [JXMyTools showTipView:Localized(@"JX_SaveFiled")];
//                    }else {
//                        [JXMyTools showTipView:Localized(@"JX_SaveSuessed")];
//                    }
//                }];
//
////                if (_previewVC) {
////                    //设置预览页面到代理
////                    _previewVC.previewControllerDelegate = self;
////
////                    [g_window addSubview:_previewVC.view];
////                    [g_navigation.subViews.lastObject presentViewController:previewViewController animated:YES completion:nil];
////                }
//
//            }
//
//        }];
//    });
//}

//- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
//    [_previewVC dismissViewControllerAnimated:YES completion:nil];
//}

- (void)creatLocalVideoView {
    
    self.localVideoView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.localVideoView.backgroundColor = HEXCOLOR(0x1F2025);
    [g_window addSubview:self.localVideoView];
    
    // 获取需要的设备
    AVCaptureDevice *device =  [self cameraWithPosition:AVCaptureDevicePositionFront];
    if (self.isAudio || !device) {
        
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH / 2 - 50, JX_SCREEN_HEIGHT / 2 - 110, 100, 100)];
        [headImage headRadiusWithAngle:headImage.frame.size.width];
        headImage.image = [UIImage imageNamed:@"appLogo"];
        [self.localVideoView addSubview:headImage];
        
    }else {
        NSError *error = nil;
        
        // 初始化会话
        _session = [[AVCaptureSession alloc] init];
        
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                            error:&error];
        [_session addInput:input];
        [_session startRunning];
        
        //预览层的生成，实时获取摄像头数据
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
        self.previewLayer.frame = [UIScreen mainScreen].bounds;
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.localVideoView.layer addSublayer:self.previewLayer];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, JX_SCREEN_HEIGHT / 2, JX_SCREEN_WIDTH, 20)];
    label.font = sysFontWithSize(17);
    label.text = Localized(@"JX_Connection");
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.localVideoView addSubview:label];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}

- (void)createSuspensionView {
    _suspensionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 100)];
    _suspensionBtn.backgroundColor = [UIColor whiteColor];
    _suspensionBtn.layer.cornerRadius = 2.0;
    _suspensionBtn.layer.masksToBounds = YES;
    _suspensionBtn.layer.borderWidth = 0.5;
    _suspensionBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    [_suspensionBtn addTarget:self action:@selector(showAudioView) forControlEvents:UIControlEventTouchUpInside];
    g_subWindow.frame = CGRectMake(JX_SCREEN_WIDTH - 80 - 10, 50, _suspensionBtn.frame.size.width, _suspensionBtn.frame.size.height);
    g_subWindow.backgroundColor = [UIColor cyanColor];
    [g_subWindow addSubview:_suspensionBtn];
    g_subWindow.hidden = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [g_subWindow addGestureRecognizer:pan];
    
    UIImageView *suspensionImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    suspensionImage.image = [UIImage imageNamed:@"callShow"];
    suspensionImage.center = CGPointMake(_suspensionBtn.frame.size.width / 2, _suspensionBtn.frame.size.height / 2 - 10);
    [_suspensionBtn addSubview:suspensionImage];
    
    _suspensionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(suspensionImage.frame) + 5, _suspensionBtn.frame.size.width, 20)];
    _suspensionLabel.textColor = THEMECOLOR;
    _suspensionLabel.textAlignment = NSTextAlignmentCenter;
    _suspensionLabel.font = sysFontWithSize(13);
    _suspensionLabel.text = @"00:00";
    [_suspensionBtn addSubview:_suspensionLabel];
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.subWindowFrame = g_subWindow.frame;
    }
    CGPoint offset = [pan translationInView:g_App.window];
    CGPoint offset1 = [pan translationInView:g_subWindow];
    //NSLog(@"pan - offset = %@, offset1 = %@", NSStringFromCGPoint(offset), NSStringFromCGPoint(offset1));
    
    CGRect frame = self.subWindowFrame;
    frame.origin.x += offset.x;
    frame.origin.y += offset.y;
    g_subWindow.frame = frame;
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        if (frame.origin.x <= JX_SCREEN_WIDTH / 2) {
            frame.origin.x = 10;
        }else {
            frame.origin.x = JX_SCREEN_WIDTH - frame.size.width - 10;
        }
        if (frame.origin.y < 0) {
            frame.origin.y = 10;
        }
        if ((frame.origin.y + frame.size.height) > JX_SCREEN_HEIGHT) {
            frame.origin.y = JX_SCREEN_HEIGHT - frame.size.height - 10;
        }
        [UIView animateWithDuration:0.5 animations:^{
            
            g_subWindow.frame = frame;
        }];
    }
}
- (void)callTimerAction:(NSTimer *)timer {
    self.timerIndex ++;
    NSString *str = [NSString stringWithFormat:@"%.2d:%.2d", self.timerIndex / 60,self.timerIndex % 60];
    self.suspensionLabel.text = str;
}

- (void)hideAudioView {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(JX_SCREEN_WIDTH, 0, self.view.frame.size.width, 0);
    } completion:^(BOOL finished) {
        g_subWindow.hidden = NO;
        self.view.hidden = YES;
    }];
}

- (void)showAudioView {
    g_subWindow.hidden = YES;
    self.view.hidden = NO;
    self.view.frame = CGRectMake(JX_SCREEN_WIDTH, 0, self.view.frame.size.width, 0);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}

-(void)newMsgCome:(NSNotification *)notifacation{
    
    WH_JXMessageObject *msg = (WH_JXMessageObject *)notifacation.object;
    if ([msg.type intValue] == kWCMessageTypeVideoChatEnd || [msg.type intValue] == kWCMessageTypeAudioChatEnd || [msg.type intValue] == kWCMessageTypeAudioChatCancel || [msg.type intValue] == kWCMessageTypeVideoChatCancel) {
        if ([msg.fromUserId isEqualToString:self.toUserId]) {
//            [self actionQuit];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                JitsiMeetView *view = (JitsiMeetView *)self.view;
                [view leave];
                [self actionQuit];
            });
            
        }
    }
    
    if ([msg.type intValue] == kWCMessageTypeAVPing) {
        if ([msg.fromUserId isEqualToString:self.toUserId]) {
            self.isOldVersion = NO;
            self.pingCount = 0;
            //NSLog(@"timerPingCountNew = %d",self.pingCount);
        }
    }
}

// 监听网络状态
- (void)networkStatusChange {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    __weak JXAVCallViewController *weakSelf = self;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [weakSelf actionQuit];
        }
    }];
}

-(void)callEndNotification:(NSNotification *)notifacation{
    if (self.timerIndex == 5) {
        return;
    }
    if (!self.isGroup) {
        //        int n = [[NSDate date] timeIntervalSince1970]-_startTime;
        int type = kWCMessageTypeVideoChatEnd;
        if (self.isAudio) {
            type = kWCMessageTypeAudioChatEnd;
        }
        [g_meeting sendEnd:type toUserId:self.toUserId toUserName:self.toUserName timeLen:self.timerIndex];
    }
    [self actionQuit];
}

void _onJitsiMeetViewDelegateEvent(NSString *name, NSDictionary *data) {
    NSLog(
          @"[%s:%d] JitsiMeetViewDelegate %@ %@",
          __FILE__, __LINE__, name, data);
}

- (void)_onJitsiMeetViewDelegateEvent:(NSString *)name
                             withData:(NSDictionary *)data {
    NSLog(
          @"[%s:%d] JitsiMeetViewDelegate %@ %@",
          __FILE__, __LINE__, name, data);
    
    NSAssert(
             [NSThread isMainThread],
             @"JitsiMeetViewDelegate %@ method invoked on a non-main thread",
             name);
}

- (void)conferenceFailed:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_FAILED", data);
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        _startTime = [[NSDate date] timeIntervalSince1970];
        self.session = nil;
        self.localVideoView.hidden = YES;
        [self.previewLayer removeFromSuperlayer];
        [self.localVideoView removeFromSuperview];
        self.localVideoView = nil;
    });
}

- (void)conferenceJoined:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_JOINED", data);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!g_meeting.isMeeting) {
            [self actionQuit];
            return;
        }
        
        _startTime = [[NSDate date] timeIntervalSince1970];
        
        self.timerIndex = 0;
        // 通话计时
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(callTimerAction:) userInfo:nil repeats:YES];
        self.session = nil;
        self.localVideoView.hidden = YES;
        [self.previewLayer removeFromSuperlayer];
        [self.localVideoView removeFromSuperview];
        self.localVideoView = nil;
    });
}

- (void)conferenceLeft:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_LEFT", data);
    
    
}

- (void)conferenceWillJoin:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_WILL_JOIN", data);
}

- (void)conferenceTerminated:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_WILL_LEAVE", data);
    
    [self _onJitsiMeetViewDelegateEvent:@"CONFERENCE_JOINED" withData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.pingTimer invalidate];
        self.pingTimer = nil;
        
        if (!self.isGroup) {
//        int n = [[NSDate date] timeIntervalSince1970]-_startTime;
        int type = kWCMessageTypeVideoChatEnd;
        if (self.isAudio) {
            type = kWCMessageTypeAudioChatEnd;
        }
            //不能退出视频会议
        [g_meeting sendEnd:type toUserId:self.toUserId toUserName:self.toUserName timeLen:self.timerIndex];
        }
        [self actionQuit];
    });
}

- (void)loadConfigError:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"LOAD_CONFIG_ERROR", data);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionQuit {
    
//    if (_recorderBtn.selected) {
//        [self stopRecord];
//    }
    
    [self.pingTimer invalidate];
    self.pingTimer = nil;
    
    [g_App endCall];
    [self.timer invalidate];
    self.timer = nil;
    g_meeting.isMeeting = NO;
//    [self dismissViewControllerAnimated:YES completion:nil];
    [g_notify removeObserver:self];
    [g_subWindow removeFromSuperview];
    g_subWindow = nil;
    [self.view removeFromSuperview];
    self.view = nil;
    _pSelf = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        g_meeting.isMeeting = NO;
        [UIApplication sharedApplication].statusBarHidden = NO;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    });
}

- (void)dealloc {
    //NSLog(@"%@ -- dealloc",NSStringFromClass([self class]));
    [g_notify removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
