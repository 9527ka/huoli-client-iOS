//
//  NSString+WH_ContainStr.h
//  Tigase_imChatT
//
//  Created by 1 on 17/7/4.
//  Copyright © 2019年 YanZhenKui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WH_ContainStr)

-(BOOL)containsMyString:(NSString *)str;

//生成UUID
+ (NSString *)createUUID;

- (BOOL)isUrl;
- (void)sp_getUserName;

//判断是否包含中文
+ (BOOL)isHasChineseWithStr:(NSString *)strFrom ;

+ (NSMutableAttributedString *)changeSpecialWordColor:(id)spcColor AllContent:(NSString *)allWord SpcWord:(NSString *)spcWord font:(CGFloat)size;

- (NSURL *)urlScheme:(NSString *)scheme;

//计算单行文本宽度和高度，返回值与UIFont.lineHeight一致，支持开头空格计算。包含emoji表情符的文本行高返回值有较大偏差。
- (CGSize)singleLineSizeWithText:(UIFont *)font;

//计算单行文本行高、支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围
- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font;

@end
