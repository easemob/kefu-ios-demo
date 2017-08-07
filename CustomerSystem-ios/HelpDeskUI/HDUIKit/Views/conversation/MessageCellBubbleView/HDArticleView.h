//
//  HDArticleTableView.h
//  CustomerSystem-ios
//
//  Created by afanda on 8/3/17.
//  Copyright © 2017 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDArticleViewDelegate <NSObject>
@optional

- (NSInteger)articleViewNumberOfSectionsInTableView:(UITableView *)tableView;

@required

- (NSInteger)articleViewTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section ;

- (UITableViewCell *)articleViewTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)articleTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)articleTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


@end

@interface HDArticleView : UIView

@property(nonatomic,assign) id<HDArticleViewDelegate> delegate;


- (void)reloadData;


@end

























