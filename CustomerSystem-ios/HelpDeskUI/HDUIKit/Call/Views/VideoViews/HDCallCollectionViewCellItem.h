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
@property (nonatomic, strong) NSString *  uid; // Call中的属性，用于区分当前属于哪一个uid
@property (nonatomic, strong) UIView *camView;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSMutableArray *handleStreams;
@end

NS_ASSUME_NONNULL_END
