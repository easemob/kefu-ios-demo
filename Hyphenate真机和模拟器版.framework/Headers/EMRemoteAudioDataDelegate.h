//
//  EMRemoteAudioDataDelegate.h
//  HyphenateSDK
//
//  Created by 杜洁鹏 on 2020/7/24.
//  Copyright © 2020 easemob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EMRemoteAudioDataDelegate <NSObject>
- (void)onRemoteAudioData:(NSData *)mData
                 dataSize:(int)mDataSize
               sampleRate:(int)mDataSampleRate
                  channel:(int)mChannel;
@end

NS_ASSUME_NONNULL_END
