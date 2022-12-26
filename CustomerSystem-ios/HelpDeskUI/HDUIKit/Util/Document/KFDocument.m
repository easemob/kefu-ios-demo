//
//  ZZDocument.m
//  HLtest
//
//  Created by houli on 2022/3/18.
//

#import "KFDocument.h"

@implementation KFDocument
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    self.data = contents;
    return YES;
}
@end
