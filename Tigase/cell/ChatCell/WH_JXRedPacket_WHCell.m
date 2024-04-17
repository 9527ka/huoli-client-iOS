//
//  WH_JXRedPacket_WHCell.m
//  Tigase_imChatT
//
//  Created by Apple on 16/10/10.
//  Copyright © 2016年 Reese. All rights reserved.
//

#import "WH_JXRedPacket_WHCell.h"
#import "NSString+ContainStr.h"

@interface WH_JXRedPacket_WHCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *checkLabel;

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UILabel *line;

@property (nonatomic, strong) UILabel *toUserLab;

@property (nonatomic, strong) UILabel *sendTimeLab;

@end

@implementation WH_JXRedPacket_WHCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)creatUI{
    self.bubbleBg.custom_acceptEventInterval = 1.0;
    self.layer.masksToBounds = YES;
    self.bubbleBg.layer.masksToBounds = NO;
    
    _imageBackground =[[WH_JXImageView alloc]initWithFrame:CGRectZero];
    [_imageBackground setBackgroundColor:[UIColor clearColor]];
    _imageBackground.layer.cornerRadius = 6;
    _imageBackground.image = [[UIImage imageNamed:@"WH_hongbao_background"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    _imageBackground.layer.masksToBounds = YES;
    [self.bubbleBg addSubview:_imageBackground];
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake(12,11, 35, 41);
    _headImageView.image = [UIImage imageNamed:@"WH_hongbao_top"];//图片
    _headImageView.userInteractionEnabled = NO;
    _headImageView.hidden = YES;
    [_imageBackground addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10,22, 160, 23);
    _nameLabel.font = sysFontWithSize(10);
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.numberOfLines = 0;
    _nameLabel.userInteractionEnabled = NO;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_imageBackground addSubview:_nameLabel];

    _checkLabel = [[UILabel alloc] init];
    [_imageBackground addSubview:_checkLabel];
    _checkLabel.frame = CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame) + 4.0f, CGRectGetWidth(_nameLabel.frame), 20);
    _checkLabel.text = Localized(@"WH_Check_RedPacket");
    _checkLabel.textColor = [UIColor whiteColor];
    _checkLabel.font = sysFontWithSize(14);
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_headImageView.frame)+1.0f, 10, 120, 30)];
    _title.text = Localized(@"JX_BusinessCard");
    _title.font = sysFontWithSize(10);
    _title.textAlignment = NSTextAlignmentCenter;
    [_imageBackground addSubview:_title];
    
    _toUserLab = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 172, 10, 100, 30)];
    _toUserLab.font = [UIFont boldSystemFontOfSize:20];
    _toUserLab.textColor = [UIColor whiteColor];
//    _toUserLab.hidden = YES;
    _toUserLab.textAlignment = NSTextAlignmentCenter;
    [_imageBackground addSubview:_toUserLab];
    
    _sendTimeLab = [[UILabel alloc] init];
    _sendTimeLab.font = sysFontWithSize(8);
    _sendTimeLab.textColor = [UIColor whiteColor];
    _sendTimeLab.textAlignment = NSTextAlignmentCenter;
    [_imageBackground addSubview:_sendTimeLab];
    
    _line = [[UILabel alloc] initWithFrame:CGRectMake(4, self.bounds.size.height - 12, 120, 0.3)];
    _line.alpha = 1.0f;
    _line.backgroundColor= HEXCOLOR(0xFFAD58);
    [_imageBackground addSubview:_line];
    
    //
//    _redPacketGreet = [[JXEmoji alloc]initWithFrame:CGRectMake(5, 25, 80, 16)];
//    _redPacketGreet.textAlignment = NSTextAlignmentCenter;
//    _redPacketGreet.font = [UIFont systemFontOfSize:12];
//    _redPacketGreet.textColor = [UIColor whiteColor];
//    _redPacketGreet.userInteractionEnabled = NO;
//    [_imageBackground addSubview:_redPacketGreet];
}

-(void)setCellData{
    [super setCellData];
    //判断是否是全部隐藏
    if([g_App.isShowRedPacket intValue] == 0 || g_myself.isTestAccount){
        self.timeLabel.hidden = self.readNum.hidden = YES;
        for (UIView *view in self.contentView.subviews) {
            view.hidden = YES;
        }
    }
    

    CGFloat bubbleX = .0f;
    CGFloat bubbleY = .0f;
    CGFloat bubbleW = 232.0f;
    CGFloat bubbleH = .0f;
    
    float wide = (JX_SCREEN_WIDTH/375.0f)*232.0;
    float height = (JX_SCREEN_WIDTH/375.0f)*95.0;
    
    if(JX_SCREEN_WIDTH > 375.0){
        bubbleW = wide;
    }
    if(self.msg.isMySend) {//屏幕375 等比缩放
//        bubbleW = 220.0f;
        bubbleX = JX_SCREEN_WIDTH - INSETS - HEAD_SIZE - CHAT_WIDTH_ICON - bubbleW;
        bubbleY = INSETS;
        bubbleH = height;
    } else {
//        bubbleW = 220.0f;
        bubbleX = CGRectGetMaxX(self.headImage.frame) + CHAT_WIDTH_ICON;
        bubbleY = INSETS2(self.msg.isGroup);
        bubbleH = height;
    }
    
    self.bubbleBg.frame = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
    _imageBackground.frame = self.bubbleBg.bounds;
    
    
    if(self.msg.isMySend){
        _title.frame = CGRectMake(_imageBackground.frame.size.width - 70, 11, 60, 15);
        _nameLabel.frame = CGRectMake(_imageBackground.frame.size.width - 70, 26, 60, 15);
    }else{
        _title.frame = CGRectMake(8, 11, 60, 15);
        _nameLabel.frame = CGRectMake(8, 26, 60, 15);
    }
    _sendTimeLab.frame = CGRectMake((_imageBackground.bounds.size.width - 108)/2, _imageBackground.frame.size.height - 24, 108, 15);
    _toUserLab.frame = CGRectMake((_imageBackground.bounds.size.width - 108)/2 - 8, (_imageBackground.frame.size.height - 44)/2 - 6, 108, 44);
    
    
    _line.frame = CGRectMake(8, _imageBackground.frame.size.height - (8+17), 200, 0.3);
    _line.hidden = YES;
    
    if (self.msg.isShowTime) {
        CGRect frame = self.bubbleBg.frame;
        frame.origin.y = self.bubbleBg.frame.origin.y + 40 - 14;
        self.bubbleBg.frame = frame;
    }
    
//    [self setMaskLayer:_imageBackground];
//    self.toUserLab.hidden = ([self.msg.type intValue] == kWCMessageTypeRedPacketExclusive)?NO:YES;
//    self.toUserLab.text = [NSString stringWithFormat:@"仅 %@ 可领",self.msg.toUserNames];
    
    NSString *amountStr = [NSString stringWithFormat:@"￥%.2f",self.msg.amount.doubleValue];
    
    self.toUserLab.attributedText = [NSString changeSpecialWordColor:[UIColor whiteColor] AllContent:amountStr SpcWord:@"￥" font:14];
    
    //日期
    NSDate * date = self.msg.timeSend;
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    self.sendTimeLab.text = [dateFormatter stringFromDate:date];
        
    //服务端返回的数据类型错乱，强行改
    self.msg.fileName = [NSString stringWithFormat:@"%@",self.msg.fileName];
    if ([self.msg.fileName isEqualToString:@"3"]) {
        _nameLabel.text = [NSString stringWithFormat:@"%@%@",Localized(@"JX_Message"),self.msg.content];
        
        NSString *title = @"口令券";//口令红包
        if([self.msg.type intValue] == kWCMessageTypeRedPacketExclusive){
            title = @"专属券";
        }else{
            title = @"口令券";
        }
        
        _title.text = title;
    }else{
//        NSArray *gree
        _nameLabel.text = self.msg.content;
        NSString *title = @"优惠券";//红包
        if([self.msg.type intValue] == kWCMessageTypeRedPacketExclusive){
//            title = self.room.category == 1?@"专属钻石":@"专属红包";
            title = @"专属券";
            
            NSString *name = self.msg.toUserNames;
            if(self.msg.toUserNames.length > 4){
                name = [name substringToIndex:4];
                name = [NSString stringWithFormat:@"%@...",name];
            }
            self.sendTimeLab.text = [NSString stringWithFormat:@"仅 %@ 可领",name];
        }else{
//            title = self.room.category == 1?@"手气钻石":@"手气红包";
            title = @"手气券";
        }
        _title.text = title;
    }
    _checkLabel.text = self.room.category == 1?@"查看钻石":Localized(@"WH_Check_RedPacket");
    _checkLabel.hidden = YES;
    _headImageView.image = [UIImage imageNamed: self.room.category == 1?@"red_diamound_icon":@"WH_hongbao_top"];
    //专属的用WH_hongbao_top
    if(self.room.category != 1 && [self.msg.type intValue] != kWCMessageTypeRedPacketExclusive){
        _headImageView.image = [UIImage imageNamed: [self.msg.fileSize intValue] == 2?@"hongbao_receive_icon":@"WH_hongbao_top_icon"];
    }
    
    _imageBackground.image = [UIImage imageNamed:self.msg.isMySend?@"hong_mySend_bg":@"hong_otherSend_bg"];
    
    //专属红包更改红包颜色
    //    if([self.msg.type intValue] == kWCMessageTypeRedPacketExclusive){
//
//    UIImage *image = [[UIImage imageNamed:@"WH_hongbao_background"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
//    _imageBackground.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [_imageBackground setTintColor:self.room.category==1?HEXCOLOR(0x179cfb):HEXCOLOR(0xfa9e3b)];
    //    }
//    _title.textColor = [self.msg.type intValue] == kWCMessageTypeRedPacketExclusive?[UIColor whiteColor]:HEXCOLOR(0x8C9AB8);
    
    _title.textColor = [UIColor whiteColor];
    
    if ([self.msg.fileSize intValue] == 2) {
        
        _imageBackground.alpha = 0.7;
    }else {
        
        _imageBackground.alpha = 1;
    }
    

}

-(void)didTouch:(UIButton*)button{
    if ([self.msg.fileName isEqualToString:@"3"] || [self.msg.fileName isEqualToString:@"4"]) {
//        //如果可以打开
//        if([self.msg.fileSize intValue] != 2){
//            [g_App showAlert:Localized(@"JX_WantOpenGift")];
//            return;
//        }
        
        [g_notify postNotificationName:kcellRedPacketDidTouchNotifaction object:self.msg];
    }
    
    if ([self.msg.fileName isEqualToString:@"1"] || [self.msg.fileName isEqualToString:@"2"]) {
    
            [g_notify postNotificationName:kcellRedPacketDidTouchNotifaction object:self.msg];
            return;

    }
    

}

+ (float)getChatCellHeight:(WH_JXMessageObject *)msg {
    if ([g_App.isShowRedPacket intValue] == 1 && !g_myself.isTestAccount){
        if ([msg.chatMsgHeight floatValue] > 1) {
            return [msg.chatMsgHeight floatValue];
        }
        
        float n = 0;
        float wide = (JX_SCREEN_WIDTH/375.0f)*232.0;
        float height = (JX_SCREEN_WIDTH/375.0f)*95.0 + 40;
//        float height = JX_SCREEN_WIDTH/3;
        
        if (msg.isGroup && !msg.isMySend) {
            if (msg.isShowTime) {
                n = height + 40;
            }else {
                n = height + 10;
            }
        }else {
            if (msg.isShowTime) {
                n = height + 40;
            }else {
                n = height;
            }
        }
        n-=20;
        msg.chatMsgHeight = [NSString stringWithFormat:@"%f",n];
        if (!msg.isNotUpdateHeight) {
            [msg updateChatMsgHeight];
        }
        return n;
        
    }else{
        
        msg.chatMsgHeight = [NSString stringWithFormat:@"0"];
        if (!msg.isNotUpdateHeight) {
            [msg updateChatMsgHeight];
        }
        return 0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)sp_getMediaData {
    //NSLog(@"Continue");
}
@end
