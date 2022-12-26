//
//  HDVideoCallChatViewController.h
//  CustomerSystem-ios
//
//  Created by houli on 2022/7/28.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDVideoChatMessageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDVideoCallChatViewController : HDVideoChatMessageViewController <HDVideoChatMessageViewControllerDelegate, HDVideoChatMessageViewControllerDataSource>

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;
@end
NS_ASSUME_NONNULL_END
