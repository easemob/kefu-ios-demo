//
//  WhiteRegisterParams.h
//  Whiteboard
//
//  Created by xuyunshi on 2022/3/22.
//

#import "WhiteObject.h"

NS_ASSUME_NONNULL_BEGIN

/// 注册自定义插件的参数类
@interface WhiteRegisterAppParams : WhiteObject

/// 插件类型名称，需要在多端保持一致
@property (nonatomic, copy) NSString* kind;
/// 插件注册额外参数，按需填
@property (nonatomic, copy) NSDictionary* appOptions;


/// 创建一个由js代码生成的自定义app
/// @param javascriptString js代码字符串
/// @param kind 插件类型名称，需要在多端保持一致
/// @param appOptions 插件注册额外参数，按需填
/// @param variable 在上述注入的javascript中，要插入的app变量名
+ (instancetype)paramsWithJavascriptString: (NSString *)javascriptString kind:(NSString *)kind appOptions:(NSDictionary *)appOptions variable:(NSString *)variable;

/// 创建一个由远端js生成的自定义app
/// @param url js地址
/// @param kind 插件类型名称，需要在多端保持一致。（白板会利用这个名字去寻找app入口)
/// @param appOptions 插件注册额外参数，按需填
+ (instancetype)paramsWithUrl: (NSString *)url kind:(NSString *)kind appOptions:(NSDictionary *)appOptions;

@end

NS_ASSUME_NONNULL_END
