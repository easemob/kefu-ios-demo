//
//  LeaveMsgAttatchmentView.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/7/25.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "LeaveMsgAttatchmentView.h"
#import "LeaveMsgDetailModel.h"
//#import "SCAudioPlay.h"

@interface LeaveMsgAttatchmentView ()
{
    BOOL _edit;
}

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *removeButton;
@property (nonatomic,strong) UIImageView *animationView;
@property (nonatomic,strong) UILabel *durationLabel;
@end

@implementation LeaveMsgAttatchmentView
{
    NSArray *_images;
}

- (instancetype)initWithFrame:(CGRect)frame edit:(BOOL)edit model:(LeaveMsgAttachmentModel*)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        self.backgroundColor = RGBACOLOR(77, 178, 244, 1);
        _edit = edit;
        [self addSubview:self.nameLabel];
        
        if (![model.type isEqualToString:@"audio"]) {
            self.nameLabel.text = model.name;
        } else {
            _animationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
            _animationView.animationDuration = 1;
            _animationView.image = [UIImage imageNamed:@"chat_receiver_audio_playing_full"];
            [self addSubview:_animationView];
            [self.nameLabel addSubview:self.durationLabel];
            _durationLabel.text = [model.wavDuration stringByAppendingString:@"″"];
        }
        if (edit) {
            [self addSubview:self.removeButton];
        }
        _images = @[[UIImage imageNamed:@"chat_receiver_audio_playing000"],
                    [UIImage imageNamed:@"chat_receiver_audio_playing001"],
                    [UIImage imageNamed:@"chat_receiver_audio_playing002"],
                    [UIImage imageNamed:@"chat_receiver_audio_playing003"]
                    ];
    }
    return self;
}

- (UILabel*)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _edit ? CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame):CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
//        _nameLabel.text = NSLocalizedString(@"leaveMessage.leavemsg.attachmentname", @"Attachment");
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = _edit ? NSTextAlignmentLeft : NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:14.f];
        _nameLabel.userInteractionEnabled = YES;
    }
    return _nameLabel;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.textAlignment = NSTextAlignmentRight;
    }
    return _durationLabel;
}

- (UIButton*)removeButton
{
    if (_removeButton == nil) {
        _removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _removeButton.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
        [_removeButton setTitle:@"X" forState:UIControlStateNormal];
        [_removeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_removeButton addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
        _removeButton.backgroundColor = [UIColor redColor];
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

- (void)startAnimating {
    
    if ([self isAnimating]) {
        [self stopAnimating];
    }
    _animationView.animationImages = _images;
    [_animationView startAnimating];
}

- (void)stopAnimating {
    if (![self isAnimating]) {
        return;
    }
    [_animationView stopAnimating];
}

- (BOOL)isAnimating {
    return _animationView.isAnimating;
}

#pragma mark - removeAction

- (void)removeAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRemoveAttatchment:)]) {
        [self.delegate didRemoveAttatchment:self.tag];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}
@end
