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
        numberLabel.font = [UIFont systemFontOfSize:12];
        numberLabel.textAlignment = NSTextAlignmentLeft;
        [numberLabel setTextColor:RGBACOLOR(98, 98, 98, 1)];
        self.numberLabel = numberLabel;
        [self.contentView addSubview:self.numberLabel];
        
        UILabel *netValueLabel = [[UILabel alloc] init];
        netValueLabel.font = [UIFont systemFontOfSize:17];
        netValueLabel.textAlignment = NSTextAlignmentCenter;
        [netValueLabel setTextColor:RGBACOLOR(255, 91, 91, 1)];
        self.netValueLabel = netValueLabel;
        [self.contentView addSubview:self.netValueLabel];
        
        UILabel *riseLabel = [[UILabel alloc] init];
        riseLabel.font = [UIFont systemFontOfSize:17];
        riseLabel.textAlignment = NSTextAlignmentCenter;
        [riseLabel setTextColor:RGBACOLOR(255, 91, 91, 1)];
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
    self.nameLabel.frame = CGRectMake(18, 14, 160, 17);
    self.numberLabel.frame = CGRectMake(18, CGRectGetMaxY(self.nameLabel.frame) + 7, 50, 14);
    self.netValueLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + kScreenWidth * 0.024, 24, 60, 17);
    self.riseLabel.frame = CGRectMake(kScreenWidth - kScreenWidth*0.053 - 63, 24, 63, 17);
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
