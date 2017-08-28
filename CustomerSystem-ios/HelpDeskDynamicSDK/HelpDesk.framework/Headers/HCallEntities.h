//
//  HCallEntities.h
//  helpdesk_sdk
//
//  Created by afanda on 8/22/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HCallStreamType) {
    HCallStreamTypeNormal,  //正常消息
    HCallStreamTypeDeskTop  //桌面分享
};

@interface HCallMember : NSObject
@property (nonatomic, readonly) NSString * memberName;
@property (nonatomic, readonly) NSDictionary * extension;
@end

@interface HCallStream : NSObject
@property (nonatomic, readonly) NSString * streamId;
@property (nonatomic, readonly) NSString * streamName;
@property (nonatomic, readonly) NSString * memberName;
@property (nonatomic, readonly) HCallStreamType streamType;
@property (nonatomic, readonly) BOOL videoOff;
@property (nonatomic, readonly) BOOL audioOff;
@property (nonatomic, readonly) NSString * extension;
@end
