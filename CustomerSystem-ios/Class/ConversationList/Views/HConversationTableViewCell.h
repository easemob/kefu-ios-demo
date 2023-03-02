//
//  HConversationTableViewCell.h
//  CustomerSystem-ios
//
//  Created by afanda on 6/8/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HConversationsViewController.h"
#import "DXTipView.h"

@interface HConversationTableViewCell : UITableViewCell

@property (nonatomic,strong) HDConversation *model;

@property (strong, nonatomic) UIImageView *headerImageView;

@property (strong, nonatomic) UILabel *unreadLabel;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UILabel *timeLabel;

@end
