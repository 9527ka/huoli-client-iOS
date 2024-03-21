//
//  ReplyCell.m
//  Tigase_imChatT
//
//  Created by Apple on 16/6/25.
//  Copyright © 2016年 Reese. All rights reserved.
//

#import "ReplyCell.h"

@implementation ReplyCell

//@synthesize label;
//-(void)prepareForReuse
//{
//    self.label.wh_match=nil;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.wh_pointIndex = point.x/10;
//    printf("point = %lf,%lf\n", point.x, point.y);
//    [self setNeedsDisplay];
    [super touchesEnded:touches withEvent:event];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(4, 4, JX_SCREEN_WIDTH - 80, 27)];
        _label.font = [UIFont systemFontOfSize:14];
        _label.numberOfLines = 0;
        _label.textColor = HEXCOLOR(0x161819);
//        _label.textColor = [UIColor whiteColor];
        _label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label];
    }
    return _label;
}
-(UILabel *)timeLab{
    if(!_timeLab){
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, JX_SCREEN_WIDTH - 100, 20)];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textColor = HEXCOLOR(0xBABABA);
        _timeLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLab];
    }
    return _timeLab;
}

- (void)sp_checkNetWorking:(NSString *)isLogin {
    //NSLog(@"Get User Succrss");
}
@end
