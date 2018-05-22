//
//  HCallViewCollectionViewCell.h
//  testBitCode
//
//  Created by 杜洁鹏 on 2018/5/22.
//  Copyright © 2018年 杜洁鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCallViewCollectionViewCellItem;
@interface HCallViewCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) HCallViewCollectionViewCellItem *item;
- (void)selected;
@end

@interface HCallViewCollectionViewCellItem : NSObject
@property (nonatomic, strong) NSString *memberName;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) UIView *camView;
@property (nonatomic, assign) BOOL isSelected;

- (instancetype)initWithAvatarURI:(NSString *)aUrl
                     defaultImage:(UIImage *)aImage
                         nickname:(NSString *)aNickname;
@end
