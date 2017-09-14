//
//  HDBubbleView.h+Article.h
//  CustomerSystem-ios
//
//  Created by afanda on 8/2/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import "HDBubbleView.h"


#pragma mark - model

#define kTitleFontSize 15
#define kProfileFontSize 12
#define kTopMargin 10
#define kLeftMargin 10
#define kTitleImageHeight 180
#define kTitleFontSize 15
#define kTimeFontSize 10
#define kDigistFontSize 10
#define kMarginNormal 10


typedef NS_ENUM(NSUInteger, HDCellType) {
    HDCellTypeTitle = 0,
    HDCellTypeSub
};

@interface  HDSubItem: NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@property(nonatomic,assign) HDCellType type;

@property(nonatomic,strong) NSString *createTime; //创建时间

@property(nonatomic,strong) NSString *title; //标题

@property(nonatomic,strong) NSString *imageUrl; //图片url

@property(nonatomic,strong) NSString *url;  //跳转url

@property(nonatomic,strong) NSString *digest; //简介

@end

#pragma makr - view

@interface HDBubbleView (Article) <HDArticleViewDelegate>



- (void)setupArticleuBubbleView;

- (void)updateArticleMargin:(UIEdgeInsets)margin;


- (void)reloadArticleData;

@end


#pragma mark cell

//有详情的cell
@interface HDDetailTitleCell : UITableViewCell

@property(nonatomic,strong) HDSubItem *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

//sub CELL

@interface HDSubCell : UITableViewCell

@property(nonatomic,strong) HDSubItem *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end




