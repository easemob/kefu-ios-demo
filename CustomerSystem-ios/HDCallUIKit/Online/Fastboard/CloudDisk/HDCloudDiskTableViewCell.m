//
//  HDCloudDiskTableViewCell.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/8.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDCloudDiskTableViewCell.h"
#import "UIImage+HDIconFont.h"
#import "HDAppSkin.h"
@implementation HDCloudDiskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCloudDiskModel:(HDCloudDiskModel *)model{
    
    
    switch (model.fileType) {
        case HDFastBoardFileTypeimg:
            self.iconImg.image = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:22 color:[[HDAppSkin mainSkin] contentColorGray1] ];
            break;
        case HDFastBoardFileTypepdf:
            self.iconImg.image = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:22 color:[[HDAppSkin mainSkin] contentColorGray1] ];
            break;
        case HDFastBoardFileTypeppt:
            self.iconImg.image = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:22 color:[[HDAppSkin mainSkin] contentColorGray1] ];
            break;
        case HDFastBoardFileTypemusic:
            self.iconImg.image = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:22 color:[[HDAppSkin mainSkin] contentColorGray1] ];
            break;
        case HDFastBoardFileTypevideo:
            self.iconImg.image = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:22 color:[[HDAppSkin mainSkin] contentColorGray1] ];
            break;
        case HDFastBoardFileTypeword:
            self.iconImg.image = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:22 color:[[HDAppSkin mainSkin] contentColorGray1] ];
            break;
        default:
            self.iconImg.image = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:22 color:[[HDAppSkin mainSkin] contentColorGray1] ];
            break;
    }
    
    self.fileName.text = model.fileName;
    self.fileSizeLabel.text = model.fileSize;
    self.uploadDateLabel.text = model.uploadDate;

}

@end
