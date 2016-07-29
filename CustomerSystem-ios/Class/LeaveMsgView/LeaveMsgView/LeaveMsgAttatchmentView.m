//
//  LeaveMsgAttatchmentView.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/7/25.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "LeaveMsgAttatchmentView.h"

#import "LeaveMsgDetailModel.h"

@interface LeaveMsgAttatchmentView ()
{
    BOOL _edit;
}

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *removeButton;

@end

@implementation LeaveMsgAttatchmentView

- (instancetype)initWithFrame:(CGRect)frame edit:(BOOL)edit model:(LeaveMsgAttachmentModel*)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        self.backgroundColor = RGBACOLOR(77, 178, 244, 1);
        _edit = edit;
        [self addSubview:self.nameLabel];
        self.nameLabel.text = model.name;
        if (edit) {
            [self.nameLabel addSubview:self.removeButton];
        }
    }
    return self;
}

- (UILabel*)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _edit ? CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame):CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _nameLabel.text = NSLocalizedString(@"leaveMessage.leavemsg.attachmentname", @"Attachment");
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = _edit ? NSTextAlignmentLeft : NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:14.f];
        _nameLabel.userInteractionEnabled = YES;
    }
    return _nameLabel;
}

- (UIButton*)removeButton
{
    if (_removeButton == nil) {
        _removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _removeButton.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
        [_removeButton setTitle:@"X" forState:UIControlStateNormal];
        [_removeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_removeButton addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeButton;
}

+ (CGFloat)widthForName:(NSString*)name maxWidth:(CGFloat)maxWidth
{
    CGFloat width = [name boundingRectWithSize:CGSizeMake(MAXFLOAT, 16.f)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                       context:nil].size.width;
    
    if (width + 30.f >= maxWidth) {
        return maxWidth;
    }
    return width + 30.f;
}

#pragma mark - removeAction

- (void)removeAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRemoveAttatchment:)]) {
        [self.delegate didRemoveAttatchment:self.tag];
    }
}

@end
