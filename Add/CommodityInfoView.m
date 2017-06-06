//
//  CommodityInfoView.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/5/31.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import "CommodityInfoView.h"
#import "MallViewController.h"

@interface CommodityInfoView ()
{
    NSInteger _tagNumber;
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
        NSLog(@"1--%lf", frame.size.width);
    }
    return self;
}

- (void)setUIWidth:(CGFloat)width height:(CGFloat)height tagNum:(NSInteger)tag
{
    CGFloat space = 5;
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, width/1.5, height/1.5)];
    self.name.text = [_comDataSource[tag] objectForKey:@"name"];
    self.name.font = [UIFont systemFontOfSize:15];
    self.name.textAlignment = UITextAlignmentLeft;
    [self addSubview:self.name];
    
    self.money = [[UILabel alloc] initWithFrame:CGRectMake(width - width/3 - space, space + 2, width/3, height/3)];
    self.money.text = [_comDataSource[tag] objectForKey:@"money"];
    self.money.font = [UIFont systemFontOfSize:13];
    self.money.textAlignment = UITextAlignmentRight;
    self.money.textColor = [UIColor redColor];
    [self addSubview:self.money];
    
    self.novemberSales = [[UILabel alloc] initWithFrame:CGRectMake(space, CGRectGetMaxY(self.name.frame), width/3, height/3)];
    self.novemberSales.text = [_comDataSource[tag] objectForKey:@"novemberSales"];
    self.novemberSales.font = [UIFont systemFontOfSize:8];
    self.name.textAlignment = UITextAlignmentLeft;
    [self addSubview:self.novemberSales];
    
    self.originalPrice = [[UILabel alloc] initWithFrame:CGRectMake(width - width/3 - space, CGRectGetMaxY(self.name.frame), width/3, height/3)];
    self.originalPrice.font = [UIFont systemFontOfSize:8];
    self.originalPrice.textAlignment = UITextAlignmentRight;

    NSString *textStr = [_comDataSource[tag] objectForKey:@"originalPrice"];
    
//    中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    
    // 赋值
    self.originalPrice.attributedText = attribtStr;
    [self addSubview:self.originalPrice];
    
    
    
}






@end
