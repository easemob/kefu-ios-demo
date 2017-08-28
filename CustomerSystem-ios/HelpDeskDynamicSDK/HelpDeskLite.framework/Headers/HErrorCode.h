/*!
 *  \~chinese
 *  @header EMErrorCode.h
 *  @abstract SDK定义的错误类型
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMErrorCode.h
 *  @abstract SDK defined error type
 *  @author Hyphenate
 *  @version 3.00
 */

typedef enum{
    
    HErrorGeneral = 1,                      /*! \~chinese 一般错误 \~english General error */
    HErrorNetworkUnavailable,               /*! \~chinese 网络不可用 \~english Network is unavaliable */
    HErrorDatabaseOperationFailed,          /*! \~chinese 数据库操作失败 \~english Database operation failed */
    
    HErrorInvalidAppkey = 100,              /*! \~chinese Appkey无效 \~english App key is invalid */
    HErrorInvalidUsername,                  /*! \~chinese 用户名无效 \~english User name is invalid */
    HErrorInvalidPassword,                  /*! \~chinese 密码无效 \~english Password is invalid */
    HErrorInvalidURL,                       /*! \~chinese URL无效 \~english URL is invalid */
    
    HErrorUserAlreadyLogin = 200,           /*! \~chinese 用户已登录 \~english User has already logged in */
    HErrorUserNotLogin,                     /*! \~chinese 用户未登录 \~english User has not logged in */
    HErrorUserAuthenticationFailed,         /*! \~chinese 密码验证失败 \~english Password authentication failed */
    HErrorUserAlreadyExist,                 /*! \~chinese 用户已存在 \~english User has already existed */
    HErrorUserNotFound,                     /*! \~chinese 用户不存在 \~english User was not found */
    HErrorUserIllegalArgument,              /*! \~chinese 参数不合法 \~english Illegal argument */
    HErrorUserLoginOnAnotherDevice,         /*! \~chinese 当前用户在另一台设备上登录 \~english User has logged in from another device */
    HErrorUserRemoved,                      /*! \~chinese 当前用户从服务器端被删掉 \~english User was removed from server */
    HErrorUserRegisterFailed,               /*! \~chinese 用户注册失败 \~english Registration failed */
    HErrorUpdateApnsConfigsFailed,          /*! \~chinese 更新推送设置失败 \~english Update Apple Push Notification configurations failed */
    HErrorUserPermissionDenied,             /*! \~chinese 用户没有权限做该操作 \~english User has no access for this operation. */
    
    HErrorServerNotReachable = 300,         /*! \~chinese 服务器未连接 \~english Server is not reachable */
    HErrorServerTimeout,                    /*! \~chinese 服务器超时 \~english Server response timeout */
    HErrorServerBusy,                       /*! \~chinese 服务器忙碌 \~english Server is busy */
    HErrorServerUnknownError,               /*! \~chinese 未知服务器错误 \~english Unknown server error */
    HErrorServerGetDNSConfigFailed,         /*! \~chinese 获取DNS设置失败 \~english Get DNS config failure */
    HErrorServerServingForbidden,           /*! \~chinese 服务被禁用 \~english Serving is forbidden */
    
    HErrorFileNotFound = 400,               /*! \~chinese 文件没有找到 \~english Can't find the file */
    HErrorFileInvalid,                      /*! \~chinese 文件无效 \~english File is invalid */
    HErrorFileUploadFailed,                 /*! \~chinese 上传文件失败 \~english Upload file failure */
    HErrorFileDownloadFailed,               /*! \~chinese 下载文件失败 \~english Download file failed */
    
    HErrorMessageInvalid = 500,             /*! \~chinese 消息无效 \~english Message is invalid */
    HErrorMessageIncludeIllegalContent,      /*! \~chinese 消息内容包含不合法信息 \~english Message contains illegal content */
    HErrorMessageTrafficLimit,              /*! \~chinese 单位时间发送消息超过上限 \~english Unit time to send messages over the upper limit */
    HErrorMessageEncryption,                /*! \~chinese 加密错误 \~english Encryption error */
    
    HErrorGroupInvalidId = 600,             /*! \~chinese 群组ID无效 \~english Group Id is invalid */
    HErrorGroupAlreadyJoined,               /*! \~chinese 已加入群组 \~english User has already joined the group */
    HErrorGroupNotJoined,                   /*! \~chinese 未加入群组 \~english User has not joined the group */
    HErrorGroupPermissionDenied,            /*! \~chinese 没有权限进行该操作 \~english User has no access for the operation */
    HErrorGroupMHbersFull,                 /*! \~chinese 群成员个数已达到上限 \~english Reach group's max mHber count */
    HErrorGroupNotExist,                    /*! \~chinese 群组不存在 \~english Group is not existed */
    
    
    HErrorCallInvalidId = 800,              /*! \~chinese 实时通话ID无效 \~english Call id is invalid */
    HErrorCallBusy,                         /*! \~chinese 已经在进行实时通话了 \~english User is busy */
    HErrorCallRemoteOffline,                /*! \~chinese 对方不在线 \~english Callee is offline */
    HErrorCallConnectFailed,                /*! \~chinese 实时通话建立连接失败 \~english Establish connection failure */
}HErrorCode;
