//
//  MediaFileModel.m
//  EMCSApp
//
//  Created by EaseMob on 15/4/20.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "MediaFileModel.h"

#import "NSDictionary+SafeValue.h"

@implementation MediaFileModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.uuid = [dictionary safeStringValueForKey:MEDIA_UUID];
        self.url = [dictionary safeStringValueForKey:MEDIA_URL];
        self.contentType = [dictionary safeStringValueForKey:MEDIA_CONTENTTYPE];
        self.contentLength = [dictionary safeIntegerValueForKey:MEDIA_LENGTH];
        self.fileName = [dictionary safeStringValueForKey:MEDIA_FILENAME];
    }
    return self;
}


@end
