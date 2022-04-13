//
//  DXQuestionView.h
//  CustomerSystem-ios
//
//  Created by dhc on 15/2/14.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DXQuestionViewDelegate <NSObject>

@required
- (void)questionViewSeletedTitle:(NSString *)title;
@end


@interface DXQuestionView : UIView
{
    NSArray *_titleArray;
}

@property (nonatomic, weak) id<DXQuestionViewDelegate> delegate;

@end
