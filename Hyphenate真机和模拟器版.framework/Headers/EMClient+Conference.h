//
//  EMClient+Conference.h
//  HyphenateSDK
//
//  Created by XieYajie on 21/10/2016.
//  Copyright © 2016 easemob.com. All rights reserved.
//

#import "EMClient.h"

#import "IEMConferenceManager.h"

@interface EMClient (Conference)

/*!
 *  \~chinese
 *  多人会议模块
 *
 *  \~english
 *  mutil conference module
 */
@property (strong, nonatomic, readonly) id<IEMConferenceManager> conferenceManager;

@end
