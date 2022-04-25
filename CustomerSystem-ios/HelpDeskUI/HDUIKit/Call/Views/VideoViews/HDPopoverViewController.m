//
//  Popover.m
//  presentingViewController
//
//  Created by yiban on 15/8/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "HDPopoverViewController.h"
#import "UIImage+HDIconFont.h"
@implementation HDPopoverViewControllerCellItem

@end

@implementation HDPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    
    HDPopoverViewControllerCellItem * item = [[HDPopoverViewControllerCellItem alloc] init];
    item.name =@"关闭摄像头";
    item.imgName = kshexiangtou1;
    
    HDPopoverViewControllerCellItem * item1 = [[HDPopoverViewControllerCellItem alloc] init];
    item1.name =@"切换摄像头";
    item1.imgName = kqiehuanshexiangtou;
    self.dataArray = [[NSMutableArray alloc] initWithObjects:item,item1, nil];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    HDPopoverViewControllerCellItem * item =self.dataArray[indexPath.row];
   
    cell.textLabel.text = [NSString stringWithFormat:@"%@",item.name];
    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-44, 7, 25, 25)];
    img.image = [UIImage imageWithIcon:item.imgName inFont:kfontName size:img.size.width color:[UIColor colorWithRed:12.0/255.0 green:110.0/255.0 blue:254.0/255.0 alpha:1.000] ] ;
    
    [cell addSubview:img];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"click" object:indexPath];
}

//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    if (self.presentingViewController && self.tableView != nil) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 180;
        CGSize size = [self.tableView sizeThatFits:tempSize];  //sizeThatFits返回的是最合适的尺寸，但不会改变控件的大小
        return size;
    }else {
        return [super preferredContentSize];
    }
}

- (void)setPreferredContentSize:(CGSize)preferredContentSize{
    super.preferredContentSize = preferredContentSize;
}
@end
