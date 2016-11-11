//
//  LeaveMsgCell.h
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/6/30.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeaveMsgAttachmentModel;
@class LeaveMsgCommentModel;
@class LeaveMsgAttatchmentView;
@protocol LeaveMsgCellDelegate <NSObject>

- (void)didSelectFileAttachment:(LeaveMsgAttachmentModel*)attachment;

- (void)didSelectAudioAttachment:(LeaveMsgAttachmentModel*)attachment touchImage:(LeaveMsgAttatchmentView *)attatchmentView;

@end

@interface LeaveMsgCell : UITableViewCell

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detailMsg;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSArray *attachments;
@property (nonatomic) NSInteger unreadCount;

@property (nonatomic, weak) id<LeaveMsgCellDelegate> delegate;

- (void)setModel:(LeaveMsgCommentModel*)model;

+(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath;

+(CGFloat)tableView:(UITableView *)tableView model:(LeaveMsgCommentModel*)model;

@end
