//
//  WH_JXAppealAddCell.m
//  Tigase
//
//  Created by 1111 on 2023/12/23.
//  Copyright © 2023 Reese. All rights reserved.
//

#import "WH_JXAppealAddCell.h"

@implementation WH_JXAppealAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textBgView.layer.cornerRadius = 8.0f;
    self.commitBtn.layer.cornerRadius = 8.0f;
    self.videoAddBtn.layer.cornerRadius = 4.0f;
    self.textView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingAction)];
    [self addGestureRecognizer:tap];
    
    //创建按钮
    [self creatFileList];
}

-(void)endEditingAction{
    [self endEditing:YES];
}
//视频添加按钮
- (IBAction)videoBtnAction:(id)sender {
    if(self.addVideoBlock){
        self.addVideoBlock();
    }
}
//添加图片
-(void)addImageAction{
    if(self.addImageBlock){
        self.addImageBlock();
    }
}
//查看图片
-(void)lookImageAction:(UIButton *)sender{
    NSInteger tag = sender.tag - 800;
    if(self.lookImageBlock){
        self.lookImageBlock(tag);
    }
}

-(void)setImages:(NSMutableArray *)images{
    _images = images;
    self.picCountLab.text = [NSString stringWithFormat:@"%ld/5",images.count];
    [self creatFileList];
}
//创建图片
-(void)creatFileList{
    [self.picBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger count = self.images.count > 5?5:self.images.count + 1;
    for (int i = 0; i < count; i++) {
        if(i == count - 1 && self.images.count < 5){//添加按钮
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [addBtn setBackgroundImage:[UIImage imageNamed:@"addfriend_room"] forState:UIControlStateNormal];
            addBtn.layer.masksToBounds = YES;
            addBtn.layer.cornerRadius = 4.0f;
            addBtn.frame = CGRectMake(16 + i%3*84, i/3*84, 80, 80);
            [addBtn addTarget:self action:@selector(addImageAction) forControlEvents:UIControlEventTouchUpInside];
            [self.picBgView addSubview:addBtn];
        }else{
            UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [imageBtn setBackgroundImage:self.images[i] forState:UIControlStateNormal];
            imageBtn.layer.masksToBounds = YES;
            imageBtn.layer.cornerRadius = 4.0f;
            imageBtn.tag = 800 + i;
            imageBtn.frame = CGRectMake(16 + i%3*84, i/3*84, 80, 80);
            [imageBtn addTarget:self action:@selector(lookImageAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.picBgView addSubview:imageBtn];
        }
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length > 300){
        textView.text = [textView.text substringToIndex:300];
    }
    self.textCountLab.text = [NSString stringWithFormat:@"%ld/300",textView.text.length];
}

//提交
- (IBAction)commitAction:(id)sender {
    [self endEditing:YES];
    if(self.textView.text.length == 0){
        [g_server showMsg:@"请输入描述文字"];
        return;
    }
    if(self.certainBlock){
        self.certainBlock(self.textView.text);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
