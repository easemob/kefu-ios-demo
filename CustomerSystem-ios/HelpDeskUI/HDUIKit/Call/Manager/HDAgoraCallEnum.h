//
//  HDHDAgoraCallEnum.h
//  HelpDesk
//
//  Created by houli on 2022/1/7.
//  Copyright © 2022 hyphenate. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  \~chinese
 *  视频通话页面缩放方式
 *
 *  \~english
 *  Video view scale mode
 */
typedef enum{
    HDAgoraCallViewScaleModeAspectFit = 0,   /*! \~chinese 按比例缩放 \~english Aspect fit */
    HDAgoraCallViewScaleModeAspectFill = 1,  /*! \~chinese 全屏 \~english Aspect fill */
}HDAgoraCallViewScaleMode;

/** Warning code.

Warning codes occur when the SDK encounters an error that may be recovered automatically. These are only notifications, and can generally be ignored. For example, when the SDK loses connection to the server, the SDK reports the HDAgoraWarningCodeOpenChannelTimeout(106) warning and tries to reconnect automatically.
*/
typedef NS_ENUM(NSInteger, HDAgoraWarningCode) {
  /** 8: The specified view is invalid. Specify a view when using the video call function. */
  HDAgoraWarningCodeInvalidView = 8,
  /** 16: Failed to initialize the video function, possibly caused by a lack of resources. The users cannot see the video while the voice communication is not affected. */
  HDAgoraWarningCodeInitVideo = 16,
  /** 20: The request is pending, usually due to some module not being ready, and the SDK postpones processing the request. */
  HDAgoraWarningCodePending = 20,
  /** 103: No channel resources are available. Maybe because the server cannot allocate any channel resource. */
  HDAgoraWarningCodeNoAvailableChannel = 103,
  /** 104: A timeout occurs when looking up the channel. When joining a channel, the SDK looks up the specified channel. The warning usually occurs when the network condition is too poor for the SDK to connect to the server. */
  HDAgoraWarningCodeLookupChannelTimeout = 104,
  /** 105: The server rejects the request to look up the channel. The server cannot process this request or the request is illegal.
   <p><b>DEPRECATED</b> as of v2.4.1. Use HDAgoraConnectionChangedRejectedByServer(10) in the `reason` parameter of [connectionChangedToState]([HDAgoraRtcEngineDelegate rtcEngine:connectionChangedToState:reason:]).</p>
   */
  HDAgoraWarningCodeLookupChannelRejected = 105,
  /** 106: The server rejects the request to look up the channel. The server cannot process this request or the request is illegal. */
  HDAgoraWarningCodeOpenChannelTimeout = 106,
  /** 107: The server rejects the request to open the channel. The server cannot process this request or the request is illegal. */
  HDAgoraWarningCodeOpenChannelRejected = 107,
  /** 111: A timeout occurs when switching to the live video. */
  HDAgoraWarningCodeSwitchLiveVideoTimeout = 111,
  /** 118: A timeout occurs when setting the client role in the interactive live streaming profile. */
  HDAgoraWarningCodeSetClientRoleTimeout = 118,
  /** 119: The client role is unauthorized. */
  HDAgoraWarningCodeSetClientRoleNotAuthorized = 119,
  /** 121: The ticket to open the channel is invalid. */
  HDAgoraWarningCodeOpenChannelInvalidTicket = 121,
  /** 122: Try connecting to another server. */
  HDAgoraWarningCodeOpenChannelTryNextVos = 122,
  /** 701: An error occurs in opening the audio mixing file. */
  HDAgoraWarningCodeAudioMixingOpenError = 701,
  /** 1014: Audio Device Module: a warning occurs in the playback device. */
  HDAgoraWarningCodeAdmRuntimePlayoutWarning = 1014,
  /** 1016: Audio Device Module: a warning occurs in the sampling device. */
  HDAgoraWarningCodeAdmRuntimeRecordingWarning = 1016,
  /** 1019: Audio device module: No valid audio data is sampled. */
  HDAgoraWarningCodeAdmRecordAudioSilence = 1019,
  /** 1020: Audio Device Module: a playback device fails. */
  HDAgoraWarningCodeAdmPlaybackMalfunction = 1020,
  /** 1021: Audio Device Module: a sampling device fails. */
  HDAgoraWarningCodeAdmRecordMalfunction = 1021,
  /** 1025: Call is interrupted by system events such as phone call or siri etc. */
  HDAgoraWarningCodeAdmInterruption = 1025,
  /** 1029: During a call, `AudioSessionCategory` should be set to `AVAudioSessionCategoryPlayAndRecord`, and the SDK monitors this value. If the `AudioSessionCategory` is set to other values, this warning code is triggered and the SDK will forcefully set it back to `AVAudioSessionCategoryPlayAndRecord`.*/
  HDAgoraWarningCodeAdmCategoryNotPlayAndRecord = 1029,
  /** 1031: Audio Device Module: the sampled audio is too low. */
  HDAgoraWarningCodeAdmRecordAudioLowlevel = 1031,
  /** 1032: Audio Device Module: the playback audio is too low. */
  HDAgoraWarningCodeAdmPlayoutAudioLowlevel = 1032,
  /** 1040: Audio device module: An error occurs in the audio driver. Solution: <li>Restart your audio device.<li>Restart your device where the app runs.<li>Upgrade the sound card drive.</li> */
  HDAgoraWarningCodeAdmNoDataReadyCallback = 1040,
  /** 1042: Audio device module: The audio sampling device is different from the audio playback device, which may cause echoes problem. HDAgora recommends using the same audio device to sample and playback audio. */
  HDAgoraWarningCodeAdmInconsistentDevices = 1042,
  /** 1051: (Communication profile only) Audio Processing Module: A howling sound is detected when sampling the audio data */
  HDAgoraWarningCodeApmHowling = 1051,
  /** 1052: Audio Device Module: the device is in the glitch state. */
  HDAgoraWarningCodeAdmGlitchState = 1052,
  /** 1053: Audio Processing Module: A residual echo is detected, which may be caused by the belated scheduling of system threads or the signal overflow. */
  HDAgoraWarningCodeApmResidualEcho = 1053,
  /** 1610: Super-resolution warning: The original resolution of the remote user's video is beyond the range where super resolution can be applied. */
  HDAgoraWarningCodeSuperResolutionStreamOverLimitation = 1610,
  /** 1611: Super-resolution warning: Super resolution is already being used to boost another remote user's video. */
  HDAgoraWarningCodeSuperResolutionUserCountOverLimitation = 1611,
  /** 1612: Super-resolution warning: The device does not support using super resolution. */
  HDAgoraWarningCodeSuperResolutionDeviceNotSupported = 1612,
};

/** Error code.

Error codes occur when the SDK encounters an error that cannot be recovered automatically without any app intervention. For example, the SDK reports the `HDAgoraErrorCodeStartCall` = `1002` error if it fails to start a call, and reminds the user to call the [leaveChannel]([HDAgoraRtcEngineKit leaveChannel:]) method.
*/
typedef NS_ENUM(NSInteger, HDAgoraErrorCode) {
  /** 0: No error occurs. */
  HDAgoraErrorCodeNoError = 0,
  /** 1: A general error occurs (no specified reason). */
  HDAgoraErrorCodeFailed = 1,
  /** 2: An invalid parameter is used. For example, the specific channel name includes illegal characters. */
  HDAgoraErrorCodeInvalidArgument = 2,
  /** 3: The SDK module is not ready.
   <p>Possible solutions：
   <ul><li>Check the audio device.</li>
   <li>Check the completeness of the app.</li>
   <li>Re-initialize the SDK.</li></ul></p>
  */
  HDAgoraErrorCodeNotReady = 3,
  /** 4: The current state of the SDK does not support this function. */
  HDAgoraErrorCodeNotSupported = 4,
  /** 5: The request is rejected. This is for internal SDK use only, and is not returned to the app through any method or callback. */
  HDAgoraErrorCodeRefused = 5,
  /** 6: The buffer size is not big enough to store the returned data. */
  HDAgoraErrorCodeBufferTooSmall = 6,
  /** 7: The SDK is not initialized before calling this method. */
  HDAgoraErrorCodeNotInitialized = 7,
  /** 9: No permission exists. Check if the user has granted access to the audio or video device. */
  HDAgoraErrorCodeNoPermission = 9,
  /** 10: An API method timeout occurs. Some API methods require the SDK to return the execution result, and this error occurs if the request takes too long (over 10 seconds) for the SDK to process. */
  HDAgoraErrorCodeTimedOut = 10,
  /** 11: The request is canceled. This is for internal SDK use only, and is not returned to the app through any method or callback. */
  HDAgoraErrorCodeCanceled = 11,
  /** 12: The method is called too often. This is for internal SDK use only, and is not returned to the app through any method or callback. */
  HDAgoraErrorCodeTooOften = 12,
  /** 13: The SDK fails to bind to the network socket. This is for internal SDK use only, and is not returned to the app through any method or callback. */
  HDAgoraErrorCodeBindSocket = 13,
  /** 14: The network is unavailable. This is for internal SDK use only, and is not returned to the app through any method or callback. */
  HDAgoraErrorCodeNetDown = 14,
  /** 15: No network buffers are available. This is for internal SDK use only, and is not returned to the app through any method or callback. */
  HDAgoraErrorCodeNoBufs = 15,
  /** 17: The request to join the channel is rejected.
   <p>Possible reasons are:
   <ul><li>The user is already in the channel, and still calls the API method to join the channel, for example, [joinChannelByToken]([HDAgoraRtcEngineKit joinChannelByToken:channelId:info:uid:joinSuccess:]).</li>
   <li>The user tries to join a channel during a call test ([startEchoTestWithInterval]([HDAgoraRtcEngineKit startEchoTestWithInterval:successBlock:])). Once you call `startEchoTestWithInterval`, you need to call [stopEchoTest]([HDAgoraRtcEngineKit stopEchoTest]) before joining a channel.</li>
   <li>The user tries to join the channel with a token that is expired.</li></ul></p>
  */
  HDAgoraErrorCodeJoinChannelRejected = 17,
  /** 18: The request to leave the channel is rejected.
   <p>Possible reasons are:
   <ul><li>The user left the channel and still calls the API method to leave the channel, for example, [leaveChannel]([HDAgoraRtcEngineKit leaveChannel:]).</li>
   <li>The user has not joined the channel and calls the API method to leave the channel.</li></ul></p>
  */
  HDAgoraErrorCodeLeaveChannelRejected = 18,
  /** 19: The resources are occupied and cannot be used. */
  HDAgoraErrorCodeAlreadyInUse = 19,
  /** 20: The SDK gave up the request due to too many requests.  */
  HDAgoraErrorCodeAbort = 20,
  /** 21: In Windows, specific firewall settings cause the SDK to fail to initialize and crash. */
  HDAgoraErrorCodeInitNetEngine = 21,
  /** 22: The app uses too much of the system resources and the SDK fails to allocate the resources. */
  HDAgoraErrorCodeResourceLimited = 22,
  /** 101: The specified App ID is invalid. Please try to rejoin the channel with a valid App ID.*/
  HDAgoraErrorCodeInvalidAppId = 101,
  /** 102: The specified channel name is invalid. Please try to rejoin the channel with a valid channel name. */
  HDAgoraErrorCodeInvalidChannelId = 102,
  /** 103: Fails to get server resources in the specified region. Please try to specify another region when calling [sharedEngineWithConfig]([HDAgoraRtcEngineKit  sharedEngineWithConfig:delegate:]). */
  HDAgoraErrorCodeNoServerResources = 103,
  /** 109: The token expired.
   <p><b>DEPRECATED</b> as of v2.4.1. Use HDAgoraConnectionChangedTokenExpired(9) in the `reason` parameter of [connectionChangedToState]([HDAgoraRtcEngineDelegate rtcEngine:connectionChangedToState:reason:]).</p>
   <p>Possible reasons are:
   <ul><li>Authorized Timestamp expired: The timestamp is represented by the number of seconds elapsed since 1/1/1970. The user can use the token to access the HDAgora service within 24 hours after the token is generated. If the user does not access the HDAgora service after 24 hours, this token is no longer valid.</li>
   <li>Call Expiration Timestamp expired: The timestamp is the exact time when a user can no longer use the HDAgora service (for example, when a user is forced to leave an ongoing call). When a value is set for the Call Expiration Timestamp, it does not mean that the token will expire, but that the user will be banned from the channel.</li></ul></p>
   */
  HDAgoraErrorCodeTokenExpired = 109,
  /** 110: The token is invalid.
   <p><b>DEPRECATED</b> as of v2.4.1. Use HDAgoraConnectionChangedInvalidToken(8) in the `reason` parameter of [connectionChangedToState]([HDAgoraRtcEngineDelegate rtcEngine:connectionChangedToState:reason:]).</p>
   <p>Possible reasons are:
   <ul><li>The App Certificate for the project is enabled in Console, but the user is using the App ID. Once the App Certificate is enabled, the user must use a token.</li>
   <li>The uid is mandatory, and users must set the same uid as the one set in the [joinChannelByToken]([HDAgoraRtcEngineKit joinChannelByToken:channelId:info:uid:joinSuccess:]) method.</li></ul></p>
   */
  HDAgoraErrorCodeInvalidToken = 110,
  /** 111: The Internet connection is interrupted. This applies to the HDAgora Web SDK only. */
  HDAgoraErrorCodeConnectionInterrupted = 111,
  /** 112: The Internet connection is lost. This applies to the HDAgora Web SDK only. */
  HDAgoraErrorCodeConnectionLost = 112,
  /** 113: The user is not in the channel when calling the method. */
  HDAgoraErrorCodeNotInChannel = 113,
  /** 114: The size of the sent data is over 1024 bytes when the user calls the [sendStreamMessage]([HDAgoraRtcEngineKit sendStreamMessage:data:]) method. */
  HDAgoraErrorCodeSizeTooLarge = 114,
  /** 115: The bitrate of the sent data exceeds the limit of 6 Kbps when the user calls the [sendStreamMessage]([HDAgoraRtcEngineKit sendStreamMessage:data:]) method. */
  HDAgoraErrorCodeBitrateLimit = 115,
  /** 116: Too many data streams (over five streams) are created when the user calls the [createDataStream]([HDAgoraRtcEngineKit createDataStream:reliable:ordered:]) method. */
  HDAgoraErrorCodeTooManyDataStreams = 116,
  /** 120: Decryption fails. The user may have used a different encryption password to join the channel. Check your settings or try rejoining the channel. */
  HDAgoraErrorCodeDecryptionFailed = 120,
  /** 124: Incorrect watermark file parameter. */
  HDAgoraErrorCodeWatermarkParam = 124,
  /** 125: Incorrect watermark file path. */
  HDAgoraErrorCodeWatermarkPath = 125,
  /** 126: Incorrect watermark file format. */
  HDAgoraErrorCodeWatermarkPng = 126,
  /** 127: Incorrect watermark file information. */
  HDAgoraErrorCodeWatermarkInfo = 127,
  /** 128: Incorrect watermark file data format. */
  HDAgoraErrorCodeWatermarkAGRB = 128,
  /** 129: An error occurs in reading the watermark file. */
  HDAgoraErrorCodeWatermarkRead = 129,
  /** 130: The encrypted stream is not allowed to publish. */
  HDAgoraErrorCodeEncryptedStreamNotAllowedPublish = 130,
  /** 134: The user account is invalid. */
  HDAgoraErrorCodeInvalidUserAccount = 134,

  /** 151: CDN related errors. Remove the original URL address and add a new one by calling the [removePublishStreamUrl]([HDAgoraRtcEngineKit removePublishStreamUrl:]) and [addPublishStreamUrl]([HDAgoraRtcEngineKit addPublishStreamUrl:transcodingEnabled:]) methods. */
  HDAgoraErrorCodePublishStreamCDNError = 151,
  /** 152: The host publishes more than 10 URLs. Delete the unnecessary URLs before adding new ones. */
  HDAgoraErrorCodePublishStreamNumReachLimit = 152,
  /** 153: The host manipulates other hosts' URLs. Check your app logic. */
  HDAgoraErrorCodePublishStreamNotAuthorized = 153,
  /** 154: An error occurs in HDAgora's streaming server. Call the [addPublishStreamUrl]([HDAgoraRtcEngineKit addPublishStreamUrl:transcodingEnabled:]) method to publish the stream again. */
  HDAgoraErrorCodePublishStreamInternalServerError = 154,
  /** 155: The server fails to find the stream. */
  HDAgoraErrorCodePublishStreamNotFound = 155,
  /** 156: The format of the RTMP stream URL is not supported. Check whether the URL format is correct. */
  HDAgoraErrorCodePublishStreamFormatNotSuppported = 156,
  /** 157: The extension library is not integrated, such as the library for enabling deep-learning noise reduction. */
  HDAgoraErrorCodeModuleNotFound = 157,
  /** 160: The client is already recording audio. To start a new recording, call [stopAudioRecording]([HDAgoraRtcEngineKit stopAudioRecording])
   to stop the current recording first, and then call [startAudioRecordingWithConfig]([HDAgoraRtcEngineKit startAudioRecordingWithConfig:]).

   @since v3.4.0
   */
  HDAgoraErrorCodeAlreadyInRecording = 160,
  /** 1001: Fails to load the media engine. */
  HDAgoraErrorCodeLoadMediaEngine = 1001,
  /** 1002: Fails to start the call after enabling the media engine. */
  HDAgoraErrorCodeStartCall = 1002,
  /** 1003: Fails to start the camera.
   <p><b>DEPRECATED</b> as of v2.4.1. Use HDAgoraLocalVideoStreamErrorCaptureFailure(4) in the `error` parameter of [connectionChangedToState]([HDAgoraRtcEngineDelegate rtcEngine:connectionChangedToState:reason:]).</p>
   */
  HDAgoraErrorCodeStartCamera = 1003,
  /** 1004: Fails to start the video rendering module. */
  HDAgoraErrorCodeStartVideoRender = 1004,
  /** 1005: A general error occurs in the Audio Device Module (the reason is not classified specifically). Check if the audio device is used by another app, or try rejoining the channel. */
  HDAgoraErrorCodeAdmGeneralError = 1005,
  /** 1006: Audio Device Module: An error occurs in using the Java resources. */
  HDAgoraErrorCodeAdmJavaResource = 1006,
  /** 1007: Audio Device Module: An error occurs in setting the sampling frequency. */
  HDAgoraErrorCodeAdmSampleRate = 1007,
  /** 1008: Audio Device Module: An error occurs in initializing the playback device. */
  HDAgoraErrorCodeAdmInitPlayout = 1008,
  /** 1009: Audio Device Module: An error occurs in starting the playback device. */
  HDAgoraErrorCodeAdmStartPlayout = 1009,
  /** 1010: Audio Device Module: An error occurs in stopping the playback device. */
  HDAgoraErrorCodeAdmStopPlayout = 1010,
  /** 1011: Audio Device Module: An error occurs in initializing the sampling device. */
  HDAgoraErrorCodeAdmInitRecording = 1011,
  /** 1012: Audio Device Module: An error occurs in starting the sampling device. */
  HDAgoraErrorCodeAdmStartRecording = 1012,
  /** 1013: Audio Device Module: An error occurs in stopping the sampling device. */
  HDAgoraErrorCodeAdmStopRecording = 1013,
  /** 1015: Audio Device Module: A playback error occurs. Check your playback device, or try rejoining the channel. */
  HDAgoraErrorCodeAdmRuntimePlayoutError = 1015,
  /** 1017: Audio Device Module: A sampling error occurs. */
  HDAgoraErrorCodeAdmRuntimeRecordingError = 1017,
  /** 1018: Audio Device Module: Fails to sample the audio data. */
  HDAgoraErrorCodeAdmRecordAudioFailed = 1018,
  /** 1020: Audio Device Module: The audio playback frequency is abnormal, which may cause audio freezes. This abnormality is caused by high CPU usage. HDAgora recommends stopping other apps. */
  HDAgoraErrorCodeAdmPlayAbnormalFrequency = 1020,
  /** 1021: Audio Device Module: The audio sampling frequency is abnormal, which may cause audio freezes. This abnormality is caused by high CPU usage. HDAgora recommends stopping other apps. */
  HDAgoraErrorCodeAdmRecordAbnormalFrequency = 1021,
  /** 1022: Audio Device Module: An error occurs in initializing the loopback device. */
  HDAgoraErrorCodeAdmInitLoopback = 1022,
  /** 1023: Audio Device Module: An error occurs in starting the loopback device. */
  HDAgoraErrorCodeAdmStartLoopback = 1023,
  /** 1027: Audio Device Module: An error occurs in no audio sampling permission. */
  HDAgoraErrorCodeAdmNoPermission = 1027,
  /** 1206: Audio device module: Cannot activate the Audio Session.*/
  HDAgoraErrorCodeAdmActivateSessionFail = 1206,
  /** 1359: No sampling device is available. Check whether the sampling device is connected or whether it is already in use by another app. */
  HDAgoraErrorCodeAdmNoRecordingDevice = 1359,
  /** 1360: No playback device exists. */
  HDAgoraErrorCodeAdmNoPlayoutDevice = 1360,
  /** 1501: Video Device Module: The camera is unauthorized. */
  HDAgoraErrorCodeVdmCameraNotAuthorized = 1501,
  /** 1600: Video Device Module: An unknown error occurs. */
  HDAgoraErrorCodeVcmUnknownError = 1600,
  /** 1601: Video Device Module: An error occurs in initializing the video encoder. */
  HDAgoraErrorCodeVcmEncoderInitError = 1601,
  /** 1602: Video Device Module: An error occurs in video encoding. */
  HDAgoraErrorCodeVcmEncoderEncodeError = 1602,
  /** 1603: Video Device Module: An error occurs in setting the video encoder.
  <p><b>DEPRECATED</b></p>
  */
  HDAgoraErrorCodeVcmEncoderSetError = 1603,
};

/** The current music file playback state. Reports in the [localAudioMixingStateDidChanged]([HDAgoraRtcEngineDelegate rtcEngine:localAudioMixingStateDidChanged:reason:]) callback. */
typedef NS_ENUM(NSInteger, HDAgoraAudioMixingStateCode) {
  /** 710: The music file is playing.
   <p>This state comes with one of the following associated reasons:</p>
   <li><code>HDAgoraAudioMixingReasonStartedByUser(720)</code></li>
   <li><code>HDAgoraAudioMixingReasonOneLoopCompleted(721)</code></li>
   <li><code>HDAgoraAudioMixingReasonStartNewLoop(722)</code></li>
   <li><code>HDAgoraAudioMixingReasonResumedByUser(726)</code></li>
   */
  HDAgoraAudioMixingStatePlaying = 710,
  /** 711: The music file pauses playing.
   <p>This state comes with <code>HDAgoraAudioMixingReasonPausedByUser(725)</code>.</p>
   */
  HDAgoraAudioMixingStatePaused = 711,
  /** 713: The music file stops playing.
   <p>This state comes with one of the following associated reasons:</p>
   <li><code>HDAgoraAudioMixingReasonAllLoopsCompleted(723)</code></li>
   <li><code>HDAgoraAudioMixingReasonStoppedByUser(724)</code></li>
   */
  HDAgoraAudioMixingStateStopped = 713,
  /** 714: An exception occurs during the playback of the music file.
   <p>This state comes with one of the following associated reasons:</p>
   <li><code>HDAgoraAudioMixingReasonCanNotOpen(701)</code></li>
   <li><code>HDAgoraAudioMixingReasonTooFrequentCall(702)</code></li>
   <li><code>HDAgoraAudioMixingReasonInterruptedEOF(703)</code></li>
   */
  HDAgoraAudioMixingStateFailed = 714,
};

/** Audio Mixing Error Code. <p>**Deprecated** from v3.4.0. Use HDAgoraAudioMixingReasonCode instead.</p> */
typedef NS_ENUM(NSInteger, HDAgoraAudioMixingErrorCode) {
  /** 701: The SDK cannot open the audio mixing file. */
  HDAgoraAudioMixingErrorCanNotOpen __deprecated_enum_msg("HDAgoraAudioMixingErrorCanNotOpen is deprecated.") = 701,
  /** 702: The SDK opens the audio mixing file too frequently. */
  HDAgoraAudioMixingErrorTooFrequentCall __deprecated_enum_msg("HDAgoraAudioMixingErrorTooFrequentCall is deprecated.") = 702,
  /** 703: The opening of the audio mixing file is interrupted. */
  HDAgoraAudioMixingErrorInterruptedEOF __deprecated_enum_msg("HDAgoraAudioMixingErrorInterruptedEOF is deprecated.") = 703,
  /** 0: No error. */
  HDAgoraAudioMixingErrorOK __deprecated_enum_msg("HDAgoraAudioMixingErrorOK is deprecated.") = 0,
};

/**  The reason for the change of the music file playback state. Reports in the [localAudioMixingStateDidChanged]([HDAgoraRtcEngineDelegate rtcEngine:localAudioMixingStateDidChanged:reason:]) callback.

 @since 3.4.0
 */
typedef NS_ENUM(NSInteger, HDAgoraAudioMixingReasonCode) {
  /** 701: The SDK cannot open the music file. Possible causes include the local music file does not exist, the SDK
   does not support the file format, or the SDK cannot access the music file URL.
   */
  HDAgoraAudioMixingReasonCanNotOpen = 701,
  /** 702: The SDK opens the music file too frequently. If you need to call
   [startAudioMixing]([HDAgoraRtcEngineKit startAudioMixing:loopback:replace:cycle:startPos:]) multiple times, ensure that the call
   interval is longer than 500 ms.
   */
  HDAgoraAudioMixingReasonTooFrequentCall = 702,
  /** 703: The music file playback is interrupted.
   */
  HDAgoraAudioMixingReasonInterruptedEOF = 703,
  /** 720: Successfully calls [startAudioMixing]([HDAgoraRtcEngineKit startAudioMixing:loopback:replace:cycle:startPos:]) to play a music file.
   */
  HDAgoraAudioMixingReasonStartedByUser = 720,
  /** 721: The music file completes a loop playback.
   */
  HDAgoraAudioMixingReasonOneLoopCompleted = 721,
  /** 722: The music file starts a new loop playback.
   */
  HDAgoraAudioMixingReasonStartNewLoop = 722,
  /** 723: The music file completes all loop playback.
   */
  HDAgoraAudioMixingReasonAllLoopsCompleted = 723,
  /** 724: Successfully calls [stopAudioMixing]([HDAgoraRtcEngineKit stopAudioMixing]) to stop playing the music file.
   */
  HDAgoraAudioMixingReasonStoppedByUser = 724,
  /** 725: Successfully calls [pauseAudioMixing]([HDAgoraRtcEngineKit pauseAudioMixing]) to pause playing the music file.
   */
  HDAgoraAudioMixingReasonPausedByUser = 725,
  /** 726: Successfully calls [resumeAudioMixing]([HDAgoraRtcEngineKit resumeAudioMixing]) to resume playing the music file.
   */
  HDAgoraAudioMixingReasonResumedByUser = 726,
};

/** Video profile.

**DEPRECATED**

Please use `HDAgoraVideoEncoderConfiguration`.

iPhones do not support resolutions above 720p.
*/
typedef NS_ENUM(NSInteger, HDAgoraVideoProfile) {
  /** Invalid profile. */
  HDAgoraVideoProfileInvalid = -1,
  /** Resolution 160 * 120, frame rate 15 fps, bitrate 65 Kbps. */
  HDAgoraVideoProfileLandscape120P = 0,
  /** (iOS only) Resolution 120 * 120, frame rate 15 fps, bitrate 50 Kbps. */
  HDAgoraVideoProfileLandscape120P_3 = 2,
  /** (iOS only) Resolution 320 * 180, frame rate 15 fps, bitrate 140 Kbps. */
  HDAgoraVideoProfileLandscape180P = 10,
  /** (iOS only) Resolution 180 * 180, frame rate 15 fps, bitrate 100 Kbps. */
  HDAgoraVideoProfileLandscape180P_3 = 12,
  /** Resolution 240 * 180, frame rate 15 fps, bitrate 120 Kbps. */
  HDAgoraVideoProfileLandscape180P_4 = 13,
  /** Resolution 320 * 240, frame rate 15 fps, bitrate 200 Kbps. */
  HDAgoraVideoProfileLandscape240P = 20,
  /** (iOS only) Resolution 240 * 240, frame rate 15 fps, bitrate 140 Kbps. */
  HDAgoraVideoProfileLandscape240P_3 = 22,
  /** Resolution 424 * 240, frame rate 15 fps, bitrate 220 Kbps. */
  HDAgoraVideoProfileLandscape240P_4 = 23,
  /** Resolution 640 * 360, frame rate 15 fps, bitrate 400 Kbps. */
  HDAgoraVideoProfileLandscape360P = 30,
  /** (iOS only) Resolution 360 * 360, frame rate 15 fps, bitrate 260 Kbps. */
  HDAgoraVideoProfileLandscape360P_3 = 32,
  /** Resolution 640 * 360, frame rate 30 fps, bitrate 600 Kbps. */
  HDAgoraVideoProfileLandscape360P_4 = 33,
  /** Resolution 360 * 360, frame rate 30 fps, bitrate 400 Kbps. */
  HDAgoraVideoProfileLandscape360P_6 = 35,
  /** Resolution 480 * 360, frame rate 15 fps, bitrate 320 Kbps. */
  HDAgoraVideoProfileLandscape360P_7 = 36,
  /** Resolution 480 * 360, frame rate 30 fps, bitrate 490 Kbps. */
  HDAgoraVideoProfileLandscape360P_8 = 37,
  /** Resolution 640 * 360, frame rate 15 fps, bitrate 800 Kbps.
   <p><b>Note:</b> This profile applies to the interactive live streaming channel profile only.</p>
   */
  HDAgoraVideoProfileLandscape360P_9 = 38,
  /** Resolution 640 * 360, frame rate 24 fps, bitrate 800 Kbps.
   <p>><b>Note:</b> This profile applies to the interactive live streaming channel profile only.</p>
   */
  HDAgoraVideoProfileLandscape360P_10 = 39,
  /** Resolution 640 * 360, frame rate 24 fps, bitrate 1000 Kbps.
   <p><b>Note:</b> This profile applies to the interactive live streaming channel profile only.</p>
   */
  HDAgoraVideoProfileLandscape360P_11 = 100,
  /** Resolution 640 * 480, frame rate 15 fps, bitrate 500 Kbps. */
  HDAgoraVideoProfileLandscape480P = 40,
  /** (iOS only) Resolution 480 * 480, frame rate 15 fps, bitrate 400 Kbps. */
  HDAgoraVideoProfileLandscape480P_3 = 42,
  /** Resolution 640 * 480, frame rate 30 fps, bitrate 750 Kbps. */
  HDAgoraVideoProfileLandscape480P_4 = 43,
  /** Resolution 480 * 480, frame rate 30 fps, bitrate 600 Kbps. */
  HDAgoraVideoProfileLandscape480P_6 = 45,
  /** Resolution 848 * 480, frame rate 15 fps, bitrate 610 Kbps. */
  HDAgoraVideoProfileLandscape480P_8 = 47,
  /** Resolution 848 * 480, frame rate 30 fps, bitrate 930 Kbps. */
  HDAgoraVideoProfileLandscape480P_9 = 48,
  /** Resolution 640 * 480, frame rate 10 fps, bitrate 400 Kbps. */
  HDAgoraVideoProfileLandscape480P_10 = 49,
  /** Resolution 1280 * 720, frame rate 15 fps, bitrate 1130 Kbps. */
  HDAgoraVideoProfileLandscape720P = 50,
  /** Resolution 1280 * 720, frame rate 30 fps, bitrate 1710 Kbps. */
  HDAgoraVideoProfileLandscape720P_3 = 52,
  /** Resolution 960 * 720, frame rate 15 fps, bitrate 910 Kbps. */
  HDAgoraVideoProfileLandscape720P_5 = 54,
  /** Resolution 960 * 720, frame rate 30 fps, bitrate 1380 Kbps. */
  HDAgoraVideoProfileLandscape720P_6 = 55,
  /** (macOS only) Resolution 1920 * 1080, frame rate 15 fps, bitrate 2080 Kbps. */
  HDAgoraVideoProfileLandscape1080P = 60,
  /** (macOS only) Resolution 1920 * 1080, frame rate 30 fps, bitrate 3150 Kbps. */
  HDAgoraVideoProfileLandscape1080P_3 = 62,
  /** (macOS only) Resolution 1920 * 1080, frame rate 60 fps, bitrate 4780 Kbps. */
  HDAgoraVideoProfileLandscape1080P_5 = 64,
  /** Reserved for future use. */
  HDAgoraVideoProfileLandscape1440P = 66,
  /** Reserved for future use. */
  HDAgoraVideoProfileLandscape1440P_2 = 67,
  /** Reserved for future use. */
  HDAgoraVideoProfileLandscape4K = 70,
  /** Reserved for future use. */
  HDAgoraVideoProfileLandscape4K_3 = 72,

  /** Resolution 120 * 160, frame rate 15 fps, bitrate 65 Kbps. */
  HDAgoraVideoProfilePortrait120P = 1000,
  /** (iOS only) Resolution 120 * 120, frame rate 15 fps, bitrate 50 Kbps. */
  HDAgoraVideoProfilePortrait120P_3 = 1002,
  /** (iOS only) Resolution 180 * 320, frame rate 15 fps, bitrate 140 Kbps. */
  HDAgoraVideoProfilePortrait180P = 1010,
  /** (iOS only) Resolution 180 * 180, frame rate 15 fps, bitrate 100 Kbps. */
  HDAgoraVideoProfilePortrait180P_3 = 1012,
  /** Resolution 180 * 240, frame rate 15 fps, bitrate 120 Kbps. */
  HDAgoraVideoProfilePortrait180P_4 = 1013,
  /** Resolution 240 * 320, frame rate 15 fps, bitrate 200 Kbps. */
  HDAgoraVideoProfilePortrait240P = 1020,
  /** (iOS only) Resolution 240 * 240, frame rate 15 fps, bitrate 140 Kbps. */
  HDAgoraVideoProfilePortrait240P_3 = 1022,
  /** Resolution 240 * 424, frame rate 15 fps, bitrate 220 Kbps. */
  HDAgoraVideoProfilePortrait240P_4 = 1023,
  /** Resolution 360 * 640, frame rate 15 fps, bitrate 400 Kbps. */
  HDAgoraVideoProfilePortrait360P = 1030,
  /** (iOS only) Resolution 360 * 360, frame rate 15 fps, bitrate 260 Kbps. */
  HDAgoraVideoProfilePortrait360P_3 = 1032,
  /** Resolution 360 * 640, frame rate 30 fps, bitrate 600 Kbps. */
  HDAgoraVideoProfilePortrait360P_4 = 1033,
  /** Resolution 360 * 360, frame rate 30 fps, bitrate 400 Kbps. */
  HDAgoraVideoProfilePortrait360P_6 = 1035,
  /** Resolution 360 * 480, frame rate 15 fps, bitrate 320 Kbps. */
  HDAgoraVideoProfilePortrait360P_7 = 1036,
  /** Resolution 360 * 480, frame rate 30 fps, bitrate 490 Kbps. */
  HDAgoraVideoProfilePortrait360P_8 = 1037,
  /** Resolution 360 * 640, frame rate 15 fps, bitrate 600 Kbps. */
  HDAgoraVideoProfilePortrait360P_9 = 1038,
  /** Resolution 360 * 640, frame rate 24 fps, bitrate 800 Kbps. */
  HDAgoraVideoProfilePortrait360P_10 = 1039,
  /** Resolution 360 * 640, frame rate 24 fps, bitrate 800 Kbps. */
  HDAgoraVideoProfilePortrait360P_11 = 1100,
  /** Resolution 480 * 640, frame rate 15 fps, bitrate 500 Kbps. */
  HDAgoraVideoProfilePortrait480P = 1040,
  /** (iOS only) Resolution 480 * 480, frame rate 15 fps, bitrate 400 Kbps. */
  HDAgoraVideoProfilePortrait480P_3 = 1042,
  /** Resolution 480 * 640, frame rate 30 fps, bitrate 750 Kbps. */
  HDAgoraVideoProfilePortrait480P_4 = 1043,
  /** Resolution 480 * 480, frame rate 30 fps, bitrate 600 Kbps. */
  HDAgoraVideoProfilePortrait480P_6 = 1045,
  /** Resolution 480 * 848, frame rate 15 fps, bitrate 610 Kbps. */
  HDAgoraVideoProfilePortrait480P_8 = 1047,
  /** Resolution 480 * 848, frame rate 30 fps, bitrate 930 Kbps. */
  HDAgoraVideoProfilePortrait480P_9 = 1048,
  /** Resolution 480 * 640, frame rate 10 fps, bitrate 400 Kbps. */
  HDAgoraVideoProfilePortrait480P_10 = 1049,
  /** Resolution 720 * 1280, frame rate 15 fps, bitrate 1130 Kbps. */
  HDAgoraVideoProfilePortrait720P = 1050,
  /** Resolution 720 * 1280, frame rate 30 fps, bitrate 1710 Kbps. */
  HDAgoraVideoProfilePortrait720P_3 = 1052,
  /** Resolution 720 * 960, frame rate 15 fps, bitrate 910 Kbps. */
  HDAgoraVideoProfilePortrait720P_5 = 1054,
  /** Resolution 720 * 960, frame rate 30 fps, bitrate 1380 Kbps. */
  HDAgoraVideoProfilePortrait720P_6 = 1055,
  /** (macOS only) Resolution 1080 * 1920, frame rate 15 fps, bitrate 2080 Kbps. */
  HDAgoraVideoProfilePortrait1080P = 1060,
  /** (macOS only) Resolution 1080 * 1920, frame rate 30 fps, bitrate 3150 Kbps. */
  HDAgoraVideoProfilePortrait1080P_3 = 1062,
  /** (macOS only) Resolution 1080 * 1920, frame rate 60 fps, bitrate 4780 Kbps. */
  HDAgoraVideoProfilePortrait1080P_5 = 1064,
  /** Reserved for future use. */
  HDAgoraVideoProfilePortrait1440P = 1066,
  /** Reserved for future use. */
  HDAgoraVideoProfilePortrait1440P_2 = 1067,
  /** Reserved for future use. */
  HDAgoraVideoProfilePortrait4K = 1070,
  /** Reserved for future use. */
  HDAgoraVideoProfilePortrait4K_3 = 1072,
  /** (Default) Resolution 640 * 360, frame rate 15 fps, bitrate 400 Kbps. */
  HDAgoraVideoProfileDEFAULT = HDAgoraVideoProfileLandscape360P,
};

/** The camera capture preference. */
typedef NS_ENUM(NSInteger, HDAgoraCameraCaptureOutputPreference) {
  /** (default) Self-adapts the camera output parameters to the system performance and network conditions to balance CPU consumption and video preview quality. */
  HDAgoraCameraCaptureOutputPreferenceAuto = 0,
  /** Prioritizes the system performance. The SDK chooses the dimension and frame rate of the local camera capture closest to those set by [setVideoEncoderConfiguration]([HDAgoraRtcEngineKit setVideoEncoderConfiguration:]). */
  HDAgoraCameraCaptureOutputPreferencePerformance = 1,
  /** Prioritizes the local preview quality. The SDK chooses higher camera output parameters to improve the local video preview quality. This option requires extra CPU and RAM usage for video pre-processing. */
  HDAgoraCameraCaptureOutputPreferencePreview = 2,
  /** Allows you to customize the width and height of the video image captured by the local camera. */
  HDAgoraCameraCaptureOutputPreferenceManual = 3,
  /** Internal use only */
  HDAgoraCameraCaptureOutputPreferenceUnkown = 4
};

#if defined(TARGET_OS_IOS) && TARGET_OS_IOS
/** The camera direction. */
typedef NS_ENUM(NSInteger, HDAgoraCameraDirection) {
  /** The rear camera. */
  HDAgoraCameraDirectionRear = 0,
  /** The front camera. */
  HDAgoraCameraDirectionFront = 1,
};
#endif

/** Video frame rate */
typedef NS_ENUM(NSInteger, HDAgoraVideoFrameRate) {
  /** 1 fps. */
  HDAgoraVideoFrameRateFps1 = 1,
  /** 7 fps. */
  HDAgoraVideoFrameRateFps7 = 7,
  /** 10 fps. */
  HDAgoraVideoFrameRateFps10 = 10,
  /** 15 fps. */
  HDAgoraVideoFrameRateFps15 = 15,
  /** 24 fps. */
  HDAgoraVideoFrameRateFps24 = 24,
  /** 30 fps. */
  HDAgoraVideoFrameRateFps30 = 30,
  /** 60 fps (macOS only). */
  HDAgoraVideoFrameRateFps60 = 60,
};

/** Video output orientation mode.

  **Note:** When a custom video source is used, if you set HDAgoraVideoOutputOrientationMode as HDAgoraVideoOutputOrientationModeFixedLandscape(1) or HDAgoraVideoOutputOrientationModeFixedPortrait(2), when the rotated video image has a different orientation than the specified output orientation, the video encoder first crops it and then encodes it.
 */
typedef NS_ENUM(NSInteger, HDAgoraVideoOutputOrientationMode) {
  /** Adaptive mode (Default).
   <p>The video encoder adapts to the orientation mode of the video input device. When you use a custom video source, the output video from the encoder inherits the orientation of the original video.
   <ul><li>If the width of the captured video from the SDK is greater than the height, the encoder sends the video in landscape mode. The encoder also sends the rotational information of the video, and the receiver uses the rotational information to rotate the received video.</li>
   <li>If the original video is in portrait mode, the output video from the encoder is also in portrait mode. The encoder also sends the rotational information of the video to the receiver.</li></ul></p>
   */
  HDAgoraVideoOutputOrientationModeAdaptative = 0,
  /** Landscape mode.
   <p>The video encoder always sends the video in landscape mode. The video encoder rotates the original video before sending it and the rotational information is 0. This mode applies to scenarios involving CDN live streaming.</p>
   */
  HDAgoraVideoOutputOrientationModeFixedLandscape = 1,
  /** Portrait mode.
   <p>The video encoder always sends the video in portrait mode. The video encoder rotates the original video before sending it and the rotational information is 0. This mode applies to scenarios involving CDN live streaming.</p>
   */
  HDAgoraVideoOutputOrientationModeFixedPortrait = 2,
};

/** Channel profile. */
typedef NS_ENUM(NSInteger, HDAgoraChannelProfile) {
  /** 0: Communication.
   <p>This profile applies to scenarios such as an audio call or video call, where all users can publish and subscribe to streams.</p>
   */
  HDAgoraChannelProfileCommunication = 0,
  /** 1: Interactive live streaming.
   <p>In this profile, uses have roles, namely, host and audience (default). A host both publishes and subscribes to streams, while an audience subscribes to streams only. This profile applies to scenarios such as a chat room or interactive video streaming.</p>
   */
  HDAgoraChannelProfileLiveBroadcasting = 1,
  /** HDAgora recommends not using this profile.
   */
  HDAgoraChannelProfileGame = 2,
};

/** The role of a user in a interactive live streaming. */
typedef NS_ENUM(NSInteger, HDAgoraClientRole) {
  /** 1: Host. A host can both send and receive streams.
   If you set this user role in the channel, the SDK automatically calls
   [muteLocalAudioStream(NO)]([HDAgoraRtcEngineKit muteLocalAudioStream:]) and
   [muteLocalVideoStream(NO)]([HDAgoraRtcEngineKit muteLocalVideoStream:]).
   */
  HDAgoraClientRoleBroadcaster = 1,
  /** 2: (Default) Audience. An audience member can only receive streams.
   If you set this user role in the channel, the SDK automatically calls
   [muteLocalAudioStream(YES)]([HDAgoraRtcEngineKit muteLocalAudioStream:]) and
   [muteLocalVideoStream(YES)]([HDAgoraRtcEngineKit muteLocalVideoStream:]).
   */
  HDAgoraClientRoleAudience = 2,
};

/** The latency level of an audience member in a interactive live streaming.<p>**Note**:</p><p>Takes effect only when the user role is
 `HDAgoraClientRoleAudience`.</p> */
typedef NS_ENUM(NSInteger, HDAgoraAudienceLatencyLevelType) {
  /** 1: Low latency. */
  HDAgoraAudienceLatencyLevelLowLatency = 1,
  /** 2: (Default) Ultra low latency. */
  HDAgoraAudienceLatencyLevelUltraLowLatency = 2,
};

/** The brightness level of the video image captured by the local camera. */
typedef NS_ENUM(NSInteger, HDAgoraCaptureBrightnessLevelType) {
  /** -1: The SDK does not detect the brightness level of the video image.
   Wait a few seconds to get the brightness level in the next callback.
   */
  HDAgoraCaptureBrightnessLevelInvalid = -1,
  /** 0: The brightness level of the video image is normal.
   */
  HDAgoraCaptureBrightnessLevelNormal = 0,
  /** 1: The brightness level of the video image is too bright.
   */
  HDAgoraCaptureBrightnessLevelBright = 1,
  /** 2: The brightness level of the video image is too dark.
   */
  HDAgoraCaptureBrightnessLevelDark = 2,
};

/** Media type. */
typedef NS_ENUM(NSInteger, HDAgoraMediaType) {
  /** No audio and video. */
  HDAgoraMediaTypeNone = 0,
  /** Audio only. */
  HDAgoraMediaTypeAudioOnly = 1,
  /** Video only. */
  HDAgoraMediaTypeVideoOnly = 2,
  /** Audio and video. */
  HDAgoraMediaTypeAudioAndVideo = 3,
};

/** Encryption mode. HDAgora recommends using either the
 `HDAgoraEncryptionModeAES128GCM2` or `HDAgoraEncryptionModeAES256GCM2` encryption
 mode, both of which support adding a salt and are more secure.
 */
typedef NS_ENUM(NSInteger, HDAgoraEncryptionMode) {
  /** 0: **Deprecated** as of v3.4.5. */
  HDAgoraEncryptionModeNone __deprecated_enum_msg("HDAgoraEncryptionModeNone is deprecated.") = 0,
  /** 1: 128-bit AES encryption, XTS mode. */
  HDAgoraEncryptionModeAES128XTS = 1,
  /** 2: 128-bit AES encryption, ECB mode. */
  HDAgoraEncryptionModeAES128ECB = 2,
  /** 3: 256-bit AES encryption, XTS mode. */
  HDAgoraEncryptionModeAES256XTS = 3,
  /** 4: Reserved parameter. */
  HDAgoraEncryptionModeSM4128ECB = 4,
  /** 5: 128-bit AES encryption, GCM mode.

   @since v3.3.1
   */
  HDAgoraEncryptionModeAES128GCM = 5,
  /** 6: 256-bit AES encryption, GCM mode.

   @since v3.3.1
   */
  HDAgoraEncryptionModeAES256GCM = 6,
  /** 7: (Default) 128-bit AES encryption, GCM mode. Compared to
   `HDAgoraEncryptionModeAES128GCM` encryption mode,
   `HDAgoraEncryptionModeAES128GCM2` encryption mode is more secure and requires
   you to set the salt (`encryptionKdfSalt`).

   @since v3.4.5
   */
  HDAgoraEncryptionModeAES128GCM2 = 7,
  /** 8: 256-bit AES encryption, GCM mode. Compared to
   `HDAgoraEncryptionModeAES256GCM` encryption mode,
   `HDAgoraEncryptionModeAES256GCM2` encryption mode is more secure and requires
   you to set the salt (`encryptionKdfSalt`).

   @since v3.4.5
   */
  HDAgoraEncryptionModeAES256GCM2 = 8,
  /** Enumerator boundary */
  HDAgoraEncryptionModeEnd,
};

/** Reason for the user being offline. */
typedef NS_ENUM(NSUInteger, HDAgoraUserOfflineReason) {
  /** The user left the current channel. */
  HDAgoraUserOfflineReasonQuit = 0,
  /** The SDK timed out and the user dropped offline because no data packet is received within a certain period of time. If a user quits the call and the message is not passed to the SDK (due to an unreliable channel), the SDK assumes the user dropped offline. */
  HDAgoraUserOfflineReasonDropped = 1,
  /** (Interactive live streaming only.) The client role switched from the host to the audience. */
  HDAgoraUserOfflineReasonBecomeAudience = 2,
};

/** The RTMP or RTMPS streaming state. */
typedef NS_ENUM(NSUInteger, HDAgoraRtmpStreamingState) {
  /** 0: The RTMP or RTMPS streaming has not started or has ended. This state is also triggered after you remove an RTMP or RTMPS stream from the CDN by calling [removePublishStreamUrl]([HDAgoraRtcEngineKit removePublishStreamUrl:]).*/
  HDAgoraRtmpStreamingStateIdle = 0,
  /** 1: The SDK is connecting to HDAgora's streaming server and the CDN server. This state is triggered after you call the [addPublishStreamUrl]([HDAgoraRtcEngineKit addPublishStreamUrl:transcodingEnabled:]) method. */
  HDAgoraRtmpStreamingStateConnecting = 1,
  /** 2: The RTMP or RTMPS streaming is being published. The SDK successfully publishes the RTMP or RTMPS streaming and returns this state. */
  HDAgoraRtmpStreamingStateRunning = 2,
  /** 3: The RTMP or RTMPS streaming is recovering. When exceptions occur to the CDN, or the streaming is interrupted, the SDK attempts to resume RTMP or RTMPS streaming and returns this state.
<li> If the SDK successfully resumes the streaming, `HDAgoraRtmpStreamingStateRunning(2)` returns.
<li> If the streaming does not resume within 60 seconds or server errors occur, HDAgoraRtmpStreamingStateFailure(4) returns. You can also reconnect to the server by calling the [removePublishStreamUrl]([HDAgoraRtcEngineKit removePublishStreamUrl:]) and [addPublishStreamUrl]([HDAgoraRtcEngineKit addPublishStreamUrl:transcodingEnabled:]) methods. */
  HDAgoraRtmpStreamingStateRecovering = 3,
  /** 4: The RTMP or RTMPS streaming fails. See the errorCode parameter for the detailed error information. You can also call the [addPublishStreamUrl]([HDAgoraRtcEngineKit addPublishStreamUrl:transcodingEnabled:]) method to publish the RTMP or RTMPS streaming again. */
  HDAgoraRtmpStreamingStateFailure = 4,
  /** 5: The SDK is disconnecting from the HDAgora streaming server and CDN. When you call `remove` or `stop` to stop the streaming normally, the SDK reports the streaming state as `Disconnecting`, `Idle` in sequence.

   @since v3.6.0
   */
  HDAgoraRtmpStreamingStateDisconnecting = 5,
};

/** The detailed error information for streaming. */
typedef NS_ENUM(NSUInteger, HDAgoraRtmpStreamingErrorCode) {
  /** 0: The RTMP or RTMPS streaming publishes successfully. */
  HDAgoraRtmpStreamingErrorCodeOK = 0,
  /** 1: Invalid argument used. If, for example, you do not call the [setLiveTranscoding]([HDAgoraRtcEngineKit setLiveTranscoding:]) method to configure the LiveTranscoding parameters before calling the [addPublishStreamUrl]([HDAgoraRtcEngineKit addPublishStreamUrl:transcodingEnabled:]) method, the SDK returns this error. Check whether you set the parameters in the setLiveTranscoding method properly. */
  HDAgoraRtmpStreamingErrorCodeInvalidParameters = 1,
  /** 2: The RTMP or RTMPS streaming is encrypted and cannot be published. */
  HDAgoraRtmpStreamingErrorCodeEncryptedStreamNotAllowed = 2,
  /** 3: Timeout for the RTMP or RTMPS streaming. Call the [addPublishStreamUrl]([HDAgoraRtcEngineKit addPublishStreamUrl:transcodingEnabled:]) method to publish the streaming again. */
  HDAgoraRtmpStreamingErrorCodeConnectionTimeout = 3,
  /** 4: An error occurs in HDAgora's streaming server. Call the [addPublishStreamUrl]([HDAgoraRtcEngineKit addPublishStreamUrl:transcodingEnabled:]) method to publish the streaming again. */
  HDAgoraRtmpStreamingErrorCodeInternalServerError = 4,
  /** 5: An error occurs in the CDN server. */
  HDAgoraRtmpStreamingErrorCodeRtmpServerError = 5,
  /** 6: The RTMP or RTMPS streaming publishes too frequently. */
  HDAgoraRtmpStreamingErrorCodeTooOften = 6,
  /** 7: The host publishes more than 10 URLs. Delete the unnecessary URLs before adding new ones. */
  HDAgoraRtmpStreamingErrorCodeReachLimit = 7,
  /** 8: The host manipulates other hosts' URLs. Check your app logic. */
  HDAgoraRtmpStreamingErrorCodeNotAuthorized = 8,
  /** 9: HDAgora's server fails to find the RTMP or RTMPS streaming. */
  HDAgoraRtmpStreamingErrorCodeStreamNotFound = 9,
  /** 10: The format of the RTMP or RTMPS streaming URL is not supported. Check whether the URL format is correct. */
  HDAgoraRtmpStreamingErrorCodeFormatNotSupported = 10,
  /** 11: The user role is not host, so the user cannot use the CDN live streaming function. Check your application code logic.

   @since v3.6.0
   */
  HDAgoraRtmpStreamPublishErrorNotBroadcaster = 11,
  /** 13: The `updateRtmpTranscoding` or `setLiveTranscoding` method is called to update the transcoding configuration in a scenario where there is streaming without transcoding. Check your application code logic.

   @since v3.6.0
   */
  HDAgoraRtmpStreamPublishErrorTranscodingNoMixStream = 13,
  /** 14: Errors occurred in the host's network.

   @since v3.6.0
   */
  HDAgoraRtmpStreamPublishErrorNetDown = 14,
  /** 15: Your App ID does not have permission to use the CDN live streaming function. Refer to [Prerequisites](https://docs.HDAgora.io/en/Interactive%20Broadcast/cdn_streaming_apple?platform=iOS#prerequisites) to enable the CDN live streaming permission.

   @since v3.6.0
   */
  HDAgoraRtmpStreamPublishErrorInvalidAppId = 15,
  /** The streaming has been stopped normally. After you call
   [removePublishStreamUrl]([HDAgoraRtcEngineKit removePublishStreamUrl:]) to
   stop streaming, the SDK returns this value.

   @since v3.4.5
   */
  HDAgoraRtmpStreamingErrorCodeUnpublishOK = 100,
};

/** Events during the RTMP or RTMPS streaming. */
typedef NS_ENUM(NSUInteger, HDAgoraRtmpStreamingEvent) {
  /** 1: An error occurs when you add a background image or a watermark image
   to the RTMP stream.
   */
  HDAgoraRtmpStreamingEventFailedLoadImage = 1,
  /** 2: The streaming URL is already being used for CDN live streaming. If you
   want to start new streaming, use a new streaming URL.

   @since v3.4.5
   */
  HDAgoraRtmpStreamingEventUrlAlreadyInUse = 2,
  /** 3: The feature is not supported.

   @since v3.6.0
   */
  HDAgoraRtmpStreamingEventAdvancedFeatureNotSupport = 3,
  /** 4: Reserved.

   @since v3.6.0
   */
  HDAgoraRtmpStreamingEventRequestTooOften = 4,
};

/** State of importing an external video stream in the interactive live streaming. */
typedef NS_ENUM(NSUInteger, HDAgoraInjectStreamStatus) {
  /** The external video stream imported successfully. */
  HDAgoraInjectStreamStatusStartSuccess = 0,
  /** The external video stream already exists. */
  HDAgoraInjectStreamStatusStartAlreadyExists = 1,
  /** The external video stream import is unauthorized. */
  HDAgoraInjectStreamStatusStartUnauthorized = 2,
  /** Import external video stream timeout. */
  HDAgoraInjectStreamStatusStartTimedout = 3,
  /** The external video stream failed to import. */
  HDAgoraInjectStreamStatusStartFailed = 4,
  /** The external video stream imports successfully. */
  HDAgoraInjectStreamStatusStopSuccess = 5,
  /** No external video stream is found. */
  HDAgoraInjectStreamStatusStopNotFound = 6,
  /** The external video stream is stopped from being unauthorized. */
  HDAgoraInjectStreamStatusStopUnauthorized = 7,
  /** Importing the external video stream timeout. */
  HDAgoraInjectStreamStatusStopTimedout = 8,
  /** Importing the external video stream failed. */
  HDAgoraInjectStreamStatusStopFailed = 9,
  /** The external video stream import is interrupted. */
  HDAgoraInjectStreamStatusBroken = 10,
};

/** Output log filter level. */
typedef NS_ENUM(NSUInteger, HDAgoraLogFilter) {
  /** Do not output any log information. */
  HDAgoraLogFilterOff = 0,
  /** Output all log information. Set your log filter as debug if you want to get the most complete log file. */
  HDAgoraLogFilterDebug = 0x080f,
  /** Output CRITICAL, ERROR, WARNING, and INFO level log information. We recommend setting your log filter as this level. */
  HDAgoraLogFilterInfo = 0x000f,
  /** Outputs CRITICAL, ERROR, and WARNING level log information. */
  HDAgoraLogFilterWarning = 0x000e,
  /** Outputs CRITICAL and ERROR level log information. */
  HDAgoraLogFilterError = 0x000c,
  /** Outputs CRITICAL level log information. */
  HDAgoraLogFilterCritical = 0x0008,
};

/** Audio recording quality, which is set in [startAudioRecordingWithConfig]([HDAgoraRtcEngineKit startAudioRecordingWithConfig:]). */
typedef NS_ENUM(NSInteger, HDAgoraAudioRecordingQuality) {
  /** 0: Low quality. For example, the size of an AAC file with a sample rate of 32,000 Hz and a 10-minute recording is approximately 1.2 MB. */
  HDAgoraAudioRecordingQualityLow = 0,
  /** 1: (Default) Medium quality. For example, the size of an AAC file with a sample rate of 32,000 Hz and a 10-minute recording is approximately 2 MB. */
  HDAgoraAudioRecordingQualityMedium = 1,
  /** 2: High quality. For example, the size of an AAC file with a sample rate of 32,000 Hz and a 10-minute recording is approximately 3.75 MB. */
  HDAgoraAudioRecordingQualityHigh = 2
};

/** Recording content, which is set in [startAudioRecordingWithConfig]([HDAgoraRtcEngineKit startAudioRecordingWithConfig:]). */
typedef NS_ENUM(NSInteger, HDAgoraAudioRecordingPosition) {
  /** 0: (Default) Records the mixed audio of the local user and all remote users. */
  HDAgoraAudioRecordingPositionMixedRecordingAndPlayback = 0,
  /** 1: Records the audio of the local user only. */
  HDAgoraAudioRecordingPositionRecording = 1,
  /** 2: Records the audio of all remote users only. */
  HDAgoraAudioRecordingPositionMixedPlayback = 2
};

/** Lifecycle of the CDN live video stream.

**DEPRECATED**
*/
typedef NS_ENUM(NSInteger, HDAgoraRtmpStreamLifeCycle) {
  /** Bound to the channel lifecycle. If all hosts leave the channel, the CDN live streaming stops after 30 seconds. */
  HDAgoraRtmpStreamLifeCycleBindToChannel = 1,
  /** Bound to the owner of the RTMP stream. If the owner leaves the channel, the CDN live streaming stops immediately. */
  HDAgoraRtmpStreamLifeCycleBindToOwnner = 2,
};

/** Network quality. */
typedef NS_ENUM(NSUInteger, HDAgoraNetworkQuality) {
  /** The network quality is unknown. */
  HDAgoraNetworkQualityUnknown = 0,
  /** The network quality is excellent. */
  HDAgoraNetworkQualityExcellent = 1,
  /** The network quality is quite good, but the bitrate may be slightly lower than excellent. */
  HDAgoraNetworkQualityGood = 2,
  /** Users can feel the communication slightly impaired. */
  HDAgoraNetworkQualityPoor = 3,
  /** Users can communicate only not very smoothly. */
  HDAgoraNetworkQualityBad = 4,
  /** The network quality is so bad that users can hardly communicate. */
  HDAgoraNetworkQualityVBad = 5,
  /** The network is disconnected and users cannot communicate at all. */
  HDAgoraNetworkQualityDown = 6,
  /** Users cannot detect the network quality. (Not in use.) */
  HDAgoraNetworkQualityUnsupported = 7,
  /** Detecting the network quality. */
  HDAgoraNetworkQualityDetecting = 8,
};

/** Quality of experience (QoE) of the local user when receiving a remote audio stream.

 @since v3.3.0
 */
typedef NS_ENUM(NSUInteger, HDAgoraExperienceQuality) {
  /** QoE of the local user is good. */
  HDAgoraExperienceQualityGood = 0,
  /** QoE of the local user is poor. */
  HDAgoraExperienceQualityBad = 1,
};

/** The reason for poor QoE of the local user when receiving a remote audio stream.

 @since v3.3.0
 */
typedef NS_ENUM(NSUInteger, HDAgoraExperiencePoorReason) {
  /** None, indicating good QoE of the local user. */
  HDAgoraExperienceReasonNone = 0,
  /** The remote user's network quality is poor. */
  HDAgoraRemoteNetworkPoor = 1,
  /** The local user's network quality is poor. */
  HDAgoraLocalNetworkPoor = 2,
  /** The local user's Wi-Fi or mobile network signal is weak. */
  HDAgoraWirelessSignalPoor = 4,
  /** he local user enables both Wi-Fi and bluetooth, and their signals interfere with each other. As a result, audio transmission quality is undermined. */
  HDAgoraWifiBluetoothCoexist = 8,
};

/** API for future use.
 */
typedef NS_ENUM(NSInteger, HDAgoraUploadErrorReason) {
  HDAgoraUploadErrorReasonSuccess = 0,
  HDAgoraUploadErrorReasonNetError = 1,
  HDAgoraUploadErrorReasonServerError = 2,
};

/** Video stream type. */
typedef NS_ENUM(NSInteger, HDAgoraVideoStreamType) {
  /** High-bitrate, high-resolution video stream. */
  HDAgoraVideoStreamTypeHigh = 0,
  /** Low-bitrate, low-resolution video stream. */
  HDAgoraVideoStreamTypeLow = 1,
};

/** The priority of the remote user. */
typedef NS_ENUM(NSInteger, HDAgoraUserPriority) {
  /** The user's priority is high. */
  HDAgoraUserPriorityHigh = 50,
  /** (Default) The user's priority is normal. */
  HDAgoraUserPriorityNormal = 100,
};

/**  Quality change of the local video in terms of target frame rate and target bit rate since last count. */
typedef NS_ENUM(NSInteger, HDAgoraVideoQualityAdaptIndication) {
  /** The quality of the local video stays the same. */
  HDAgoraVideoQualityAdaptNone = 0,
  /** The quality improves because the network bandwidth increases. */
  HDAgoraVideoQualityAdaptUpBandwidth = 1,
  /** The quality worsens because the network bandwidth decreases. */
  HDAgoraVideoQualityAdaptDownBandwidth = 2,
};

/** Video display mode. */
typedef NS_ENUM(NSUInteger, HDAgoraVideoRenderMode) {
  /** Hidden(1): Uniformly scale the video until it fills the visible boundaries (cropped). One dimension of the video may have clipped contents. */
  HDAgoraVideoRenderModeHidden = 1,

  /** Fit(2): Uniformly scale the video until one of its dimension fits the boundary (zoomed to fit). Areas that are not filled due to the disparity in the aspect ratio are filled with black. */
  HDAgoraVideoRenderModeFit = 2,

  /** Adaptive(3)：This mode is deprecated. */
  HDAgoraVideoRenderModeAdaptive __deprecated_enum_msg("HDAgoraVideoRenderModeAdaptive is deprecated.") = 3,

  /** Fill(4): The fill mode. In this mode, the SDK stretches or zooms the video to fill the display window. */
  HDAgoraVideoRenderModeFill = 4,
};

/** Self-defined video codec profile. */
typedef NS_ENUM(NSInteger, HDAgoraVideoCodecProfileType) {
  /** 66: Baseline video codec profile. Generally used in video calls on mobile phones. */
  HDAgoraVideoCodecProfileTypeBaseLine = 66,
  /** 77: Main video codec profile. Generally used in mainstream electronics, such as MP4 players, portable video players, PSP, and iPads. */
  HDAgoraVideoCodecProfileTypeMain = 77,
  /** 100: (Default) High video codec profile. Generally used in high-resolution interactive live streaming or television. */
  HDAgoraVideoCodecProfileTypeHigh = 100
};

/** The video codec type. (iOS only) */
typedef NS_ENUM(NSInteger, HDAgoraVideoCodecType) {
  /** 1: VP8 */
  HDAgoraVideoCodecTypeVP8 = 1,
  /** 2: (Default) H.264 */
  HDAgoraVideoCodecTypeH264 = 2,
  /** 3: Enhanced VP8 */
  HDAgoraVideoCodecTypeEVP = 3,
  /** 4: Enhanced H.264 */
  HDAgoraVideoCodecTypeE264 = 4,
};

/** The video codec type of the output video stream.

 @since v3.2.0
 */
typedef NS_ENUM(NSInteger, HDAgoraVideoCodecTypeForStream) {
  /** 1: (Default) H.264 */
  HDAgoraVideoCodecTypeH264ForStream = 1,
  /** 2: H.265 */
  HDAgoraVideoCodecTypeH265ForStream = 2,
};

/** Video mirror mode. */
typedef NS_ENUM(NSUInteger, HDAgoraVideoMirrorMode) {
  /** 0: (Default) The SDK determines the mirror mode.
   */
  HDAgoraVideoMirrorModeAuto = 0,
  /** 1: Enables mirror mode. */
  HDAgoraVideoMirrorModeEnabled = 1,
  /** 2: Disables mirror mode. */
  HDAgoraVideoMirrorModeDisabled = 2,
};

/** The publishing state */
typedef NS_ENUM(NSUInteger, HDAgoraStreamPublishState) {
  /** 0: The initial publishing state after joining the channel.
   */
  HDAgoraStreamPublishIdle = 0,
  /** 1: Fails to publish the local stream. Possible reasons:
   <li>The local user calls [muteLocalAudioStream(YES)]([HDAgoraRtcEngineKit muteLocalAudioStream:]) or [muteLocalVideoStream(YES)]([HDAgoraRtcEngineKit muteLocalVideoStream:]) to stop sending local streams.</li>
   <li>The local user calls [disableAudio]([HDAgoraRtcEngineKit disableAudio]) or [disableVideo]([HDAgoraRtcEngineKit disableVideo]) to disable the entire audio or video module.</li>
   <li>The local user calls [enableLocalAudio(NO)]([HDAgoraRtcEngineKit  enableLocalAudio:]) or [enableLocalVideo(NO)]([HDAgoraRtcEngineKit  enableLocalVideo:]) to disable the local audio sampling or video capturing.</li>
   <li>The role of the local user is <tt>HDAgoraClientRoleAudience</tt>.</li>
   */
  HDAgoraStreamPublishNoPublished = 1,
  /** 2: Publishing.
   */
  HDAgoraStreamPublishPublishing = 2,
  /** 3: Publishes successfully.
   */
  HDAgoraStreamPublishPublished = 3,
};

/** The subscribing state. */
typedef NS_ENUM(NSUInteger, HDAgoraStreamSubscribeState) {
  /** 0: The initial subscribing state after joining the channel.
   */
  HDAgoraStreamSubscribeIdle = 0,
  /** 1: Fails to subscribe to the remote stream. Possible reasons:
   <li>The remote user:</li>
   <ul><li>Calls [muteLocalAudioStream(YES)]([HDAgoraRtcEngineKit muteLocalAudioStream:]) or [muteLocalVideoStream(YES)]([HDAgoraRtcEngineKit muteLocalVideoStream:]) to stop sending local streams.</li></ul>
   <ul><li>The local user calls [disableAudio]([HDAgoraRtcEngineKit disableAudio]) or [disableVideo]([HDAgoraRtcEngineKit disableVideo]) to disable the entire audio or video module.</li></ul>
   <ul><li>The local user calls [enableLocalAudio(NO)]([HDAgoraRtcEngineKit enableLocalAudio:]) or [enableLocalVideo(NO)]([HDAgoraRtcEngineKit enableLocalVideo:]) to disable the local audio sampling or video capturing.</li></ul>
   <ul><li>The role of the local user is <tt>HDAgoraClientRoleAudience</tt>.</li></ul>
   <li>The local user calls the following methods to stop receiving remote streams:</li>
   <ul><li>Calls [muteRemoteAudioStream(YES)]([HDAgoraRtcEngineKit muteRemoteAudioStream:mute:]), [muteAllRemoteAudioStreams(YES)]([HDAgoraRtcEngineKit muteAllRemoteAudioStreams:]), or [setDefaultMuteAllRemoteAudioStreams(YES)]([HDAgoraRtcEngineKit setDefaultMuteAllRemoteAudioStreams:]) to stop receiving remote audio streams.</li></ul>
   <ul><li></li>Calls [muteRemoteVideoStream(YES)]([HDAgoraRtcEngineKit muteRemoteVideoStream:mute:]), [muteAllRemoteVideoStreams(YES)]([HDAgoraRtcEngineKit muteAllRemoteVideoStreams:]), or [setDefaultMuteAllRemoteVideoStreams(YES)]([HDAgoraRtcEngineKit setDefaultMuteAllRemoteVideoStreams:]) to stop receiving remote video streams.</ul>
   */
  HDAgoraStreamSubscribeNoSubscribed = 1,
  /** 2: Subscribing.
   */
  HDAgoraStreamSubscribeSubscribing = 2,
  /** 3: Subscribes to and receives the remote stream successfully.
   */
  HDAgoraStreamSubscribeSubscribed = 3,
};

/** The content hint for screen sharing. */
typedef NS_ENUM(NSUInteger, HDAgoraVideoContentHint) {
  /** 0: (Default) No content hint. */
  HDAgoraVideoContentHintNone = 0,
  /** 1: Motion-intensive content. Choose this option if you prefer smoothness or when you are sharing a video clip, movie, or video game. */
  HDAgoraVideoContentHintMotion = 1,
  /** 2: Motionless content. Choose this option if you prefer sharpness or when you are sharing a picture, PowerPoint slide, or text. */
  HDAgoraVideoContentHintDetails = 2,
};

/** The state of the remote video. */
typedef NS_ENUM(NSUInteger, HDAgoraVideoRemoteState) {
  /** 0: The remote video is in the default state, probably due to `HDAgoraVideoRemoteStateReasonLocalMuted(3)`, `HDAgoraVideoRemoteStateReasonRemoteMuted(5)`, or `HDAgoraVideoRemoteStateReasonRemoteOffline(7)`.
   */
  HDAgoraVideoRemoteStateStopped = 0,
  /** 1: The first remote video packet is received.
   */
  HDAgoraVideoRemoteStateStarting = 1,
  /** 2: The remote video stream is decoded and plays normally, probably due to `HDAgoraVideoRemoteStateReasonNetworkRecovery(2)`, `HDAgoraVideoRemoteStateReasonLocalUnmuted(4)`, `HDAgoraVideoRemoteStateReasonRemoteUnmuted(6)`, or `HDAgoraVideoRemoteStateReasonAudioFallbackRecovery(9)`.
   */
  HDAgoraVideoRemoteStateDecoding = 2,
  /** 3: The remote video is frozen, probably due to `HDAgoraVideoRemoteStateReasonNetworkCongestion(1)` or `HDAgoraVideoRemoteStateReasonAudioFallback(8)`.
   */
  HDAgoraVideoRemoteStateFrozen = 3,
  /** 4: The remote video fails to start, probably due to `HDAgoraVideoRemoteStateReasonInternal(0)`.
   */
  HDAgoraVideoRemoteStateFailed = 4,
};

/** The reason for the remote video state change. */
typedef NS_ENUM(NSUInteger, HDAgoraVideoRemoteStateReason) {
  /** 0: The SDK reports this reason when the video state changes. */
  HDAgoraVideoRemoteStateReasonInternal = 0,
  /** 1: Network congestion. */
  HDAgoraVideoRemoteStateReasonNetworkCongestion = 1,
  /** 2: Network recovery. */
  HDAgoraVideoRemoteStateReasonNetworkRecovery = 2,
  /** 3: The local user stops receiving the remote video stream or disables the video module. */
  HDAgoraVideoRemoteStateReasonLocalMuted = 3,
  /** 4: The local user resumes receiving the remote video stream or enables the video module. */
  HDAgoraVideoRemoteStateReasonLocalUnmuted = 4,
  /** 5: The remote user stops sending the video stream or disables the video module. */
  HDAgoraVideoRemoteStateReasonRemoteMuted = 5,
  /** 6: The remote user resumes sending the video stream or enables the video module. */
  HDAgoraVideoRemoteStateReasonRemoteUnmuted = 6,
  /** 7: The remote user leaves the channel. */
  HDAgoraVideoRemoteStateReasonRemoteOffline = 7,
  /** 8: The remote audio-and-video stream falls back to the audio-only stream due to poor network conditions. */
  HDAgoraVideoRemoteStateReasonAudioFallback = 8,
  /** 9: The remote audio-only stream switches back to the audio-and-video stream after the network conditions improve. */
  HDAgoraVideoRemoteStateReasonAudioFallbackRecovery = 9,
};

/** The reason why super resolution is not successfully enabled or the message
 that confirms success.

 @since v3.5.1
 */
typedef NS_ENUM(NSUInteger, HDAgoraSuperResolutionStateReason) {
  /** 0: Super resolution is successfully enabled. */
  HDAgoraSRStateReasonSuccess = 0,
  /** 1: The original resolution of the remote video is beyond the range where
   super resolution can be applied.
   */
  HDAgoraSRStateReasonStreamOverLimitation = 1,
  /** 2: Super resolution is already being used to boost another remote user's video. */
  HDAgoraSRStateReasonUserCountOverLimitation = 2,
  /** 3: The device does not support using super resolution. */
  HDAgoraSRStateReasonDeviceNotSupported = 3,
};

/** The reason why the virtual background is not successfully enabled or the
 message that confirms success.
 @since v3.4.5
 */
typedef NS_ENUM(NSUInteger, HDAgoraVirtualBackgroundSourceStateReason) {
  /** 0: The virtual background is successfully enabled.*/
  HDAgoraVBSStateReasonSuccess = 0,
  /** 1: The custom background image does not exist. Please check the value of
  `source` in HDAgoraVirtualBackgroundSource.
   */
  HDAgoraVBSStateReasonImageNotExist = 1,
  /** 2: The color format of the custom background image is invalid. Please
   check the value of `color` in HDAgoraVirtualBackgroundSource.
   */
  HDAgoraVBSStateReasonColorFormatNotSupported = 2,
  /** 3: The device does not support using the virtual background.*/
  HDAgoraVBSStateReasonDeviceNotSupported = 3,
};

/** Stream fallback option. */
typedef NS_ENUM(NSInteger, HDAgoraStreamFallbackOptions) {
  /** No fallback behavior for the local/remote video stream when the uplink/downlink network condition is unreliable. The quality of the stream is not guaranteed. */
  HDAgoraStreamFallbackOptionDisabled = 0,
  /** Under unreliable downlink network conditions, the remote video stream falls back to the low-stream (low resolution and low bitrate) video. You can only set this option in the [setRemoteSubscribeFallbackOption]([HDAgoraRtcEngineKit setRemoteSubscribeFallbackOption:]) method. Nothing happens when you set this in the [setLocalPublishFallbackOption]([HDAgoraRtcEngineKit setLocalPublishFallbackOption:]) method. */
  HDAgoraStreamFallbackOptionVideoStreamLow = 1,
  /** Under unreliable uplink network conditions, the published video stream falls back to audio only. Under unreliable downlink network conditions, the remote video stream first falls back to the low-stream (low resolution and low bitrate) video; and then to an audio-only stream if the network condition deteriorates. */
  HDAgoraStreamFallbackOptionAudioOnly = 2,
};

/** Audio sample rate. */
typedef NS_ENUM(NSInteger, HDAgoraAudioSampleRateType) {
  /** 32 kHz. */
  HDAgoraAudioSampleRateType32000 = 32000,
  /** 44.1 kHz. */
  HDAgoraAudioSampleRateType44100 = 44100,
  /** 48 kHz. */
  HDAgoraAudioSampleRateType48000 = 48000,
};

/** Audio profile. */
typedef NS_ENUM(NSInteger, HDAgoraAudioProfile) {
  /** 0: Default audio profile.
   <li>In the Communication profile: A sample rate of 32 KHz, audio encoding, mono, and a bitrate of up to 18 Kbps.
   <li>In the interactive live streaming profile: A sample rate of 48 KHz, music encoding, mono, and a bitrate of up to 64 Kbps.</li> */
  HDAgoraAudioProfileDefault = 0,
  /** 1: A sample rate of 32 KHz, audio encoding, mono, and a bitrate of up to 18 Kbps. */
  HDAgoraAudioProfileSpeechStandard = 1,
  /** 2: A sample rate of 48 KHz, music encoding, mono, and a bitrate of up to 64 Kbps. */
  HDAgoraAudioProfileMusicStandard = 2,
  /** 3: A sample rate of 48 KHz, music encoding, stereo, and a bitrate of up to 80 Kbps. */
  HDAgoraAudioProfileMusicStandardStereo = 3,
  /** 4: A sample rate of 48 KHz, music encoding, mono, and a bitrate of up to 96 Kbps. */
  HDAgoraAudioProfileMusicHighQuality = 4,
  /** 5: A sample rate of 48 KHz, music encoding, stereo, and a bitrate of up to 128 Kbps. */
  HDAgoraAudioProfileMusicHighQualityStereo = 5,
};

/** Audio scenario. */
typedef NS_ENUM(NSInteger, HDAgoraAudioScenario) {
  /** 0: Default audio scenario.
   <p><b>Note</b>: If you run the iOS app on an M1 Mac, due to the hardware
   differences between M1 Macs, iPhones, and iPads, the default audio scenario
   of the HDAgora iOS SDK is the same as that of the HDAgora macOS SDK.</p>
   */
  HDAgoraAudioScenarioDefault = 0,
  /** 1: Entertainment scenario where users need to frequently switch the user role. */
  HDAgoraAudioScenarioChatRoomEntertainment = 1,
  /** 2: Education scenario where users want smoothness and stability. */
  HDAgoraAudioScenarioEducation = 2,
  /** 3: High-quality audio chatroom scenario where hosts mainly play music.*/
  HDAgoraAudioScenarioGameStreaming = 3,
  /** 4: Showroom scenario where a single host wants high-quality audio. */
  HDAgoraAudioScenarioShowRoom = 4,
  /** 5: Gaming scenario for group chat that only contains the human voice. */
  HDAgoraAudioScenarioChatRoomGaming = 5,
  /** 6: IoT (Internet of Things) scenario where users use IoT devices with low power consumption. */
  HDAgoraAudioScenarioIot = 6,
  /** Communication scenario.*/
  HDAgoraAudioScenarioCommunication = 7,
  /** 8: Meeting scenario that mainly contains the human voice.

   @since v3.2.0
   */
  HDAgoraAudioScenarioMeeting = 8,
};

/** The current audio route. Reports in the [didAudioRouteChanged]([HDAgoraRtcEngineDelegate rtcEngine:didAudioRouteChanged:]) callback. */
typedef NS_ENUM(NSInteger, HDAgoraAudioOutputRouting) {
  /** -1: Default audio route. */
  HDAgoraAudioOutputRoutingDefault = -1,
  /** 0: The audio route is a headset with a microphone.*/
  HDAgoraAudioOutputRoutingHeadset = 0,
  /** 1: The audio route is an earpiece. */
  HDAgoraAudioOutputRoutingEarpiece = 1,
  /** 2: The audio route is a headset without a microphone. */
  HDAgoraAudioOutputRoutingHeadsetNoMic = 2,
  /** 3: The audio route is the speaker that comes with the device. */
  HDAgoraAudioOutputRoutingSpeakerphone = 3,
  /** 4: The audio route is a Bluetooth headset. */
  HDAgoraAudioOutputRoutingLoudspeaker = 4,
  /** 5: Bluetooth headset. */
  HDAgoraAudioOutputRoutingHeadsetBluetooth = 5,
  /** 6: (macOS only) The audio route is a USB peripheral device. */
  HDAgoraAudioOutputRoutingUsb = 6,
  /** 7: (macOS only) The audio route is an HDMI peripheral device. */
  HDAgoraAudioOutputRoutingHdmi = 7,
  /** 8: (macOS only) The audio route is a DisplayPort peripheral device. */
  HDAgoraAudioOutputRoutingDisplayPort = 8,
  /** 9: The audio route is Apple AirPlay. */
  HDAgoraAudioOutputRoutingAirPlay = 9
};

/** The use mode of the audio data. */
typedef NS_ENUM(NSInteger, HDAgoraAudioRawFrameOperationMode) {
  /** 0: (Default) Read-only mode, in which users can only read the
   HDAgoraAudioFrame without modifying anything. For example, this mode
   applies when users acquire data with the HDAgora SDK and then push the
   RTMP or RTMPS streams.
   */
  HDAgoraAudioRawFrameOperationModeReadOnly = 0,
  /** 1: Write-only mode, in which users replace the HDAgoraAudioFrame with their
   own data and then pass it to the SDK for encoding. For example, this mode
   applies when users need the HDAgora SDK to encode and transmit their custom
   audio data.
   */
  HDAgoraAudioRawFrameOperationModeWriteOnly = 1,
  /** 2: Read and write mode, in which users read the HDAgoraAudioFrame,
   modify it, and then play it. For example, this mode applies when users
   have their own sound-effect processing module to pre-process the audio
   (such as a voice changer).
   */
  HDAgoraAudioRawFrameOperationModeReadWrite = 2,
};

/** Audio equalization band frequency. */
typedef NS_ENUM(NSInteger, HDAgoraAudioEqualizationBandFrequency) {
  /** 31 Hz. */
  HDAgoraAudioEqualizationBand31 = 0,
  /** 62 Hz. */
  HDAgoraAudioEqualizationBand62 = 1,
  /** 125 Hz. */
  HDAgoraAudioEqualizationBand125 = 2,
  /** 250 Hz. */
  HDAgoraAudioEqualizationBand250 = 3,
  /** 500 Hz */
  HDAgoraAudioEqualizationBand500 = 4,
  /** 1 kHz. */
  HDAgoraAudioEqualizationBand1K = 5,
  /** 2 kHz. */
  HDAgoraAudioEqualizationBand2K = 6,
  /** 4 kHz. */
  HDAgoraAudioEqualizationBand4K = 7,
  /** 8 kHz. */
  HDAgoraAudioEqualizationBand8K = 8,
  /** 16 kHz. */
  HDAgoraAudioEqualizationBand16K = 9,
};

/** Audio reverberation type. */
typedef NS_ENUM(NSInteger, HDAgoraAudioReverbType) {
  /** The level of the dry signal (dB). The value ranges between -20 and 10. */
  HDAgoraAudioReverbDryLevel = 0,
  /** The level of the early reflection signal (wet signal) in dB. The value ranges between -20 and 10. */
  HDAgoraAudioReverbWetLevel = 1,
  /** The room size of the reverberation. A larger room size means a stronger reverberation. The value ranges between 0 and 100. */
  HDAgoraAudioReverbRoomSize = 2,
  /** The length of the initial delay of the wet signal (ms). The value ranges between 0 and 200. */
  HDAgoraAudioReverbWetDelay = 3,
  /** The reverberation strength. The value ranges between 0 and 100. */
  HDAgoraAudioReverbStrength = 4,
};

/** **DEPRECATED** from v3.2.0. The preset audio voice configuration used to change the voice effect. */
typedef NS_ENUM(NSInteger, HDAgoraAudioVoiceChanger) {
  /** Turn off the local voice changer, that is, to use the original voice. */
  HDAgoraAudioVoiceChangerOff __deprecated_enum_msg("HDAgoraAudioVoiceChangerOff is deprecated.") = 0x00000000,
  /** The voice of an old man. */
  HDAgoraAudioVoiceChangerOldMan __deprecated_enum_msg("HDAgoraAudioVoiceChangerOldMan is deprecated.") = 0x00000001,
  /** The voice of a little boy. */
  HDAgoraAudioVoiceChangerBabyBoy __deprecated_enum_msg("HDAgoraAudioVoiceChangerBabyBoy is deprecated.") = 0x00000002,
  /** The voice of a little girl. */
  HDAgoraAudioVoiceChangerBabyGirl __deprecated_enum_msg("HDAgoraAudioVoiceChangerBabyGirl is deprecated.") = 0x00000003,
  /** The voice of Zhu Bajie, a character in Journey to the West who has a voice like that of a growling bear. */
  HDAgoraAudioVoiceChangerZhuBaJie __deprecated_enum_msg("HDAgoraAudioVoiceChangerZhuBaJie is deprecated.") = 0x00000004,
  /** The ethereal voice. */
  HDAgoraAudioVoiceChangerEthereal __deprecated_enum_msg("HDAgoraAudioVoiceChangerEthereal is deprecated.") = 0x00000005,
  /** The voice of Hulk. */
  HDAgoraAudioVoiceChangerHulk __deprecated_enum_msg("HDAgoraAudioVoiceChangerHulk is deprecated.") = 0x00000006,
  /** A more vigorous voice. */
  HDAgoraAudioVoiceBeautyVigorous __deprecated_enum_msg("HDAgoraAudioVoiceBeautyVigorous is deprecated.") = 0x00100001,
  /** A deeper voice. */
  HDAgoraAudioVoiceBeautyDeep __deprecated_enum_msg("HDAgoraAudioVoiceBeautyDeep is deprecated.") = 0x00100002,
  /** A mellower voice. */
  HDAgoraAudioVoiceBeautyMellow __deprecated_enum_msg("HDAgoraAudioVoiceBeautyMellow is deprecated.") = 0x00100003,
  /** Falsetto. */
  HDAgoraAudioVoiceBeautyFalsetto __deprecated_enum_msg("HDAgoraAudioVoiceBeautyFalsetto is deprecated.") = 0x00100004,
  /** A fuller voice. */
  HDAgoraAudioVoiceBeautyFull __deprecated_enum_msg("HDAgoraAudioVoiceBeautyFull is deprecated.") = 0x00100005,
  /** A clearer voice. */
  HDAgoraAudioVoiceBeautyClear __deprecated_enum_msg("HDAgoraAudioVoiceBeautyClear is deprecated.") = 0x00100006,
  /** A more resounding voice. */
  HDAgoraAudioVoiceBeautyResounding __deprecated_enum_msg("HDAgoraAudioVoiceBeautyResounding is deprecated.") = 0x00100007,
  /** A more ringing voice. */
  HDAgoraAudioVoiceBeautyRinging __deprecated_enum_msg("HDAgoraAudioVoiceBeautyRinging is deprecated.") = 0x00100008,
  /** A more spatially resonant voice. */
  HDAgoraAudioVoiceBeautySpacial __deprecated_enum_msg("HDAgoraAudioVoiceBeautySpacial is deprecated.") = 0x00100009,
  /** (For male only) A more magnetic voice. Do not use it when the speaker is a female; otherwise, voice distortion occurs. */
  HDAgoraAudioGeneralBeautyVoiceMaleMagnetic __deprecated_enum_msg("HDAgoraAudioGeneralBeautyVoiceMaleMagnetic is deprecated.") = 0x00200001,
  /** (For female only) A fresher voice. Do not use it when the speaker is a male; otherwise, voice distortion occurs. */
  HDAgoraAudioGeneralBeautyVoiceFemaleFresh __deprecated_enum_msg("HDAgoraAudioGeneralBeautyVoiceFemaleFresh is deprecated.") = 0x00200002,
  /** (For female only) A more vital voice. Do not use it when the speaker is a male; otherwise, voice distortion occurs. */
  HDAgoraAudioGeneralBeautyVoiceFemaleVitality __deprecated_enum_msg("HDAgoraAudioGeneralBeautyVoiceFemaleVitality is deprecated.") = 0x00200003,
};

/** **DEPRECATED** from v3.2.0. The preset local voice reverberation option. */
typedef NS_ENUM(NSInteger, HDAgoraAudioReverbPreset) {
  /** Turn off local voice reverberation, that is, to use the original voice. */
  HDAgoraAudioReverbPresetOff __deprecated_enum_msg("HDAgoraAudioReverbPresetOff is deprecated.") = 0x00000000,
  /** The reverberation style typical of a KTV venue (enhanced).  */
  HDAgoraAudioReverbPresetFxKTV __deprecated_enum_msg("HDAgoraAudioReverbPresetFxKTV is deprecated.") = 0x00100001,
  /** The reverberation style typical of a concert hall (enhanced). */
  HDAgoraAudioReverbPresetFxVocalConcert __deprecated_enum_msg("HDAgoraAudioReverbPresetFxVocalConcert is deprecated.") = 0x00100002,
  /** The reverberation style typical of an uncle's voice. */
  HDAgoraAudioReverbPresetFxUncle __deprecated_enum_msg("HDAgoraAudioReverbPresetFxUncle is deprecated.") = 0x00100003,
  /** The reverberation style typical of a sister's voice. */
  HDAgoraAudioReverbPresetFxSister __deprecated_enum_msg("HDAgoraAudioReverbPresetFxSister is deprecated.") = 0x00100004,
  /** The reverberation style typical of a recording studio (enhanced).  */
  HDAgoraAudioReverbPresetFxStudio __deprecated_enum_msg("HDAgoraAudioReverbPresetFxStudio is deprecated.") = 0x00100005,
  /** The reverberation style typical of popular music (enhanced). */
  HDAgoraAudioReverbPresetFxPopular __deprecated_enum_msg("HDAgoraAudioReverbPresetFxPopular is deprecated.") = 0x00100006,
  /** The reverberation style typical of R&B music (enhanced). */
  HDAgoraAudioReverbPresetFxRNB __deprecated_enum_msg("HDAgoraAudioReverbPresetFxRNB is deprecated.") = 0x00100007,
  /** The reverberation style typical of the vintage phonograph. */
  HDAgoraAudioReverbPresetFxPhonograph __deprecated_enum_msg("HDAgoraAudioReverbPresetFxPhonograph is deprecated.") = 0x00100008,
  /** The reverberation style typical of popular music. */
  HDAgoraAudioReverbPresetPopular __deprecated_enum_msg("HDAgoraAudioReverbPresetPopular is deprecated.") = 0x00000001,
  /** The reverberation style typical of R&B music. */
  HDAgoraAudioReverbPresetRnB __deprecated_enum_msg("HDAgoraAudioReverbPresetRnB is deprecated.") = 0x00000002,
  /** The reverberation style typical of rock music. */
  HDAgoraAudioReverbPresetRock __deprecated_enum_msg("HDAgoraAudioReverbPresetRock is deprecated.") = 0x00000003,
  /** The reverberation style typical of hip-hop music. */
  HDAgoraAudioReverbPresetHipHop __deprecated_enum_msg("HDAgoraAudioReverbPresetHipHop is deprecated.") = 0x00000004,
  /** The reverberation style typical of a concert hall. */
  HDAgoraAudioReverbPresetVocalConcert __deprecated_enum_msg("HDAgoraAudioReverbPresetVocalConcert is deprecated.") = 0x00000005,
  /** The reverberation style typical of a KTV venue. */
  HDAgoraAudioReverbPresetKTV __deprecated_enum_msg("HDAgoraAudioReverbPresetKTV is deprecated.") = 0x00000006,
  /** The reverberation style typical of a recording studio. */
  HDAgoraAudioReverbPresetStudio __deprecated_enum_msg("HDAgoraAudioReverbPresetStudio is deprecated.") = 0x00000007,
  /** The reverberation of the virtual stereo. The virtual stereo is an effect that renders the monophonic audio as the stereo audio, so that all users in the channel can hear the stereo voice effect. To achieve better virtual stereo reverberation, HDAgora recommends setting the `profile` parameter in `setAudioProfile` as `HDAgoraAudioProfileMusicHighQualityStereo(5)`. */
  HDAgoraAudioReverbPresetVirtualStereo __deprecated_enum_msg("HDAgoraAudioReverbPresetVirtualStereo is deprecated.") = 0x00200001,
  /** The reverberation of the Electronic Voice */
  HDAgoraAudioReverbPresetElectronicVoice __deprecated_enum_msg("HDAgoraAudioReverbPresetElectronicVoice is deprecated.") = 0x00300001,
  /** 3D Voice */
  HDAgoraAudioReverbPresetThreeDimVoice __deprecated_enum_msg("HDAgoraAudioReverbPresetThreeDimVoice is deprecated.") = 0x00400001

};

/** The options for SDK preset voice beautifier effects. */
typedef NS_ENUM(NSInteger, HDAgoraVoiceBeautifierPreset) {
  /** Turn off voice beautifier effects and use the original voice. */
  HDAgoraVoiceBeautifierOff = 0x00000000,
  /** A more magnetic voice.<p>**Note**</p><p>HDAgora recommends using this enumerator to process a male-sounding voice; otherwise, you
   may experience vocal distortion.</p>
   */
  HDAgoraChatBeautifierMagnetic = 0x01010100,
  /** A fresher voice.<p>**Note**</p><p>HDAgora recommends using this enumerator to process a female-sounding voice; otherwise, you
   may experience vocal distortion.</p>
   */
  HDAgoraChatBeautifierFresh = 0x01010200,
  /** A more vital voice.<p>**Note**</p><p>HDAgora recommends using this enumerator to process a female-sounding voice; otherwise, you
   may experience vocal distortion.</p>
   */
  HDAgoraChatBeautifierVitality = 0x01010300,
  /** Singing beautifier effect.
   <li>If you call [setVoiceBeautifierPreset(HDAgoraSingingBeautifier)]([HDAgoraRtcEngineKit setVoiceBeautifierPreset:]),
   you can beautify a male-sounding voice and add a reverberation effect that
   sounds like singing in a small room. HDAgora recommends not using
   <tt>setVoiceBeautifierPreset(HDAgoraSingingBeautifier)</tt> to process a
   female-sounding voice; otherwise, you may experience vocal distortion.</li>
   <li>If you call [setVoiceBeautifierParameters(HDAgoraSingingBeautifier, param1, param2)]([HDAgoraRtcEngineKit setVoiceBeautifierParameters:param1:param2:]),
   you can beautify a male- or female-sounding voice and add a reverberation
   effect.</li>

   @since v3.3.0
   */
  HDAgoraSingingBeautifier = 0x01020100,
  /** A more vigorous voice. */
  HDAgoraTimbreTransformationVigorous = 0x01030100,
  /** A deeper voice. */
  HDAgoraTimbreTransformationDeep = 0x01030200,
  /** A mellower voice. */
  HDAgoraTimbreTransformationMellow = 0x01030300,
  /** A falsetto voice. */
  HDAgoraTimbreTransformationFalsetto = 0x01030400,
  /** A fuller voice. */
  HDAgoraTimbreTransformationFull = 0x01030500,
  /** A clearer voice. */
  HDAgoraTimbreTransformationClear = 0x01030600,
  /** A more resounding voice. */
  HDAgoraTimbreTransformationResounding = 0x01030700,
  /** A more ringing voice. */
  HDAgoraTimbreTransformationRinging = 0x01030800
};

/** The options for SDK preset audio effects. */
typedef NS_ENUM(NSInteger, HDAgoraAudioEffectPreset) {
  /** Turn off audio effects and use the original voice. */
  HDAgoraAudioEffectOff = 0x00000000,
  /** An audio effect typical of a KTV venue.
   <p>**Note**</p>
   <p>To achieve better audio effect quality, HDAgora recommends calling [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:])
   and setting the `profile` parameter to `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)`
   before setting this enumerator.</p>
   */
  HDAgoraRoomAcousticsKTV = 0x02010100,
  /** An audio effect typical of a concert hall.
   <p>**Note**</p>
   <p>To achieve better audio effect quality, HDAgora recommends calling [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:])
   and setting the `profile` parameter to `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)`
   before setting this enumerator.</p>
   */
  HDAgoraRoomAcousticsVocalConcert = 0x02010200,
  /** An audio effect typical of a recording studio.
   <p>**Note**</p>
   <p>To achieve better audio effect quality, HDAgora recommends calling [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:])
   and setting the `profile` parameter to `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)`
   before setting this enumerator.</p>
   */
  HDAgoraRoomAcousticsStudio = 0x02010300,
  /** An audio effect typical of a vintage phonograph.
   <p>**Note**</p>
   <p>To achieve better audio effect quality, HDAgora recommends calling [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:])
   and setting the `profile` parameter to `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)`
   before setting this enumerator.</p>
   */
  HDAgoraRoomAcousticsPhonograph = 0x02010400,
  /** A virtual stereo effect that renders monophonic audio as stereo audio.
   <p>**Note**</p>
   <p>Call [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:]) and set the `profile` parameter to
   `HDAgoraAudioProfileMusicStandardStereo(3)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)` before setting this enumerator;
   otherwise, the enumerator setting does not take effect.</p>
   */
  HDAgoraRoomAcousticsVirtualStereo = 0x02010500,
  /** A more spatial audio effect.
   <p>**Note**</p>
   <p>To achieve better audio effect quality, HDAgora recommends calling [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:])
   and setting the `profile` parameter to `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)`
   before setting this enumerator.</p>
   */
  HDAgoraRoomAcousticsSpacial = 0x02010600,
  /** A more ethereal audio effect.
   <p>**Note**</p>
   <p>To achieve better audio effect quality, HDAgora recommends calling [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:])
   and setting the `profile` parameter to `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)`
   before setting this enumerator.</p>
   */
  HDAgoraRoomAcousticsEthereal = 0x02010700,
  /** A 3D voice effect that makes the voice appear to be moving around the user. The default cycle period of the 3D voice effect is
   10 seconds. To change the cycle period, call [setAudioEffectParameters]([HDAgoraRtcEngineKit setAudioEffectParameters:param1:param2:])
   after this method.
   <p>**Note**</p>
   <li>Call [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:]) and set the `profile` parameter to
   `HDAgoraAudioProfileMusicStandardStereo(3)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)` before setting this enumerator;
   otherwise, the enumerator setting does not take effect.</li>
   <li>If the 3D voice effect is enabled, users need to use stereo audio playback devices to hear the anticipated voice effect.</li>
   */
  HDAgoraRoomAcoustics3DVoice = 0x02010800,
  /** The voice of a middle-aged man.
   <p>**Note**</p>
   <li>HDAgora recommends using this enumerator to process a male-sounding voice; otherwise, you may not hear the anticipated voice
   effect.</li>
   <li>To achieve better audio effect quality, HDAgora recommends calling [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:])
   and setting the `profile` parameter to `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)`
   before setting this enumerator.</li>
   */
  HDAgoraVoiceChangerEffectUncle = 0x02020100,
  /** The voice of an old man.
   <p>**Note**</p>
   <li>HDAgora recommends using this enumerator to process a male-sounding voice; otherwise, you may not hear the anticipated voice
   effect.</li>
   <li>To achieve better audio effect quality, HDAgora recommends calling [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:])
   and setting the `profile` parameter to `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)`
   before setting this enumerator.</li>
   */
  HDAgoraVoiceChangerEffectOldMan = 0x02020200,
  /** The voice of a boy.
   <p>**Note**</p>
   <li>HDAgora recommends using this enumerator to process a male-sounding voice; otherwise, you may not hear the anticipated voice
   effect.</li>
   <li>To achieve better audio effect quality, HDAgora recommends calling [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:])
   and setting the `profile` parameter to `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)`
   before setting this enumerator.</li>
   */
  HDAgoraVoiceChangerEffectBoy = 0x02020300,
  /** The voice of a young woman.
   <p>**Note**</p>
   <li>HDAgora recommends using this enumerator to process a female-sounding voice; otherwise, you may not hear the anticipated voice
   effect.</li>
   <li>To achieve better audio effect quality, HDAgora recommends calling [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:])
   and setting the `profile` parameter to `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)`
   before setting this enumerator.</li>
   */
  HDAgoraVoiceChangerEffectSister = 0x02020400,
  /** The voice of a girl.
   <p>**Note**</p>
   <li>HDAgora recommends using this enumerator to process a female-sounding voice; otherwise, you may not hear the anticipated voice
   effect.</li>
   <li>To achieve better audio effect quality, HDAgora recommends calling [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:])
   and setting the `profile` parameter to `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)`
   before setting this enumerator.</li>
   */
  HDAgoraVoiceChangerEffectGirl = 0x02020500,
  /** The voice of Pig King, a character in Journey to the West who has a voice like a growling bear.
   <p>**Note**</p>
   <p>To achieve better audio effect quality, HDAgora recommends calling [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:])
   and setting the `profile` parameter to `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)`
   before setting this enumerator.</p>
   */
  HDAgoraVoiceChangerEffectPigKing = 0x02020600,
  /** The voice of Hulk.
   <p>**Note**</p>
   <p>To achieve better audio effect quality, HDAgora recommends calling [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:])
   and setting the `profile` parameter to `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)`
   before setting this enumerator.</p>
   */
  HDAgoraVoiceChangerEffectHulk = 0x02020700,
  /** An audio effect typical of R&B music.
   <p>**Note**</p>
   <p>Call [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:]) and set the `profile` parameter to
   `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)` before setting this enumerator;
   otherwise, the enumerator setting does not take effect.</p>
   */
  HDAgoraStyleTransformationRnB = 0x02030100,
  /** An audio effect typical of popular music.
   <p>**Note**</p>
   <p>Call [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:]) and set the `profile` parameter to
   `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)` before setting this enumerator;
   otherwise, the enumerator setting does not take effect.</p>
   */
  HDAgoraStyleTransformationPopular = 0x02030200,
  /** A pitch correction effect that corrects the user's pitch based on the pitch of the natural C major scale. To change the basic
   mode and tonic pitch, call [setAudioEffectParameters]([HDAgoraRtcEngineKit setAudioEffectParameters:param1:param2:]) after this method.
   <p>**Note**</p>
   <p>To achieve better audio effect quality, HDAgora recommends calling [setAudioProfile]([HDAgoraRtcEngineKit setAudioProfile:scenario:])
   and setting the `profile` parameter to `HDAgoraAudioProfileMusicHighQuality(4)` or `HDAgoraAudioProfileMusicHighQualityStereo(5)`
   before setting this enumerator.</p>
   */
  HDAgoraPitchCorrection = 0x02040100
};

/** The options for SDK preset voice conversion effects.

 @since v3.3.1
 */
typedef NS_ENUM(NSInteger, HDAgoraVoiceConversionPreset) {
  /** Turn off voice conversion effects and use the original voice. */
  HDAgoraVoiceConversionOff = 0x00000000,
  /** A gender-neutral voice. To avoid audio distortion, ensure that you use this enumerator to process a female-sounding voice. */
  HDAgoraVoiceChangerNeutral = 0x03010100,
  /** A sweet voice. To avoid audio distortion, ensure that you use this enumerator to process a female-sounding voice. */
  HDAgoraVoiceChangerSweet = 0x03010200,
  /** A steady voice. To avoid audio distortion, ensure that you use this enumerator to process a male-sounding voice. */
  HDAgoraVoiceChangerSolid = 0x03010300,
  /** A deep voice. To avoid audio distortion, ensure that you use this enumerator to process a male-sounding voice. */
  HDAgoraVoiceChangerBass = 0x03010400
};

/** The operational permission of the SDK on the audio session. */
typedef NS_OPTIONS(NSUInteger, HDAgoraAudioSessionOperationRestriction) {
  /** No restriction; the SDK can change the audio session. */
  HDAgoraAudioSessionOperationRestrictionNone = 0,
  /** The SDK cannot change the audio session category. */
  HDAgoraAudioSessionOperationRestrictionSetCategory = 1,
  /** The SDK cannot change the audio session category, mode, or categoryOptions. */
  HDAgoraAudioSessionOperationRestrictionConfigureSession = 1 << 1,
  /** The SDK keeps the audio session active when the user leaves the channel, for example, to play an audio file in the background. */
  HDAgoraAudioSessionOperationRestrictionDeactivateSession = 1 << 2,
  /** Completely restricts the operational permission of the SDK on the audio session; the SDK cannot change the audio session. */
  HDAgoraAudioSessionOperationRestrictionAll = 1 << 7
};

/** Audio codec profile. */
typedef NS_ENUM(NSInteger, HDAgoraAudioCodecProfileType) {
  /** 0: (Default) LC-AAC */
  HDAgoraAudioCodecProfileLCAAC = 0,
  /** 1: HE-AAC */
  HDAgoraAudioCodecProfileHEAAC = 1,
  /** 2: HE-AAC v2

   @since v3.6.0
   */
  HDAgoraAudioCodecProfileHEAACv2 = 2
};

/** The state of the remote audio. */
typedef NS_ENUM(NSUInteger, HDAgoraAudioRemoteState) {
  /** 0: The remote audio is in the default state, probably due to `HDAgoraAudioRemoteReasonLocalMuted(3)`, `HDAgoraAudioRemoteReasonRemoteMuted(5)`, or `HDAgoraAudioRemoteReasonRemoteOffline(7)`. */
  HDAgoraAudioRemoteStateStopped = 0,
  /** 1: The first remote audio packet is received. */
  HDAgoraAudioRemoteStateStarting = 1,
  /** 2: The remote audio stream is decoded and plays normally, probably due to `HDAgoraAudioRemoteReasonNetworkRecovery(2)`, `HDAgoraAudioRemoteReasonLocalUnmuted(4)`, or `HDAgoraAudioRemoteReasonRemoteUnmuted(6)`. */
  HDAgoraAudioRemoteStateDecoding = 2,
  /** 3: The remote audio is frozen, probably due to `HDAgoraAudioRemoteReasonNetworkCongestion(1)`. */
  HDAgoraAudioRemoteStateFrozen = 3,
  /** 4: The remote audio fails to start, probably due to `HDAgoraAudioRemoteReasonInternal(0)`. */
  HDAgoraAudioRemoteStateFailed = 4,
};

/** The reason of the remote audio state change. */
typedef NS_ENUM(NSUInteger, HDAgoraAudioRemoteStateReason) {
  /** 0: The SDK reports this reason when the audio state changes. */
  HDAgoraAudioRemoteReasonInternal = 0,
  /** 1: Network congestion. */
  HDAgoraAudioRemoteReasonNetworkCongestion = 1,
  /** 2: Network recovery. */
  HDAgoraAudioRemoteReasonNetworkRecovery = 2,
  /** 3: The local user stops receiving the remote audio stream or disables the audio module. */
  HDAgoraAudioRemoteReasonLocalMuted = 3,
  /** 4: The local user resumes receiving the remote audio stream or enables the audio module. */
  HDAgoraAudioRemoteReasonLocalUnmuted = 4,
  /** 5: The remote user stops sending the audio stream or disables the audio module. */
  HDAgoraAudioRemoteReasonRemoteMuted = 5,
  /** 6: The remote user resumes sending the audio stream or enables the audio module. */
  HDAgoraAudioRemoteReasonRemoteUnmuted = 6,
  /** 7: The remote user leaves the channel. */
  HDAgoraAudioRemoteReasonRemoteOffline = 7,
};

/** The state of the local audio. */
typedef NS_ENUM(NSUInteger, HDAgoraAudioLocalState) {
  /** 0: The local audio is in the initial state. */
  HDAgoraAudioLocalStateStopped = 0,
  /** 1: The audio sampling device starts successfully.  */
  HDAgoraAudioLocalStateRecording = 1,
  /** 2: The first audio frame encodes successfully. */
  HDAgoraAudioLocalStateEncoding = 2,
  /** 3: The local audio fails to start. */
  HDAgoraAudioLocalStateFailed = 3,
};

/** The error information of the local audio. */
typedef NS_ENUM(NSUInteger, HDAgoraAudioLocalError) {
  /** 0: The local audio is normal. */
  HDAgoraAudioLocalErrorOk = 0,
  /** 1: No specified reason for the local audio failure. */
  HDAgoraAudioLocalErrorFailure = 1,
  /** 2: No permission to use the local audio sampling device. */
  HDAgoraAudioLocalErrorDeviceNoPermission = 2,
  /** 3: The audio sampling device is in use. */
  HDAgoraAudioLocalErrorDeviceBusy = 3,
  /** 4: The local audio sampling fails. Check whether the sampling device is working properly. */
  HDAgoraAudioLocalErrorRecordFailure = 4,
  /** 5: The local audio encoding fails. */
  HDAgoraAudioLocalErrorEncodeFailure = 5,
};

/** The information acquisition state. This enum is reported in
 [didRequestAudioFileInfo]([HDAgoraRtcEngineDelegate rtcEngine:didRequestAudioFileInfo:error:]).

 @since v3.5.1
 */
typedef NS_ENUM(NSUInteger, HDAgoraAudioFileInfoError) {
  /** 0: Successfully get the information of an audio file. */
  HDAgoraAudioFileInfoErrorOk = 0,
  /** 1: Fail to get the information of an audio file. */
  HDAgoraAudioFileInfoErrorFailure = 1
};

/** Media device type. */
typedef NS_ENUM(NSInteger, HDAgoraMediaDeviceType) {
  /** Unknown device. */
  HDAgoraMediaDeviceTypeAudioUnknown = -1,
  /** Audio playback device. */
  HDAgoraMediaDeviceTypeAudioPlayout = 0,
  /** Audio sampling device. */
  HDAgoraMediaDeviceTypeAudioRecording = 1,
  /** Video render device. */
  HDAgoraMediaDeviceTypeVideoRender = 2,
  /** Video capture device. */
  HDAgoraMediaDeviceTypeVideoCapture = 3,
};

/** Connection states. */
typedef NS_ENUM(NSInteger, HDAgoraConnectionStateType) {
  /** <p>1: The SDK is disconnected from HDAgora's edge server.</p>
<li>This is the initial state before [joinChannelByToken]([HDAgoraRtcEngineKit joinChannelByToken:channelId:info:uid:joinSuccess:]).
<li>The SDK also enters this state when the app calls [leaveChannel]([HDAgoraRtcEngineKit leaveChannel:]).
  */
  HDAgoraConnectionStateDisconnected = 1,
  /** <p>2: The SDK is connecting to HDAgora's edge server.
<p>When the app calls [joinChannelByToken]([HDAgoraRtcEngineKit joinChannelByToken:channelId:info:uid:joinSuccess:]), the SDK starts to establish a connection to the specified channel, triggers the [connectionChangedToState]([HDAgoraRtcEngineDelegate rtcEngine:connectionChangedToState:reason:]) callback, and switches to the `HDAgoraConnectionStateConnecting` state.
<p>When the SDK successfully joins the channel, the SDK triggers the [connectionChangedToState]([HDAgoraRtcEngineDelegate rtcEngine:connectionChangedToState:reason:]) callback and switches to the `HDAgoraConnectionStateConnected` state.
<p>After the SDK joins the channel and when it finishes initializing the media engine, the SDK triggers the [didJoinChannel]([HDAgoraRtcEngineDelegate rtcEngine:didJoinChannel:withUid:elapsed:]) callback.
*/
  HDAgoraConnectionStateConnecting = 2,
  /** <p>3: The SDK is connected to HDAgora's edge server and joins a channel. You can now publish or subscribe to a media stream in the channel.</p>
If the connection to the channel is lost because, for example, the network is down or switched, the SDK automatically tries to reconnect and triggers:
<li> The [rtcEngineConnectionDidInterrupted]([HDAgoraRtcEngineDelegate rtcEngineConnectionDidInterrupted:])(deprecated) callback
<li> The [connectionChangedToState]([HDAgoraRtcEngineDelegate rtcEngine:connectionChangedToState:reason:]) callback, and switches to the `HDAgoraConnectionStateReconnecting` state.
  */
  HDAgoraConnectionStateConnected = 3,
  /** <p>4: The SDK keeps rejoining the channel after being disconnected from a joined channel because of network issues.</p>
<li>If the SDK cannot rejoin the channel within 10 seconds after being disconnected from HDAgora's edge server, the SDK triggers the [rtcEngineConnectionDidLost]([HDAgoraRtcEngineDelegate rtcEngineConnectionDidLost:]) callback, stays in the `HDAgoraConnectionStateReconnecting` state, and keeps rejoining the channel.
<li>If the SDK fails to rejoin the channel 20 minutes after being disconnected from HDAgora's edge server, the SDK triggers the [connectionChangedToState]([HDAgoraRtcEngineDelegate rtcEngine:connectionChangedToState:reason:]) callback, switches to the `HDAgoraConnectionStateFailed` state, and stops rejoining the channel.
  */
  HDAgoraConnectionStateReconnecting = 4,
  /** <p>5: The SDK fails to connect to HDAgora's edge server or join the channel.</p>
<li>You must call [leaveChannel]([HDAgoraRtcEngineKit leaveChannel:]) to leave this state, and call [joinChannelByToken]([HDAgoraRtcEngineKit joinChannelByToken:channelId:info:uid:joinSuccess:]) again to rejoin the channel.
<li>If the SDK is banned from joining the channel by HDAgora's edge server (through the RESTful API), the SDK triggers the [rtcEngineConnectionDidBanned]([HDAgoraRtcEngineDelegate rtcEngineConnectionDidBanned:])(deprecated) and [connectionChangedToState]([HDAgoraRtcEngineDelegate rtcEngine:connectionChangedToState:reason:]) callbacks.
  */
  HDAgoraConnectionStateFailed = 5,
};

/** Reasons for the connection state change. */
typedef NS_ENUM(NSUInteger, HDAgoraConnectionChangedReason) {
  /** 0: The SDK is connecting to HDAgora's edge server. */
  HDAgoraConnectionChangedConnecting = 0,
  /** 1: The SDK has joined the channel successfully. */
  HDAgoraConnectionChangedJoinSuccess = 1,
  /** 2: The connection between the SDK and HDAgora's edge server is interrupted.  */
  HDAgoraConnectionChangedInterrupted = 2,
  /** 3: The user is banned by the server. This error occurs when the user is kicked out the channel from the server. */
  HDAgoraConnectionChangedBannedByServer = 3,
  /** 4: The SDK fails to join the channel for more than 20 minutes and stops reconnecting to the channel. */
  HDAgoraConnectionChangedJoinFailed = 4,
  /** 5: The SDK has left the channel. */
  HDAgoraConnectionChangedLeaveChannel = 5,
  /** 6: The specified App ID is invalid. Try to rejoin the channel with a valid App ID. */
  HDAgoraConnectionChangedInvalidAppId = 6,
  /** 7: The specified channel name is invalid. Try to rejoin the channel with a valid channel name. */
  HDAgoraConnectionChangedInvalidChannelName = 7,
  /** 8: The generated token is invalid probably due to the following reasons:
<li>The App Certificate for the project is enabled in Console, but you do not use Token when joining the channel. If you enable the App Certificate, you must use a token to join the channel.
<li>The uid that you specify in the [joinChannelByToken]([HDAgoraRtcEngineKit joinChannelByToken:channelId:info:uid:joinSuccess:]) method is different from the uid that you pass for generating the token.
   */
  HDAgoraConnectionChangedInvalidToken = 8,
  /** 9: The token has expired. Generate a new token from your server. */
  HDAgoraConnectionChangedTokenExpired = 9,
  /** 10: The user is banned by the server. This error usually occurs in the following situations:
<li>When the user is already in the channel, and still calls the method to join the channel, for example, [joinChannelByToken]([HDAgoraRtcEngineKit joinChannelByToken:channelId:info:uid:joinSuccess:]).</li>
<li>When the user tries to join a channel during a call test ([startEchoTestWithInterval]([HDAgoraRtcEngineKit startEchoTestWithInterval:successBlock:])). Once you call `startEchoTest`, you need to call [stopEchoTest]([HDAgoraRtcEngineKit stopEchoTest]) before joining a channel.</li>
   */
  HDAgoraConnectionChangedRejectedByServer = 10,
  /** 11: The SDK tries to reconnect after setting a proxy server. */
  HDAgoraConnectionChangedSettingProxyServer = 11,
  /** 12: The token renews. */
  HDAgoraConnectionChangedRenewToken = 12,
  /** 13: The client IP address has changed, probably due to a change of the network type, IP address, or network port. */
  HDAgoraConnectionChangedClientIpAddressChanged = 13,
  /** 14: Timeout for the keep-alive of the connection between the SDK and HDAgora's edge server. The connection state changes to `HDAgoraConnectionStateReconnecting(4)`. */
  HDAgoraConnectionChangedKeepAliveTimeout = 14,
};

/** The state code in HDAgoraChannelMediaRelayState.
 */
typedef NS_ENUM(NSInteger, HDAgoraChannelMediaRelayState) {
  /** 0: The initial state. After you successfully stop the channel media relay by calling
   [stopChannelMediaRelay]([HDAgoraRtcEngineKit stopChannelMediaRelay]), the
   [channelMediaRelayStateDidChange]([HDAgoraRtcEngineDelegate rtcEngine:channelMediaRelayStateDidChange:error:]) callback
   returns this state.
   */
  HDAgoraChannelMediaRelayStateIdle = 0,
  /** 1: The SDK tries to relay the media stream to the destination channel.
   */
  HDAgoraChannelMediaRelayStateConnecting = 1,
  /** 2: The SDK successfully relays the media stream to the destination channel.
   */
  HDAgoraChannelMediaRelayStateRunning = 2,
  /** 3: A failure occurs. See the details in `error`.
   */
  HDAgoraChannelMediaRelayStateFailure = 3,
};

/** The event code in HDAgoraChannelMediaRelayEvent.
 */
typedef NS_ENUM(NSInteger, HDAgoraChannelMediaRelayEvent) {
  /** 0: The user disconnects from the server due to poor network connections.
   */
  HDAgoraChannelMediaRelayEventDisconnect = 0,
  /** 1: The network reconnects.
   */
  HDAgoraChannelMediaRelayEventConnected = 1,
  /** 2: The user joins the source channel.
   */
  HDAgoraChannelMediaRelayEventJoinedSourceChannel = 2,
  /** 3: The user joins the destination channel.
   */
  HDAgoraChannelMediaRelayEventJoinedDestinationChannel = 3,
  /** 4: The SDK starts relaying the media stream to the destination channel.
   */
  HDAgoraChannelMediaRelayEventSentToDestinationChannel = 4,
  /** 5: The server receives the video stream from the source channel.
   */
  HDAgoraChannelMediaRelayEventReceivedVideoPacketFromSource = 5,
  /** 6: The server receives the audio stream from the source channel.
   */
  HDAgoraChannelMediaRelayEventReceivedAudioPacketFromSource = 6,
  /** 7: The destination channel is updated.
   */
  HDAgoraChannelMediaRelayEventUpdateDestinationChannel = 7,
  /** 8: The destination channel update fails due to internal reasons.
   */
  HDAgoraChannelMediaRelayEventUpdateDestinationChannelRefused = 8,
  /** 9: The destination channel does not change, which means that the destination channel fails to be updated.
   */
  HDAgoraChannelMediaRelayEventUpdateDestinationChannelNotChange = 9,
  /** 10: The destination channel name is `nil`.
   */
  HDAgoraChannelMediaRelayEventUpdateDestinationChannelIsNil = 10,
  /** 11: The video profile is sent to the server.
   */
  HDAgoraChannelMediaRelayEventVideoProfileUpdate = 11,
  /** 12: The SDK successfully pauses relaying the media stream to destination channels.

   @since v3.5.1
   */
  HDAgoraChannelMediaRelayEventPauseSendPacketToDestChannelSuccess = 12,
  /** 13: The SDK fails to pause relaying the media stream to destination channels.

   @since v3.5.1
   */
  HDAgoraChannelMediaRelayEventPauseSendPacketToDestChannelFailed = 13,
  /** 14: The SDK successfully resumes relaying the media stream to destination channels.

   @since v3.5.1
   */
  HDAgoraChannelMediaRelayEventResumeSendPacketToDestChannelSuccess = 14,
  /** 15: The SDK fails to resume relaying the media stream to destination channels.

   @since v3.5.1
   */
  HDAgoraChannelMediaRelayEventResumeSendPacketToDestChannelFailed = 15,

};

/** The error code in HDAgoraChannelMediaRelayError.
 */
typedef NS_ENUM(NSInteger, HDAgoraChannelMediaRelayError) {
  /** 0: The state is normal.
   */
  HDAgoraChannelMediaRelayErrorNone = 0,
  /** 1: An error occurs in the server response.
   */
  HDAgoraChannelMediaRelayErrorServerErrorResponse = 1,
  /** 2: No server response. This error can also occur if your project has not enabled co-host token authentication. Contact support@HDAgora.io to enable the co-host token authentication service before starting a channel media relay.
   */
  HDAgoraChannelMediaRelayErrorServerNoResponse = 2,
  /** 3: The SDK fails to access the service, probably due to limited resources of the server.
   */
  HDAgoraChannelMediaRelayErrorNoResourceAvailable = 3,
  /** 4: Fails to send the relay request.
   */
  HDAgoraChannelMediaRelayErrorFailedJoinSourceChannel = 4,
  /** 5: Fails to accept the relay request.
   */
  HDAgoraChannelMediaRelayErrorFailedJoinDestinationChannel = 5,
  /** 6: The server fails to receive the media stream.
   */
  HDAgoraChannelMediaRelayErrorFailedPacketReceivedFromSource = 6,
  /** 7: The server fails to send the media stream.
   */
  HDAgoraChannelMediaRelayErrorFailedPacketSentToDestination = 7,
  /** 8: The SDK disconnects from the server due to poor network connections. You can call the [leaveChannel]([HDAgoraRtcEngineKit leaveChannel:]) method to leave the channel.
   */
  HDAgoraChannelMediaRelayErrorServerConnectionLost = 8,
  /** 9: An internal error occurs in the server.
   */
  HDAgoraChannelMediaRelayErrorInternalError = 9,
  /** 10: The token of the source channel has expired.
   */
  HDAgoraChannelMediaRelayErrorSourceTokenExpired = 10,
  /** 11: The token of the destination channel has expired.
   */
  HDAgoraChannelMediaRelayErrorDestinationTokenExpired = 11,
};

/** Network type. */
typedef NS_ENUM(NSInteger, HDAgoraNetworkType) {
  /** -1: The network type is unknown. */
  HDAgoraNetworkTypeUnknown = -1,
  /** 0: The SDK disconnects from the network. */
  HDAgoraNetworkTypeDisconnected = 0,
  /** 1: The network type is LAN. */
  HDAgoraNetworkTypeLAN = 1,
  /** 2: The network type is Wi-Fi (including hotspots). */
  HDAgoraNetworkTypeWIFI = 2,
  /** 3: The network type is mobile 2G. */
  HDAgoraNetworkTypeMobile2G = 3,
  /** 4: The network type is mobile 3G. */
  HDAgoraNetworkTypeMobile3G = 4,
  /** 5: The network type is mobile 4G. */
  HDAgoraNetworkTypeMobile4G = 5,
  /** 6: The network type is mobile 5G.

   @since v3.5.1
   */
  HDAgoraNetworkTypeMobile5G = 6,
};

/** The video encoding degradation preference under limited bandwidth. */
typedef NS_ENUM(NSInteger, HDAgoraDegradationPreference) {
  /** (Default) Prefers to reduce the video frame rate while maintaining video quality during video encoding under
   limited bandwidth. This degradation preference is suitable for scenarios where video quality is prioritized.

   @note In the `Communication` channel profile, the resolution of the video sent may change, so remote users need to
   handle this issue. See [videoSizeChangedOfUid]([HDAgoraRtcEngineDelegate rtcEngine:videoSizeChangedOfUid:size:rotation:]).
   */
  HDAgoraDegradationMaintainQuality = 0,
  /** Prefers to reduce the video quality while maintaining the video frame rate during video encoding under limited
   bandwidth. This degradation preference is suitable for scenarios where smoothness is prioritized and video quality
   is allowed to be reduced.
   */
  HDAgoraDegradationMaintainFramerate = 1,
  /** Reduces the video frame rate and video quality simultaneously during video encoding under limited bandwidth.
   `HDAgoraDegradationBalanced` has a lower reduction than `HDAgoraDegradationMaintainQuality` and `HDAgoraDegradationMaintainFramerate`,
   and this preference is suitable for scenarios where both smoothness and video quality are a priority.

   @note The resolution of the video sent may change, so remote users need to handle this issue. See [videoSizeChangedOfUid]([HDAgoraRtcEngineDelegate rtcEngine:videoSizeChangedOfUid:size:rotation:]).
   */
  HDAgoraDegradationBalanced = 2,
};

/** The lightening contrast level. */
typedef NS_ENUM(NSUInteger, HDAgoraLighteningContrastLevel) {
  /** 0: Low contrast level. */
  HDAgoraLighteningContrastLow = 0,
  /** 1: (Default) Normal contrast level. */
  HDAgoraLighteningContrastNormal = 1,
  /** 2: High contrast level. */
  HDAgoraLighteningContrastHigh = 2,
};

/** The type of the custom background image.
 @since v3.4.5
 */
typedef NS_ENUM(NSUInteger, HDAgoraVirtualBackgroundSourceType) {
  /** 1: (Default) The background image is a solid color.*/
  HDAgoraVirtualBackgroundColor = 1,
  /** 2: The background image is a file in PNG or JPG format.*/
  HDAgoraVirtualBackgroundImg = 2,
  /** 3: The background image is blurred.

   @since v3.5.1
   */
  HDAgoraVirtualBackgroundBlur = 3,
};

/** The degree of blurring applied to the custom background image.
 @since v3.5.1
 */
typedef NS_ENUM(NSUInteger, HDAgoraBlurDegree) {
  /** 1: The degree of blurring applied to the custom background image is low.
   The user can almost see the background clearly.
   */
  HDAgoraBlurLow = 1,
  /** 2: The degree of blurring applied to the custom background image is
   medium. It is difficult for the user to recognize details in the background.
   */
  HDAgoraBlurMedium = 2,
  /** 3: (Default) The degree of blurring applied to the custom background
   image is high. The user can barely see any distinguishing features in the
   background.
   */
  HDAgoraBlurHigh = 3,
};

/** The state of the probe test result. */
typedef NS_ENUM(NSUInteger, HDAgoraLastmileProbeResultState) {
  /** 1: The last-mile network probe test is complete. */
  HDAgoraLastmileProbeResultComplete = 1,
  /** 2: The last-mile network probe test is incomplete and the bandwidth estimation is not available, probably due to limited test resources. */
  HDAgoraLastmileProbeResultIncompleteNoBwe = 2,
  /** 3: The last-mile network probe test is not carried out, probably due to poor network conditions. */
  HDAgoraLastmileProbeResultUnavailable = 3,
};

/** The state of the local video stream. */
typedef NS_ENUM(NSInteger, HDAgoraLocalVideoStreamState) {
  /** 0: The local video is in the initial state. */
  HDAgoraLocalVideoStreamStateStopped = 0,
  /** 1: The local video capturing device starts successfully. The SDK also reports this state when you share a maximized window by calling [startScreenCaptureByWindowId]([HDAgoraRtcEngineKit startScreenCaptureByWindowId:rectangle:parameters:]).

   @since v3.1.0
   */
  HDAgoraLocalVideoStreamStateCapturing = 1,
  /** 2: The first local video frame encodes successfully. */
  HDAgoraLocalVideoStreamStateEncoding = 2,
  /** 3: The local video fails to start. */
  HDAgoraLocalVideoStreamStateFailed = 3,
};

/** The detailed error information of the local video. */
typedef NS_ENUM(NSInteger, HDAgoraLocalVideoStreamError) {
  /** 0: The local video is normal. */
  HDAgoraLocalVideoStreamErrorOK = 0,
  /** 1: No specified reason for the local video failure. */
  HDAgoraLocalVideoStreamErrorFailure = 1,
  /** 2: No permission to use the local video device. */
  HDAgoraLocalVideoStreamErrorDeviceNoPermission = 2,
  /** 3: The local video capturer is in use. */
  HDAgoraLocalVideoStreamErrorDeviceBusy = 3,
  /** 4: The local video capture fails. Check whether the capturer is working properly. */
  HDAgoraLocalVideoStreamErrorCaptureFailure = 4,
  /** 5: The local video encoding fails. */
  HDAgoraLocalVideoStreamErrorEncodeFailure = 5,
  /** 6: (iOS only) The application is in the background.

   @since v3.3.0
   */
  HDAgoraLocalVideoStreamErrorCaptureInBackGround = 6,
  /** 7: (iOS only) The application is running in Slide Over, Split View, or Picture in Picture mode.

   @since v3.3.0
   */
  HDAgoraLocalVideoStreamErrorCaptureMultipleForegroundApps = 7,
  /** 8: The SDK cannot find the local video capture device.

   @since v3.4.0
   */
  HDAgoraLocalVideoStreamErrorCaptureNoDeviceFound = 8,
  /** 9: (macOS only) The external camera currently in use is disconnected
   (such as being unplugged).

   @since v3.5.0
   */
  HDAgoraLocalVideoStreamErrorCaptureDeviceDisconnected = 9,
  /** 10: (macOS only) The SDK cannot find the video device in the video device list. Check whether the ID of the video device is valid.

   @since v3.5.0
   */
  HDAgoraLocalVideoStreamErrorCaptureDeviceInvalidId = 10,
  /** 11: (macOS only) The shared window is minimized when you call
   [startScreenCaptureByWindowId]([HDAgoraRtcEngineKit startScreenCaptureByWindowId:rectangle:parameters:]) to share a window.

   @since v3.1.0
   */
  HDAgoraLocalVideoStreamErrorScreenCaptureWindowMinimized = 11,
  /** 12: (macOS only) The error code indicates that a window shared by the window ID has been closed, or a full-screen
   window shared by the window ID has exited full-screen mode. After exiting
   full-screen mode, remote users cannot see the shared window. To prevent remote users from seeing a black screen, HDAgora recommends
   that you immediately stop screen sharing.
   <p>Common scenarios for reporting this error code:</p>
   <li>When the local user closes the shared window, the SDK reports this error code.</li>t
   <li>The local user shows some slides in full-screen mode first, and then shares the windows of the slides. After the user exits full-screen
   mode, the SDK reports this error code.</li>
   <li>The local user watches web video or reads web document in full-screen mode first, and then shares the window of the web video or
   document. After the user exits full-screen mode, the SDK reports this error code.</li>

   @since v3.2.0
   */
  HDAgoraLocalVideoStreamErrorScreenCaptureWindowClosed = 12,
};
/** Regions for connection
 */
typedef NS_ENUM(NSUInteger, HDAgoraAreaCode) {
  /** Mainland China
   */
  HDAgoraAreaCodeCN = 0x00000001,
  /** North America
   */
  HDAgoraAreaCodeNA = 0x00000002,
  /** Europe
   */
  HDAgoraAreaCodeEU = 0x00000004,
  /** Asia, excluding Mainland China
   */
  HDAgoraAreaCodeAS = 0x00000008,
  /** Japan
   */
  HDAgoraAreaCodeJP = 0x00000010,
  /** India
   */
  HDAgoraAreaCodeIN = 0x00000020,
  /** (Default) Global
   */
  HDAgoraAreaCodeGLOB = 0xFFFFFFFF
};

/** The output log level of the SDK
 */
typedef NS_ENUM(NSInteger, HDAgoraLogLevel) {
  /** Do not output any log.
   */
  HDAgoraLogLevelNone = 0x0000,
  /** (Default) Output logs of the `HDAgoraLogLevelFatal`, `HDAgoraLogLevelError`,
   `HDAgoraLogLevelWarn` and `HDAgoraLogLevelInfo` level. We recommend setting
   your log filter as this level.
   */
  HDAgoraLogLevelInfo = 0x0001,
  /** Output logs of the `HDAgoraLogLevelFatal`, `HDAgoraLogLevelError` and
   `HDAgoraLogLevelWarn` level.
   */
  HDAgoraLogLevelWarn = 0x0002,
  /** Output logs of the `HDAgoraLogLevelFatal` and `HDAgoraLogLevelError` level.
   */
  HDAgoraLogLevelError = 0x0004,
  /** Output logs of the `HDAgoraLogLevelFatal` level.
   */
  HDAgoraLogLevelFatal = 0x0008
};

/** The cloud proxy type.
 */
typedef NS_ENUM(NSUInteger, HDAgoraCloudProxyType) {
  /** 0: Do not use the cloud proxy.
   */
  HDAgoraNoneProxy = 0,
  /** 1: The cloud proxy for the UDP protocol.
   */
  HDAgoraUdpProxy = 1,
  /** 2: Reserved parameter.
   */
  HDAgoraTcpProxy = 2,
};

/** Reserved.
 */
typedef NS_ENUM(NSUInteger, HDAgoraLocalProxyMode) {

  HDAgoraConnectivityFirst = 0,

  HDAgoraLocalOnly = 1,
};

/** The channel mode. Set in
 [setAudioMixingDualMonoMode]([HDAgoraRtcEngineKit setAudioMixingDualMonoMode:]).

 @since v3.5.1
 */
typedef NS_ENUM(NSUInteger, HDAgoraAudioMixingDualMonoMode) {
  /** 0: Original mode.
   */
  HDAgoraAudioMixingDualMonoAuto,
  /** 1: Left channel mode. This mode replaces the audio of the right channel
   with the audio of the left channel, which means the user can only hear
   the audio of the left channel.
   */
  HDAgoraAudioMixingDualMonoL,
  /** 2: Right channel mode. This mode replaces the audio of the left channel
   with the audio of the right channel, which means the user can only hear the
   audio of the right channel.
   */
  HDAgoraAudioMixingDualMonoR,
  /** 3: Mixed channel mode. This mode mixes the audio of the left channel and
   the right channel, which means the user can hear the audio of the left
   channel and the right channel at the same time.
   */
  HDAgoraAudioMixingDualMonoMix
};

/**
 The type of the shared target.

 @since v3.5.2
 */
typedef NS_ENUM(NSInteger, HDAgoraScreenCaptureSourceType) {
  /** -1: Unknown type. */
  HDAgoraScreenCaptureSourceTypeUnknown = -1,
  /** 0: The shared target is a window. */
  HDAgoraScreenCaptureSourceTypeWindow = 0,
  /** 1: The shared target is a screen of a particular monitor. */
  HDAgoraScreenCaptureSourceTypeScreen = 1,
  /** 2: Reserved parameter. */
  HDAgoraScreenCaptureSourceTypeCustom = 2,
};

/** The clockwise rotation angle of the video frame. (iOS only)

 @since v3.4.5
 */
typedef NS_ENUM(NSInteger, HDAgoraVideoRotation) {
  /** 0: No rotation */
  HDAgoraVideoRotationNone = 0,
  /** 1: 90 degrees */
  HDAgoraVideoRotation90 = 1,
  /** 2: 180 degrees */
  HDAgoraVideoRotation180 = 2,
  /** 3: 270 degrees */
  HDAgoraVideoRotation270 = 3,
};

/** The color video format. (iOS only)

 @since v3.4.5
 */
typedef NS_ENUM(NSUInteger, HDAgoraVideoFrameType) {
  /** 0: (Default) YUV 420
   */
  HDAgoraVideoFrameTypeYUV420 = 0,  // YUV 420 format
  /** 1: YUV422
   */
  HDAgoraVideoFrameTypeYUV422 = 1,  // YUV 422 format
  /** 2: RGBA
   */
  HDAgoraVideoFrameTypeRGBA = 2,  // RGBA format
};

/** The video frame type. (iOS only)

 @since v3.4.5
 */
typedef NS_ENUM(NSUInteger, HDAgoraVideoEncodeType) {
  /** 0: (Default) A black frame
   */
  HDAgoraVideoEncodeTypeBlankFrame = 0,
  /** 3: The keyframe
   */
  HDAgoraVideoEncodeTypeKeyFrame = 3,
  /** 4: The delta frame
   */
  HDAgoraVideoEncodeTypeDetaFrame = 4,
  /** 5: The B-frame
   */
  HDAgoraVideoEncodeTypeBFrame = 5,

};

/** The bit mask of the observation positions. (iOS only)

 @since v3.4.5
 */
typedef NS_ENUM(NSUInteger, HDAgoraVideoFramePosition) {
  /** (Default) The position to observe the video data captured by the local
   camera, which corresponds to the
   [onCaptureVideoFrame]([HDAgoraVideoDataFrameProtocol onCaptureVideoFrame:])
   callback.
   */
  HDAgoraVideoFramePositionPostCapture = 1 << 0,
  /** (Default) The position to observe the incoming remote video data,
   which corresponds to the
   [onRenderVideoFrame]([HDAgoraVideoDataFrameProtocol onRenderVideoFrame:forUid:]) or
   [onRenderVideoFrameEx]([HDAgoraVideoDataFrameProtocol onRenderVideoFrameEx:forUid:inChannel:])
   callback.
   */
  HDAgoraVideoFramePositionPreRenderer = 1 << 1,
  /** The position to observe the local pre-encoded video data, which
   corresponds to the
   [onPreEncodeVideoFrame]([HDAgoraVideoDataFrameProtocol onPreEncodeVideoFrame:])
   callback.
   */
  HDAgoraVideoFramePositionPreEncoder = 1 << 2,
};

/** The bit mask that controls the audio observation positions. (iOS only)

 @since v3.4.5
 */
typedef NS_ENUM(NSUInteger, HDAgoraAudioFramePosition) {
  /** The position for observing the playback audio of all remote users after
   mixing, which enables the SDK to trigger the
   [onPlaybackAudioFrame]([HDAgoraAudioDataFrameProtocol onPlaybackAudioFrame:])
   callback.
   */
  HDAgoraAudioFramePositionPlayback = 1 << 0,
  /** The position for observing the recorded audio of the local user, which
   enables the SDK to trigger the
   [onRecordAudioFrame]([HDAgoraAudioDataFrameProtocol onRecordAudioFrame:])
   callback.
   */
  HDAgoraAudioFramePositionRecord = 1 << 1,
  /** The position for observing the mixed audio of the local user and all
   remote users, which enables the SDK to trigger the
   [onMixedAudioFrame]([HDAgoraAudioDataFrameProtocol onMixedAudioFrame:])
   callback.
   */
  HDAgoraAudioFramePositionMixed = 1 << 2,
  /** The position for observing the audio of a single remote user before
   mixing, which enables the SDK to trigger the
   [onPlaybackAudioFrameBeforeMixing]([HDAgoraAudioDataFrameProtocol onPlaybackAudioFrameBeforeMixing:uid:])
   callback.
   */
  HDAgoraAudioFramePositionBeforeMixing = 1 << 3,

};

/** The push position of the external audio frame. Set in
 [pushExternalAudioFrameRawData]([HDAgoraRtcEngineKit pushExternalAudioFrameRawData:frame:]),
 [pushExternalAudioFrameSampleBuffer]([HDAgoraRtcEngineKit pushExternalAudioFrameSampleBuffer:sampleBuffer:]),
 or [setExternalAudioSourceVolume]([HDAgoraRtcEngineKit setExternalAudioSourceVolume:volume:]).

 @since v3.5.1
 */
typedef NS_ENUM(NSUInteger, HDAgoraAudioExternalSourcePos) {
  /** 0: The position before local playback. If you need to play the external
   audio frame on the local client, set this position.
   */
  HDAgoraAudioExternalPlayoutSource = 0,
  /** 1: The position after audio capture and before audio pre-processing.
   If you need the audio module of the SDK to process the external audio frame,
   set this position.
   */
  HDAgoraAudioExternalRecordSourcePreProcess = 1,
  /** 2: The position after audio pre-processing and before audio encoding.
   If you do not need the audio module of the SDK to process the external audio
   frame, set this position.
   */
  HDAgoraAudioExternalRecordSourcePostProcess = 2,
};

/** API for future use. */
typedef NS_ENUM(NSInteger, HDAgoraContentInspectType) {
  HDAgoraContentInspectTypeInvalid = 0,
  HDAgoraContentInspectTypeModeration = 1,
  HDAgoraContentInspectTypeSupervise = 2,
};

/** API for future use. */
typedef NS_ENUM(NSUInteger, HDAgoraContentInspectResult) {
  HDAgoraContentInspectNeutral = 1,
  HDAgoraContentInspectSexy = 2,
  HDAgoraContentInspectPorn = 3,
};

/**
 The current recording state.

 @since v3.5.2
 */
typedef NS_ENUM(NSInteger, HDAgoraMediaRecorderState) {
  /** -1: An error occurs during the recording. See `error` for the reason. */
  HDAgoraMediaRecorderStateError = -1,
  /** 2: The audio and video recording is started. */
  HDAgoraMediaRecorderStateStarted = 2,
  /** 3: The audio and video recording is stopped. */
  HDAgoraMediaRecorderStateStopped = 3,
};

/**
 The reason for the state change.

 @since v3.5.2
 */
typedef NS_ENUM(NSInteger, HDAgoraMediaRecorderErrorCode) {
  /** 0: No error occurs. */
  HDAgoraMediaRecorderErrorCodeNoError = 0,
  /** 1: The SDK fails to write the recorded data to a file. */
  HDAgoraMediaRecorderErrorCodeWriteFailed = 1,
  /** 2: The SDK does not detect audio and video streams to be recorded, or audio and video streams are interrupted for more than five seconds during recording. */
  HDAgoraMediaRecorderErrorCodeNoStream = 2,
  /** 3: The recording duration exceeds the upper limit. */
  HDAgoraMediaRecorderErrorCodeOverMaxDuration = 3,
  /** 4: The recording configuration changes. */
  HDAgoraMediaRecorderErrorCodeConfigChange = 4,
  /** 5: The SDK detects audio and video streams from users using versions of the SDK earlier than v3.0.0 in the `Communication` channel profile. */
  HDAgoraMediaRecorderErrorCustomStreamDetected = 5,
};

/**
 The recording content.

 @since v3.5.2
 */
typedef NS_ENUM(NSInteger, HDAgoraMediaRecorderStreamType) {
  /** 1: Only audio. */
  HDAgoraMediaRecorderStreamTypeAudio = 1,
  /** 2: Only video. */
  HDAgoraMediaRecorderStreamTypeVideo = 2,
  /** 3: (Default) Audio and video. */
  HDAgoraMediaRecorderStreamTypeBoth = 3,
};

/**
 The format of the recording file.

 @since v3.5.2
 */
typedef NS_ENUM(NSInteger, HDAgoraMediaRecorderContainerFormat) {
  /** 1: MP4 */
  HDAgoraMediaRecorderContainerFormatMP4 = 1,
};
