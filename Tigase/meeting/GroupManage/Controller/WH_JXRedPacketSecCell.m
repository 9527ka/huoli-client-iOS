//
//  WH_JXRedPacketSecCell.m
//  Tigase
//
//  Created by 1111 on 2024/1/27.
//  Copyright © 2024 Reese. All rights reserved.
//

#import "WH_JXRedPacketSecCell.h"


@interface WH_JXRedPacketSecCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation WH_JXRedPacketSecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatarImage.layer.cornerRadius = 5;
    self.avatarImage.layer.masksToBounds = YES;
    self.secField.delegate = self;
    
    UIImage *image = [UIImage imageNamed:@"blog_delete"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.deleteBtn setImage:image forState:UIControlStateNormal];
    self.deleteBtn.tintColor = [UIColor redColor];
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//    longPress.minimumPressDuration = 1.5;
//    [self addGestureRecognizer:longPress];
}

-(void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    if(longPress.state == UIGestureRecognizerStateBegan){
        
        if(self.longPressBlock){
            self.longPressBlock();
        }
    }
}
- (IBAction)deleteAction:(id)sender {
    
    if(self.longPressBlock){
        self.longPressBlock();
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if(self.textCountBlock){
        self.textCountBlock(textField.text);
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
