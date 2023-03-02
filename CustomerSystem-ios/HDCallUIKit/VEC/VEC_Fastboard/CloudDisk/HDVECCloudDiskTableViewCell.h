//
//  HDCloudDiskTableViewCell.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/8.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDVECCloudDiskModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDVECCloudDiskTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *uploadDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;


/// 设置界面显示model
/// @param model  model
- (void)setCloudDiskModel:(HDVECCloudDiskModel *)model;

@end

NS_ASSUME_NONNULL_END
