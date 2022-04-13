//
//  EMChatSatisfactionBubbleView.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 15/10/26.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "EMChatSatisfactionBubbleView.h"

NSString *const kRouterEventSatisfactionBubbleTapEventName = @"kRouterEventSatisfactionBubbleTapEventName";

@implementation EMChatSatisfactionBubbleView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backImageView.autoresizingMask =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _satisfactionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _satisfactionBtn.userInteractionEnabled = YES;
        [_satisfactionBtn setTitle:NSLocalizedString(@"satisfaction.evaluate", @"Evaluate") forState:UIControlStateNormal];
        [_satisfactionBtn setTitle:NSLocalizedString(@"satisfaction.evaluated", @"Evaluated") forState:UIControlStateSelected];
        _satisfactionBtn.backgroundColor = [UIColor lightGrayColor];
        _satisfactionBtn.layer.cornerRadius = 5.f;
        [_satisfactionBtn.titleLabel setFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE]];
        [_satisfactionBtn addTarget:self action:@selector(satisfactionAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_satisfactionBtn];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.size.height -= 75.f;
    frame.size.width -= BUBBLE_ARROW_WIDTH;
    frame = CGRectInset(frame, BUBBLE_VIEW_PADDING, BUBBLE_VIEW_PADDING);
    if (self.model.isSender) {
        frame.origin.x = BUBBLE_VIEW_PADDING;
    }else{
        frame.origin.x = BUBBLE_VIEW_PADDING + BUBBLE_ARROW_WIDTH;
    }
    
    frame.origin.y = BUBBLE_VIEW_PADDING;
    [self.textLabel setFrame:frame];
    
    frame.size.height = 50.f;
    frame.origin.x = CGRectGetMaxX(self.textLabel.frame) - CGRectGetWidth(frame);
    frame.origin.y = CGRectGetMaxY(self.textLabel.frame) + 20;
    [self.satisfactionBtn setFrame:frame];
    
    frame = self.backImageView.frame;
    frame.size.height -= 75.f;
    self.backImageView.frame = frame;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize textBlockMinSize = {TEXTLABEL_MAX_WIDTH, CGFLOAT_MAX};
    CGSize retSize;
    NSString *content = NSLocalizedString(@"message.satisfaction", @"please evaluate my service");
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:LABEL_LINESPACE];//调整行间距
        
        retSize = [content boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{
                                                             NSFontAttributeName:self.textLabel.font,
                                                             NSParagraphStyleAttributeName:paragraphStyle
                                                             }
                                                   context:nil].size;
    }else{
        retSize = [content sizeWithFont:self.textLabel.font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
        retSize.height += 10;
    }
    
    CGFloat height = 40;
    if (2*BUBBLE_VIEW_PADDING + retSize.height > height) {
        height = 2*BUBBLE_VIEW_PADDING + retSize.height;
    }
    
    return CGSizeMake(retSize.width + BUBBLE_VIEW_PADDING*2 + BUBBLE_VIEW_PADDING, height + 75.f);
}

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
 
    NSString *content = NSLocalizedString(@"satisfaction.message", @"please evaluate my service");
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]
                                                    initWithString:content];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:LABEL_LINESPACE];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [content length])];
    [self.textLabel setAttributedText:attributedString];
    
    if ([model.message.ext objectForKey:kMesssageExtWeChat]) {
        if ([[model.message.ext objectForKey:kMesssageExtWeChat] objectForKey:@"enable"]) {
            _satisfactionBtn.selected = YES;
            _satisfactionBtn.userInteractionEnabled = NO;
        } else {
            _satisfactionBtn.selected = NO;
            _satisfactionBtn.userInteractionEnabled = YES;
        }
    } else {
        _satisfactionBtn.selected = NO;
        _satisfactionBtn.userInteractionEnabled = YES;
    }
}

#pragma mark - action
- (void)satisfactionAction:(id)sender
{
    [self routerEventWithName:kRouterEventSatisfactionBubbleTapEventName
                     userInfo:@{KMESSAGEKEY:self.model}];
}

#pragma mark - public

+ (BOOL)isSatisfactionMessage:(EMMessage*)message
{
    NSDictionary *userInfo = [[EaseMob sharedInstance].chatManager loginInfo];
    NSString *login = [userInfo objectForKey:kSDKUsername];
    BOOL isSender = [login isEqualToString:message.from] ? YES : NO;
    if ([message.ext objectForKey:kMesssageExtWeChat] && !isSender) {
        NSDictionary *dic = [message.ext objectForKey:kMesssageExtWeChat];
        if ([dic objectForKey:kMesssageExtWeChat_ctrlType] &&
            [dic objectForKey:kMesssageExtWeChat_ctrlType] != [NSNull null] &&
            [[dic objectForKey:kMesssageExtWeChat_ctrlType] isEqualToString:kMesssageExtWeChat_ctrlType_inviteEnquiry]) {
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
    if (systemVersion >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:LABEL_LINESPACE];//调整行间距
        size = [object.content boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{
                                                      NSFontAttributeName:[UIFont systemFontOfSize:LABEL_FONT_SIZE],
                                                      NSParagraphStyleAttributeName:paragraphStyle
                                                      }
                                            context:nil].size;
    }else{
        size = [object.content sizeWithFont:[UIFont systemFontOfSize:LABEL_FONT_SIZE]
                          constrainedToSize:textBlockMinSize
                              lineBreakMode:NSLineBreakByCharWrapping];
        size.height += 10;
    }
    return 2 * BUBBLE_VIEW_PADDING + size.height + 75.f;
}

@end
