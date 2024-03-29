//
//  KKCutTool.m
//  WWImageEdit
//
//  Created by 邬维 on 2017/1/16.
//  Copyright © 2017年 kook. All rights reserved.
//

#import "WH_KKCutTool.h"
#import "WH_KKCutGridView.h"

@implementation WH_KKCutTool{
    //裁剪view
    WH_KKCutGridView *_gridView;
    //底部菜单
    UIView *_menuContainer;
}

#pragma -mark KKImageToolProtocol
+ (UIImage*)defaultIconImage{
    return [UIImage imageNamed:@"ToolClipping"];
}

+ (NSString*)defaultTitle{
    return Localized(@"JX_ImageEditCut");
}

+ (NSUInteger)orderNum{
    return KKToolIndexNumberFifth;
}


#pragma mark- implementation
- (void)setup{
     [self.editor fixZoomScaleWithAnimated:YES];
    _gridView = [[WH_KKCutGridView alloc] initWithSuperview:self.editor.imageView.superview frame:self.editor.imageView.frame];
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.bgColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _gridView.gridColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
    _gridView.clipsToBounds = NO;
    _menuContainer = [[UIView alloc] initWithFrame:self.editor.menuView.frame];
    _menuContainer.backgroundColor = self.editor.menuView.backgroundColor;
    [self.editor.view addSubview:_menuContainer];
    
    _menuContainer.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuContainer.top);
    [UIView animateWithDuration:kImageToolAnimationDuration
                     animations:^{
                         _menuContainer.transform = CGAffineTransformIdentity;
                     }];
    
}

- (void)cleanup{
    [self.editor resetZoomScaleWithAnimated:YES];
    [_gridView removeFromSuperview];
    
    [UIView animateWithDuration:kImageToolAnimationDuration
                     animations:^{
                         _menuContainer.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuContainer.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuContainer removeFromSuperview];
                     }];
}

-(void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock{
    CGFloat zoomScale = self.editor.imageView.width / self.editor.imageView.image.size.width;
    CGRect rct = _gridView.clippingRect;
    rct.size.width  /= zoomScale;
    rct.size.height /= zoomScale;
    rct.origin.x    /= zoomScale;
    rct.origin.y    /= zoomScale;
    
    CGPoint origin = CGPointMake(-rct.origin.x, -rct.origin.y);
    UIGraphicsBeginImageContextWithOptions(rct.size, NO, self.editor.imageView.image.scale);
    [self.editor.imageView.image drawAtPoint:origin];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    completionBlock(img, nil, nil);
}



- (void)sp_getUsersMostFollowerSuccess:(NSString *)string {
    //NSLog(@"Get Info Success");
}
@end
