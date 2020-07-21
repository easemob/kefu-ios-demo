/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "HDConvertToCommonEmoticonsHelper.h"
#import "HDEmoji.h"

@implementation HDConvertToCommonEmoticonsHelper

#pragma mark smallpngface
// 获取表情字符
+ (NSArray*)emotionsArray
{
    NSMutableArray *array = [NSMutableArray array];

    [array addObject:@"[):]"];
    [array addObject:@"[:D]"];
    [array addObject:@"[;)]"];
    [array addObject:@"[:-o]"];
    [array addObject:@"[:p]"];
    [array addObject:@"[(H)]"];
    [array addObject:@"[:@]"];
    [array addObject:@"[:s]"];
    [array addObject:@"[:$]"];
    [array addObject:@"[:(]"];
    [array addObject:@"[:'(]"];
    [array addObject:@"[:|]"];
    [array addObject:@"[(a)]"];
    [array addObject:@"[8o|]"];
    [array addObject:@"[8-|]"];
    [array addObject:@"[+o(]"];
    [array addObject:@"[<o)]"];
    [array addObject:@"[|-)]"];
    [array addObject:@"[*-)]"];
    [array addObject:@"[:-#]"];
    [array addObject:@"[:-*]"];
    [array addObject:@"[^o)]"];
    [array addObject:@"[8-)]"];
    [array addObject:@"[(|)]"];
    [array addObject:@"[(u)]"];
    [array addObject:@"[(S)]"];
    [array addObject:@"[(*)]"];
    [array addObject:@"[(#)]"];
    [array addObject:@"[(R)]"];
    [array addObject:@"[({)]"];
    [array addObject:@"[(})]"];
    [array addObject:@"[(k)]"];
    [array addObject:@"[(F)]"];
    [array addObject:@"[(W)]"];
    [array addObject:@"[(D)]"];

    return array;
    
}
#pragma mark smallpngface
// 定义表情字符和表情图片名称
+ (NSDictionary *)emotionsDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_1" forKey:@"[):]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_2" forKey:@"[:D]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_3" forKey:@"[;)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_4" forKey:@"[:-o]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_5" forKey:@"[:p]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_6" forKey:@"[(H)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_7" forKey:@"[:@]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_8" forKey:@"[:s]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_9" forKey:@"[:$]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_10" forKey:@"[:(]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_11" forKey:@"[:'(]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_12" forKey:@"[:|]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_13" forKey:@"[(a)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_14" forKey:@"[8o|]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_15" forKey:@"[8-|]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_16" forKey:@"[+o(]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_17" forKey:@"[<o)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_18" forKey:@"[|-)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_19" forKey:@"[*-)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_20" forKey:@"[:-#]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_21" forKey:@"[:-*]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_22" forKey:@"[^o)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_23" forKey:@"[8-)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_24" forKey:@"[(|)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_25" forKey:@"[(u)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_26" forKey:@"[(S)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_27" forKey:@"[(*)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_28" forKey:@"[(#)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_29" forKey:@"[(R)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_30" forKey:@"[({)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_31" forKey:@"[(})]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_32" forKey:@"[(k)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_33" forKey:@"[(F)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_34" forKey:@"[(W)]"];
    [dic setObject:@"HelpDeskUIResource.bundle/e_e_35" forKey:@"[(D)]"];
    
    

    
    return dic;
}

#pragma mark - emotics

+ (NSString *)convertToCommonEmoticons:(NSString *)text
{
    int allEmoticsCount = (int)[HDEmoji allEmoji].count;
    NSMutableString *retText = [[NSMutableString alloc] initWithString:text];
    for(int i=0; i<allEmoticsCount; ++i) {
        NSRange range;
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😊"
                                 withString:@"[):]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😃"
                                 withString:@"[:D]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😉"
                                 withString:@"[;)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😮"
                                 withString:@"[:-o]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😋"
                                 withString:@"[:p]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😎"
                                 withString:@"[(H)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😡"
                                 withString:@"[:@]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😖"
                                 withString:@"[:s]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😳"
                                 withString:@"[:$]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😞"
                                 withString:@"[:(]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😭"
                                 withString:@"[:'(]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😐"
                                 withString:@"[:|]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😇"
                                 withString:@"[(a)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😬"
                                 withString:@"[8o|]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😆"
                                 withString:@"[8-|]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😱"
                                 withString:@"[+o(]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🎅"
                                 withString:@"[<o)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😴"
                                 withString:@"[|-)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😕"
                                 withString:@"[*-)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😷"
                                 withString:@"[:-#]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😯"
                                 withString:@"[:-*]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😏"
                                 withString:@"[^o)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😑"
                                 withString:@"[8-)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"💖"
                                 withString:@"[(|)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"💔"
                                 withString:@"[(u)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🌙"
                                 withString:@"[(S)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🌟"
                                 withString:@"[(*)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🌞"
                                 withString:@"[(#)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🌈"
                                 withString:@"[(R)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        
        [retText replaceOccurrencesOfString:@"😚"
                                 withString:@"[(})]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        
        [retText replaceOccurrencesOfString:@"😍"
                                 withString:@"[({)]"
                                    options:NSLiteralSearch
                                      range:range];

        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"💋"
                                 withString:@"[(k)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🌹"
                                 withString:@"[(F)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🍂"
                                 withString:@"[(W)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"👍"
                                 withString:@"[(D)]"
                                    options:NSLiteralSearch
                                      range:range];
    }
    
    return retText;
}

+ (NSString *)convertToSystemEmoticons:(NSString *)text
{
    if (![text isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    if ([text length] == 0) {
        return @"";
    }
    
    return text;
}

@end
