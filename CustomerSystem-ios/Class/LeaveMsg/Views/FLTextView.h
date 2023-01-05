//
//  FLTextView.h
//  FLTextView
//
//  Created by afanda on 16/7/29.
//  Copyright © 2016年 afanda All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLTextView : UITextView

@property (nonatomic,copy)   NSString *placeholderText;      //预填充文字
@property (nonatomic,strong) UIColor  *placeholderTextColor;  //预填充字体颜色
@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic,assign) NSUInteger maxNoOfWords; //最大字数

@end
