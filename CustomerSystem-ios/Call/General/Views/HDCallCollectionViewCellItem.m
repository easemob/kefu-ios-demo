//
//  HDCallViewCollectionViewCellItem.m
//  HLtest
//
//  Created by houli on 2022/3/8.
//

#import "HDCallCollectionViewCellItem.h"

@implementation HDCallCollectionViewCellItem
- (instancetype)initWithAvatarURI:(NSString *)aUrl
                     defaultImage:(UIImage *)aImage
                         nickname:(NSString *)aNickname {
    if (self = [super init]) {
       
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
