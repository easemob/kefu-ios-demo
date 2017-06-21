//
//  HotFundCell.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 17/6/20.
//  Copyright © 2017年 easemob. All rights reserved.
//

#import "HotFundCell.h"
#import "HotFundModel.h"

@interface HotFundCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *netValueLabel;
@property (nonatomic, strong) UILabel *riseLabel;
@end

@implementation HotFundCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:17];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel = nameLabel;
        [self.contentView addSubview:self.nameLabel];
        
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.font = [UIFont systemFontOfSize:10];
        numberLabel.textAlignment = NSTextAlignmentLeft;
        [numberLabel setTextColor:[UIColor grayColor]];
        self.numberLabel = numberLabel;
        [self.contentView addSubview:self.numberLabel];
        
        UILabel *netValueLabel = [[UILabel alloc] init];
        netValueLabel.font = [UIFont systemFontOfSize:16];
        netValueLabel.textAlignment = NSTextAlignmentCenter;
        [netValueLabel setTextColor:[UIColor redColor]];
        self.netValueLabel = netValueLabel;
        [self.contentView addSubview:self.netValueLabel];
        
        UILabel *riseLabel = [[UILabel alloc] init];
        riseLabel.font = [UIFont systemFontOfSize:16];
        riseLabel.textAlignment = NSTextAlignmentCenter;
        [riseLabel setTextColor:[UIColor redColor]];
        self.riseLabel = riseLabel;
        [self.contentView addSubview:self.riseLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    
    CGContextFillRect(context, rect);
    
    //上分割线，
    CGContextSetStrokeColorWithColor(context,RGBACOLOR(216, 216, 216, 1).CGColor);
    CGContextStrokeRect(context,CGRectMake(0, -1, kScreenWidth,1));
    
//    //下分割线
//    CGContextSetStrokeColorWithColor(context,RGBACOLOR(216, 216, 216, 1).CGColor);
//    CGContextStrokeRect(context,CGRectMake(0, rect.size.height, kScreenWidth,1));
}

- (void)layoutSubviews
{
    self.nameLabel.frame = CGRectMake(10, 10, self.size.width*0.4, self.size.height/2);
    self.numberLabel.frame = CGRectMake(10, CGRectGetMaxY(self.nameLabel.frame), self.size.width/4, self.size.height/4);
    self.netValueLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame), (self.size.height - self.size.height/3)/2, self.size.width * 0.3, self.size.height/3);
    self.riseLabel.frame = CGRectMake(CGRectGetMaxX(self.netValueLabel.frame), self.netValueLabel.frame.origin.y, self.size.width * 0.3, self.size.height/3);
}

- (void)setHotFundModel:(HotFundModel *)hotFundModel
{
    _hotFundModel = hotFundModel;
    self.nameLabel.text = hotFundModel.name;
    self.numberLabel.text = hotFundModel.number;
    self.netValueLabel.text = hotFundModel.netValue;
    self.riseLabel.text = hotFundModel.rise;
}

@end
