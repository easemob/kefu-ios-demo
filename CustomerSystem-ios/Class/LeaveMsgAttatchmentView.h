//
//  LeaveMsgAttatchmentView.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/7/25.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeaveMsgAttachmentModel;
@protocol LeaveMsgAttatchmentViewDelegate <NSObject>

- (void)didRemoveAttatchment:(NSInteger)index;

@end

@interface LeaveMsgAttatchmentView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic,copy) NSString *localPath;

@property (nonatomic, strong) id<LeaveMsgAttatchmentViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                         edit:(BOOL)edit
                        model:(LeaveMsgAttachmentModel*)model;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

+ (CGFloat)widthForName:(NSString*)name maxWidth:(CGFloat)maxWidth;

@end
