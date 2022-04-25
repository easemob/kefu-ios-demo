//
//  WhiteVideoView.h
//  WhiteCombinePlayer
//
//  Created by yleaf on 2019/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AVPlayer;
/** 本地视频界面。 */
@interface WhiteVideoView : UIView

/**
 设置用 AVPlayer 播放本地视频。

 @param player AVPlayer。 
 */
- (void)setAVPlayer:(AVPlayer *)player;

@end

NS_ASSUME_NONNULL_END
