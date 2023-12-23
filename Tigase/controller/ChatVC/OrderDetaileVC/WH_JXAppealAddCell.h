//
//  WH_JXAppealAddCell.h
//  Tigase
//
//  Created by 1111 on 2023/12/23.
//  Copyright © 2023 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WH_JXAppealAddCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *videoCountLab;

@property (weak, nonatomic) IBOutlet UILabel *picCountLab;
@property (weak, nonatomic) IBOutlet UILabel *textCountLab;
@property (weak, nonatomic) IBOutlet UIView *textBgView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIView *picBgView;
@property (weak, nonatomic) IBOutlet UIButton *videoAddBtn;

@property(nonatomic,strong) NSMutableArray *images;

@property(nonatomic,copy)void(^addVideoBlock)(void);
@property(nonatomic,copy)void(^addImageBlock)(void);
@property(nonatomic,copy)void(^lookImageBlock)(NSInteger tag);

@property(nonatomic,copy)void(^certainBlock)(NSString *text);


@end

NS_ASSUME_NONNULL_END
