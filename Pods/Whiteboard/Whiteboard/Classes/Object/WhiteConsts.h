//
//  WhiteConsts.h
//  WhiteSDK
//
//  Created by yleaf on 2019/3/4.
//

#import <Foundation/Foundation.h>

#pragma mark - Domain

extern NSString * const WhiteConstErrorDomain;
extern NSString * const WhiteConstConvertDomain;

#pragma mark - Name

typedef NSString * WhiteFunName NS_STRING_ENUM;
extern WhiteFunName const WhiteVideoPluginName;

#pragma mark - Ratio
extern NSTimeInterval const WhiteConstTimeUnitRatio;

#pragma mark - Region
/** 数据中心 */
typedef NSString * WhiteRegionKey NS_STRING_ENUM;

extern WhiteRegionKey const WhiteRegionDefault;
/** 中国 */
extern WhiteRegionKey const WhiteRegionCN;
/** 美国 */
extern WhiteRegionKey const WhiteRegionUS;
/** 印度 */
extern WhiteRegionKey const WhiteRegionIN;
/** 新加坡 */
extern WhiteRegionKey const WhiteRegionSG;
/** 英国 */
extern WhiteRegionKey const WhiteRegionGB;
