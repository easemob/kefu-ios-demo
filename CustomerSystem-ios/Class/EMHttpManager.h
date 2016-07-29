//
//  EMHttpManager.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/6/30.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMHttpManager : NSObject

+ (instancetype)sharedInstance;

/*
 @method
 @brief 创建一个留言
 @discussion 失败返回NSError,成功返回responseObject
 @param tenantId    客服tenantId
 @param projectId   留言的Project ID
 @param parameters  留言参数
 @result
 */
- (void)asyncCreateMessageWithTenantId:(NSString*)tenantId
                             projectId:(NSString*)projectId
                            parameters:(NSDictionary*)parameters
                            completion:(void (^)(id responseObject, NSError *error))completion;
/*
 @method
 @brief 获取留言详情
 @discussion 失败返回NSError,成功返回responseObject
 @param tenantId    客服tenantId
 @param projectId   留言的Project ID
 @param tickedId    留言ID
 @param parameters  参数
 @result
 */
- (void)asyncGetLeaveMessageDetailWithTenantId:(NSString*)tenantId
                                     projectId:(NSString*)projectId
                                      ticketId:(NSInteger)ticketId
                                    parameters:(NSDictionary*)parameters
                                    completion:(void (^)(id responseObject, NSError *error))completion;

/*
 @method
 @brief 获取留言下所有评论
 @discussion 失败返回NSError,成功返回responseObject
 @param tenantId    客服tenantId
 @param projectId   留言的Project ID
 @param tickedId    留言ID
 @param parameters  参数
 @result
 */
- (void)asyncGetLeaveMessageAllCommentsWithTenantId:(NSString*)tenantId
                                          projectId:(NSString*)projectId
                                           ticketId:(NSInteger)ticketId
                                         parameters:(NSDictionary*)parameters
                                         completion:(void (^)(id responseObject, NSError *error))completion;

/*
 @method
 @brief 给一个留言添加评论
 @discussion 失败返回NSError,成功返回responseObject
 @param tenantId    客服tenantId
 @param projectId   留言的Project ID
 @param tickedId    留言ID
 @param parameters  参数
 @result
 */
- (void)asyncLeaveAMessageWithTenantId:(NSString*)tenantId
                             projectId:(NSString*)projectId
                              ticketId:(NSInteger)ticketId
                            parameters:(NSDictionary*)parameters
                            completion:(void (^)(id responseObject, NSError *error))completion;


/*
 @method
 @brief 获取留言列表
 @discussion 失败返回NSError,成功返回responseObject
 @param tenantId    客服tenantId
 @param projectId   留言的Project ID
 @param parameters  参数
 @result
 */
- (void)asyncGetMessagesWithTenantId:(NSString*)tenantId
                           projectId:(NSString*)projectId
                          parameters:(NSDictionary*)parameters
                          completion:(void (^)(id responseObject, NSError *error))completion;


/*
 @method
 @brief 上传附件
 @discussion 失败返回NSError,成功返回responseObject
 @param tenantId    客服tenantId
 @param file        附件
 @param parameters  参数
 @result
 */
- (void)uploadWithTenantId:(NSString*)tenantId
                      File:(NSData*)file
                parameters:(NSDictionary*)parameters
                completion:(void (^)(id responseObject, NSError *error))completion;

@end
