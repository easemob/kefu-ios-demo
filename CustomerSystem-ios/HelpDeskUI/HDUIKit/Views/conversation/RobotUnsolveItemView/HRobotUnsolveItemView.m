//
//  HRobotUnsolveItemView.m
//  CustomerSystem-ios
//
//  Created by 杜洁鹏 on 2019/10/14.
//  Copyright © 2019 easemob. All rights reserved.
//

#import "HRobotUnsolveItemView.h"

#define SubmitBtnWidth 80
#define SubmitBtnHeight 40
#define SubmitBtnPadding 20

#define DefaultColor [UIColor colorWithRed:25 / 255.0 green:155 / 255.0 blue:252 / 255.0 alpha:1.0]

@interface HRobotUnsolveItemView ()
{
    HDMessage *_msg;
}

@property (nonatomic, strong) NSMutableArray *selectedList;
@property (nonatomic, strong) NSMutableArray *btnList;
@end

@implementation HRobotUnsolveItemView

- (instancetype)initWithList:(NSArray *)aList
                      message:(HDMessage *)aMsg {
    if (self = [super init]) {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.frame = frame;
        _msg = aMsg;
        [self setupButtonLists:aList];
        [self setupSubViews];
    }
    return self;
}

- (void)setupButtonLists:(NSArray *)aList {
    [self.btnList removeAllObjects];
    for (NSString *title in aList) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn sizeToFit];
        [self.btnList addObject:btn];
    }
}

- (void)setupSubViews {
    // TODO: 添加scrollView, submit btn, cacnel btn;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat screenW = frame.size.width;
    CGFloat screenH = frame.size.height;
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW - 80, screenH / 2)];
    itemView.backgroundColor = [UIColor whiteColor];
    itemView.center = self.center;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = @"未解决原因:";
    titleLabel.font = [UIFont systemFontOfSize:17];
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(20, 30, titleLabel.frame.size.width, titleLabel.frame.size.height);
    [itemView addSubview:titleLabel];
    
    
    CGFloat itemViewW = itemView.frame.size.width;
    CGFloat itemViewH = itemView.frame.size.height;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.layer.borderColor = [UIColor blackColor].CGColor;
    cancelBtn.layer.borderWidth = 0.5;
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    cancelBtn.frame = CGRectMake((itemViewW - SubmitBtnWidth * 2 - SubmitBtnPadding) / 2, (itemViewH - SubmitBtnPadding - SubmitBtnHeight), SubmitBtnWidth, SubmitBtnHeight);
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:cancelBtn];
    
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    submitBtn.backgroundColor = DefaultColor;
    submitBtn.frame = CGRectMake((itemViewW - SubmitBtnWidth * 2 - SubmitBtnPadding) / 2 + SubmitBtnPadding + SubmitBtnWidth, (itemViewH - SubmitBtnPadding - SubmitBtnHeight), SubmitBtnWidth, SubmitBtnHeight);
    [submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:submitBtn];
    
    
    
    CGRect scrollViewFrame = CGRectMake(30, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, itemView.frame.size.width - 60, itemView.frame.size.height - SubmitBtnHeight - SubmitBtnPadding - (titleLabel.frame.origin.y + titleLabel.frame.size.height) - 20);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    
    CGFloat flagX = 0;
    CGFloat flagY = 0;
    for (UIButton *btn in self.btnList) {

        CGRect frame = btn.frame;
        
        if (flagX + btn.frame.size.width + SubmitBtnPadding < scrollView.frame.size.width)
         {
             if (flagX != 0) {
                 frame.origin.x += flagX;
             }else {
                 frame.origin.x = 0;
             }
             frame.origin.y = flagY;
             btn.frame = frame;
             [scrollView addSubview:btn];
             flagX += frame.size.width + SubmitBtnPadding;
             continue;
         }
        
        if (flagX + btn.frame.size.width + SubmitBtnPadding >= scrollView.frame.size.width)
        {
            flagY += frame.size.height + SubmitBtnPadding;
            
            if (btn.frame.size.width > scrollView.frame.size.width) {
                frame.size.width = scrollView.frame.size.width;
            }
            frame.origin.x = 0;
            frame.origin.y = flagY;
            btn.frame = frame;
            [scrollView addSubview:btn];
            flagX = 0;
            flagY += frame.size.height + SubmitBtnPadding;
            continue;
        }
    }

    UIButton *lastBtn = self.btnList.lastObject;
    CGFloat contentY = lastBtn.frame.origin.y + lastBtn.frame.size.height;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, contentY);
    
    [itemView addSubview:scrollView];
    
    
    [self addSubview:itemView];
}

- (void)cancelBtnClicked:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissView:)]) {
        [self.delegate dismissView:self];
    }
}

- (void)submitBtnClicked:(UIButton *)btn {
    NSMutableArray *list = [NSMutableArray array];
    for (UIButton *btn in self.btnList) {
        if (btn.isSelected) {
            [list addObject:btn.titleLabel.text];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(submitView:list:message:)]) {
        [self.delegate submitView:self list:list message:_msg];
    }
}

- (void)btnDidClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    btn.backgroundColor = btn.selected ? DefaultColor : [UIColor clearColor];
}


- (NSMutableArray *)selectedList {
    if (!_selectedList) {
        _selectedList = [NSMutableArray array];
    }
    return _selectedList;
}

- (NSMutableArray *)btnList {
    if (!_btnList) {
        _btnList = [NSMutableArray array];
    }
    return _btnList;
}
@end
