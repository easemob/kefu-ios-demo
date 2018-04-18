//
//  CommodityInfoView.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/5/31.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import "CommodityInfoView.h"


@interface CommodityInfoView ()
{
    NSInteger _tagNumber;
    CGRect _frame;
}
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *money;
@property (nonatomic, strong) UILabel *novemberSales;
@property (nonatomic, strong) UILabel *originalPrice;

@property (nonatomic, strong) NSArray *comDataSource;



@end

@implementation CommodityInfoView

- (instancetype)initWithFrame:(CGRect)frame tag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"commodityInfo.plist" ofType:nil];
        _comDataSource = [NSArray arrayWithContentsOfFile:path];
        [self setUIWidth:frame.size.width height:frame.size.height tagNum:tag];
    }
    return self;
}

- (void)setUIWidth:(CGFloat)width height:(CGFloat)height tagNum:(NSInteger)tag
{
    CGFloat space = 5;
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, width*0.6, height*0.8)];
    self.name.text = NSLocalizedString([_comDataSource[tag] objectForKey:@"name"], @"em_example1_text");
    self.name.numberOfLines = 2;
    self.name.lineBreakMode = NSLineBreakByCharWrapping;
    self.name.font = [UIFont systemFontOfSize:13];
    self.name.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.name];
    if (tag == 3) {
        _frame = CGRectMake(width - width/3.5 - space*4, space + 5, width*0.35, height/3);
    } else {
        _frame = CGRectMake(width - width/3 - space, space + 5, width*0.3, height/3);
    }
    self.money = [[UILabel alloc] initWithFrame:_frame];
    self.money.text = [_comDataSource[tag] objectForKey:@"money"];
    self.money.font = [UIFont systemFontOfSize:12];
    self.money.textAlignment = NSTextAlignmentRight;
    self.money.textColor = [UIColor redColor];
    [self addSubview:self.money];
    
    self.novemberSales = [[UILabel alloc] initWithFrame:CGRectMake(space, CGRectGetMaxY(self.name.frame), width*0.7, height*0.2)];
    self.novemberSales.text = NSLocalizedString([_comDataSource[tag] objectForKey:@"novemberSales"], @"em_example1_text_description");
    self.novemberSales.font = [UIFont systemFontOfSize:8];
    self.name.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.novemberSales];
    
    self.originalPrice = [[UILabel alloc] initWithFrame:CGRectMake(width - width/3 - space, CGRectGetMaxY(self.name.frame), width*0.3, height*0.2)];
    self.originalPrice.font = [UIFont systemFontOfSize:8];
    self.originalPrice.textAlignment = NSTextAlignmentRight;

    NSString *textStr = [_comDataSource[tag] objectForKey:@"originalPrice"];
    
//    中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    
    // 赋值
    self.originalPrice.attributedText = attribtStr;
    [self addSubview:self.originalPrice];
    
    
    
}






@end
