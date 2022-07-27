//
//  WhiteAppParam.h
//
//  Created by yleaf on 2021/8/21.
//

#import "WhiteObject.h"
#import "WhiteScene.h"

NS_ASSUME_NONNULL_BEGIN


@interface WhiteAppOptions : WhiteObject

@property (nonatomic, nullable, copy) NSString *scenePath;
@property (nonatomic, nullable, copy) NSString *title;
@property (nonatomic, nullable, strong) NSArray<WhiteScene *> *scenes;

@end

/** 多窗口模式下，一些插件的配置参数项，直接使用类方法生成，不需要主动配置各个属性值 */
@interface WhiteAppParam : WhiteObject

/** 插件类型 */
@property (nonatomic, copy, readonly) NSString *kind;
/** 插件固定需要的一些配置项 */
@property (nonatomic, strong, readonly) WhiteAppOptions *options;
/** 插件所需要的一些额外可选属性,可以不填 */
@property (nonatomic, copy, readonly) NSDictionary *attrs;

+ (instancetype)createSlideApp:(NSString *)dir scenes:(NSArray <WhiteScene *>*)scenes title:(NSString *)title;
+ (instancetype)createDocsViewerApp:(NSString *)dir scenes:(NSArray <WhiteScene *>*)scenes title:(NSString *)title;
+ (instancetype)createMediaPlayerApp:(NSString *)src title:(NSString *)title;

/** 特定的App，一般用来创建自定义的App插入参数
 @param kind 注册App时使用的kind
 @param options 详见[WhiteAppOptions](WhiteAppOptions)
 @param attrs 初始化App的参数，按需填
 */
- (instancetype)initWithKind:(NSString *)kind options:(WhiteAppOptions *)options attrs:(NSDictionary *)attrs;

@end

NS_ASSUME_NONNULL_END
