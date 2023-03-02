//
//  SKTagView.h
//
//  Created by Shaokang Zhao on 15/1/12.
//  Copyright (c) 2015 Shaokang Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDVECSKTag.h"

@interface HDVECSKTagView : UIView

@property (assign, nonatomic) UIEdgeInsets padding;
@property (assign, nonatomic) CGFloat lineSpacing;
@property (assign, nonatomic) CGFloat interitemSpacing;
@property (assign, nonatomic) CGFloat preferredMaxLayoutWidth;
@property (assign, nonatomic) CGFloat regularWidth; //!< 固定宽度
@property (nonatomic,assign ) CGFloat regularHeight; //!< 固定高度
@property (nonatomic,assign) NSInteger currentLineCount; //! 当前添加button 一共多少行
@property (assign, nonatomic) BOOL singleLine;
@property (copy, nonatomic, nullable) void (^hdvecDidTapTagAtIndex)(NSUInteger index);
@property (copy, nonatomic, nullable) void (^hdvecDidTapTagAtButton)(UIButton * button,NSUInteger buttonId);

- (void)addTag: (nonnull HDVECSKTag *)tag;
- (void)insertTag: (nonnull HDVECSKTag *)tag atIndex:(NSUInteger)index;
- (void)removeTag: (nonnull HDVECSKTag *)tag;
- (void)removeTagAtIndex: (NSUInteger)index;
- (void)removeAllTags;

@end

