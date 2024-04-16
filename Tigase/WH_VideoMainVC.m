//
//  WH_VideoMainVC.m
//  Tigase
//
//  Created by 1111 on 2024/4/7.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_VideoMainVC.h"
#import "UIView+LK.h"
#import "XMGTitleButton.h"
#import "WH_Player_WHVC.h"
#import "AwemeListController.h"

@interface WH_VideoMainVC ()<UIScrollViewDelegate>
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
@property (strong, nonatomic) UIView *sliderView;
@property (strong, nonatomic) MASConstraint *sliderViewCenterX;
@property (strong, nonatomic) UIButton *searchBtn;
@property (nonatomic,assign) NSInteger index;
@property (strong, nonatomic)WH_Player_WHVC *mainVC;
@property (strong, nonatomic)WH_Player_WHVC *shortVC;
@property (strong, nonatomic)WH_Player_WHVC *videoVC;
//@property (strong, nonatomic)AwemeListController *shortVC;
//@property (strong, nonatomic)AwemeListController *videoVC;
//@property (strong, nonatomic)AwemeListController *mainVC;

@end

@implementation WH_VideoMainVC

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
  
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        [self titleClick:self.titlesView.subviews[self.index]];
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wh_heightHeader = JX_SCREEN_TOP;
    self.wh_heightFooter = 0;
    [self createHeadAndFoot];
    
    

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(JX_SCREEN_WIDTH - NAV_INSETS - 24-BTN_RANG_UP*2, JX_SCREEN_TOP - 44, 34, 34)];
    [btn setImage:[UIImage imageNamed:@"search_publicNumber"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.wh_tableHeader addSubview:btn];
    self.searchBtn = btn;

    [self setupNavBar];
    [self setupContentView];
    [self setupChildViewControllers];
    [self setupTitlesView];
    
}
- (void)searchAction:(UIButton *)btn{

}
- (void)setupContentView {
    
    float topHeight = (g_App.isShowRedPacket.intValue == 1 && !g_myself.isTestAccount)?50:10;
    
    topHeight = 8;
    
    //模拟多端登录
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = [UIColor clearColor];
//    contentView.frame = CGRectMake(0, JX_SCREEN_TOP + topHeight, self.view.bounds.size.width, self.view.bounds.size.height-JX_SCREEN_TOP - topHeight);
    contentView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentView.delegate = self;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.pagingEnabled = YES;
    contentView.bounces=NO;
    contentView.scrollEnabled = YES;
    
    NSArray *lastUrl = @[@"推荐",@"短剧",@"短视频"];
    contentView.contentSize = CGSizeMake(JX_SCREEN_WIDTH * lastUrl.count, 0);
    [self.view addSubview:contentView];
    self.contentView = contentView;
}
 
-(void)swipeAction:(UISwipeGestureRecognizer *)sender {
 
    if (sender.direction ==UISwipeGestureRecognizerDirectionLeft) {
        self.index ++;
        if(self.index > 2){
            self.index = 2;
        }
        
    }else if(sender.direction ==UISwipeGestureRecognizerDirectionRight){
        self.index --;
        if(self.index < 0){
            self.index = 0;
        }
    }
    [self titleClick:self.titlesView.subviews[self.index]];
    [self switchController:self.index];
}

 
 
- (void)setupTitlesView {
   
    UIView *titlesView = [[UIView alloc] init];
    titlesView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titlesView.frame = CGRectMake(0,  JX_SCREEN_TOP- 44, JX_SCREEN_WIDTH, 40);
    titlesView.userInteractionEnabled = YES;
    titlesView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titlesView];
//    [self.wh_tableHeader addSubview:titlesView];
//    self.wh_tableHeader.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.sliderView];
    self.titlesView = titlesView;

    NSArray *lastUrl = @[@"推荐",@"短剧",@"短视频"];
    for (int i=0;i<lastUrl.count; i++) {
        XMGTitleButton *button = [[XMGTitleButton alloc]init];
        [button setTitle:lastUrl[i] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = i;
        [titlesView addSubview:button];
        button.frame = CGRectMake(12+i*60, 0, 60, 36);
        if (i==0) {
            button.enabled = NO;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:22];
            _selectedButton = button;
            // 添加约束
            [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(button);
                make.width.mas_equalTo(8);
                make.height.mas_equalTo(4);
                make.top.equalTo(button.mas_bottom);
            }];
        }
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    }
        
}
- (void)titleClick:(UIButton *)button {
    self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    self.selectedButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    // 添加约束
    [self.sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(4);
        make.top.equalTo(button.mas_bottom);
        self.sliderViewCenterX = make.centerX.equalTo(button);
    }];

    [UIView animateWithDuration:0.25 animations:^{
        [self.sliderView layoutIfNeeded];
    }];
    
     int index = (int)[self.titlesView.subviews indexOfObject:button];
     [self.contentView setContentOffset:CGPointMake(index * self.contentView.frame.size.width, self.contentView.contentOffset.y) animated:YES];
    
    if (index == 0) {
        [self.shortVC.player.currentPlayerManager pause];
        [self.videoVC.player.currentPlayerManager pause];
        [self.mainVC.player.currentPlayerManager play];
        
//        [self.shortVC applicationEnterBackground];
//        [self.videoVC applicationEnterBackground];
//        [self.mainVC applicationBecomeActive];
    }else if (index == 1){
//        [self.shortVC applicationBecomeActive];
//        [self.videoVC applicationEnterBackground];
////        [self.mainVC.player.currentPlayerManager pause];
//        [self.mainVC applicationEnterBackground];
        
        [self.shortVC.player.currentPlayerManager play];
        [self.videoVC.player.currentPlayerManager pause];
        [self.mainVC.player.currentPlayerManager pause];
        
    }else{
        
        [self.shortVC.player.currentPlayerManager pause];
        [self.videoVC.player.currentPlayerManager play];
        [self.mainVC.player.currentPlayerManager pause];
        
//        [self.shortVC applicationBecomeActive];
//        [self.videoVC applicationEnterBackground];
//        [self.mainVC applicationEnterBackground];
//        [self.mainVC.player.currentPlayerManager pause];
    }
}

- (void)setupNavBar {
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupChildViewControllers {
    
//    _mainVC = [AwemeListController alloc];
//    _mainVC.type = 0;
//    _mainVC = [_mainVC init];
//    [self addChildViewController:_mainVC];
//
//    _shortVC = [AwemeListController alloc];
//    _shortVC.type = 1;
//    _shortVC = [_shortVC init];
//    [self addChildViewController:_shortVC];
//
//    _videoVC = [AwemeListController alloc];
//    _videoVC.type = 2;
//    _videoVC = [_videoVC init];
//    [self addChildViewController:_videoVC];
    __weak typeof (&*self)weakSelf = self;
    _videoVC = [WH_Player_WHVC alloc];
    _videoVC.requestFinishBlock = ^{
        [weakSelf titleClick:weakSelf.titlesView.subviews[weakSelf.index]];
    };
    _videoVC.type = 2;
    _videoVC = [_videoVC init];
    [self addChildViewController:_videoVC];
    
    _shortVC = [WH_Player_WHVC alloc];
    _shortVC.requestFinishBlock = ^{
        [weakSelf titleClick:weakSelf.titlesView.subviews[weakSelf.index]];
    };
    _shortVC.type = 1;
    _shortVC = [_shortVC init];
    [self addChildViewController:_shortVC];
    
    _mainVC = [WH_Player_WHVC alloc];
    _mainVC.type = 0;
    _mainVC = [_mainVC init];
    [self addChildViewController:_mainVC];
    
    
     
    _mainVC.view.xmg_y = 0;
    _mainVC.view.xmg_width = self.contentView.xmg_width;
    _mainVC.view.xmg_height = self.contentView.xmg_height;
    _mainVC.view.xmg_x = _mainVC.view.xmg_width * 0;
    [self.contentView addSubview:_mainVC.view];
    
    _shortVC.view.xmg_y = 0;
    _shortVC.view.xmg_width = self.contentView.xmg_width;
    _shortVC.view.xmg_height = self.contentView.xmg_height;
    _shortVC.view.xmg_x = _shortVC.view.xmg_width * 1;
    [self.contentView addSubview:_shortVC.view];
    
    _videoVC.view.xmg_y = 0;
    _videoVC.view.xmg_width = self.contentView.xmg_width;
    _videoVC.view.xmg_height = self.contentView.xmg_height;
    _videoVC.view.xmg_x = _videoVC.view.xmg_width * 2;
    [self.contentView addSubview:_videoVC.view];
        
//    [self performSelector:@selector(stopAction) withObject:nil afterDelay:1];
}
//-(void)stopAction{
//    [self.shortVC applicationEnterBackground];
//    [self.videoVC applicationEnterBackground];
//}

- (void)switchController:(NSInteger)index {
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

-(UIView *)sliderView{
    if(!_sliderView){
        _sliderView = [[UIView alloc] init];
        _sliderView.backgroundColor = HEXCOLOR(0x2BAF67);
        _sliderView.layer.masksToBounds = YES;
        _sliderView.hidden = YES;
        _sliderView.layer.cornerRadius = 2.0f;
    }
    return _sliderView;
}



@end
