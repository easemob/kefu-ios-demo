//
//  WhiteConverionInfoV5.m
//  Whiteboard
//
//  Created by xuyunshi on 2022/2/22.
//

#import "WhiteConversionInfoV5.h"

WhiteConvertTypeV5 const WhiteConvertTypeDynamic = @"dynamic";
WhiteConvertTypeV5 const WhiteConvertTypeStatic = @"static";

WhiteConvertStatusV5 const WhiteConvertStatusV5Waiting = @"Waiting";
WhiteConvertStatusV5 const WhiteConvertStatusV5Converting = @"Converting";
WhiteConvertStatusV5 const WhiteConvertStatusV5Finished = @"Finished";
WhiteConvertStatusV5 const WhiteConvertStatusV5Fail = @"Fail";

@interface WhiteConversionProgressV5 ()

@property (nonatomic, assign, readwrite) NSInteger totalPageSize;
@property (nonatomic, assign, readwrite) NSInteger convertedPageSize;
@property (nonatomic, assign, readwrite) CGFloat convertedPercentage;
@property (nonatomic, copy, readwrite) NSArray<WhitePptPage *> *convertedFileList;
@property (nonatomic, copy, readwrite) NSString *currentStep;

@end

@implementation WhiteConversionProgressV5

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"convertedFileList": WhitePptPage.class};
}

@end

@interface WhiteConversionInfoV5 ()

@property (nonatomic, copy, readwrite) NSString *uuid;
@property (nonatomic, copy, readwrite) WhiteConvertTypeV5 type;
@property (nonatomic, copy, readwrite) WhiteConvertStatusV5 status;
@property (nonatomic, copy, readwrite) NSString *failedReason;
@property (nonatomic, strong, readwrite, nullable) WhiteConversionProgressV5 *progress;

@end

@implementation WhiteConversionInfoV5

@end
