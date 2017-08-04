//
//  HDBubbleView.h+Article.m
//  CustomerSystem-ios
//
//  Created by afanda on 8/2/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HDBubbleView+Article.h"

#define kTitleFontSize 15
#define kTimeFontSize 10
#define kDigistFontSize 10
#define kMarginNormal 10


@implementation HDSubItem

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (dic != nil) {
        _type = HDCellTypeSub;
        _title = [dic objectForKey:@"title"];
        _createTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createdTime"]];
        _digest = [dic objectForKey:@"digest"];
        _imageUrl = [dic objectForKey:@"thumbUrl"];
        _url = [dic objectForKey:@"url"];
    }
    return self;
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
            cell.textLabel.text = @"阅读全文";
            return cell;
        }
        return nil;
    }
    cell = (HDSubCell *)[[HDSubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    HDSubItem *item = self.subModels[indexPath.row];
    if (indexPath.row == 0) {
        item.type = HDCellTypeTitle;
    } else {
        item.type = HDCellTypeSub;
    }
    ((HDSubCell *)cell).model = item;
    return cell;
}

- (CGFloat)articleTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.subModels.count == 1) { //style:detail
        HDSubItem *item = [self.subModels firstObject];
        CGSize size = CGSizeMake(self.width-2*kMarginNormal, MAXFLOAT);
        if (indexPath.row == 0) {
            CGFloat titleH = [NSString rectOfString:item.title fontSize:kTitleFontSize size:size].size.height;
            CGFloat timeH = 15;
            CGFloat imageH = 120;
            CGFloat digistH = [NSString rectOfString:item.digest fontSize:kDigistFontSize size:size].size.height;
            if (digistH>50) {
                digistH = 50;
            }
            return titleH+timeH+imageH+digistH+2*kMarginNormal;
        }
        if (indexPath.row == 1) {
            return 44;
        }
    } else {//style:sub
        if (indexPath.row == 0) {
            return 180;
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
    CGSize size = CGSizeMake(self.width-20, MAXFLOAT);
    CGRect rect = [model.title boundingRectWithSize:size options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    _titleLabel.frame = CGRectMake(kLeftMargin, kTopMargin, self.width-2*kLeftMargin, rect.size.height);
    
    _timeLabel.frame = CGRectMake(kLeftMargin, CGRectGetMaxY(_titleLabel.frame), 200,15);
    
    _titleLabel.text = model.title;
    _timeLabel.text = model.createTime;
    _imageView.frame = CGRectMake(10, CGRectGetMaxY(_timeLabel.frame), self.width-20, 130);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl] placeholderImage:nil];
    CGRect imgRect = [model.digest boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
    _profile.frame = CGRectMake(10, CGRectGetMaxY(_imageView.frame), self.width-20, imgRect.size.height);
    _profile.text = _model.digest;
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
    }
    return self;
}

- (void)setUI {
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    _titleLabel.textColor = [UIColor redColor];
    _titleLabel.numberOfLines = 0 ;
    [self.contentView addSubview:_titleLabel];
}

- (void)setModel:(HDSubItem *)model {
    _model = model;
    if (_model.type == HDCellTypeTitle) {
        _titleLabel.text = model.title;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:nil];
    }
    if (_model.type == HDCellTypeSub) {
        _titleLabel.text = model.title;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:nil];
    }
}

- (void)layoutSubviews {
    CGFloat wh = self.height-20;
    if (_model.type == HDCellTypeTitle) {
        _titleLabel.frame = CGRectMake(10, self.height-20, self.width-20, 15);
        _imageView.frame = CGRectMake(10, 10, self.width-20, self.height-10);
    }
    if (_model.type == HDCellTypeSub) {
        CGSize size = CGSizeMake(self.width-20-wh-10, MAXFLOAT);
        CGRect rect = [_model.title boundingRectWithSize:size options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
        CGFloat height = rect.size.height > wh ? wh:rect.size.height;
        _titleLabel.frame = CGRectMake(10, 10, self.width-20-wh-10, height);
        _imageView.frame = CGRectMake(self.width-wh-10, 10, wh, wh);
    }
}


@end








