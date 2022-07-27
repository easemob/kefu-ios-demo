//
//  HDMiddleVideoView.h
//  HLtest
//
//  Created by houli on 2022/3/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDMiddleVideoView : UIView
@property (nonatomic, strong) UIImageView *bgImgView;
//@property (nonatomic, strong) UIView *subView;
@property(nonatomic ,assign)BOOL *isLandscape; // 判断是横竖屏 默认竖屏
@end

NS_ASSUME_NONNULL_END
