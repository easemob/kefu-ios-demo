//
//  HCallViewCollectionViewCell.m
//  testBitCode
//
//  Created by 杜洁鹏 on 2018/5/22.
//  Copyright © 2018年 杜洁鹏. All rights reserved.
//

#import "HCallViewCollectionViewCell.h"

@interface HCallViewCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@end

@implementation HCallViewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNoti:)
                                                 name:@"SelectedNotification"
                                               object:nil];
}

- (void)setItem:(HCallViewCollectionViewCellItem *)item {
    _item = item;
    self.avatarImageView.image = _item.defaultImage; // 可能需要用sdWebImage根据url设置
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.nicknameLabel.text = _item.nickname;
    if (_item.isSelected) {
        [self selected];
    }else {
        [self unSelected];
    }
}

- (void)selected {
    self.avatarImageView.layer.borderWidth = 3;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedNotification"
                                                        object:nil
                                                      userInfo:@{@"item_memberName":self.item.memberName}];
    _item.isSelected = YES;
}

- (void)receiveNoti:(NSNotification *)noti {
    NSString *memberName = noti.userInfo[@"item_memberName"];
    if (![memberName isEqualToString:self.item.memberName]) {
        [self unSelected];
    }
    _item.isSelected = NO;
}

- (void)unSelected {
    self.avatarImageView.layer.borderWidth = 0;
}

@end


@implementation HCallViewCollectionViewCellItem

- (instancetype)initWithAvatarURI:(NSString *)aUrl
                     defaultImage:(UIImage *)aImage
                         nickname:(NSString *)aNickname {
    if (self = [super init]) {
        _avatarUrl = aUrl;
        _defaultImage = aImage;
        _nickname = aNickname;
    }
    
    return self;
}
@end
