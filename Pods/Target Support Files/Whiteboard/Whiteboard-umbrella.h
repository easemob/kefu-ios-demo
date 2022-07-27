#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Whiteboard.h"
#import "WhiteAudioMixerBridge.h"
#import "WhiteBoardView.h"
#import "WhiteCommonCallbacks.h"
#import "WhiteDisplayer.h"
#import "WhiteDisplayerState.h"
#import "WhiteGlobalState.h"
#import "WhiteWebViewInjection.h"
#import "WhiteRegisterAppParams.h"
#import "WhiteSDK.h"
#import "WhiteSdkConfiguration.h"
#import "WhiteConversionInfo.h"
#import "WhiteConversionInfoV5.h"
#import "WhiteConverter.h"
#import "WhiteConverterV5.h"
#import "WhiteObject.h"
#import "WhiteCombinePlayer.h"
#import "WhiteSliderView.h"
#import "WhiteVideoView.h"
#import "WhiteAppParam.h"
#import "WhiteCameraBound.h"
#import "WhiteCameraConfig.h"
#import "WhiteCameraState.h"
#import "WhiteConsts.h"
#import "WhiteEvent.h"
#import "WhiteFontFace.h"
#import "WhiteMemberInformation.h"
#import "WhiteMemberState.h"
#import "WhitePageState.h"
#import "WhitePanEvent.h"
#import "WhitePptPage.h"
#import "WhiteRectangleConfig.h"
#import "WhiteRoomMember.h"
#import "WhiteScene.h"
#import "WhiteSceneState.h"
#import "WhiteWindowParams.h"
#import "WhitePlayer.h"
#import "WhitePlayerConfig.h"
#import "WhitePlayerConsts.h"
#import "WhitePlayerEvent.h"
#import "WhitePlayerState.h"
#import "WhitePlayerTimeInfo.h"
#import "WhiteSDK+Replayer.h"
#import "WhiteBroadcastState.h"
#import "WhiteImageInformation.h"
#import "WhiteRoom.h"
#import "WhiteRoomCallbacks.h"
#import "WhiteRoomConfig.h"
#import "WhiteRoomState.h"
#import "WhiteSDK+Room.h"
#import "WhiteSocket.h"
#import "WritableDetectRoom.h"

FOUNDATION_EXPORT double WhiteboardVersionNumber;
FOUNDATION_EXPORT const unsigned char WhiteboardVersionString[];

