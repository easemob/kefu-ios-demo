//
//  HDCustomJSObject.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/6/9.
//  Copyright © 2022 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^HDJSObjectBlock)(NSDictionary *dic);

@protocol HDCustomJSProtocol <JSExport>
//Html调用OC方法
- (void)helloWQL;

//从html传一个值给OC
- (void)sendValueFromHtmlToOCWithValue:(NSString*)value;

//从html传两个值给OC
- (void)sendValueFromHtmlToOCWithValue:(NSString*)value WithValueTwo:(NSString*)valueTwo;

//从OC传值给Html
- (void)sendValueToHtml;

@end
@interface HDCustomJSObject : NSObject<HDCustomJSProtocol>
- (id)initWithSuccessCallback:(HDJSObjectBlock)success faileCallback:(HDJSObjectBlock)fail;

@end

NS_ASSUME_NONNULL_END
