//
//  EMFileViewController.m
//  EMCSApp
//
//  Created by EaseMob on 16/3/18.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "EMFileViewController.h"

#import "TTOpenInAppActivity.h"
#import "MessageModel.h"
//#import "DXCSManager.h"
#import "ChatViewController.h"

@interface EMFileViewController ()

@property (nonatomic, strong) UIBarButtonItem *openFileItem;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIImageView *fileImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation EMFileViewController
{
    NSString *_filesPath;
    NSFileManager *_fm;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self base];
    
    self.title = @"文件";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.hidden = YES;
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.navigationItem.rightBarButtonItem = self.openFileItem;
    
    if (![self isExistFile:_model]) {
        [self.view addSubview:self.downloadButton];
    }
    [self.view addSubview:self.fileImageView];
    [self.view addSubview:self.nameLabel];
}

- (void)base {
    NSString *libDir = NSHomeDirectory();
    libDir = [libDir stringByAppendingPathComponent:@"Library"];
    _filesPath = [libDir stringByAppendingPathComponent:@"DemoFiles"];
    _fm = [NSFileManager defaultManager];
}

- (UILabel*)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake((KScreenWidth - 200.f)/2, CGRectGetMaxY(self.fileImageView.frame) + 10.f, 200.f, 20.f);
        _nameLabel.textColor = RGBACOLOR(26, 26, 26, 1);
        _nameLabel.font = [UIFont systemFontOfSize:17];
        _nameLabel.text = _model.body.filename ? _model.body.filename : @"";
    }
    return _nameLabel;
}

- (BOOL)isExistFile:(MessageModel*)model
{
    NSString *libDir = NSHomeDirectory();
    libDir = [libDir stringByAppendingPathComponent:@"Library"];
    NSString *dbDirectoryPath = [libDir stringByAppendingPathComponent:@"DemoFiles"];
    BOOL isDirectory = YES;
    BOOL isCreate = NO;
    if (![_fm fileExistsAtPath:dbDirectoryPath isDirectory:&isDirectory]) {
        isCreate = [_fm createDirectoryAtPath:dbDirectoryPath withIntermediateDirectories:NO attributes:nil error:nil];
        if (!isCreate) {
            dbDirectoryPath = nil;
        }
    }
    
    __block BOOL exit = NO;
    NSArray *contents = [_fm contentsOfDirectoryAtPath:dbDirectoryPath error:nil];
    [contents enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *fileName = obj;
        if ([fileName containsString:model.body.filename]) {
            _model.localPath = [_filesPath stringByAppendingPathComponent:_model.body.filename];
            exit = YES;
        }
    }];
    
    if (exit) {
        return YES;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",dbDirectoryPath,model.body.filename];
    if ([_fm fileExistsAtPath:path]) {
        model.localPath = path;
        return YES;
    }
    return NO;
}

- (UIImageView*)fileImageView
{
    if (_fileImageView == nil) {
        _fileImageView = [[UIImageView alloc] init];
        _fileImageView.frame = CGRectMake((KScreenWidth - 120)/2, 100.f, 120.f, 120.f);
        _fileImageView.image = [UIImage imageNamed:@"image_file2_icon_files"];
        _fileImageView.contentMode = UIViewContentModeScaleAspectFill;
        _fileImageView.layer.masksToBounds = YES;
    }
    return _fileImageView;
}

- (UIButton*)downloadButton
{
    if (_downloadButton == nil) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadButton.frame = CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame) + 10.f, KScreenWidth, 20.f);
        [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        [_downloadButton.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
        [_downloadButton setTitleColor:RGBACOLOR(25, 163, 255, 1) forState:UIControlStateNormal];
        [_downloadButton addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}

- (UIBarButtonItem*)openFileItem
{
    if (_openFileItem == nil) {
        UIButton *openFileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        openFileButton.frame = CGRectMake(0, 0, 44, 44);
        [openFileButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [openFileButton setTitle:@"打开" forState:UIControlStateNormal];
        [openFileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [openFileButton addTarget:self action:@selector(openFileAction) forControlEvents:UIControlEventTouchUpInside];
        _openFileItem = [[UIBarButtonItem alloc] initWithCustomView:openFileButton];
    }
    return _openFileItem;
}

- (void)downloadAction
{
    [self downloadMessageAttachments:_model];
}

- (void)openFileAction
{
    
    if (![self isExistFile:_model]) {
        [self showHint:@"正在下载文件,请稍后点击"];
        [self downloadMessageAttachments:_model];
    }
    
    NSURL *URL = [NSURL fileURLWithPath:_model.localPath];
    TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:self.tableView.frame];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        // Store reference to superview (UIActionSheet) to allow dismissal
        openInAppActivity.superViewController = activityViewController;
        // Show UIActivityViewController
        [self presentViewController:activityViewController animated:YES completion:NULL];
    } else {
        // Create pop up
        UIPopoverController *activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        // Store reference to superview (UIPopoverController) to allow dismissal
        openInAppActivity.superViewController = activityPopoverController;
        // Show UIActivityViewController in popup
        [activityPopoverController presentPopoverFromRect:self.tableView.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }

}

- (void)downloadMessageAttachments:(MessageModel *)model
{
    if (model.type == eMessageBodyType_File) {
        if (model.body) {
            
            if ([self isExistFile:model]) {
                return;
            }
            kWeakSelf
            [self showHudInView:self.view hint:@""];
            [[SCNetworkManager sharedInstance] downloadFileWithUrl:model.body.url completionHander:^(BOOL success, NSURL *filePath, NSError *error) {
                if (success) {
                    NSString *path = [_filesPath stringByAppendingPathComponent:model.body.filename];
                    NSData *fileData = [NSData dataWithContentsOfURL:filePath];
                    BOOL sus = [fileData writeToFile:path atomically:YES];
                    if (sus) {
                        [self showHudInView:self.view hint:@"下载成功"];
                        model.localPath = [_filesPath stringByAppendingPathComponent:model.body.filename];
                        [weakSelf.downloadButton setTitle:@"已下载" forState:UIControlStateNormal];
                        weakSelf.downloadButton.enabled = NO;
                    }
                    
                } else {
                    
                    [self showHint:@"下载失败"];

                }
                 [self hideHud];
            }];
           
        }
    }
}

@end
