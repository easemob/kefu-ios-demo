//
//  WhiteConversionInfoV5.h
//  Whiteboard
//
//  Created by xuyunshi on 2022/2/22.
//

#import "WhiteObject.h"
#import "WhitePptPage.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * WhiteConvertTypeV5 NS_STRING_ENUM;
FOUNDATION_EXPORT WhiteConvertTypeV5 const WhiteConvertTypeDynamic;
FOUNDATION_EXPORT WhiteConvertTypeV5 const WhiteConvertTypeStatic;

typedef NSString * WhiteConvertStatusV5 NS_STRING_ENUM;
FOUNDATION_EXPORT WhiteConvertStatusV5 const WhiteConvertStatusV5Waiting;
FOUNDATION_EXPORT WhiteConvertStatusV5 const WhiteConvertStatusV5Converting;
FOUNDATION_EXPORT WhiteConvertStatusV5 const WhiteConvertStatusV5Finished;
FOUNDATION_EXPORT WhiteConvertStatusV5 const WhiteConvertStatusV5Fail;

@interface WhiteConversionProgressV5 : WhiteObject

/** 转换文档总页数*/
@property (nonatomic, assign, readonly) NSInteger totalPageSize;

/** 已经转换完成的页数*/
@property (nonatomic, assign, readonly) NSInteger convertedPageSize;

/** 转换进度百分比 0-100 */
@property (nonatomic, assign, readonly) CGFloat convertedPercentage;
            
/** 转换结果列表 pdf, word, ppt, pptx都会被转化为pptPage */
@property (nonatomic, copy, readonly) NSArray<WhitePptPage *> *convertedFileList;

/** 当前转换任务步骤，只有 type == dynamic 时才有该字段*/
@property (nonatomic, copy, readonly) NSString *currentStep;

@end

/** 文档转换进度信息。*/
@interface WhiteConversionInfoV5 : WhiteObject

/** 任务uuid*/
@property (nonatomic, copy, readonly) NSString *uuid;

/** 任务type*/
@property (nonatomic, copy, readonly) WhiteConvertTypeV5 type;

/** 任务状态*/
@property (nonatomic, copy, readonly) WhiteConvertStatusV5 status;

/** 任务失败*/
@property (nonatomic, copy, readonly) NSString *failedReason;

/** 任务进度百分比 区间在0-100*/
@property (nonatomic, strong, readonly, nullable) WhiteConversionProgressV5 *progress;

@end

NS_ASSUME_NONNULL_END
