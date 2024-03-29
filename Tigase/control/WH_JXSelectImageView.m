//
//  WH_JXSelectImageView.m
//
//  Created by Reese on 13-8-22.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "WH_JXSelectImageView.h"

#define INSET 24//间距
#define SELECTIMAGE_WIDTH 50//间距
//动态间距
#define DWIDTH (JX_SCREEN_WIDTH - 200)/5.0
//动态间距
#define DHEIGHT (218 - 110)/3.0


@implementation WH_JXSelectImageView 
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //写死面板的高度
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.wh_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.wh_scrollView.delegate = self;
        self.wh_scrollView.showsVerticalScrollIndicator = NO;
        self.wh_scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.wh_scrollView];

        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0,0,JX_SCREEN_WIDTH * 2,0.5)];
        line.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.wh_scrollView addSubview:line];
        
        int h = SELECTIMAGE_WIDTH+15;
        int inset = DWIDTH;
        int margeY = (frame.size.height - (THE_DEVICE_HAVE_HEAD ? 75 : 40) - (h * 2)) / 2;
        
        int n = 0;
        int m = 1;
        int X = inset;
        int Y = margeY;
        
        //
        UIView *button;
        if(self.wh_isGroup && self.wh_isGroupDiamound && [g_App.isShowRedPacket intValue] == 1 && !g_myself.isTestAccount){
            // 钻石
            button = [self WH_create_WHButtonWithImage:@"diamond_btn" highlight:@"diamond_btn" target:delegate selector:self.onDiamond title:@"发钻石"];
            button.frame = CGRectMake(X, Y, SELECTIMAGE_WIDTH, h);
        }else if ([g_App.isShowRedPacket intValue] == 1 && !self.wh_isGroupMessages && !self.wh_isDevice && !g_myself.isTestAccount) {
            // 发红包
            
            button = [self WH_create_WHButtonWithImage:@"WH_awarda_a_bonus_normal" highlight:@"WH_awarda_a_bonus_normal" target:delegate selector:self.wh_onGift title:Localized(@"JX_SendGift")];
            button.frame = CGRectMake(X, Y, SELECTIMAGE_WIDTH, h);
            
            if (!self.wh_isGroup) {
                // 转账
                n = (n + 1) >= 4 ? 0 : n + 1;
                m += 1;
                X = m >8 ? SELECTIMAGE_WIDTH *n + (n+1)*inset+JX_SCREEN_WIDTH : SELECTIMAGE_WIDTH *n + (n+1)*inset;
                Y = m > 4 && m <=8 ? h+margeY*2 : margeY;
                button = [self WH_create_WHButtonWithImage:@"WH_tool_transfer_button_bg" highlight:@"WH_tool_transfer_button_bg" target:delegate selector:self.wh_onTransfer title:Localized(@"JX_Transfer")];
                button.frame = CGRectMake(X, Y, SELECTIMAGE_WIDTH, h);
            }
        }
        
        n = (n + 1) >= 4 ? 0 : n + 1;
        m += 1;
        X = m >8 ? SELECTIMAGE_WIDTH *n + (n+1)*inset+JX_SCREEN_WIDTH : SELECTIMAGE_WIDTH *n + (n+1)*inset;
        Y = m > 4 && m <=8 ? h+margeY*2 : margeY;
        
        // 照片
        button = [self WH_create_WHButtonWithImage:@"WH_photo_button_normal" highlight:@"WH_photo_button_normal" target:delegate selector:self.wh_onImage title:Localized(@"JX_Photo")];
        button.frame = CGRectMake(X, Y, SELECTIMAGE_WIDTH, h);
        
        // 拍摄
        n = (n + 1) >= 4 ? 0 : n + 1;
        m += 1;
        X = m >8 ? SELECTIMAGE_WIDTH *n + (n+1)*inset+JX_SCREEN_WIDTH : SELECTIMAGE_WIDTH *n + (n+1)*inset;
        Y = m > 4 && m <=8 ? h+margeY*2 : margeY;
        button = [self WH_create_WHButtonWithImage:@"WH_pickup_button_normal" highlight:@"WH_pickup_button_normal" target:delegate selector:self.onCamera title:Localized(@"JX_PhotoAndVideo")];
        button.frame = CGRectMake(X, Y, SELECTIMAGE_WIDTH, h);

#if TAR_IM
#ifdef Meeting_Version
        //PACKGE_IS_SHOW_VIDEOMEETING
        if ([g_config.isAudioStatus integerValue] == 1 ) {
            if (!self.wh_isGroupMessages && !self.wh_isDevice) {
                // 语音通话 or 视频会议
                n = (n + 1) >= 4 ? 0 : n + 1;
                m += 1;
                X = m >8 ? SELECTIMAGE_WIDTH *n + (n+1)*inset+JX_SCREEN_WIDTH : SELECTIMAGE_WIDTH *n + (n+1)*inset;
                Y = m > 4 && m <=8 ? h+margeY*2 : margeY;
                
                NSString *str;
                if (_wh_isGroup) {
                    str = Localized(@"WaHu_JXSetting_WaHuVC_VideoMeeting");
                }else {
                    str = Localized(@"JX_VideoChat");
                }
                button = [self WH_create_WHButtonWithImage:@"WH_audio_button_normal" highlight:@"WH_audio_button_normal" target:delegate selector:self.wh_onAudioChat title:str];
                button.frame = CGRectMake(X, Y, SELECTIMAGE_WIDTH, h);
            }
        }
#endif
#endif
        // 位置
        if ([g_config.isOpenPositionService intValue] == 0) {
            n = (n + 1) >= 4 ? 0 : n + 1;
            m += 1;
            X = m >8 ? SELECTIMAGE_WIDTH *n + (n+1)*inset+JX_SCREEN_WIDTH : SELECTIMAGE_WIDTH *n + (n+1)*inset;
            Y = m > 4 && m <=8 ? h+margeY*2 : margeY;
            button = [self WH_create_WHButtonWithImage:@"WH_map_button_normal" highlight:@"WH_map_button_normal" target:delegate selector:self.onLocation title:Localized(@"JX_Location")];
            button.frame = CGRectMake(X, Y, SELECTIMAGE_WIDTH, h);
        }
       
            
        if (!self.wh_isGroup) {
            // 戳一戳
            n = (n + 1) >= 4 ? 0 : n + 1;
            m += 1;
            X = m >8 ? SELECTIMAGE_WIDTH *n + (n+1)*inset+JX_SCREEN_WIDTH : SELECTIMAGE_WIDTH *n + (n+1)*inset;
            Y = m > 4 && m <=8 ? h+margeY*2 : margeY;
            button = [self WH_create_WHButtonWithImage:@"WH_tool_shake" highlight:@"WH_tool_shake" target:delegate selector:self.onShake title:Localized(@"JX_Shake")];
            button.frame = CGRectMake(X, Y, SELECTIMAGE_WIDTH, h);
        }
        // 名片
        n = (n + 1) >= 4 ? 0 : n + 1;
        m += 1;
        X = m >8 ? SELECTIMAGE_WIDTH *n + (n+1)*inset+JX_SCREEN_WIDTH : SELECTIMAGE_WIDTH *n + (n+1)*inset;
        Y = m > 4 && m <=8 ? h+margeY*2 : margeY;
        button = [self WH_create_WHButtonWithImage:@"WH_card_button_normal" highlight:@"WH_card_button_normal" target:delegate selector:self.onCard title:Localized(@"JX_Card")];
        button.frame = CGRectMake(X, Y, SELECTIMAGE_WIDTH, h);

        // 收藏
        n = (n + 1) >= 4 ? 0 : n + 1;
        m += 1;
        X = m >8 ? SELECTIMAGE_WIDTH *n + (n+1)*inset+JX_SCREEN_WIDTH : SELECTIMAGE_WIDTH *n + (n+1)*inset;
        Y = m > 4 && m <=8 ? h+margeY*2 : margeY;
        button = [self WH_create_WHButtonWithImage:@"WH_collection_button_normal" highlight:@"WH_collection_button_normal" target:delegate selector:self.onCollection title:Localized(@"JX_Collection")];
        button.frame = CGRectMake(X, Y, SELECTIMAGE_WIDTH, h);
            
        if (IS_SHOW_TWOWAYWITHDRAWAL && self.wh_isGroup) {
            //显示双向撤回
            
            n = (n + 1) >= 4 ? 0 : n + 1;
            m += 1;
            X = m >8 ? SELECTIMAGE_WIDTH *n + (n+1)*inset+JX_SCREEN_WIDTH : SELECTIMAGE_WIDTH *n + (n+1)*inset;
            Y = m > 4 && m <=8 ? h+margeY*2 : margeY;
            button = [self WH_create_WHButtonWithImage:@"WH_TwoWayWithdrawal" highlight:@"WH_TwoWayWithdrawal" target:delegate selector:self.onTwoWayWithdrawal title:Localized(@"JX_DelMsgTwoSides")];
            button.frame = CGRectMake(X, Y, SELECTIMAGE_WIDTH, h);
        }
            
        // 文件
        n = (n + 1) >= 4 ? 0 : n + 1;
        m += 1;
        X = m >8 ? SELECTIMAGE_WIDTH *n + (n+1)*inset+JX_SCREEN_WIDTH : SELECTIMAGE_WIDTH *n + (n+1)*inset;
        Y = m > 4 && m <=8 ? h+margeY*2 : margeY;
        button = [self WH_create_WHButtonWithImage:@"WH_file_button_normal" highlight:@"WH_file_button_normal" target:delegate selector:self.onFile title:Localized(@"JX_File")];
        button.frame = CGRectMake(X, Y, SELECTIMAGE_WIDTH, h);
        
        // 联系人
        n = (n + 1) >= 4 ? 0 : n + 1;
        m += 1;
        X = m >8 ? SELECTIMAGE_WIDTH *n + (n+1)*inset+JX_SCREEN_WIDTH : SELECTIMAGE_WIDTH *n + (n+1)*inset;
        Y = m > 4 && m <=8 ? h+margeY*2 : margeY;
        button = [self WH_create_WHButtonWithImage:@"WH_ab_button_normal" highlight:@"WH_ab_button_normal" target:delegate selector:self.onAddressBook title:Localized(@"JX_SelectImageContact")];
        button.frame = CGRectMake(X, Y, SELECTIMAGE_WIDTH, h);
        
        if(self.wh_isGroup && [g_App.isShowRedPacket intValue] == 1 && !g_myself.isTestAccount && !self.wh_isGroupDiamound){
            // 急速红包
            n = (n + 1) >= 4 ? 0 : n + 1;
            m += 1;
            X = m >8 ? SELECTIMAGE_WIDTH *n + (n+1)*inset+JX_SCREEN_WIDTH : SELECTIMAGE_WIDTH *n + (n+1)*inset;
            Y = m > 4 && m <=8 ? h+margeY*2 : margeY;//WH_awarda_a_bonus_normal
            button = [self WH_create_WHButtonWithImage:@"WH_fast_a_bonus_use" highlight:@"WH_fast_a_bonus_use" target:delegate selector:self.onFastRedPacket title:@"极速红包"];//WH_fast_a_bonus_normal
            button.frame = CGRectMake(X, Y, SELECTIMAGE_WIDTH, h);
        }

        if (m > 8) {
            self.wh_scrollView.contentSize = CGSizeMake(JX_SCREEN_WIDTH * 2, 0);
            self.wh_scrollView.pagingEnabled = YES;
            
            
            _wh_pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, self.frame.size.height-(THE_DEVICE_HAVE_HEAD ? 65 : 30), JX_SCREEN_WIDTH-200, 30)];
            _wh_pageControl.numberOfPages  = 2;
            _wh_pageControl.pageIndicatorTintColor = HEXCOLOR(0xE7E7E7);
            _wh_pageControl.currentPageIndicatorTintColor = HEXCOLOR(0x8C9AB8);
            [_wh_pageControl addTarget:self action:@selector(actionPage) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_wh_pageControl];
        }
        
        
    }
    return self;
}

- (void)actionPage {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x/320;
    int mod   = fmod(scrollView.contentOffset.x,320);
    if( mod >= 160)
        index++;
    _wh_pageControl.currentPage = index;
}

-(void)dealloc
{
//    [super dealloc];
    
}

- (UIView *)WH_create_WHButtonWithImage:(NSString *)normalImage
                          highlight:(NSString *)clickIamge
                             target:(id)target
                           selector:(SEL)selector
                              title:(NSString*)title
{
    UIView* v = [[UIView alloc]init];
    
    UIButton* btn = [UIFactory WH_create_WHButtonWithImage:normalImage highlight:clickIamge target:target selector:selector];
    btn.frame = CGRectMake(0, 0, SELECTIMAGE_WIDTH, SELECTIMAGE_WIDTH);
    [v addSubview:btn];
    
    UILabel* p = [[UILabel alloc]initWithFrame:CGRectMake(-15, SELECTIMAGE_WIDTH+5, SELECTIMAGE_WIDTH+30, 15)];
    p.text = title;
    p.font = sysFontWithSize(12);
    p.textAlignment = NSTextAlignmentCenter;
    p.textColor = HEXCOLOR(0x969696);
    [v addSubview:p];
//    [p release];
    
    [self.wh_scrollView addSubview:v];
//    [v release];
    return v;
}

@end
