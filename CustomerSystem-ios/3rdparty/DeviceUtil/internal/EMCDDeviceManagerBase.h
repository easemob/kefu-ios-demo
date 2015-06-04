//
//  EMCDDeviceManager.h
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 5/14/15.
//  Copyright (c) 2015 dujiepeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMCDDeviceManagerDelegate.h"

@interface EMCDDeviceManager : NSObject{
    // recorder
    NSDate              *_recorderStartDate;
    NSDate              *_recorderEndDate;
    NSString            *_currCategory;
    BOOL                _currActive;

    // proximitySensor
    BOOL _isSupportProximitySensor;
    BOOL _isCloseToUser;
}

@property (nonatomic, assign) id <EMCDDeviceManagerDelegate> delegate;

+(EMCDDeviceManager *)sharedInstance;


@end
