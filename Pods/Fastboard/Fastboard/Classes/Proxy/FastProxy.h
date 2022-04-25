//
//  FastProxy.h
//  Fastboard
//
//  Created by xuyunshi on 2021/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FastProxy : NSProxy

@property (weak, nonatomic, nullable) id target;
@property (weak, nonatomic, nullable) id middleMan;

+ (instancetype)target: (id _Nullable)target middleMan: (id _Nullable)middleMan;

@end

NS_ASSUME_NONNULL_END
