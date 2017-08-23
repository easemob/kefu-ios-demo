//
//  HFileViewController.m
//  CustomerSystem-ios
//
//  Created by afanda on 16/12/6.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "HFileViewController.h"

@interface HFileViewController () <UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIImageView *fileImageView;
@property (nonatomic, strong) UIBarButtonItem *openFileItem;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property(nonatomic,strong) UIDocumentInteractionController *documentInteractionController;
@end

@implementation HFileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"file", @"File");
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.navigationItem.rightBarButtonItem = self.openFileItem;
    [self.view addSubview:self.downloadButton];
    if (![self isExistFile:_model]) {
        [_downloadButton setTitle:NSLocalizedString(@"download", @"Download") forState:UIControlStateNormal];
    } else {
        [_downloadButton setTitle:NSLocalizedString(@"have_downloaded", @"Have downloaded") forState:UIControlStateNormal];
    }
    [self.view addSubview:self.fileImageView];
    [self.view addSubview:self.nameLabel];
}

- (UIImageView*)fileImageView
{
    if (_fileImageView == nil) {
        _fileImageView = [[UIImageView alloc] init];
        _fileImageView.frame = CGRectMake((kHDScreenWidth - 120)/2, 100.f, 120.f, 120.f);
        _fileImageView.image = [UIImage imageNamed:@"HelpDeskUIResource.bundle/chat_item_file"];
        _fileImageView.contentMode = UIViewContentModeScaleAspectFill;
        _fileImageView.layer.masksToBounds = YES;
    }
    return _fileImageView;
}

- (UILabel*)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake((kHDScreenWidth - 200.f)/2, CGRectGetMaxY(self.fileImageView.frame) + 10.f, 200.f, 20.f);
        _nameLabel.centerX = _fileImageView.centerX;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = RGBACOLOR(26, 26, 26, 1);
        _nameLabel.font = [UIFont systemFontOfSize:17];
        _nameLabel.text = _model.fileName ? _model.fileName : @"";
    }
    return _nameLabel;
}

- (UIBarButtonItem*)openFileItem
{
    if (_openFileItem == nil) {
        UIButton *openFileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        openFileButton.frame = CGRectMake(0, 0, 44, 44);
        [openFileButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [openFileButton setTitle:NSLocalizedString(@"open", @"Open") forState:UIControlStateNormal];
        [openFileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [openFileButton addTarget:self action:@selector(openFileAction) forControlEvents:UIControlEventTouchUpInside];
        _openFileItem = [[UIBarButtonItem alloc] initWithCustomView:openFileButton];
    }
    return _openFileItem;
}

- (UIButton*)downloadButton
{
    if (_downloadButton == nil) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadButton.frame = CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame) + 20.f, kHDScreenWidth, 20.f);
        [_downloadButton.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
        [_downloadButton setTitleColor:RGBACOLOR(25, 163, 255, 1) forState:UIControlStateNormal];
        [_downloadButton addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}
- (BOOL)isExistFile:(HDMessageModel*)model
{
    EMFileMessageBody *body = (EMFileMessageBody *)model.firstMessageBody;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:body.localPath];
    return isExist;
}

- (void)downloadAction {
    [self downloadMessageAttachments:_model];
}

- (UIDocumentInteractionController *)documentInteractionController {
    if (!_documentInteractionController) {
        _documentInteractionController = [[UIDocumentInteractionController alloc]init];
        _documentInteractionController.delegate = self;
    }
    return _documentInteractionController;
}

- (void)openFileAction
{
    
    if (![self isExistFile:_model]) {
        [self showHint:NSLocalizedString(@"download_file", @"Is the download file, please click on the later")];
        [self downloadMessageAttachments:_model];
        return;
    }
    EMFileMessageBody *body = (EMFileMessageBody *)_model.firstMessageBody;
    NSURL *localUrl = [NSURL fileURLWithPath:body.localPath];
    self.documentInteractionController.URL = localUrl;
    self.documentInteractionController.name = body.displayName;
    if (![self.documentInteractionController presentPreviewAnimated:YES]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"not_support_preview_files", @"Such systems do not support preview files") delegate:nil cancelButtonTitle:NSLocalizedString(@"know_the", @"Know The") otherButtonTitles:nil];
        [alert show];
    }
    
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller {
    
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
    
}

- (void)downloadMessageAttachments:(HDMessageModel *)model
{
    EMFileMessageBody *body = (EMFileMessageBody *)model.firstMessageBody;
    if (model.bodyType == EMMessageBodyTypeFile) {
        if (body.localPath) {
            if ([self isExistFile:model]) {
                [self showHint:[NSString stringWithFormat:@"%@~~",NSLocalizedString(@"have_downloaded", @"Have downloaded")]];
                return;
            }
            [self showHudInView:self.view hint:[NSString stringWithFormat:@"%@...",NSLocalizedString(@"in_the_download", @"In the download")]];
            
            [[HChatClient sharedClient].chat downloadMessageAttachment:model.message progress:^(int progress) {
                
            } completion:^(HMessage *message, HError *error) {
                [self hideHud];
                if (!error) { //成功
                    [_downloadButton setTitle:NSLocalizedString(@"have_downloaded", @"Have downloaded") forState:UIControlStateNormal];
                } else { //下载失败
                    
                }
            }];
        }
    }
}


- (UIBarButtonItem *)backItem
{
    if (_backItem == nil) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [backButton setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        nagetiveSpacer.width = - 16;
        self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,_backItem];
    }
    
    return _backItem;
}
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
