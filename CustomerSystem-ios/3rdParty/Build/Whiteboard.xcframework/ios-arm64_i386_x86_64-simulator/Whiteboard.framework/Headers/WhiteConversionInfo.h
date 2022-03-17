//
//  PptProgress.h
//  WhiteSDK
//
//  Created by yleaf on 2019/6/25.
//

#import "WhiteObject.h"
#import "WhiteScene.h"
#import "WhitePptPage.h"
NS_ASSUME_NONNULL_BEGIN


/** 服务器端文档转换状态。*/
typedef NS_ENUM(NSInteger, ServerConversionStatus) {
    /** 文档转换服务排队中。*/
    ServerConversionStatusWaiting,
    /** 文档正在转换。 */
    ServerConversionStatusConverting,
    /** 未查询到文档转换服务，请检查 `taskId`，与转换类型（动态，静态）是否正确。 */
    ServerConversionStatusNotFound,
    /** 文档转换完成。 */
    ServerConversionStatusFinished,
    /** 文档转换失败，错误原因详见服务器 `reason` 字段。 */
    ServerConversionStatusFail
};

/** PPT 转换类型。*/
typedef NS_ENUM(NSInteger, ConvertType) {
    /** 未知，初始状态。 */
    ConvertTypeUnknown = -1,
    /** 静态 ppt，即每一页 PPT 都会被转换为图片。 */
    ConvertTypeStatic,
    /** 动态 PPT，即每一页 PPT 会被转化为动态版本。 */
    ConvertTypeDynamic
};

/** 服务器中文档转换的进度信息。*/
@interface WhiteConversionInfo : WhiteObject

@property (nonatomic, assign, readonly) ServerConversionStatus convertStatus;
@property (nonatomic, copy, readonly) NSString *reason;
@property (nonatomic, assign, readonly) NSInteger totalPageSize;
@property (nonatomic, assign, readonly) NSInteger convertedPageSize;
@property (nonatomic, assign, readonly) CGFloat convertedPercentage;

/** 转换成功时，资源文件所用前缀。*/
@property (nonatomic, copy, readonly, nullable) NSString *prefix;

/** 转换结果。*/
@property (nonatomic, copy, readonly, nullable) NSArray<WhitePptPage *> *convertedFileList;
@end

/** 将服务器转换好的数据，转化为 SDK 可用的格式，直接将 scenes 插入 sdk 即可。*/
@interface ConvertedFiles : NSObject

@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, assign) ConvertType type;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSArray<NSString *> *slideURLs;

/** 白板可接受，能够直接使用场景数据。*/
@property (nonatomic, copy) NSArray<WhiteScene *> *scenes;
@end


NS_ASSUME_NONNULL_END
