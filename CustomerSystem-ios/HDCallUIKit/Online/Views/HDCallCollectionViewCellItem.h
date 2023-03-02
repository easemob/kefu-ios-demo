//
//  HDCallViewCollectionViewCellItem.h
//  HLtest
//
//  Created by houli on 2022/3/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HDCallCollectionViewCellItem : NSObject
@property (nonatomic, assign) NSInteger   uid; // Call中的属性，用于区分当前属于哪一个uid
@property (nonatomic, strong) UIView *camView;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isMute;
@property (nonatomic, assign) BOOL isVideoMute;
@property (nonatomic, assign) BOOL isWhiteboard;
@property (nonatomic, assign) NSInteger replaceUid; //需要替换的uid
@property (nonatomic, assign) NSInteger realUid; //真实uid
@property (nonatomic, strong) NSMutableArray *handleStreams;
@property (nonatomic, strong) UIView *closeCamView;
@end

NS_ASSUME_NONNULL_END
