//
//  WH_JXTabMenuView.m
//  sjvodios
//
//  Created by daxiong on 13-4-17.
//
//

#import "WH_JXTabMenuView.h"
#import "JXLabel.h"
#import "JXTabButton.h"

@implementation WH_JXTabMenuView
@synthesize wh_delegate,wh_items,wh_height,wh_selected,wh_imagesNormal,wh_imagesSelect,wh_onClick,wh_backgroundImageName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        NSInteger count = wh_items.count + 1;
//        float width = JX_SCREEN_WIDTH/5.0;
        NSInteger count = wh_items.count;
        float width = JX_SCREEN_WIDTH/4.0;
                
        wh_height    = 49;
        self.backgroundColor = [UIColor whiteColor];
        
        self.userInteractionEnabled = YES;
//        self.image = [UIImage imageNamed:backgroundImageName];

        _arrayBtns = [[NSMutableArray alloc]init];
        
        int i;
        for(i=0;i<count;i++){
            CGRect r = CGRectMake(width*i, 7, width, wh_height);
            
//            if(i == 2){//加号
//                _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                _publishBtn.frame = r;
//                [_publishBtn setImage:[UIImage imageNamed:@"add_tab_icon"] forState:UIControlStateNormal];
//                [_publishBtn addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
//                [self addSubview:self.publishBtn];
//            }else{
                JXTabButton *btn = [JXTabButton buttonWithType:UIButtonTypeCustom];
    //            btn.wh_iconName = [wh_imagesNormal objectAtIndex:i];
    //            btn.wh_selectedIconName = [wh_imagesSelect objectAtIndex:i];
//                btn.wh_text  = [wh_items objectAtIndex:i<2?i:i - 1];
                btn.wh_text  = [wh_items objectAtIndex:i];
                [btn.titleLabel setFont:pingFangRegularFontWithSize(14)];
                btn.wh_textColor = HEXCOLOR(0x9B9B9B);
                btn.wh_selectedTextColor = HEXCOLOR(0x161819);
                btn.wh_delegate  = self.wh_delegate;
                btn.wh_onDragout = self.wh_onDragout;
    //            if(i==1)
    //                btn.bage = @"1";
                btn.frame = r;
//                btn.tag = i<2?i:i - 1;
                btn.tag = i;
                if ((wh_onClick != nil) && (wh_delegate != nil))
                    [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn textShow];
                [self addSubview:btn];
                [_arrayBtns addObject:btn];
//            }
        }

        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0,0,JX_SCREEN_WIDTH,0.5)];
        line.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self addSubview:line];
//        [line release];
    }
    return self;
}

-(void)publishAction:(UIButton *)sender{
    if(self.publishBlock){
        self.publishBlock();
    }
}

-(void)dealloc{
//    [_arrayBtns release];
//    [items release];
//    [super dealloc];
}

-(void)onClick:(JXTabButton*)sender{
    [self wh_unSelectAll];
    sender.selected = YES;
    self.wh_selected = sender.tag;
	if(self.wh_delegate != nil && [self.wh_delegate respondsToSelector:self.wh_onClick])
		[self.wh_delegate performSelectorOnMainThread:self.wh_onClick withObject:sender waitUntilDone:NO];
}

-(void)wh_unSelectAll{
    for(int i=0;i<[_arrayBtns count];i++){
        ((JXTabButton*)[_arrayBtns objectAtIndex:i]).selected = NO;
    }
    wh_selected = -1;
}

-(void)wh_selectOne:(int)n{
    [self wh_unSelectAll];
    if(n >= [_arrayBtns count])
        return;
    ((JXTabButton*)[_arrayBtns objectAtIndex:n]).selected=YES;
    wh_selected = n;
}

-(void)wh_setTitle:(int)n title:(NSString*)s{
    if(n >= [_arrayBtns count])
        return;
    [[_arrayBtns objectAtIndex:n] setTitle:s forState:UIControlStateNormal];
}

-(void)wh_setBadge:(int)n title:(NSString*)s{
    if(n >= [_arrayBtns count])
        return;
    JXTabButton *btn = [_arrayBtns objectAtIndex:n];
    btn.wh_bage = s;
    btn = nil;
}

@end
