//
//  HDCallViewCollectionViewCell.m
//  testBitCode
//
//  Created by 杜洁鹏 on 2018/5/22.
//  Copyright © 2018年 杜洁鹏. All rights reserved.
//

#import "HDCallViewCollectionViewCell.h"

@interface HDCallViewCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@end

@implementation HDCallViewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNoti:)
                                                 name:@"SelectedNotification"
                                               object:nil];
}

- (void)setItem:(HDCallViewCollectionViewCellItem *)item {
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
    self.avatarImageView.layer.borderWidth = 2;
    // 发送被选中通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedNotification"
                                                        object:nil
                                                      userInfo:@{@"item_memberName":self.item.memberName ? :[NSString stringWithFormat:@"%lud",self.item.uid]}];
    _item.isSelected = YES;
}

// 接收被选中通知，如果被选中的不是self，则将self设置为未选中状态
- (void)receiveNoti:(NSNotification *)noti {
    
    if (self.item.memberName) {
    NSString *memberName = noti.userInfo[@"item_memberName"];
    if (![memberName isEqualToString:self.item.memberName]) {
        [self unSelected];
    }
    _item.isSelected = NO;
    }else{
        NSString *memberName = noti.userInfo[@"item_memberName"];
        if ([memberName integerValue] != self.item.uid) {
            [self unSelected];
        }
        _item.isSelected = NO;
        
        
    }
}

- (void)unSelected {
    self.avatarImageView.layer.borderWidth = 0;
}

@end


@implementation HDCallViewCollectionViewCellItem

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

- (NSMutableArray *)handleStreams {
    if (!_handleStreams) {
        _handleStreams = [NSMutableArray array];
    }
    
    return _handleStreams;
}
@end
