//
//  MediaFileModel.h
//  EMCSApp
//
//  Created by EaseMob on 15/4/20.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MEDIA_UUID @"uuid"
#define MEDIA_URL @"url"
#define MEDIA_CONTENTTYPE @"contentType"
#define MEDIA_FILENAME @"fileName"
#define MEDIA_LENGTH @"contentLength"

@interface MediaFileModel : NSObject

@property (copy, nonatomic) NSString *uuid;
@property (copy, nonatomic) NSString *contentType;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *fileName;
@property (assign, nonatomic) NSInteger contentLength;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
