//
//  DrawingBoardView.m
//  Quartz2D
//
//  Created by fangjs on 16/5/4.
//  Copyright © 2016年 fangjs. All rights reserved.
//

#import "HDDrawingBoardView.h"

@interface HDDrawingBoardView ()

@property (strong , nonatomic) UIBezierPath *path;
@property (strong , nonatomic) NSMutableArray *pathArray;
@property (nonatomic,strong) UILabel *markLabel;
@end

@implementation HDDrawingBoardView

-(NSMutableArray *)pathArray {
    if (_pathArray == nil) {
        _pathArray = [NSMutableArray array];
    }
    return _pathArray;
}

-(void)setImage:(UIImage *)image {
    _image = image;
    [self.pathArray addObject:image];
    [self setNeedsDisplay];
}



- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpDrawView];
    }
    return self;
}

- (void)setUpDrawView {
    self.backgroundColor = [UIColor whiteColor];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    self.pathColor = [UIColor colorWithRed:44/255.0 green:48/255.0 blue:51/255.0 alpha:1.0];
    self.lineWidth = 3;
    
    self.markLabel = [[UILabel alloc] init];
    self.markLabel.text = NSLocalizedString(@"video.call.sign", @"请在此处签字");
    self.markLabel.font = [UIFont systemFontOfSize:24];
    self.markLabel.textColor = [UIColor colorWithRed:165/255.0 green:169/255.0 blue:180/250.0 alpha:1.0];
    [self addSubview:self.markLabel];
}

-(void)layoutSubviews {
    [super layoutSubviews];
//    self.markLabel.frame = CGRectMake(self.frame.size.width/2-50, self.frame.size.height/2-9, 100, 18);
    
    [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.centerX).offset(0);
        make.centerY.mas_equalTo(self.centerY).offset(0);
        
    }];
    
}

- (void)pan:(UIPanGestureRecognizer *) pan {
    //获取当前点
    CGPoint currentPoint = [pan locationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        //创建贝塞尔路径
        self.path = [UIBezierPath bezierPath];
        self.path.lineWidth = self.lineWidth;
        //设置路径的起点
         [self.path moveToPoint:currentPoint];
        //保存描述好的路径
        [self.pathArray addObject:self.path];
    }
   
    if (pan.state == UIGestureRecognizerStateChanged) {
        //连接线到当前触摸点
        [self.path addLineToPoint:currentPoint];
    }
    //重绘
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    self.markLabel.hidden = self.pathArray.count;
    for (UIBezierPath *path in self.pathArray) {
        if ([path isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *) path;
            [image drawInRect:rect];
        }
        else {
            [self.pathColor set];
            [path stroke];
        }
    }
    !self.drawCallBack ? nil : self.drawCallBack(self.pathArray.count);
}

//清屏
- (void)clearContent {
    [self.pathArray removeAllObjects];
    [self setNeedsDisplay];
}

//撤销
-(void)Undo {
    [self.pathArray removeLastObject];
    [self setNeedsDisplay];
}


@end
