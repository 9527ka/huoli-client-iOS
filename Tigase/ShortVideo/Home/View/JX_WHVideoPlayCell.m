//
//  JX_WHVideoPlayCell.m
//  Tigase
//
//  Created by 1111 on 2024/3/22.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "JX_WHVideoPlayCell.h"
#import "GKDYVideoControlView.h"
#import "UIButton+WebCache.h"

@interface JX_WHVideoPlayCell()

@property (nonatomic, weak) id<ZFTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic,strong)GKDYVideoControlView *infoView;
@property (nonatomic,strong)UIScrollView *scrollView;


@end

@implementation JX_WHVideoPlayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){

        [self makeUI];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoStopePlayAction)];
//        [self.infoView addGestureRecognizer:tap];
    }
    return self;
}
-(void)makeUI{
        //视频播放的view
    [self.contentView addSubview:self.videoBtn];
    [self.contentView addSubview:self.playImageBtn];
    [self.contentView addSubview:self.infoView];
    
//    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.left.right.equalTo(self.contentView);
//    }];
//
    self.backgroundColor = [UIColor blackColor];
    
    [self.playImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(-10);
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
   
}
-(UIButton *)videoBtn{
    if (!_videoBtn) {
        _videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoBtn addTarget:self action:@selector(videoStopePlayAction) forControlEvents:UIControlEventTouchUpInside];
        _videoBtn.frame = CGRectMake(0, -JX_SCREEN_NavH, JX_SCREEN_WIDTH, JX_SCREEN_HEIGHT + JX_SCREEN_NavH);
        _videoBtn.layer.masksToBounds = YES;
        _videoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _videoBtn;
}
/// *视频暂停播放的点击事件
/// @param sender 按钮
-(void)videoStopePlayAction{
    if (self.stopPlayBlock) {
        self.stopPlayBlock();
    }
}
-(UIButton *)playImageBtn{
    if (!_playImageBtn) {
        _playImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playImageBtn setImage:[UIImage imageNamed:@"ss_icon_pause"] forState:UIControlStateNormal];
        [_playImageBtn addTarget:self action:@selector(videoPlayAction:) forControlEvents:UIControlEventTouchUpInside];
        _playImageBtn.hidden = YES;
    }
    return _playImageBtn;
}
- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath scroller:(UIScrollView *)scrollView{
    self.delegate = delegate;
    self.indexPath = indexPath;
    self.scrollView = scrollView;
    self.infoView.wh_scrollView = self.scrollView;
}
-(void)videoPlayAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(zf_playTheVideoAtIndexPath:)]) {
        [self.delegate zf_playTheVideoAtIndexPath:self.indexPath];
    }
}
-(GKDYVideoControlView *)infoView{
    if(!_infoView){
        _infoView = [GKDYVideoControlView new];
        _infoView.wh_coverImgView.hidden = YES;
        __weak typeof (&*self)weakSelf = self;
        _infoView.lookAllPlayletBlock = ^{
            if(weakSelf.lookAllPlayletBlock){
                weakSelf.lookAllPlayletBlock();
            }
        };
    }
    return _infoView;
}
-(void)setWh_model:(WH_GKDYVideoModel *)wh_model{
    _wh_model = wh_model;
    self.infoView.wh_model = wh_model;
    [self.videoBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:wh_model.thumbnail_url] forState:UIControlStateNormal];
    self.videoBtn.tag = 100100 + self.wh_model.dataType;
}

@end
