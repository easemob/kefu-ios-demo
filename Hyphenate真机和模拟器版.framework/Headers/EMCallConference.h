/*!
 *  \~chinese
 *  @header EMCallConference.h
 *  @abstract 多人会议
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMCallConference.h
 *  @abstract COnference
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EMConferenceRole){
    EMConferenceRoleNone = 0,
    EMConferenceRoleAudience = 1, /*! \~chinese 观众，只能订阅流 \~english Audience, only sub */
    EMConferenceRoleSpeaker = 3, /*! \~chinese 主播，订阅流和发布流 \~english Speaker, pub and sub */
    EMConferenceRoleAdmin = 7, /*! \~chinese 管理员，授权，订阅流，发布流 \~english Admin, authorize, pub and sub */
};

typedef NS_ENUM(NSInteger, EMConferenceType){
    EMConferenceTypeCommunication = 10, /*! \~chinese 普通通信会议，成员最多6人，参会者都是EMConferenceRoleSpeaker \~english Communication，Up to 6 members, member role is EMConferenceRoleSpeaker  */
    EMConferenceTypeLargeCommunication, /*! \~chinese 大型通信会议，成员6-30人, 参会者都是EMConferenceRoleSpeaker \~english Communication, 6-30 members, member role is EMConferenceRoleSpeaker */
    EMConferenceTypeLive, /*! \~chinese 互动视频会议，会议里支持最多6个主播和600个观众 \~english Live，support for up to 6 speakers and 600 audiences. */
};

typedef NS_ENUM(NSInteger, EMMediaType){
    EMMediaTypeAudio,
    EMMediaTypeVideo,
};

typedef NS_ENUM(NSInteger, EMMediaState){
    EMMediaStateNormal,
    EMMediaStateNoData,
};

typedef NS_ENUM(NSInteger, EMConferenceState) {
    EMConferenceStateNone = 0,
    EMConferenceStateTakePicture = 125,
    EMConferenceStateCustomMsg = 126,
    EMConferenceStateCtrlMsg = 127,
    EMConferenceStateResponceMsg = 128,
    EMConferenceStateUnpub = 130,
    EMConferenceStateP2PPeerexist = 181,
    EMConferenceStateOpenCameraFail = 201,
    EMConferenceStateOpenMicFail = 202,
    EMConferenceStateTakePictureFail = 203,
    EMConferenceStateSendFirstAudioFrame = 208,
    EMConferenceStateSendFirstVideoFrame = 209,
    EMConferenceStateReceivedFirstAudioFrame = 210,
    EMConferenceStateReceivedFirstVideoFrame = 211,
};


/*!
*  \~chinese
*  cdn 画布设置，创建会议时使用
*
*  \~english
*  The cdn canvas config
*/
@interface CDNCanvas : NSObject
 /*! \~chinese 画布宽度 \~english The width of canvas */
@property (nonatomic) NSInteger width;
/*! \~chinese 画布高度 \~english The height of canvas */
@property (nonatomic) NSInteger height;
/*! \~chinese 画布的背景色，格式为 RGB 定义下的 Hex 值，不要带 # 号，如 0xFFB6C1 表示浅粉色。默认0x000000，黑色。
 * \~english The bgclr of canvas ，use  interger as 0x112233, 0x11 is red value，0x22 is green value，0x33 is blue value*/
@property (nonatomic) NSInteger bgclr;
/*! \~chinese 推流帧率，可设置范围10-30 \~english The fps of cdn live，valid value is 10-30 */
@property (nonatomic) NSInteger fps;
/*! \~chinese 推流码率，单位kbps，width和height较大时，码率需要提高，可设置范围1-5000 \~english The bps of cdn live. Unit is kbps,valid value is 1-5000 */
@property (nonatomic) NSInteger kbps;
/*! \~chinese 推流编码格式，目前只支持"H264" \~english The codec of cdn live，now only support "H264* codec */
@property (nonatomic) NSString* codec;

@end

/*!
*  \~chinese
*  cdn推流的每一路流的模式
*
*  \~english
*  The style of stream in cdn live
*/
typedef NS_ENUM(NSInteger, LiveRegionStyle) {
    /*! \~chinese FIt模式\~english The fit content mode */
    LiveRegionStyleFit,
    /*! \~chinese FIll模式\~english The fill content mode */
    LiveRegionStyleFill
};

/*!
*  \~chinese
*  cdn推流的每一路流的区域位置信息
*
*  \~english
*  The region info of each stream in cdn live
*/
@interface LiveRegion : NSObject

/*! \~chinese 流ID \~english The stream Id */
@property (nonatomic) NSString* streamId;

/*! \~chinese 流的左上角在x轴坐标 \~english The pointX of left top */
@property (nonatomic) NSInteger x;

/*! \~chinese 流的左上角在y轴坐标 \~english The pointY of left top */
@property (nonatomic) NSInteger y;

/*! \~chinese 流的宽度 \~english The width of stream */
@property (nonatomic) NSInteger w;

/*! \~chinese 流的高度 \~english The height of stream */
@property (nonatomic) NSInteger h;

/*! \~chinese 流的图层顺序，越小越在底层，从1开始 \~english The zorder of stream，start from 1,the smaller is under others*/
@property (nonatomic) NSInteger z;

/*! \~chinese 流的显示模式，Fit或Fill \~english The content mode of stream,fit or fill*/
@property (nonatomic) LiveRegionStyle style;

@end

/*!
*  \~chinese
*  cdn推流的音频比特率
*
*  \~english
*  The audio bps of audio in cdn live
*/
typedef NS_ENUM(NSInteger, LiveAudioBps) {
    LiveAudioBps_8K = 8000,
    LiveAudioBps_10K = 10000,
    LiveAudioBps_15K = 15000,
    LiveAudioBps_20K = 20000,
    LiveAudioBps_32K = 32000,
    LiveAudioBps_36K = 36000,
    LiveAudioBps_64K = 64000,
    LiveAudioBps_128K = 128000,
};

/*!
*  \~chinese
*  cdn推流的音频采样率
*
*  \~english
*  The audio sampleRate of audio in cdn live
*/
typedef NS_ENUM(NSInteger, LiveAudioSampleRate) {
    LiveAudioSampleRate_8K = 8000,
    LiveAudioSampleRate_16K = 16000,
    LiveAudioSampleRate_32K = 32000,
    LiveAudioSampleRate_44K = 44100,
    LiveAudioSampleRate_48K = 48000,
};

/*!
*  \~chinese
*  音频录制的配置信息
*
*  \~english
*  The config of audio record.
*/
@interface AudioConfig : NSObject

/*! \~chinese 音频比特率 \~english The audio bps */
@property (nonatomic) LiveAudioBps bps;

/*! \~chinese 音频通道数,可选1或2 \~english The channels of audio.1 or 2*/
@property (nonatomic) NSInteger channels;

/*! \~chinese 音频采样率 \~english The samples of audio.*/
@property (nonatomic) LiveAudioSampleRate samples;

@end


/*!
*  \~chinese
*  cdn推流使用的画布类型
*
*  \~english
*  cdn  live layout style
*/
typedef NS_ENUM(NSInteger, LayoutStyle) {
    CUSTOM,
    DEMO,
    GRID
};
typedef CDNCanvas LiveCanvas;
/*!
*  \~chinese
*  自定义录制音视频的格式
*
*  \~english
*  the format of custom record file ext
*/
typedef NS_ENUM(NSInteger, RecordExt) {
    RecordExtMP3,
    RecordExtWAV,
    RecordExtM4A,
    RecordExtMP4,
    RecordExtAUTO,
    RecordExtUNSUPPORTED = RecordExtAUTO,
};
/*!
*  \~chinese
*  cdn推流设置
*
*  \~english
*  The cdn push stream config
*/
@interface LiveConfig : NSObject

/*! \~chinese 推流url地址\~english The url address of cdn live*/
@property (nonatomic,strong) NSString *cdnUrl;

/*! \~chinese 推流画布的配置\~english The config of live canvas*/
@property (nonatomic) LiveCanvas* canvas;

/*! \~chinese 推流方式，GRID或者CUSTOM，GRID将由服务器设置位置信息，CUSTOM将由用户自定义流的位置信息\~english The style of cdn live,GRID or CUSTOM.If GRID,server set region of streams.If CUSTOM,user set region of streams*/
@property (nonatomic) LayoutStyle layoutStyle;

/*! \~chinese 是否开启自定义录制\~english Weather custom servre record*/
@property (nonatomic) BOOL record;

/*! \~chinese 音频j录制参数\~english audio record config*/
@property (nonatomic) AudioConfig* audioCfg;

@property (nonatomic) RecordExt recordExt;

@end


/*!
 *  \~chinese
 *  多人会议成员对象
 *
 *  \~english
 *  Conference member class
 */
@interface EMCallMember : NSObject

/*!
 *  \~chinese
 *  成员标识符
 *
 *  \~english
 *  Unique member id
 */
@property (nonatomic, strong, readonly) NSString *memberId;


/*!
 *  \~chinese
 *  成员名
 *
 *  \~english
 *  The member name
 */
@property (nonatomic, strong, readonly) NSString *memberName;

/*!
 *  \~chinese
 *  扩展信息
 *
 *  \~english
 *  Extension
 */
@property (nonatomic, strong, readonly) NSString *ext;

/*!
 *  \~chinese
 *  昵称
 *
 *  \~english
 *  nickname
 */
@property (nonatomic, strong, readonly) NSString *nickname;

@end

/*!
 *  \~chinese
 *  多人会议对象
 *
 *  \~english
 *  Conference class
 */
@interface EMCallConference : NSObject

/*!
 *  \~chinese
 *  会话标识符, 本地生成
 *
 *  \~english
 *  Unique call id, locally generated
 */
@property (nonatomic, strong, readonly) NSString *callId;

/*!
 *  \~chinese
 *  会议标识符,服务器生成
 *
 *  \~english
 *  Unique conference id, server generation
 */
@property (nonatomic, strong, readonly) NSString *confId;

/*!
 *  \~chinese
 *  通话本地的username
 *
 *  \~english
 *  Local username
 */
@property (nonatomic, strong, readonly) NSString *localName;

/*!
 *  \~chinese
 *  会议类型
 *
 *  \~english
 *  The conference type
 */
@property (nonatomic) EMConferenceType type;

/*!
 *  \~chinese
 *  在会议中的角色
 *
 *  \~english
 * Role in the conference
 */
@property (nonatomic) EMConferenceRole role;

/*!
 *  \~chinese
 *  管理员列表
 *
 *  \~english
 *  Administrator's id list
 */
@property (nonatomic, strong) NSArray<NSString *> *adminIds;

/*!
 *  \~chinese
 *  主播列表
 *
 *  \~english
 *  Speaker's id list
 */
@property (nonatomic, strong) NSArray<NSString *> *speakerIds;

/*!
 *  \~chinese
 *  当前会议中成员总数（包含自己）
 *
 *  \~english
 *  Total number of members in the current meeting (including yourself)
 */
@property (nonatomic) NSInteger memberCount;

/*!
 *  \~chinese
 *  是否启用服务器录制
 *
 *  \~english
 *  Whether server recording is enabled
 */
@property (nonatomic) BOOL willRecord;
/*!
*  \~chinese
*  在会议中的昵称
*
*  \~english
*  The nickName in conference
*/
@property (nonatomic) NSString* nickName;
/*!
*  \~chinese
*  在会议中的memId
*
*  \~english
*  The memId in conference
*/
@property (nonatomic,strong ,readonly) NSString* memId;
/*!
*  \~chinese
*  在会议中的cdn推流ID
*
*  \~english
*  The cdn liveID in conference
*/
@property (nonatomic) NSString* liveId;
/*!
*  \~chinese
*  在会议中的cdn推流配置
*
*  \~english
*  The cdn liveID in conference
*/
@property (nonatomic,strong) NSDictionary* liveCfgs;
/*!
*  \~chinese
*  是否会议的创建者
*
*  \~english
*  Weather is the creator of conference
*/
@property (nonatomic) BOOL isCreator;

/*!
 *  \~chinese
 *  当前会议中观众总数
 *
 *  \~english
 *  Total number of audiences in the current meeting
 */
@property (nonatomic) NSInteger audiencesCount;
@end
