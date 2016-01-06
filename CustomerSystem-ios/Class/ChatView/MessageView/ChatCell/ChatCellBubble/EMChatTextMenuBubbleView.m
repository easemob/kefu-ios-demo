//
//  EMChatTextMenuBubbleView.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 15/9/23.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "EMChatTextMenuBubbleView.h"

#define MENU_LABEL_LINESPACE 7.5

@implementation EMChatTextMenuBubbleView

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize textBlockMinSize = {TEXTLABEL_MAX_WIDTH, CGFLOAT_MAX};
    CGSize retSize;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:MENU_LABEL_LINESPACE];//调整行间距
        
        retSize = [self.model.content boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{
                                                             NSFontAttributeName:self.textLabel.font,
                                                             NSParagraphStyleAttributeName:paragraphStyle
                                                             }
                                                   context:nil].size;
    }else{
        retSize = [self.model.content sizeWithFont:self.textLabel.font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
        retSize.height += 10;
    }
    
    CGFloat height = 40;
    if (2*BUBBLE_VIEW_PADDING + retSize.height > height) {
        height = 2*BUBBLE_VIEW_PADDING + retSize.height;
    }
    
    return CGSizeMake(retSize.width + BUBBLE_VIEW_PADDING*2 + BUBBLE_VIEW_PADDING, height);
}

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
            NSString *temp;
            for (NSString *string in menu) {
                if ([temp isEqualToString:string]) {
                    continue;
                }
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:string options:NSRegularExpressionCaseInsensitive error:nil];
                
                NSArray* matches = [regex matchesInString:self.model.content options:NSMatchingReportCompletion range:NSMakeRange(0, [self.model.content length])];
                for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
                    NSRange matchRange = [match range];
                    [array addObject:[NSTextCheckingResult replacementCheckingResultWithRange:matchRange replacementString:string]];
                }
                temp = string;
            }
            _urlMatches = array;
        }
    } else {
        _urlMatches = [_detector matchesInString:self.model.content options:0 range:NSMakeRange(0, self.model.content.length)];
    }
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]
                                                    initWithString:self.model.content];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:MENU_LABEL_LINESPACE];
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

+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    CGSize textBlockMinSize = {TEXTLABEL_MAX_WIDTH, CGFLOAT_MAX};
    CGSize size;
    static float systemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    
    NSString *content = @"";
    if ([object.message.ext objectForKey:@"msgtype"]) {
        NSDictionary *dic = [object.message.ext objectForKey:@"msgtype"];
        if ([dic objectForKey:@"choice"]) {
            NSDictionary *choice = [dic objectForKey:@"choice"];
            NSArray *menu = [choice objectForKey:@"list"];
            content = [choice objectForKey:@"title"];
            for (NSString *string in menu) {
                content = [content stringByAppendingString:[NSString stringWithFormat:@"\n%@",string]];
            }
        }
    }
    
    if (systemVersion >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:MENU_LABEL_LINESPACE];//调整行间距
        size = [content boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{
                                                      NSFontAttributeName:[UIFont systemFontOfSize:LABEL_FONT_SIZE],
                                                      NSParagraphStyleAttributeName:paragraphStyle
                                                      }
                                            context:nil].size;
    }else{
        size = [content sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE]
                          constrainedToSize:textBlockMinSize
                              lineBreakMode:NSLineBreakByCharWrapping];
        size.height += 10;
    }
    return 2 * BUBBLE_VIEW_PADDING + size.height;
}


@end
