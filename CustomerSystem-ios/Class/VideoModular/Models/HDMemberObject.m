//
//  HDMemberObject.m
//  HRTCDemo
//
//  Created by afanda on 7/26/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HDMemberObject.h"

@implementation HVideoItem

- (HDCallBackView *)backView {
    if (_backView == nil) {
        _backView = [[HDCallBackView alloc] init];
        _backView.backgroundColor = [UIColor blackColor];
    }
    return _backView;
}

- (void)setScaleMode:(EMCallViewScaleMode)scaleMode {
    self.normalView.scaleMode = scaleMode;
    self.deskTopView.scaleMode = scaleMode;
}

- (HDCallRemoteView *)normalView {
    if (_normalView == nil) {
        _normalView = [[HDCallRemoteView alloc] initWithFrame:CGRectZero];
        _normalView.scaleMode = EMCallViewScaleModeAspectFill;
        _normalView.hidden = YES;
        _normalView.frame = self.backView.bounds;
        _normalView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.backView addSubview:_normalView];
    }
    return _normalView;
}

- (HDCallRemoteView *)deskTopView {
    if (_deskTopView == nil) {
        _deskTopView = [[HDCallRemoteView alloc] initWithFrame:CGRectZero];
        _deskTopView.scaleMode = EMCallViewScaleModeAspectFill;
        _deskTopView.hidden = YES;
        _deskTopView.frame = self.backView.bounds;
        _deskTopView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.backView addSubview:_deskTopView];
    }
    return _deskTopView;
}

@end

@interface HDMemberObject ()
@property(nonatomic,strong) tapBlock tap;
@end

@implementation HDMemberObject

- (instancetype)init {
    @throw [NSException exceptionWithName:@"YYWebImageManager init error" reason:@"Use the designated initializer to init." userInfo:nil];
    return [self initWithMemberName:nil frame:CGRectZero target:nil];
}

- (instancetype)initWithMemberName:(NSString *)memberName frame:(CGRect)frame target:(id)target{
    if ( self = [super init]) {
        _memberName = memberName;
        _isFull = NO;
        self.remoteVideoItem.backView.frame = frame;
        self.remoteVideoItem.backView.delegate = target;
        [self.remoteVideoItem.backView addSubviewRestoreBtn];
        [self.remoteVideoItem.backView addSubviewNameLabel];
        [self addGes];
    }
    return self;
}

- (void)setAgentName:(NSString *)agentName {
    _agentName = agentName;
    self.remoteVideoItem.backView.nameLabel.text = self.agentName;
}

- (void)setTapBlock:(tapBlock)tapBlock {
    _tap = tapBlock;
}

- (void)addGes {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remoteVideoItemViewTap)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remoteVideoItemViewTap)];
    [self.remoteVideoItem.normalView addGestureRecognizer:tap];
    [self.remoteVideoItem.deskTopView addGestureRecognizer:tap1];
}

- (void)remoteVideoItemViewTap {
    if (_isFull == YES) {
        return;
    }
    _isFull = YES;
    if (_tap != nil) {
        tapBlock block = _tap;
        block(self.remoteVideoItem);
    }
}



- (HVideoItem *)remoteVideoItem {
    if (_remoteVideoItem == nil) {
        _remoteVideoItem = [[HVideoItem alloc] init];
    }
    return _remoteVideoItem;
}


@end
