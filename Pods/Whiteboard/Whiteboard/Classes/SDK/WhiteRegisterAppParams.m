//
//  WhiteRegisterParams.m
//  Whiteboard
//
//  Created by xuyunshi on 2022/3/22.
//

#import "WhiteRegisterAppParams.h"

@interface WhiteJavascriptStringRegisterAppParams : WhiteRegisterAppParams
@property (nonatomic, copy) NSString* javascriptString;
@property (nonatomic, copy) NSString* variable;
@end

@implementation WhiteJavascriptStringRegisterAppParams
@end

@interface WhiteUrlRegisterAppParams : WhiteRegisterAppParams
@property (nonatomic, copy) NSString* url;
@end

@implementation WhiteUrlRegisterAppParams
@end


@implementation WhiteRegisterAppParams

+ (instancetype)paramsWithJavascriptString:(NSString *)javascriptString kind:(NSString *)kind appOptions:(NSDictionary *)appOptions variable:(NSString *)variable {
    WhiteJavascriptStringRegisterAppParams* obj = [WhiteJavascriptStringRegisterAppParams new];
    obj.kind = kind;
    obj.javascriptString = javascriptString;
    obj.appOptions = appOptions;
    obj.variable = variable;
    return obj;
}

+ (instancetype)paramsWithUrl:(NSString *)url kind:(NSString *)kind appOptions:(NSDictionary *)appOptions {
    WhiteUrlRegisterAppParams* obj = [WhiteUrlRegisterAppParams new];
    obj.kind = kind;
    obj.url = url;
    obj.appOptions = appOptions;
    return obj;
}

@end
