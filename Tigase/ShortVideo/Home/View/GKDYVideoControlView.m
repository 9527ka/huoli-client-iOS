//
//  GKDYVideoControlView.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYVideoControlView.h"
#import "WH_GKSliderView.h"
#import "ReplyCell.h"
#import "WH_GKDYVideoModel.h"
#import "JXTextView.h"
#import "WH_JXRelay_WHVC.h"
#import "WH_JXUserInfo_WHVC.h"
#import "WH_JXReportUser_WHVC.h"
#import "NSString+ContainStr.h"
#import "JX_WHNoDataView.h"
#import "WH_PopularVideoVC.h"

#define commentY 200

@interface GKDYVideoItemButton : UIButton <JXReportUserDelegate>

@end

@implementation GKDYVideoItemButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat imgW = self.imageView.frame.size.width;
    CGFloat imgH = self.imageView.frame.size.height;
    
    self.imageView.frame = CGRectMake((width - imgH) / 2, 0, imgW, imgH);
    
    CGFloat titleW = self.titleLabel.frame.size.width;
    CGFloat titleH = self.titleLabel.frame.size.height;
    
    self.titleLabel.frame = CGRectMake((width - titleW) / 2, height - titleH, titleW, titleH);
}

@end

@interface GKDYVideoControlView()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIImageView           *iconView;
@property (nonatomic, strong) GKDYVideoItemButton   *praiseBtn;
@property (nonatomic, strong) GKDYVideoItemButton   *commentBtn;
@property (nonatomic, strong) GKDYVideoItemButton   *shareBtn;
@property (nonatomic, strong) GKDYVideoItemButton   *reportBtn;
@property (nonatomic, strong) UIButton   *popularBtn;

@property (nonatomic, strong) UILabel               *nameLabel;
@property (nonatomic, strong) UILabel               *contentLabel;
@property (nonatomic, strong) WH_GKSliderView          *sliderView;

@property (nonatomic, strong) UIActivityIndicatorView   *loadingView;
@property (nonatomic, strong) UIButton                  *playBtn;

@property (nonatomic, strong) UIView *commentBackView;
@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UITableView *commentTable;
@property (nonatomic, strong) UILabel *commentNum;
@property (nonatomic, strong) UITextField *commentTextField;
//@property(nonatomic,strong)WH_WeiboCell* selectWH_WeiboCell;
@property(nonatomic,strong)WeiboReplyData * replyDataTemp;
@property(nonatomic,strong)JX_WHNoDataView *noDataView;
@property(nonatomic,strong)UIView *playletView;//短剧的背景
@property (nonatomic, strong) UILabel *playletCountLab;//短剧的集数

/**
 输入条
 */
@property (nonatomic, strong) UIView * inputView;
@property (nonatomic, strong) UITextView * chatTextView;
@property (nonatomic, strong) UILabel * placeHolder;

@property (nonatomic, strong) UIButton   *automPlayBtn;

@end

@implementation GKDYVideoControlView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.wh_coverImgView];
        [self addSubview:self.iconView];
        [self addSubview:self.automPlayBtn];
        [self addSubview:self.praiseBtn];
        [self addSubview:self.commentBtn];
        [self addSubview:self.shareBtn];
        [self addSubview:self.reportBtn];
        [self addSubview:self.popularBtn];
        [self addSubview:self.nameLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.sliderView];
        
        [self addSubview:self.loadingView];
        [self addSubview:self.playBtn];
        
        [self addSubview:self.playletView];
        [self addSubview:self.playletCountLab];

        
        [self.wh_coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.automPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
//        CGFloat bottomM = THE_DEVICE_HAVE_HEAD ? (34.0f + ADAPTATIONRATIO * 40.0f) : ADAPTATIONRATIO * 40.0f;
        
        CGFloat bottomM = JX_SCREEN_BOTTOM;
        
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-bottomM);
//            make.height.mas_equalTo(ADAPTATIONRATIO * 2.0f);
            make.height.mas_equalTo(0.0f);
        }];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ADAPTATIONRATIO * 30.0f);
//            make.bottom.equalTo(self.sliderView).offset(-ADAPTATIONRATIO * 16.0f - JX_SCREEN_BOTTOM - 24);
            make.bottom.equalTo(self).offset(-ADAPTATIONRATIO * 4.0f - JX_SCREEN_BOTTOM - 24 - 34);
            make.width.mas_equalTo(ADAPTATIONRATIO * 504.0f);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentLabel);
            make.bottom.equalTo(self.contentLabel.mas_top).offset(-ADAPTATIONRATIO * 20.0f);
        }];
        
        [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-ADAPTATIONRATIO * 20.0f);
            make.bottom.equalTo(self.nameLabel.mas_top).offset(-ADAPTATIONRATIO * 16.0f);
            make.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
        }];
        
        [self.popularBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(48);
            make.centerX.equalTo(self.reportBtn);
            make.top.equalTo(self.reportBtn.mas_bottom).offset(4);
        }];
        
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.reportBtn);
            make.bottom.equalTo(self.reportBtn.mas_top).offset(-ADAPTATIONRATIO * 16.0f);
            make.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
        }];
        
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.shareBtn.mas_top).offset(-ADAPTATIONRATIO * 16.0f);
            make.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
        }];
        
        [self.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.commentBtn.mas_top).offset(-ADAPTATIONRATIO * 16.0f);
            make.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.reportBtn);
            make.bottom.equalTo(self.praiseBtn.mas_top).offset(-ADAPTATIONRATIO * 50.0f);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 100.0f);
        }];
        
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        _musicName = [[CircleTextView alloc]init];
        _musicName.textColor = [UIColor whiteColor];
        _musicName.font = [UIFont systemFontOfSize:14];
        [self addSubview:_musicName];
        
        [_musicName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentLabel.mas_left);
            make.top.equalTo(self.contentLabel.mas_bottom);
            make.width.mas_equalTo(JX_SCREEN_WIDTH/2);
            make.height.mas_equalTo(24);
        }];
        
        [self.playletView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-JX_SCREEN_BOTTOM);
            make.width.mas_equalTo(JX_SCREEN_WIDTH);
            make.height.mas_equalTo(34);
        }];
        [self.playletCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playletView).offset(13);
            make.right.equalTo(self.playletView).offset(-13);
            make.top.bottom.equalTo(self.playletView);
        }];
        [self.playletView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookAllPlayletAction)]];
        
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(controlViewDidClick:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
-(void)lookAllPlayletAction{
    if(self.lookAllPlayletBlock){
        self.lookAllPlayletBlock();
    }
}

- (void) createCommentView {
    
    self.replyDataTemp = [[WeiboReplyData alloc] init];
    
    _commentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT)];
    _commentBackView.backgroundColor = [UIColor clearColor];
    _commentBackView.hidden = YES;
    [g_window addSubview:_commentBackView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _commentBackView.frame.size.width, commentY)];
    [btn addTarget:self action:@selector(commentHiden) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor clearColor];
    [_commentBackView addSubview:btn];
    
    CGFloat commentRadiu = 8.f;
    _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, _commentBackView.frame.size.height, JX_SCREEN_WIDTH, _commentBackView.frame.size.height - commentY + commentRadiu)];
//    _commentView.backgroundColor = HEXCOLOR(0x393a3f);
    _commentView.backgroundColor = [UIColor whiteColor];
    _commentView.layer.cornerRadius = commentRadiu;
    _commentView.layer.masksToBounds = YES;
    [_commentBackView addSubview:_commentView];
    
    
    //关闭按钮
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_commentBackView.frame.size.width - 44, 0, 44, 44)];
    [closeBtn addTarget:self action:@selector(commentHiden) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"WH_CallenderClose"] forState:UIControlStateNormal];
    [_commentView addSubview:closeBtn];
    
    CGFloat btmHeight = 49.f + (THE_DEVICE_HAVE_HEAD ? 34.f : 0.f);
    UIButton *bottomView = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.frame = CGRectMake(0, _commentView.frame.size.height - btmHeight, _commentView.frame.size.width, btmHeight);
    [bottomView addTarget:self action:@selector(commentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_commentView addSubview:bottomView];
    
    //Localized(@"JX_LoveToComment")
    NSString *placeHolder = @"留下你的精彩评论";
    
    _commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 7, bottomView.frame.size.width - 24, 38.f)];
    _commentTextField.placeholder = placeHolder;
    _commentTextField.textColor = HEXCOLOR(0x161819);
    _commentTextField.userInteractionEnabled = NO;
    _commentTextField.layer.masksToBounds = YES;
    _commentTextField.layer.cornerRadius = 19.0f;
    _commentTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 38)];
    _commentTextField.leftViewMode = UITextFieldViewModeAlways;
    _commentTextField.font = sysFontWithSize(14);
    if (@available(iOS 10, *)) {
        _commentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x797979)}];
    } else {
        [_commentTextField setValue:HEXCOLOR(0x797979) forKeyPath:@"_placeholderLabel.textColor"];
    }
    _commentTextField.backgroundColor = HEXCOLOR(0xF3F3F3);
    [bottomView addSubview:_commentTextField];
    
    
    
    _commentTable = [[UITableView alloc]initWithFrame:CGRectMake(0,44,JX_SCREEN_WIDTH,_commentView.frame.size.height - bottomView.frame.size.height - 44)];
    _commentTable.dataSource = self;
    _commentTable.delegate   = self;
    _commentTable.tag        = self.tag;
    _commentTable.backgroundColor = [UIColor clearColor];
    _commentTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [_commentView addSubview:_commentTable];
    
    _commentNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, _commentTable.frame.size.width, 30)];
    _commentNum.textAlignment = NSTextAlignmentCenter;
    _commentNum.textColor = HEXCOLOR(0x161819);
    _commentNum.font = sysFontWithSize(16);
    self.commentNum.text = [NSString stringWithFormat:Localized(@"JX_%ldComments"),self.wh_model.replys.count];
    [_commentView addSubview:_commentNum];
//    _commentTable.tableHeaderView = _commentNum;
    
    _noDataView = [[JX_WHNoDataView alloc] initWithFrame:CGRectMake(0, 160, JX_SCREEN_WIDTH, 180)];
    _noDataView.hidden = self.wh_model.replys.count > 0?YES:NO;
    __weak typeof (&*self)weakSelf = self;
    _noDataView.commentBlock = ^{
        [weakSelf commentButtonAction];
    };
    [_commentView addSubview:self.noDataView];
    
    
    
    [self inputView];
}

-(UIView *)inputView{
    //输入条,副键盘
    if (!_inputView) {
        _inputView = [[UIView alloc] init];
        _inputView.frame = CGRectMake(0, JX_SCREEN_HEIGHT+10, JX_SCREEN_WIDTH, 49);
        
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = CGRectMake(0, 0, _inputView.frame.size.width, _inputView.frame.size.height);
        [_inputView addSubview:effectView];
        
        _chatTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 7, JX_SCREEN_WIDTH-24, 44-5)];
        _chatTextView.backgroundColor = HEXCOLOR(0xF3F3F3);
        _chatTextView.layer.masksToBounds = YES;
        _chatTextView.layer.cornerRadius = 18.5f;
        _chatTextView.font = sysFontWithSize(14);
        _chatTextView.textColor = HEXCOLOR(0x161819);
        _chatTextView.clearsOnInsertion = YES;
        
        _chatTextView.delegate = self;
        _chatTextView.returnKeyType = UIReturnKeySend;
        _chatTextView.tintColor = THEMECOLOR;
        [_inputView addSubview:_chatTextView];
        
        _chatTextView.inputAccessoryView = _inputView;
        
        _placeHolder = [[UILabel alloc] init];
        _placeHolder.frame = CGRectMake(4, 4, CGRectGetWidth(_chatTextView.frame), 22);
        _placeHolder.textColor = HEXCOLOR(0x797979);
        _placeHolder.font = [UIFont systemFontOfSize:14];
        _placeHolder.textAlignment = NSTextAlignmentLeft;
        
        [_chatTextView addSubview:_placeHolder];
        _placeHolder.text = @"留下你的精彩评论";

    }
    return _inputView;
}

//发送回复
-(void)onInputText:(NSString*)s{
    
    [self endChatEdit];

    self.replyDataTemp.messageId = self.wh_model.msgId;
    self.replyDataTemp.body      = s;
    self.replyDataTemp.userId    = MY_USER_ID;
    self.replyDataTemp.userNickName    = g_myself.userNickname;
    
    [[JXServer sharedServer] WH_addCommentWithData:self.replyDataTemp type:self.wh_model.type.intValue + 1 toView:self];
}


-(void)endChatEdit{
    [_chatTextView resignFirstResponder];
    _placeHolder.hidden = NO;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length <= 0) {
        _placeHolder.hidden = NO;
    }else {
        _placeHolder.hidden = YES;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        if (textView.text.length > 0) {
            [self onInputText:textView.text];
        }
        _chatTextView.text = nil;
        [self endChatEdit];
        return NO;
    }
    return YES;
}

#pragma mark - button事件
-(void)commentButtonAction{
    
    self.replyDataTemp.toUserId  = nil;
    self.replyDataTemp.toNickName  = nil;
    
    _placeHolder.text = @"留下你的精彩评论";
    _placeHolder.hidden = _chatTextView.text.length > 0?YES:NO;
    [g_window addSubview:self.inputView];
    [_chatTextView becomeFirstResponder];
}

#pragma mark - 通知事件
-(void)keyboardWillHidden:(NSNotification *)notification
{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _inputView.frame = CGRectMake(0, frame.origin.y+10, JX_SCREEN_WIDTH, 50);
    
}

- (void)commentShow {
    [_commentBackView removeFromSuperview];
    _commentBackView = nil;
    [self createCommentView];
    _commentBackView.hidden = NO;
    self.wh_scrollView.scrollEnabled = NO;
    _commentView.frame = CGRectMake(0, _commentBackView.frame.size.height, _commentView.frame.size.width, _commentView.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        _commentView.frame = CGRectMake(0, commentY, _commentView.frame.size.width, _commentView.frame.size.height);
    }];
}

- (void)commentHiden {
    
    if (_chatTextView.becomeFirstResponder) {
        [self endChatEdit];
        return;
    }
    self.wh_scrollView.scrollEnabled = YES;
    _commentView.frame = CGRectMake(0, commentY, _commentView.frame.size.width, _commentView.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        _commentView.frame = CGRectMake(0, _commentBackView.frame.size.height, _commentView.frame.size.width, _commentView.frame.size.height);
    } completion:^(BOOL finished) {
                
        _commentBackView.hidden = YES;
        [_commentBackView removeFromSuperview];
        _commentBackView = nil;
    }];
}

- (void)setWh_model:(WH_GKDYVideoModel *)model {
    _wh_model = model;
    
    self.noDataView.hidden = model.replys.count > 0?YES:NO;
    self.sliderView.value = 0;
    
    [self.wh_coverImgView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail_url]];
    
    self.nameLabel.text = [NSString stringWithFormat:@"@%@",model.author.wh_name_show];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.author.wh_portrait] placeholderImage:[UIImage imageNamed:@"avatar_normal"]];
    
    self.contentLabel.text = model.title;
    
    [_musicName setText:[NSString stringWithFormat:@"%@原创音乐", model.author.wh_name_show]];
    
    // shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 0;
    shadow.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    shadow.shadowOffset =CGSizeMake(0.5,1);
    [self.praiseBtn setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:model.agree_num attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSShadowAttributeName: shadow}] forState:UIControlStateNormal];
    [self.commentBtn setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:model.comment_num attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSShadowAttributeName: shadow}] forState:UIControlStateNormal];
    [self.shareBtn setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:Localized(@"JX_small_share") attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSShadowAttributeName: shadow}] forState:UIControlStateNormal];
    [self.reportBtn setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:model.collect attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSShadowAttributeName: shadow}] forState:UIControlStateNormal];
    
    self.praiseBtn.selected = model.isPraise;
    self.reportBtn.selected = model.collected;
    self.commentNum.text = [NSString stringWithFormat:Localized(@"JX_%ldComments"),self.wh_model.replys.count];
    
    float bottom = -ADAPTATIONRATIO * 4.0f - JX_SCREEN_BOTTOM - 24 - 34;
    
    //判断是不是短剧  ,1短剧,２用户发的视频
    if(model.type.intValue == 1){
        self.playletView.hidden = self.playletCountLab.hidden = NO;
        self.playletCountLab.text = [NSString stringWithFormat:@"短剧·%@【%@集全】》",model.shortName,model.totalSeries];
    }else{
        self.playletView.hidden = self.playletCountLab.hidden = YES;
        bottom = -ADAPTATIONRATIO * 4.0f - JX_SCREEN_BOTTOM - 24;
    }
        
    [self.commentTable reloadData];
    
    if(model.dataType == 3 || model.dataType == 4){//判断是不是全屏
        bottom+=(JX_SCREEN_BOTTOM-JX_SCREEN_Safe);
        
        [self.playletView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-JX_SCREEN_Safe);
            make.width.mas_equalTo(JX_SCREEN_WIDTH);
            make.height.mas_equalTo(34);
        }];
    }
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ADAPTATIONRATIO * 30.0f);
        make.bottom.equalTo(self).offset(bottom);
        make.width.mas_equalTo(ADAPTATIONRATIO * 504.0f);
    }];
}

#pragma mark - Public Methods
- (void)setProgress:(float)progress {
    self.sliderView.value = progress;
}

- (void)startLoading {
    [self.loadingView startAnimating];
}

- (void)stopLoading {
    [self.loadingView stopAnimating];
}

- (void)showPlayBtn {
    self.playBtn.hidden = NO;
}

- (void)hidePlayBtn {
    self.playBtn.hidden = YES;
}

#pragma mark - Action
- (void)controlViewDidClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickSelf:)]) {
        [self.delegate controlViewDidClickSelf:self];
    }
}

- (void)iconDidClick:(id)sender {
    WH_JXUserInfo_WHVC* vc = [WH_JXUserInfo_WHVC alloc];
    vc.wh_userId       = self.wh_model.userId;
    vc.wh_fromAddType = 6;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickIcon:)]) {
//        [self.delegate controlViewDidClickIcon:self];
    }
}

- (void)praiseBtnClick:(id)sender {
    _praiseBtn.selected = !_praiseBtn.selected;
    if (_praiseBtn.selected) {
        self.wh_model.agree_num = [NSString stringWithFormat:@"%ld",[self.wh_model.agree_num integerValue] + 1];
        ////1短剧,２用户发的视频  入参收藏类型,type:1-朋友圈点赞(参数默认值1),2-短剧,3-短视频
        [[JXServer sharedServer] WH_addPraiseWithMsgId:self.wh_model.msgId type:self.wh_model.type.integerValue + 1 toView:self];
    }else {
        self.wh_model.agree_num = [NSString stringWithFormat:@"%ld",[self.wh_model.agree_num integerValue] - 1];
        if ([self.wh_model.agree_num integerValue] <= 0) {
            self.wh_model.agree_num = @"0";
        }
        
        [[JXServer sharedServer] WH_delPraiseWithMsgId:self.wh_model.msgId toView:self];
    }
    self.wh_model.isPraise = _praiseBtn.selected;
//    [self.praiseBtn setTitle:self.wh_model.agree_num forState:UIControlStateNormal];jjjj
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 0;
    shadow.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    shadow.shadowOffset =CGSizeMake(0.5,1);
    [self.praiseBtn setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:self.wh_model.agree_num attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSShadowAttributeName: shadow}] forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickPriase:)]) {
//        [self.delegate controlViewDidClickPriase:self];
    }
}

- (void)commentBtnClick:(id)sender {
    if (_commentBackView.hidden || !_commentBackView) {
        [self commentShow];
    }else {
        [self commentHiden];
    }
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickComment:)]) {
//        [self.delegate controlViewDidClickComment:self];
    }
}

- (void)shareBtnClick:(id)sender {
    
    WH_JXMessageObject *msg=[[WH_JXMessageObject alloc]init];
    msg.timeSend     = [NSDate date];
    msg.fromUserId   = MY_USER_ID;
    msg.fromUserName = MY_USER_NAME;
    msg.fileName     = self.wh_model.video_url;
    msg.content      = self.wh_model.video_url;
    msg.type         = [NSNumber numberWithInt:kWCMessageTypeVideo];
    msg.isRead       = [NSNumber numberWithBool:NO];
    
    WH_JXRelay_WHVC *vc = [[WH_JXRelay_WHVC alloc] init];
    NSMutableArray *array = [NSMutableArray arrayWithObject:msg];
    //    vc.msg = msg;
    vc.relayMsgArray = array;
    //    [g_window addSubview:vc.view];
    [g_navigation pushViewController:vc animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickShare:)]) {
//        [self.delegate controlViewDidClickShare:self];
    }
}

- (void)reportClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected){//收藏
        self.wh_model.collect = [NSString stringWithFormat:@"%ld",[self.wh_model.collect integerValue] + 1];
        [g_server WH_VideoCollectWithId:self.wh_model.msgId toView:self];
    }else{//取消收藏
        self.wh_model.collect = [NSString stringWithFormat:@"%ld",[self.wh_model.collect integerValue] - 1];
        if ([self.wh_model.collect integerValue] <= 0) {
            self.wh_model.collect = @"0";
        }
        [g_server WH_VideoCancleCollectWithId:self.wh_model.msgId toView:self];
    }

    self.wh_model.collected = sender.selected;
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 0;
    shadow.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    shadow.shadowOffset =CGSizeMake(0.5,1);
    [self.reportBtn setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:self.wh_model.collect attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSShadowAttributeName: shadow}] forState:UIControlStateNormal];
    
    
//    WH_JXReportUser_WHVC * reportVC = [[WH_JXReportUser_WHVC alloc] init];
//    WH_JXUserObject *user = [[WH_JXUserObject alloc]init];
//    user.userId = self.wh_model.userId;
//    reportVC.user = user;
//    reportVC.delegate = self;
//    [g_navigation pushViewController:reportVC animated:YES];
}
//帮上热门
-(void)popularBtnClick:(UIButton *)sender{
    WH_PopularVideoVC *vc = [[WH_PopularVideoVC alloc] init];
    [g_navigation pushViewController:vc animated:YES];
}

- (void)report:(WH_JXUserObject *)reportUser reasonId:(NSNumber *)reasonId {
    [g_server WH_reportUserWithToUserId:self.wh_model.userId roomId:nil webUrl:nil reasonId:reasonId toView:self];
}
#pragma mark - 懒加载
- (UIImageView *)wh_coverImgView {
    if (!_wh_coverImgView) {
        _wh_coverImgView = [UIImageView new];
        _wh_coverImgView.contentMode = UIViewContentModeScaleAspectFill;
        _wh_coverImgView.clipsToBounds = YES;
    }
    return _wh_coverImgView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.layer.cornerRadius = ADAPTATIONRATIO * 50.0f;
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconView.layer.borderWidth = 1.0f;
        _iconView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconDidClick:)];
        [_iconView addGestureRecognizer:iconTap];
    }
    return _iconView;
}
-(UIButton *)automPlayBtn{
    if(!_automPlayBtn){
        _automPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _automPlayBtn.backgroundColor = [UIColor clearColor];
        [_automPlayBtn addTarget:self action:@selector(stopAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _automPlayBtn;
}
-(void)stopAction{
    if(self.stopActionBlock){
        self.stopActionBlock();
    }
}

- (GKDYVideoItemButton *)praiseBtn {
    if (!_praiseBtn) {
        _praiseBtn = [GKDYVideoItemButton new];
        [_praiseBtn setImage:[UIImage imageNamed:@"WH_PraiseNormal_WHIcon"] forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"WH_PraiseSelect_WHIcon"] forState:UIControlStateSelected];
        _praiseBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_praiseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseBtn;
}

- (GKDYVideoItemButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [GKDYVideoItemButton new];
        [_commentBtn setImage:[UIImage imageNamed:@"WH_Comment_WHIcon"] forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (GKDYVideoItemButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [GKDYVideoItemButton new];
        [_shareBtn setImage:[UIImage imageNamed:@"WH_TransferToOther_Icon"] forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (GKDYVideoItemButton *)reportBtn {
    if (!_reportBtn) {
        _reportBtn = [GKDYVideoItemButton new];
        [_reportBtn setImage:[UIImage imageNamed:@"collect_normal_big"] forState:UIControlStateNormal];
        [_reportBtn setImage:[UIImage imageNamed:@"collect_select_big"] forState:UIControlStateSelected];
        _reportBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_reportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reportBtn addTarget:self action:@selector(reportClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportBtn;
}
-(UIButton *)popularBtn{
    if(!_popularBtn){
        _popularBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_popularBtn setImage:[UIImage imageNamed:@"popular_icon"] forState:UIControlStateNormal];
        [_popularBtn addTarget:self action:@selector(popularBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popularBtn;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _nameLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconDidClick:)];
        [_nameLabel addGestureRecognizer:nameTap];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _contentLabel;
}

- (WH_GKSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [WH_GKSliderView new];
        _sliderView.isHideSliderBlock = YES;
        _sliderView.sliderHeight = ADAPTATIONRATIO * 2.0f;
        _sliderView.maximumTrackTintColor = [UIColor grayColor];
        _sliderView.minimumTrackTintColor = [UIColor whiteColor];
        _sliderView.hidden = YES;
    }
    return _sliderView;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loadingView.hidesWhenStopped = YES;
    }
    return _loadingView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[UIImage imageNamed:@"ss_icon_pause"] forState:UIControlStateNormal];
        _playBtn.userInteractionEnabled = NO;
        _playBtn.hidden = YES;
    }
    return _playBtn;
}

#pragma -mark  tableReply delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboReplyData * data=[self.wh_model.replys objectAtIndex:indexPath.row];
    CGFloat height = [JXXMPP getLabelHeightWithContent:[self getLabelText:data] andLabelWidth:JX_SCREEN_WIDTH - 80 andLabelFontSize:14];
    return height+46 + 24;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger n = [self.wh_model.replys count];
    //    //NSLog(@"count:%d",n);
    return n;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{//ok
    //    NSString *CellIdentifier = [NSString stringWithFormat:@"WeiboReplyCell%d_%d",refreshCount,indexPath.row];
    NSString *CellIdentifier = [NSString stringWithFormat:@"WeiboReplyCell"];
    ReplyCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell = [[ReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    if (1) {
    //        //NSLog(@"%@",CellIdentifier);
    //清空cell里的数据
//    cell.label = nil;
    
    cell.backgroundColor = [UIColor clearColor];
    if(indexPath.row>=self.wh_model.replys.count)
        return cell;
    
    if (!cell.icon) {
        cell.icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 36, 36)];
        cell.icon.layer.cornerRadius = 18.0f;
        cell.icon.layer.masksToBounds = YES;
        [cell addSubview:cell.icon];
    }
    
    if (!cell.name) {
        cell.name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.icon.frame) + 8, 0, JX_SCREEN_WIDTH - CGRectGetMaxX(cell.icon.frame) - 10, 15)];
        cell.name.textColor = HEXCOLOR(0xBABABA);
        cell.name.font = sysFontWithSize(12);
        [cell addSubview:cell.name];
    }
    
    //回复区的文字Label
//    cell.label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cell.icon.frame) + 10, CGRectGetMaxY(cell.name.frame) + 5, JX_SCREEN_WIDTH, 27)];
//    [cell addSubview:cell.label];
//    cell.label.numberOfLines = 0;
//    cell.label.font = [UIFont systemFontOfSize:13];
//    cell.label.textColor = HEXCOLOR(0x576B94);
//    cell.label.backgroundColor = [UIColor clearColor];
    WeiboReplyData * data=[self.wh_model.replys objectAtIndex:indexPath.row];
    [g_server WH_getHeadImageSmallWIthUserId:data.userId userName:data.userNickName imageView:cell.icon];
    cell.name.text = [NSString stringWithFormat:@"%@",data.userNickName];

    //    __weak WH_HBCoreLabel * wlabel=cell.label;
//    MatchParser * match=[data getMatch:^(MatchParser *parser, id data) {
//        if (wlabel) {
////            GKDYVideoModel * model=(GKDYVideoModel*)data;
////            if (model.willDisplay) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    wlabel.wh_match=parser;
//                });
////            }
//        }
//    } data:self.wh_model];
    
//    cell.label.wh_match=match;
    cell.label.text =  [self getLabelText:data];
    [JXXMPP getAttributeTextWithLabel:cell.label textString:data.body color:HEXCOLOR(0x161819)];
    CGFloat height = [JXXMPP getLabelHeightWithContent:[self getLabelText:data] andLabelWidth:JX_SCREEN_WIDTH - 80 andLabelFontSize:14];
    cell.label.userInteractionEnabled=NO;
    CGRect frame = cell.label.frame;
    cell.backgroundColor=[UIColor clearColor];
    frame.size.height= height + 3;
    frame.origin.x = CGRectGetMaxX(cell.icon.frame) + 10;
    frame.origin.y = 20;
    cell.label.frame=frame;
    
    
    CGRect timeFrame = cell.timeLab.frame;
    timeFrame.origin.y = CGRectGetMaxY(cell.label.frame) + 4;
    cell.timeLab.frame = timeFrame;
    
   NSString *timeStr = [NSString stringWithFormat:@"%@ 回复",data.publishTime];
    
    cell.timeLab.attributedText = [NSString changeSpecialWordColor:HEXCOLOR(0x797979) AllContent:timeStr SpcWord:@"回复" font:12];
    
    //    }
    //设置回复被点击后颜色不变
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (NSString *)getLabelText:(WeiboReplyData *)data {
    if ([data.match.attrString.string containsString:@"回复"]) {
           WH_JXUserObject *userA = [[WH_JXUserObject sharedUserInstance] getFriendWithUserId:data.userId];
           WH_JXUserObject *userB = [[WH_JXUserObject sharedUserInstance] getFriendWithUserId:data.toUserId];
           if (userA.remarkName.length || userB.remarkName.length) {
               data.match.attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@回复%@", userA.remarkName.length ? userA.remarkName : userA.userNickname, userB.remarkName.length ? userB.remarkName : userB.userNickname]];
               data.title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@回复%@", userA.remarkName.length ? userA.remarkName : userA.userNickname, userB.remarkName.length ? userB.remarkName : userB.userNickname]];
           }
        
        return [NSString stringWithFormat:@"%@:%@", data.title.string, data.body];
        
       } else {
           WH_JXUserObject *userA = [[WH_JXUserObject sharedUserInstance] getFriendWithUserId:data.userId];
           if (userA.remarkName.length) {
               data.match.attrString = [[NSMutableAttributedString alloc] initWithString:userA.remarkName];
               data.title = [[NSAttributedString alloc] initWithString:userA.remarkName];
           }
           
           return [NSString stringWithFormat:@"%@",data.body];
       }
//    return [NSString stringWithFormat:@"%@:%@", data.title.string, data.body];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //小Cell里面的数据
    WeiboReplyData* p =[self.wh_model.replys objectAtIndex:indexPath.row];
    if (MY_USER_ID == p.userId) {
        [JXMyTools showTipView:Localized(@"JX_NoReplyMyself")];
        return;
    }
    //回复者
    self.replyDataTemp.userId    = MY_USER_ID;
    self.replyDataTemp.userNickName  = g_myself.userNickname;
    //被回复者
    self.replyDataTemp.toNickName = p.userNickName;
    self.replyDataTemp.toUserId = p.userId;

    _placeHolder.text = [NSString stringWithFormat:@"%@%@",Localized(@"WaHu_WeiboCell_Reply"),p.userNickName];

    if (!_chatTextView.becomeFirstResponder) {
        [g_window addSubview:self.inputView];
        [_chatTextView becomeFirstResponder];
    }
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self endChatEdit];
}

#pragma mark ------------------数据成功返回----------------------
#pragma mark - 请求成功回调
-(void) WH_didServerResult_WHSucces:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    //    [super stopLoading];
    
    //添加新回复
    if([aDownload.action isEqualToString:wh_act_CommentAdd]){
        self.replyDataTemp.textColor = [UIColor whiteColor];
        self.replyDataTemp.font = sysFontWithSize(15);
        [self.replyDataTemp setMatch];
        self.replyDataTemp.publishTime = @"刚刚";
        [self.wh_model.replys insertObject:self.replyDataTemp atIndex:0];
        [self.commentTable reloadData];
        [self.commentTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.wh_model.replys.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        [self.commentBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)self.wh_model.replys.count] forState:UIControlStateNormal];
        self.commentNum.text = [NSString stringWithFormat:Localized(@"JX_%ldComments"),self.wh_model.replys.count];

        self.replyDataTemp = [[WeiboReplyData alloc] init];
        
        self.noDataView.hidden = YES;
        
    }else if ([aDownload.action isEqualToString:wh_act_CommentDel]){
        
//        [selectWeiboData.replys removeObjectAtIndex:self.deleteReply];
//
//        [replyDataTemp setMatch];
//        selectWeiboData.replyHeight=[selectWeiboData heightForReply];
//        if ([selectWeiboData.replys count] != 0) {
//            [self.selectWH_WeiboCell refresh];
//        }
    }
    if([aDownload.action isEqualToString:wh_act_PraiseAdd]){
//        [self doAddPraiseOK];
    }
    if([aDownload.action isEqualToString:wh_act_PraiseDel]){
//        [self doDelPraiseOK];
    }
    if ([aDownload.action isEqualToString:wh_act_Report]) {
        [g_App showAlert:Localized(@"WaHu_JXUserInfo_WaHuVC_ReportSuccess")];
    }
    
}

#pragma mark - 请求失败回调
-(int) WH_didServerResult_WHFailed:(WH_JXConnection*)aDownload dict:(NSDictionary*)dict{
    
    return WH_show_error;
}

#pragma mark - 请求出错回调
-(int) WH_didServerConnect_WHError:(WH_JXConnection*)aDownload error:(NSError *)error{//error为空时，代表超时
    
    return WH_show_error;
}

#pragma mark - 开始请求服务器回调
-(void) WH_didServerConnect_WHStart:(WH_JXConnection*)aDownload{
    
}
-(UIView *)playletView{
    if(!_playletView){
        _playletView = [[UIView alloc] init];
        _playletView.backgroundColor = HEXCOLOR(0xffffff);
        _playletView.alpha = 0.18;
    }
    return _playletView;
}
-(UILabel *)playletCountLab{
    if(!_playletCountLab){
        _playletCountLab = [[UILabel alloc] init];
        _playletCountLab.font = [UIFont systemFontOfSize:14];
        _playletCountLab.textColor = [UIColor whiteColor];
        _playletCountLab.text = @"短剧·掉水后夫君与我拔刀相向【77集全】》";
    }
    return _playletCountLab;
}


@end
