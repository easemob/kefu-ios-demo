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
    
//    HDPopoverViewControllerCellItem * item = [[HDPopoverViewControllerCellItem alloc] init];
//    item.name =NSLocalizedString(@"video.call.close.camera", @"关闭摄像头");
//    item.imgName = kshexiangtou1;
//    
//    HDPopoverViewControllerCellItem * item1 = [[HDPopoverViewControllerCellItem alloc] init];
//    item1.name =NSLocalizedString(@"video.call.switch.camera", @"切换摄像头");
//    item1.imgName = kqiehuanshexiangtou;
//    self.dataArray = [[NSMutableArray alloc] initWithObjects:item,item1, nil];
   
}
- (void)setDataArrayWithModel:(NSMutableArray<HDPopoverViewControllerCellItem *> *)dataArray{
    
    self.dataArray = [[NSMutableArray alloc] initWithArray:dataArray];
    
    [self.tableView reloadData];
    
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
   
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",item.name];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(10, 0, self.view.frame.size.width-54, cell.frame.size.height);
    titleLabel.text = [NSString stringWithFormat:@"%@",item.name];
//    titleLabel.backgroundColor = [UIColor yellowColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [cell addSubview:titleLabel];
    
    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-44, 7, 25, 25)];
    if (item.isOn) {
   
        img.image = [UIImage imageWithIcon:item.imgName inFont:kfontName size:img.size.width color:[[HDAppSkin mainSkin] contentColorRed] ] ;
    }else{
    img.image = [UIImage imageWithIcon:item.imgName inFont:kfontName size:img.size.width color: [[HDAppSkin mainSkin] contentColorBlue] ] ;
    }
    [cell addSubview:img];
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    HDPopoverViewControllerCellItem * item =  [self.dataArray objectAtIndex:indexPath.row];
    item.indexPath = indexPath;
    [dic hd_setValue:self forKey:@"currentClass"];
    [dic hd_setValue:item forKey:@"currentItemClass"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"click" object:indexPath userInfo:dic];
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

-(void)reloadRows:(HDPopoverViewControllerCellItem *)item{
    
    
    [_dataArray replaceObjectAtIndex:item.indexPath.row withObject:item];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:item.indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    
    
    
}




@end
