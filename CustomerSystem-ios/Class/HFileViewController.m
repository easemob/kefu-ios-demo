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
    self.title = @"文件";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.navigationItem.rightBarButtonItem = self.openFileItem;
    [self.view addSubview:self.downloadButton];
    if (![self isExistFile:_model]) {
        [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    } else {
        [_downloadButton setTitle:@"已下载" forState:UIControlStateNormal];
    }
    [self.view addSubview:self.fileImageView];
    [self.view addSubview:self.nameLabel];
}

- (UIImageView*)fileImageView
{
    if (_fileImageView == nil) {
        _fileImageView = [[UIImageView alloc] init];
        _fileImageView.frame = CGRectMake((kScreenWidth - 120)/2, 100.f, 120.f, 120.f);
        _fileImageView.image = [UIImage imageNamed:@"EaseUIResource.bundle/chat_item_file"];
        _fileImageView.contentMode = UIViewContentModeScaleAspectFill;
        _fileImageView.layer.masksToBounds = YES;
    }
    return _fileImageView;
}

- (UILabel*)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake((kScreenWidth - 200.f)/2, CGRectGetMaxY(self.fileImageView.frame) + 10.f, 200.f, 20.f);
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
        [openFileButton setTitle:@"打开" forState:UIControlStateNormal];
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
        _downloadButton.frame = CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame) + 20.f, kScreenWidth, 20.f);
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
        [self showHint:@"正在下载文件,请稍后点击"];
        [self downloadMessageAttachments:_model];
        return;
    }
    EMFileMessageBody *body = (EMFileMessageBody *)_model.firstMessageBody;
    NSURL *localUrl = [NSURL fileURLWithPath:body.localPath];
    self.documentInteractionController.URL = localUrl;
    self.documentInteractionController.name = body.displayName;
    if (![self.documentInteractionController presentPreviewAnimated:YES]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统不支持预览此类文件" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
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
                [self showHint:@"已下载~~"];
                return;
            }
            [self showHudInView:self.view hint:@"下载中..."];
            
            [[HChatClient sharedClient].chat downloadMessageAttachment:model.message progress:^(int progress) {
                
            } completion:^(HMessage *message, HError *error) {
                [self hideHud];
                if (!error) { //成功
                    [_downloadButton setTitle:@"已下载" forState:UIControlStateNormal];
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
        [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
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
