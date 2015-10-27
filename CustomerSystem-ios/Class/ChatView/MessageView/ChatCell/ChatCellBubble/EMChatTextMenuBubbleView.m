//
//  EMChatTextMenuBubbleView.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 15/9/23.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "EMChatTextMenuBubbleView.h"

@implementation EMChatTextMenuBubbleView

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    
    NSDictionary *dic = [self.model.message.ext objectForKey:@"msgtype"];
    if (dic) {
        NSDictionary *choice = [dic objectForKey:@"choice"];
        if (choice) {
            NSArray *menu = [choice objectForKey:@"list"];
            NSMutableArray *array = [NSMutableArray array];
            self.model.content = [self _getMessageContent:model.message];
            for (NSString *string in menu) {
                [array addObject:[NSTextCheckingResult replacementCheckingResultWithRange:[self.model.content rangeOfString:string] replacementString:string]];
            }
            _urlMatches = array;
        }
    } else {
        _urlMatches = [_detector matchesInString:self.model.content options:0 range:NSMakeRange(0, self.model.content.length)];
    }
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]
                                                    initWithString:self.model.content];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:LABEL_LINESPACE];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [self.model.content length])];
    [self.textLabel setAttributedText:attributedString];
    [self highlightLinksWithIndex:NSNotFound];
}

- (NSString*)_getMessageContent:(EMMessage*)message
{
    NSString *content = @"";
    if ([message.ext objectForKey:@"msgtype"]) {
        NSDictionary *dic = [message.ext objectForKey:@"msgtype"];
        if ([dic objectForKey:@"choice"]) {
            NSDictionary *choice = [dic objectForKey:@"choice"];
            NSArray *menu = [choice objectForKey:@"list"];
            content = [choice objectForKey:@"title"];
            for (NSString *string in menu) {
                content = [content stringByAppendingString:[NSString stringWithFormat:@"\n%@",string]];
            }
        }
    }
    return content;
}

+ (BOOL)isMenuMessage:(EMMessage*)message
{
    if ([message.ext objectForKey:@"msgtype"]) {
        NSDictionary *dic = [message.ext objectForKey:@"msgtype"];
        if ([dic objectForKey:@"choice"]) {
            return YES;
        }
    }
    return NO;
}

@end
