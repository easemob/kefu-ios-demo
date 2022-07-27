//
//  WhiteConsts.m
//  WhiteSDK
//
//  Created by yleaf on 2019/3/4.
//

#import "WhiteConsts.h"

NSString * const WhiteConstErrorDomain = @"com.herewhite.white";
NSString * const WhiteConstConvertDomain = @"convert.com.herewhite.white";

WhiteFunName const WhiteVideoPluginName = @"videoJsPlugin";
//javascript 端，使用的是毫秒；iOS 端，习惯使用秒，使用 NSTimeInterval
NSTimeInterval const WhiteConstTimeUnitRatio = 1000.0;

WhiteRegionKey const WhiteRegionDefault = @"cn-hz";
WhiteRegionKey const WhiteRegionCN = @"cn-hz";
WhiteRegionKey const WhiteRegionUS = @"us-sv";
WhiteRegionKey const WhiteRegionIN = @"in-mum";
WhiteRegionKey const WhiteRegionSG = @"sg";
WhiteRegionKey const WhiteRegionGB = @"gb-lon";
