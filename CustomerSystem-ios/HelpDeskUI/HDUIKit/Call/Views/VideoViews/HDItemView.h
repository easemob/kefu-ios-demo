//
//  HDItemVIew.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/3/21.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDItemView : UIView
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIButton *nickNameBtn;
@property (nonatomic, strong) UIButton *muteBtn;
- (void)setItemString:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
