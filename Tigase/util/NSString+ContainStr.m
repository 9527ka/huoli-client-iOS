//
//  NSString+ContainStr.m
//  Tigase_imChatT
//
//  Created by 1 on 17/7/4.
//  Copyright © 2019年 YanZhenKui. All rights reserved.
//

#import "NSString+ContainStr.h"

@implementation NSString (WH_ContainStr)

-(BOOL)containsMyString:(NSString *)str{
    if ([self rangeOfString:str].location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

//生成UUID
+ (NSString *)createUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString * uuid = (__bridge NSString *)uuid_string_ref;
    CFRelease(uuid_string_ref);
    return uuid;
}

- (BOOL)isUrl {
    if(self == nil) {
        return NO;
    }
    
    NSString *url;
    if (self.length>4 && [[self substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",self];
    }else{
        url = self;
    }
    NSString *urlRegex = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
}
- (void)sp_getUserName {
    //NSLog(@"Get User Succrss");
}

+ (BOOL)isHasChineseWithStr:(NSString *)strFrom {
    for (int i=0; i<strFrom.length; i++) {
        NSRange range =NSMakeRange(i, 1);
        NSString * strFromSubStr=[strFrom substringWithRange:range];
        const char *cStringFromstr = [strFromSubStr UTF8String];
        if (strlen(cStringFromstr)==3) {
            //汉字
            return YES;
        } else if (strlen(cStringFromstr)==1) {
            //字母
        }
        
    }
    
    return NO;
}
+ (NSMutableAttributedString *)changeSpecialWordColor:(id)spcColor AllContent:(NSString *)allWord SpcWord:(NSString *)spcWord font:(CGFloat)size{
    NSString *allContent = allWord;
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:allContent];
    //找出特定字符在整个字符串中的位置
    NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:spcWord].location, [[contentStr string] rangeOfString:spcWord].length);
    //修改特定字符的颜色
//    [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:spcColor]  range:redRange];
    
    [contentStr addAttribute:NSForegroundColorAttributeName value:spcColor  range:redRange];
    
    //修改特定字符的字体大小
    [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:redRange];
    
    return contentStr;
}
- (NSURL *)urlScheme:(NSString *)scheme {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:self] resolvingAgainstBaseURL:NO];
    components.scheme = scheme;
    return [components URL];
}

//计算单行文本宽度和高度，返回值与UIFont.lineHeight一致，支持开头空格计算。包含emoji表情符的文本行高返回值有较大偏差。
- (CGSize)singleLineSizeWithText:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}
//计算单行文本行高、支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围
- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font {
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof (CGFloat), &leading };
    
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    CFRange textRange = CFRangeMake(0, self.length);
    
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef) self);
    
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(DBL_MAX, DBL_MAX), nil);
    
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    return size;
}

@end
