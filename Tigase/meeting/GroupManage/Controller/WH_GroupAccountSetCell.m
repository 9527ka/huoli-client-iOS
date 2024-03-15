//
//  WH_GroupAccountSetCell.m
//  Tigase
//
//  Created by 1111 on 2023/12/11.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_GroupAccountSetCell.h"

@implementation WH_GroupAccountSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 6.0f;
    self.bgView.layer.borderWidth = 1.0f;
    self.bgView.layer.borderColor = THEMECOLOR.CGColor;
    
    self.rightPayLab.layer.cornerRadius = 4.0f;
    
    UIImage *image = [UIImage imageNamed:@"blog_delete"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.deleteBtn setImage:image forState:UIControlStateNormal];
    self.deleteBtn.tintColor = HEXCOLOR(0x797979);
    
    //添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.contentView addGestureRecognizer:longPress];
}

-(void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    if(longPress.state == UIGestureRecognizerStateBegan){
        
        if(self.deleteBlock){
            self.deleteBlock();
        }
    }
}
- (IBAction)deleteAction:(id)sender {
    if(self.deleteBlock){
        self.deleteBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
