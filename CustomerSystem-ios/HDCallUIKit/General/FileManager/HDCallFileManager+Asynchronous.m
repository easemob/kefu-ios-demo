//
//  WPFileManager+Asynchronous.m
//  WeiXinMovie
//
//  Created by qpwang on 6/13/15.
//  Copyright (c) 2015 qpwang. All rights reserved.
//

#import "HDCallFileManager+Asynchronous.h"

@implementation HDCallFileManager (Asynchronous)

#pragma mark - Write File without expire
-(void)asyncWriteData:(NSData *)data
               atPath:(NSString *)path
             complete:(complete)complete {
  [self asyncWriteData:data atPath:path expire:0 complete:complete];
}

-(void)asyncWriteDictionary:(NSDictionary *)dictionary
                     atPath:(NSString *)path
                   complete:(complete)complete {
  [self asyncWriteDictionary:dictionary atPath:path expire:0 complete:complete];
}

-(void)asyncWriteString:(NSString *)string
                 atPath:(NSString *)path
               complete:(complete)complete {
  [self asyncWriteString:string atPath:path expire:0 complete:complete];
}

- (void)asyncWriteArray:(NSArray *)array atPath:(NSString *)path complete:(complete)complete {
  [self asyncWriteArray:array atPath:path expire:0 complete:complete];
}

- (void)asyncWriteContent:(NSObject *)content atPath:(NSString *)path complete:(complete)complete
{
    [self asyncWriteContent:content atPath:path expire:0 complete:complete];
}

#pragma mark - Write File with Expire
-(void)asyncWriteData:(NSData *)data
               atPath:(NSString *)path
               expire:(NSTimeInterval)expire
             complete:(complete)complete {
  
  __unsafe_unretained HDCallFileManager *weakObj = self;
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    BOOL success = [weakObj writeData:data atPath:path expire:expire];
    dispatch_async(dispatch_get_main_queue(), ^{
      if (complete) {
        complete(success);
      }
    });
  });
}

- (void)asyncWriteDictionary:(NSDictionary *)dictionary
                      atPath:(NSString *)path
                      expire:(NSTimeInterval)expire
                    complete:(complete)complete {
  
  __unsafe_unretained HDCallFileManager *weakObj = self;
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    BOOL success = [weakObj writeDictionary:dictionary atPath:path expire:expire];
    dispatch_async(dispatch_get_main_queue(), ^{
      if (complete) {
        complete(success);
      }
    });
  });
}

- (void)asyncWriteString:(NSString *)string
                  atPath:(NSString *)path
                  expire:(NSTimeInterval)expire
                complete:(complete)complete {
  
  __unsafe_unretained HDCallFileManager *weakObj = self;
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    BOOL success = [weakObj writeString:string atPath:path expire:expire];
    dispatch_async(dispatch_get_main_queue(), ^{
      if (complete) {
        complete(success);
      }
    });
  });
}

- (void)asyncWriteArray:(NSArray *)array atPath:(NSString *)path expire:(NSTimeInterval)expire complete:(complete)complete {
  
  __unsafe_unretained HDCallFileManager *weakObj = self;
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    BOOL success = [weakObj writeArray:array atPath:path expire:expire];
    dispatch_async(dispatch_get_main_queue(), ^{
      if (complete) {
        complete(success);
      }
    });
  });
}

- (void)asyncWriteContent:(NSObject *)content atPath:(NSString *)path expire:(NSTimeInterval)expire complete:(complete)complete {
    if (content == nil) {
        return;
    }
    __unsafe_unretained HDCallFileManager *weakObj = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL success = [weakObj writeContent:content atPath:path expire:expire];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(success);
            }
        });
    });
}

#pragma mark - Read File
-(void)asyncReadDataAtPath:(NSString *)path
                  complete:(void (^)(NSData *))complete {
  
  __unsafe_unretained HDCallFileManager *weakObj = self;
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSData *resultData = [weakObj readDataAtPath:path];
    dispatch_async(dispatch_get_main_queue(), ^{
      if (complete) {
        complete(resultData);
      }
    });
  });
}

-(void)asyncReadStringAtPath:(NSString *)path
                    complete:(void (^)(NSString *))complete {
  
  __unsafe_unretained HDCallFileManager *weakObj = self;
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSString *resultString = [weakObj readStringAtPath:path];
    dispatch_async(dispatch_get_main_queue(), ^{
      if (complete) {
        complete(resultString);
      }
    });
  });
}

-(void)asyncReadDictionaryAtPath:(NSString *)path
                        complete:(void (^)(NSDictionary *))complete {
  
  __unsafe_unretained HDCallFileManager *weakObj = self;
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSDictionary *resultDictionary = [weakObj readDictionaryAtPath:path];
    dispatch_async(dispatch_get_main_queue(), ^{
      if (complete) {
        complete(resultDictionary);
      }
    });
  });
}

- (void) asyncReadArrayAtPath:(NSString *)path
                     complete:(void(^)(NSArray *resultArray))complete {
  
  __unsafe_unretained HDCallFileManager *weakObj = self;
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSArray *resultArray = [weakObj readArrayAtPath:path];
    dispatch_async(dispatch_get_main_queue(), ^{
      if (complete) {
        complete(resultArray);
      }
    });
  });
}

- (void) asyncReadContentAtPath:(NSString *)path complete:(void (^)(NSObject *content))complete
{
    __unsafe_unretained HDCallFileManager *weakObj = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSObject *content = [weakObj readContentAtPath:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(content);
            }
        });
    });
}

#pragma mark - delete file
- (void)asyncDeleteFileAtPath:(NSString *)path complete:(complete)complete {
  
  __unsafe_unretained HDCallFileManager *weakObj = self;
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    BOOL success = [weakObj deleteFileAtPath:path];
    dispatch_async(dispatch_get_main_queue(), ^{
      if (complete) {
        complete(success);
      }
    });
  });
}

- (void) asyncCleanExpireFile:(complete)complete {
  
  __unsafe_unretained HDCallFileManager *weakObj = self;
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    BOOL success = [weakObj cleanExpireFile];
    dispatch_async(dispatch_get_main_queue(), ^{
      if (complete) {
        complete(success);
      }
    });
  });
}

@end
