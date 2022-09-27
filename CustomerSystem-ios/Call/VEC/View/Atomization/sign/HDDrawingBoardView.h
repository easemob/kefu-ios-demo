//
//  DrawingBoardView.h
//  Quartz2D
//
//  Created by fangjs on 16/5/4.
//  Copyright © 2016年 fangjs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^drawState)(BOOL isFinished);

@interface HDDrawingBoardView : UIView

@property (strong , nonatomic) UIColor *pathColor;
@property (assign , nonatomic) CGFloat lineWidth;
@property (strong , nonatomic) UIImage *image;
@property (nonatomic,strong) drawState drawCallBack ;

//清除绘画内容
-(void) clearContent;

//撤销
- (void) Undo;

@end
