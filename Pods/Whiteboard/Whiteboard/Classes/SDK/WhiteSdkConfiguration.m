//
//  WhiteSdkConfiguration.m
//  WhiteSDK
//
//  Created by leavesster on 2018/8/15.
//

#import "WhiteSdkConfiguration.h"
#import "WhiteSdkConfiguration+Private.h"
#import "WhiteSDK.h"
#import <sys/utsname.h>

@implementation WhitePptParams

- (instancetype)init {
    self = [super init];
    _useServerWrap = YES;
    return self;
}

@end

WhiteSdkRenderEngineKey const WhiteSdkRenderEngineSvg = @"svg";
WhiteSdkRenderEngineKey const WhiteSdkRenderEngineCanvas = @"canvas";

WhiteSDKLoggerOptionLevelKey const WhiteSDKLoggerOptionLevelDebug = @"debug";
WhiteSDKLoggerOptionLevelKey const WhiteSDKLoggerOptionLevelInfo = @"info";
WhiteSDKLoggerOptionLevelKey const WhiteSDKLoggerOptionLevelWarn = @"warn";
WhiteSDKLoggerOptionLevelKey const WhiteSDKLoggerOptionLevelError = @"error";

WhiteSDKLoggerReportModeKey const WhiteSDKLoggerReportAlways = @"alwaysReport";
WhiteSDKLoggerReportModeKey const WhiteSDKLoggerReportBan = @"banReport";

@interface WhiteSdkConfiguration ()

@property (nonatomic, copy, nonnull) NSDictionary *nativeTags;
@property (nonatomic, copy, nonnull) NSString *platform;

@end

@implementation WhiteSdkConfiguration

static NSString *const kJSDeviceType = @"deviceType";

+ (instancetype)defaultConfig
{
    NSAssert(NO, @"WhiteSdkConfiguration must have appIdentifier, please use initWithApp:");
    return nil;
}

- (instancetype)init
{
    NSAssert(NO, @"WhiteSdkConfiguration must have appIdentifier, please use initWithApp:");
    return nil;
}

- (instancetype)initWithApp:(NSString *)appIdentifier
{
    self = [super init];
    _deviceType = WhiteDeviceTypeTouch;
    NSOperatingSystemVersion iOS_10_0_0 = (NSOperatingSystemVersion){10, 0, 0};

    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion: iOS_10_0_0]) {
        _renderEngine = WhiteSdkRenderEngineCanvas;
    } else {
        _renderEngine = WhiteSdkRenderEngineSvg;
    }
    UIDevice *currentDevice = [UIDevice currentDevice];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    _platform = @"ios";
    _nativeTags = @{@"nativeVersion": [WhiteSDK version], @"platform": [NSString stringWithFormat:@"%@ %@ %@", _platform, deviceModel, currentDevice.systemVersion]};
    _appIdentifier = appIdentifier;
    _pptParams = [[WhitePptParams alloc] init];
    _disableNewPencilStroke = NO;
    return self;
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"nativeTags": @"__nativeTags",
             @"platform": @"__platform",
             @"netlessUA": @"__netlessUA"};
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if (_deviceType == WhiteDeviceTypeDesktop) {
        dic[kJSDeviceType] = @"desktop";
    } else {
        dic[kJSDeviceType] = @"touch";
    }
    return YES;
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if ([dic[kJSDeviceType] isEqualToString:@"desktop"]) {
        _deviceType = WhiteDeviceTypeDesktop;
    } else {
        _deviceType = WhiteDeviceTypeTouch;
    }
    return YES;
}

- (void)setPreloadDynamicPPT:(BOOL)preloadDynamicPPT
{
    _preloadDynamicPPT = preloadDynamicPPT;
}

static NSString *kLegacyReportLogKey = @"disableReportLog";
- (void)setLoggerOptions:(NSDictionary *)loggerOptions
{
    NSMutableDictionary *options = [loggerOptions mutableCopy];
    if (options[kLegacyReportLogKey] && [[options allKeys] count] == 1) {
        BOOL kSwitch = [loggerOptions[kLegacyReportLogKey] boolValue];
        if (!kSwitch) {
            options[@"reportDebugLogMode"] = WhiteSDKLoggerReportBan;
            options[@"reportQualityMode"] = WhiteSDKLoggerReportBan;
        }
    }
    options[kLegacyReportLogKey] = nil;
    _loggerOptions = [options copy];
}

@end
