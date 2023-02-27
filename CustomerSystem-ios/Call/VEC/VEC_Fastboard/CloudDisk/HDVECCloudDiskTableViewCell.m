//
//  HDCloudDiskTableViewCell.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/4/8.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDVECCloudDiskTableViewCell.h"
#import "UIImage+HDIconFont.h"
#import "HDAppSkin.h"
@implementation HDVECCloudDiskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCloudDiskModel:(HDVECCloudDiskModel *)model{
    
    
    switch (model.fileType) {
        case HDVECFastBoardFileTypeimg:
            self.iconImg.image = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:22 color:[[HDVECAppSkin mainSkin] contentColorGray1] ];
            break;
        case HDVECFastBoardFileTypepdf:
            self.iconImg.image = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:22 color:[[HDVECAppSkin mainSkin] contentColorGray1] ];
            break;
        case HDVECFastBoardFileTypeppt:
            self.iconImg.image = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:22 color:[[HDVECAppSkin mainSkin] contentColorGray1] ];
            break;
        case HDVECFastBoardFileTypemusic:
            self.iconImg.image = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:22 color:[[HDVECAppSkin mainSkin] contentColorGray1] ];
            break;
        case HDVECFastBoardFileTypevideo:
            self.iconImg.image = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:22 color:[[HDVECAppSkin mainSkin] contentColorGray1] ];
            break;
        case HDVECFastBoardFileTypeword:
            self.iconImg.image = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:22 color:[[HDVECAppSkin mainSkin] contentColorGray1] ];
            break;
        default:
            self.iconImg.image = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:22 color:[[HDVECAppSkin mainSkin] contentColorGray1] ];
            break;
    }
    
    self.fileName.text = model.fileName;
    self.fileSizeLabel.text = model.fileSize;
    self.uploadDateLabel.text = model.uploadDate;

}

@end
