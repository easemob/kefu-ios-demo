//
//  SKTagView.m
//
//  Created by Shaokang Zhao on 15/1/12.
//  Copyright (c) 2015 Shaokang Zhao. All rights reserved.
//

#import "SKTagView.h"
#import "SKTagButton.h"


@interface SKTagView ()

@property (strong, nonatomic, nullable) NSMutableArray *tags;
@property (assign, nonatomic) BOOL didSetup;
@property (nonatomic,assign) BOOL isIntrinsicWidth;  //!<是否宽度固定
@property (nonatomic,assign) BOOL isIntrinsicHeight; //!<是否高度固定

@end

@implementation SKTagView

// 重写setter给bool赋值
- (void)setRegularWidth:(CGFloat)intrinsicWidth
{
    if (_regularWidth != intrinsicWidth) {
        _regularWidth = intrinsicWidth;
        if (intrinsicWidth == 0) {
            self.isIntrinsicWidth = NO;
        }
        else
        {
            self.isIntrinsicWidth = YES;
        }
    }
    
}

- (void)setRegularHeight:(CGFloat)intrinsicHeight
{
    if (_regularHeight != intrinsicHeight) {
        _regularHeight = intrinsicHeight;
        if (intrinsicHeight == 0)
        {
            self.isIntrinsicHeight = NO;
        }
        else
        {
            self.isIntrinsicHeight = YES;
        }
    }
}

#pragma mark - Lifecycle

-(CGSize)intrinsicContentSize {
    if (!self.tags.count) {
        return CGSizeZero;
    }
    
    NSArray *subviews = self.subviews;
    UIView *previousView = nil;
    CGFloat topPadding = self.padding.top;
    CGFloat bottomPadding = self.padding.bottom;
    CGFloat leftPadding = self.padding.left;
    CGFloat rightPadding = self.padding.right;
    CGFloat itemSpacing = self.interitemSpacing;
    CGFloat lineSpacing = self.lineSpacing;
    CGFloat currentX = leftPadding;
    CGFloat intrinsicHeight = topPadding;
    CGFloat intrinsicWidth = leftPadding;
    
    if (!self.singleLine && self.preferredMaxLayoutWidth > 0) {
        NSInteger lineCount = 0;
        for (UIView *view in subviews) {
            CGSize size = view.intrinsicContentSize;
            // 宽度和高度通过参数的0或者非0来进行赋值
            CGFloat width = self.isIntrinsicWidth?self.regularWidth:size.width;
            CGFloat height = self.isIntrinsicHeight?self.regularHeight:size.height;
            if (previousView) {
//                CGFloat width = size.width;
                currentX += itemSpacing;
                if (currentX + width + rightPadding <= self.preferredMaxLayoutWidth) {
                    currentX += width;
                } else {
                    lineCount ++;
                    currentX = leftPadding + width;
                    intrinsicHeight += height;
                }
            } else {
                lineCount ++;
                intrinsicHeight += height;
                currentX += width;
            }
            previousView = view;
            intrinsicWidth = MAX(intrinsicWidth, currentX + rightPadding);
        }
        
        intrinsicHeight += bottomPadding + lineSpacing * (lineCount - 1);
    } else {
        for (UIView *view in subviews) {
            CGSize size = view.intrinsicContentSize;
            intrinsicWidth += self.isIntrinsicWidth?self.regularWidth:size.width;
        }
        intrinsicWidth += itemSpacing * (subviews.count - 1) + rightPadding;
        intrinsicHeight += ((UIView *)subviews.firstObject).intrinsicContentSize.height + bottomPadding;
    }
    
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

- (void)layoutSubviews {
    if (!self.singleLine) {
        self.preferredMaxLayoutWidth = self.frame.size.width;
    }
    
    [super layoutSubviews];
    
    [self layoutTags];
}

#pragma mark - Custom accessors

- (NSMutableArray *)tags {
    if(!_tags) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

- (void)setPreferredMaxLayoutWidth: (CGFloat)preferredMaxLayoutWidth {
    if (preferredMaxLayoutWidth != _preferredMaxLayoutWidth) {
        _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
        _didSetup = NO;
        [self invalidateIntrinsicContentSize];
    }
}

#pragma mark - Private

- (void)layoutTags {
    if (self.didSetup || !self.tags.count) {
        return;
    }
    
    NSArray *subviews = self.subviews;
    UIView *previousView = nil;
    CGFloat topPadding = self.padding.top;
    CGFloat leftPadding = self.padding.left;
    CGFloat rightPadding = self.padding.right;
    CGFloat itemSpacing = self.interitemSpacing;
    CGFloat lineSpacing = self.lineSpacing;
    CGFloat currentX = leftPadding;
    self.currentLineCount =1;
    if (!self.singleLine && self.preferredMaxLayoutWidth > 0) {
        for (UIView *view in subviews) {
            CGSize size = view.intrinsicContentSize;
            CGFloat width1 = self.isIntrinsicWidth?self.regularWidth:size.width;
            CGFloat height1 = self.isIntrinsicHeight?self.regularHeight:size.height;
            if (previousView) {
//                CGFloat width = size.width;
                currentX += itemSpacing;
                if (currentX + width1 + rightPadding <= self.preferredMaxLayoutWidth) {
                    view.frame = CGRectMake(currentX, CGRectGetMinY(previousView.frame), width1, height1);
                    currentX += width1;
                } else {
                    CGFloat width = MIN(width1, self.preferredMaxLayoutWidth - leftPadding - rightPadding);
                    view.frame = CGRectMake(leftPadding, CGRectGetMaxY(previousView.frame) + lineSpacing, width, height1);
                    currentX = leftPadding + width;
                    self.currentLineCount++ ;
                }
            } else {
                CGFloat width = MIN(width1, self.preferredMaxLayoutWidth - leftPadding - rightPadding);
                view.frame = CGRectMake(leftPadding, topPadding, width, height1);
                currentX += width;
            }
            
            previousView = view;
        }
    } else {
        for (UIView *view in subviews) {
            CGSize size = view.intrinsicContentSize;
            view.frame = CGRectMake(currentX, topPadding, self.isIntrinsicWidth?self.regularWidth:size.width, self.isIntrinsicHeight?self.regularHeight:size.height);
            currentX += self.isIntrinsicWidth?self.regularWidth:size.width;
            
            previousView = view;
        }
    }
    
    self.didSetup = YES;
}

#pragma mark - IBActions

- (void)onTag: (SKTagButton *)btn {
    
    if (self.didTapTagAtIndex) {
        self.didTapTagAtIndex([self.subviews indexOfObject: btn]);
    }
    if (self.didTapTagAtButton) {
        self.didTapTagAtButton( btn,btn.tag);
    }
}

#pragma mark - Public

- (void)addTag: (SKTag *)tag {
    NSParameterAssert(tag);
    SKTagButton *btn = [SKTagButton buttonWithTag: tag];
    btn.tag = tag.tagId;
    [btn addTarget: self action: @selector(onTag:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: btn];
    [self.tags addObject: tag];
    
    self.didSetup = NO;
    [self invalidateIntrinsicContentSize];
}

- (void)insertTag: (SKTag *)tag atIndex: (NSUInteger)index {
    NSParameterAssert(tag);
    if (index + 1 > self.tags.count) {
        [self addTag: tag];
    } else {
        SKTagButton *btn = [SKTagButton buttonWithTag: tag];
        [btn addTarget: self action: @selector(onTag:) forControlEvents: UIControlEventTouchUpInside];
        [self insertSubview: btn atIndex: index];
        [self.tags insertObject: tag atIndex: index];
        
        self.didSetup = NO;
        [self invalidateIntrinsicContentSize];
    }
}

- (void)removeTag: (SKTag *)tag {
    NSParameterAssert(tag);
    NSUInteger index = [self.tags indexOfObject: tag];
    if (NSNotFound == index) {
        return;
    }
    
    [self.tags removeObjectAtIndex: index];
    if (self.subviews.count > index) {
        [self.subviews[index] removeFromSuperview];
    }
    
    self.didSetup = NO;
    [self invalidateIntrinsicContentSize];
}

- (void)removeTagAtIndex: (NSUInteger)index {
    if (index + 1 > self.tags.count) {
        return;
    }
    
    [self.tags removeObjectAtIndex: index];
    if (self.subviews.count > index) {
        [self.subviews[index] removeFromSuperview];
    }
    
    self.didSetup = NO;
    [self invalidateIntrinsicContentSize];
}

- (void)removeAllTags {
    [self.tags removeAllObjects];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    self.didSetup = NO;
    [self invalidateIntrinsicContentSize];
}

@end
