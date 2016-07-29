//
//  EMChatTransferBubbleView.m
//  CustomerSystem-ios
//
//  Created by easemob on 16/3/29.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "EMChatTransferBubbleView.h"
#import <CoreText/CoreText.h>

/** @brief 转接按钮高度 */
#define TRANSFERBUTTON_HEIGHT  35.0
/** @brief 转接按钮宽度 */
#define TRANSFERBUTTON_WIDTH   80.0
/** @brief 转接按钮与其他控件间距 */
#define TRANSFERBUTTON_PADDING       10.0

NSString *const kRouterEventTransferBubbleTapEventName = @"kRouterEventTransferBubbleTapEventName";

@interface EMChatTransferBubbleView()

@property (nonatomic, strong) UIButton *transferBtn;

@property (nonatomic, assign) CGSize fitSize;

@end

@implementation EMChatTransferBubbleView


+ (BOOL)isTransferMessage:(EMMessage*)message
{
    NSDictionary *userInfo = [[EaseMob sharedInstance].chatManager loginInfo];
    NSString *login = [userInfo objectForKey:kSDKUsername];
    BOOL isSender = [login isEqualToString:message.from] ? YES : NO;
    if ([message.ext objectForKey:kMesssageExtWeChat] && !isSender) {
        NSDictionary *dic = [message.ext objectForKey:kMesssageExtWeChat];
        if ([dic objectForKey:kMesssageExtWeChat_ctrlType] &&
            [dic objectForKey:kMesssageExtWeChat_ctrlType] != [NSNull null] &&
            [[dic objectForKey:kMesssageExtWeChat_ctrlType] isEqualToString:kMesssageExtWeChat_ctrlType_transferToKfHint]) {
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
    
    CGFloat height = 40;
    if (2*BUBBLE_VIEW_PADDING + size.height > height) {
        height = 2*BUBBLE_VIEW_PADDING + size.height;
    }
    height += TRANSFERBUTTON_HEIGHT;
    return height + TRANSFERBUTTON_PADDING * 2;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _transferBtn.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:167.0/255.0 blue:252.0/255.0 alpha:1.0];
        _transferBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_transferBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_transferBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_transferBtn setTitle:@"转人工客服" forState:UIControlStateNormal];
        [_transferBtn setTitle:@"转人工客服" forState:UIControlStateHighlighted];
        _transferBtn.layer.cornerRadius = 5.f;
        _transferBtn.userInteractionEnabled = YES;
        [_transferBtn addTarget:self action:@selector(transferAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_transferBtn];
    }

    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self updateLayout:self.bounds];
}

- (void)updateLayout:(CGRect)rect {
    CGRect frame = rect;
    frame.size.width -= BUBBLE_ARROW_WIDTH;
    frame.size.height -= (TRANSFERBUTTON_HEIGHT + 2 * TRANSFERBUTTON_PADDING);
    frame = CGRectInset(frame, BUBBLE_VIEW_PADDING, BUBBLE_VIEW_PADDING);
    if (self.model.isSender) {
        frame.origin.x = BUBBLE_VIEW_PADDING;
    }else{
        frame.origin.x = BUBBLE_VIEW_PADDING + BUBBLE_ARROW_WIDTH;
    }
    frame.origin.y = BUBBLE_VIEW_PADDING;
    [self.textLabel setFrame:frame];
    
    frame = self.backImageView.frame;
    frame.size.height = rect.size.height - (TRANSFERBUTTON_HEIGHT + 2 * TRANSFERBUTTON_PADDING);
    self.backImageView.frame = frame;
    
    frame.size.height = TRANSFERBUTTON_HEIGHT;
    frame.size.width = TRANSFERBUTTON_WIDTH;
    frame.origin.x = CGRectGetMinX(self.textLabel.frame) - BUBBLE_VIEW_PADDING;
    frame.origin.y = CGRectGetMaxY(rect) - TRANSFERBUTTON_HEIGHT - TRANSFERBUTTON_PADDING;
    [self.transferBtn setFrame:frame];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize textBlockMinSize = {TEXTLABEL_MAX_WIDTH, CGFLOAT_MAX};
    CGSize retSize;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:LABEL_LINESPACE];//调整行间距
        
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
    height += (TRANSFERBUTTON_HEIGHT + TRANSFERBUTTON_PADDING * 2);
    
    CGFloat width = MAX(retSize.width, TRANSFERBUTTON_WIDTH) + BUBBLE_VIEW_PADDING*2 + BUBBLE_ARROW_WIDTH;
    
    //size改变，则修改布局
    if (_fitSize.height != height || _fitSize.width != width) {
        _fitSize = CGSizeMake(width, height);
        CGRect rect = self.bounds;
        rect.size = _fitSize;
        [self updateLayout:rect];
    }
    return CGSizeMake(width, height);
}

#pragma mark - setter

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    
    _urlMatches = [_detector matchesInString:self.model.content options:0 range:NSMakeRange(0, self.model.content.length)];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]
                                                    initWithString:self.model.content];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:LABEL_LINESPACE];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [self.model.content length])];
    [self.textLabel setAttributedText:attributedString];
    
    BOOL hasTransfer = [model.message.ext[kMesssageExtWeChat_ctrlType_transferToKf_HasTransfer] boolValue];
    if (hasTransfer) {
        _transferBtn.backgroundColor = [UIColor lightGrayColor];
        _transferBtn.userInteractionEnabled = NO;
    }
    else {
        _transferBtn.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:167.0/255.0 blue:252.0/255.0 alpha:1.0];
        _transferBtn.userInteractionEnabled = YES;
    }
    
    if ([model.message.ext objectForKey:kMesssageExtWeChat]) {
        NSDictionary *ctrlArgs = [[model.message.ext objectForKey:kMesssageExtWeChat] objectForKey:kMesssageExtWeChat_ctrlArgs];
        if (ctrlArgs) {
            if ([ctrlArgs objectForKey:kMesssageExtWeChat_ctrlArgs_label]) {
                [_transferBtn setTitle:[ctrlArgs objectForKey:kMesssageExtWeChat_ctrlArgs_label] forState:UIControlStateNormal];
                [_transferBtn setTitle:[ctrlArgs objectForKey:kMesssageExtWeChat_ctrlArgs_label] forState:UIControlStateHighlighted];
            }
        }
    }
}

- (void)transferAction:(id)sender
{
    [self routerEventWithName:kRouterEventTransferBubbleTapEventName
                     userInfo:@{KMESSAGEKEY:self.model}];
}

@end
