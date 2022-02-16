//
//  HDCallViewCollectionViewCell.h
//  testBitCode
//
//  Created by 杜洁鹏 on 2018/5/22.
//  Copyright © 2018年 杜洁鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDCallViewCollectionViewCellItem;
@interface HDCallViewCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) HDCallViewCollectionViewCellItem *item;
- (void)selected;
@end

@interface HDCallViewCollectionViewCellItem : NSObject
@property (nonatomic, strong) NSString *memberName; // Call中的属性，用于区分当前属于哪一个member
@property (nonatomic, assign) NSInteger  uid; // Call中的属性，用于区分当前属于哪一个uid
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) UIView *camView;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSMutableArray *handleStreams;

- (instancetype)initWithAvatarURI:(NSString *)aUrl
                     defaultImage:(UIImage *)aImage
                         nickname:(NSString *)aNickname;
@end
