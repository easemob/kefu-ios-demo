//
//  HDBubbleView.h+Article.m
//  CustomerSystem-ios
//
//  Created by afanda on 8/2/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HDBubbleView+Article.h"
#import <CoreGraphics/CoreGraphics.h>
#import "NSString+HDValid.h"
#import <UIKit/UIKit.h>


@implementation HDSubItem

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (dic != nil) {
        _type = HDCellTypeSub;
        _title = [dic objectForKey:@"title"];
        double createTime = [[NSDate date] timeIntervalSince1970] * 1000;
        if ([dic objectForKey:@"createdTime"]) {
            createTime = [[dic objectForKey:@"createdTime"] doubleValue];
        }
        _createTime = [self timeFormatter:createTime/1000];
        _digest = [dic objectForKey:@"digest"];
        _imageUrl = [dic objectForKey:@"thumbUrl"];
        _url = [dic objectForKey:@"url"];
    }
    return self;
}

- (NSString *)timeFormatter:(NSTimeInterval)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timeS = [dateFormatter stringFromDate:theday];
    return timeS;
}

@end

@implementation HDBubbleView (Article)

- (void)_setupArticleBubbleMarginConstraints {
    [self.marginConstraints removeAllObjects];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.articleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.articleView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.articleView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
    [self.marginConstraints addObject:topConstraint];
    [self.marginConstraints addObject:leftConstraint];
    [self.marginConstraints addObject:rightConstraint];
    [self addConstraints:self.marginConstraints];
}

- (void)_setupArticleBubbleConstraints {
    [self _setupArticleBubbleMarginConstraints];
    [self  addConstraint:[NSLayoutConstraint constraintWithItem:self.articleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:-self.margin.top-self.margin.bottom]];
}


- (void)setupArticleuBubbleView {
    self.articleView = [[HDArticleView alloc] initWithFrame:CGRectZero];
    self.articleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.articleView.delegate = self;
    [self.backgroundImageView addSubview:self.articleView];
    [self _setupArticleBubbleConstraints];
}

- (void)updateArticleMargin:(UIEdgeInsets)margin {
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self _setupArticleBubbleConstraints];
}

- (void)reloadArticleData {
    
    [self removeConstraints:self.marginConstraints];
    [self _setupArticleBubbleMarginConstraints];
    [self.articleView reloadData];
}

#pragma mark - articleTableViewDelegate

- (NSInteger)articleViewNumberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)articleViewTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.subModels.count ==1) {
        return 2;
    }
    return self.subModels.count;
}
- (UITableViewCell *)articleViewTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (self.subModels.count == 1) { //没有sub cell
        if (indexPath.row == 0) {
            HDSubItem *subItem = self.subModels[indexPath.row];
           cell = (HDDetailTitleCell *)[[HDDetailTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            ((HDDetailTitleCell *)cell).model = subItem;
            return cell;
        }
        if (indexPath.row == 1) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.contentView.tag = 1990;
            cell.textLabel.text = @"阅读全文";
            return cell;
        }
        return nil;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:@"subcell"];
    if (cell == nil) {
        cell = (HDSubCell *)[[HDSubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    HDSubItem *item = self.subModels[indexPath.row];
    if (indexPath.row == 0) {
        item.type = HDCellTypeTitle;
    } else {
        item.type = HDCellTypeSub;
    }
    ((HDSubCell *)cell).model = item;
    return cell;
}

- (void)articleTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger itemIndex = indexPath.row ;
    if (self.subModels.count == 1) {//style:detail
        itemIndex = 0;
    }
    HDSubItem *item =self.subModels[itemIndex];
    [self routerEventWithName:HRouterEventTapArticle userInfo:@{
                                                                @"url":item.url
                                                             }];
}

- (CGFloat)articleTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.subModels.count == 1) { //style:detail
        HDSubItem *item = [self.subModels firstObject];
        CGSize size = CGSizeMake(kScreenWidth-2*kLeftMargin-2*kLeftMargin, MAXFLOAT);
        if (indexPath.row == 0) {
            CGFloat titleH = kTitleFontSize;
            CGFloat timeH = kDigistFontSize;
            CGFloat imageH = kTitleImageHeight;
            CGFloat digistH = [NSString rectOfString:item.digest fontSize:kDigistFontSize size:size].size.height;
            CGFloat h = titleH+timeH+imageH+digistH+6*kMarginNormal;
            return h;
        }
        if (indexPath.row == 1) {
            return 44;
        }
    } else {//style:sub
        if (indexPath.row == 0) {
            return kTitleImageHeight;
        }
        return 70;
    }
    return 44;
}

@end


@implementation HDDetailTitleCell
{
    UILabel *_titleLabel;   //标题
    UILabel *_timeLabel;    //时间
    UIImageView *_imageView; //图片
    UILabel *_profile;  //简介
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.contentView.tag = 1990; //tag 避免controller 拦截手势
    }
    return self;
}



- (void)setUI {
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    //时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:kTimeFontSize];
    [self.contentView addSubview:_timeLabel];
    //图片
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode= UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
    //简介
    _profile = [[UILabel alloc] init];
    _profile.textColor = [UIColor lightGrayColor];
    _profile.numberOfLines = 0;
    _profile.font = [UIFont systemFontOfSize:kDigistFontSize];
    [self.contentView addSubview:_profile];
}

- (void)setModel:(HDSubItem *)model {
    _model = model;
    _titleLabel.text = model.title;
    _timeLabel.text = model.createTime;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl] placeholderImage:nil];
    _profile.text = _model.digest;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    //    CGContextSetStrokeColorWithColor(context, RGBACOLOR(229, 230, 231, 1).CGColor);
    //    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 0.5));
    //下分割线
    CGContextSetStrokeColorWithColor(context, RGBACOLOR(0xe5, 0xe5, 0xe5, 1).CGColor);
    CGContextStrokeRect(context, CGRectMake(kLeftMargin, rect.size.height - 0.5, rect.size.width-2*kLeftMargin, 0.5f));
}

- (void)layoutSubviews {
    CGSize size = CGSizeMake(self.width-2*kLeftMargin, MAXFLOAT);
    _titleLabel.frame = CGRectMake(kLeftMargin, kTopMargin, self.width-2*kLeftMargin, kTitleFontSize);
    _timeLabel.frame = CGRectMake(kLeftMargin, CGRectGetMaxY(_titleLabel.frame)+kTopMargin, 200,kDigistFontSize);
    _imageView.frame = CGRectMake(kLeftMargin, CGRectGetMaxY(_timeLabel.frame)+kTopMargin, self.width-2*kLeftMargin, kTitleImageHeight);
    CGRect imgRect = [_model.digest boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kDigistFontSize]} context:nil];
    _profile.frame = CGRectMake(kLeftMargin, CGRectGetMaxY(_imageView.frame)+kTopMargin, self.width-2*kLeftMargin, imgRect.size.height+kTopMargin);
}

@end

@implementation HDSubCell
{
    UILabel *_titleLabel;
    UIImageView *_imageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.contentView.tag = 1990; //tag 避免controller 拦截手势
    }
    return self;
}

- (void)setUI {
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.numberOfLines = 0 ;
    [self.contentView addSubview:_titleLabel];
}

- (void)setModel:(HDSubItem *)model {
    _model = model;
    if (_model.type == HDCellTypeTitle) {
        _titleLabel.textColor = [UIColor whiteColor];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:nil];
    }
    if (_model.type == HDCellTypeSub) {
        
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:nil];
    }
    _titleLabel.text = model.title;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    //    CGContextSetStrokeColorWithColor(context, RGBACOLOR(229, 230, 231, 1).CGColor);
    //    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 0.5));
    //下分割线
    CGContextSetStrokeColorWithColor(context, RGBACOLOR(0xe5, 0xe5, 0xe5, 1).CGColor);
    CGContextStrokeRect(context, CGRectMake(kLeftMargin, rect.size.height - 0.5, rect.size.width-2*kLeftMargin, 0.5f));
}

- (void)layoutSubviews {
    CGFloat wh = self.height-20;
    if (_model.type == HDCellTypeTitle) {
        _titleLabel.frame = CGRectMake(10, self.height-kTopMargin-20, self.width-20, 15);
        _imageView.frame = CGRectMake(10, 10, self.width-2*kLeftMargin, self.height-2*kTopMargin);
    }
    if (_model.type == HDCellTypeSub) {
        CGSize size = CGSizeMake(self.width-20-wh-10, MAXFLOAT);
        CGRect rect = [_model.title boundingRectWithSize:size options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
        CGFloat height = rect.size.height > wh ? wh:rect.size.height;
        _titleLabel.frame = CGRectMake(kLeftMargin, kTopMargin, self.width-20-wh-10, height);
        _imageView.frame = CGRectMake(self.width-wh-10, 10, wh, wh);
    }
}


@end








