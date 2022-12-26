//
//  HDVideoVerticalAlignmentLabel.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/5/12.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum VerticalAlignment {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
    
} VerticalAlignment;
@interface HDVideoVerticalAlignmentLabel : UILabel{
@private VerticalAlignment verticalAlignment_;
}
@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@end

NS_ASSUME_NONNULL_END
