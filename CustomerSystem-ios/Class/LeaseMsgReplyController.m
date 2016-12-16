//
//  LeaseMsgReplyController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/7/25.
//  Copyright © 2016年 easemob. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "LeaseMsgReplyController.h"
#import "EMCDDeviceManager.h"
#import "EMCDDeviceManager+Media.h"
//#import "EMAudioPlayerUtil.h"
#import "FLTextView.h"
#import "LeaveMsgAttatchmentView.h"
#import "LeaveMsgDetailModel.h"
//#import "EMHttpManager.h"
//#import "EMIMHelper.h"
//#import "MessageReadManager.h"
//#import "MBProgressHUD+Add.h"
//#import "UIViewController+DismissKeyboard.h"
#import "DXRecordView.h"
#import "SCAudioPlay.h"
//#import "EMVoiceConverter.h"

#define kTouchToRecord NSLocalizedString(@"message.toolBar.record.touch", @"hold down to talk")
#define kTouchToFinish NSLocalizedString(@"message.toolBar.record.send", @"loosen to send")

#define kDefaultLeft 20
const NSInteger baseTag=123;
@interface LeaseMsgReplyController () <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, LeaveMsgAttatchmentViewDelegate,SCAudioPlayDelegate>

@property (nonatomic, strong) FLTextView *textView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) UIScrollView *attchmentView;
@property (nonatomic, strong) NSMutableArray *attachments;

@property(nonatomic,strong) UIButton *recordBtn;

@property(nonatomic,strong) DXRecordView *recordView;

@end

@implementation LeaseMsgReplyController
{
    LeaveMsgAttatchmentView *_currentAnimationView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    [self clearTempWav];
    [LeaseMsgReplyController resetFile]; //清除amr缓存
    
    self.title = NSLocalizedString(@"title.reply", @"Reply");
    self.view.backgroundColor = RGBACOLOR(238, 238, 245, 1);
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.attchmentView];
    [self setupBarButtonItem];
    
    [self.view addSubview:self.recordBtn];
}

- (UIView *)recordView
{
    if (_recordView == nil) {
        _recordView = [[DXRecordView alloc] initWithFrame:CGRectMake(90, 130, 140, 140)];
    }
    
    return _recordView;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.size = CGSizeMake(200, 40);
        _recordBtn.center = CGPointMake(kScreenWidth/2, kScreenHeight-100);
        _recordBtn.accessibilityIdentifier = @"record";
        _recordBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_recordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_recordBtn setBackgroundImage:[[UIImage imageNamed:@"chatBar_recordBg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        [_recordBtn setBackgroundImage:[[UIImage imageNamed:@"chatBar_recordSelectedBg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
        [_recordBtn setTitle:kTouchToRecord forState:UIControlStateNormal];
        [_recordBtn setTitle:kTouchToFinish forState:UIControlStateHighlighted];
        [_recordBtn addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_recordBtn addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtn addTarget:self action:@selector(recordDragOutside) forControlEvents:UIControlEventTouchDragExit];
        [_recordBtn addTarget:self action:@selector(recordDragInside) forControlEvents:UIControlEventTouchDragEnter];

    }
    return _recordBtn;
}

#pragma mark - 录音
- (void)recordButtonTouchDown
{
    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)self.recordView recordButtonTouchDown];
    }
    
    if ([self _canRecord]) {
        
        self.recordView.center = CGPointMake(kScreenWidth/2, CGRectGetMaxY(_textView.frame)+50);
        [self.view addSubview:self.recordView];
        [self.view bringSubviewToFront:_recordView];
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
        
        [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName
                                                                 completion:^(NSError *error)
         {
             if (error) {
                 NSLog(NSLocalizedString(@"message.startRecordFail", @"failure to start recording"));
             }
         }];
    }

}

- (void)recordButtonTouchUpOutside
{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)self.recordView recordButtonTouchUpOutside];
    }
    [self.recordView removeFromSuperview];
}


- (void)recordButtonTouchUpInside
{
    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)self.recordView recordButtonTouchUpInside];
    }

    __weak typeof(self) weakSelf = self;
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            //            EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:recordPath
            //                                                       displayName:@"audio"];
            //            voice.duration = aDuration;
            
            __weak typeof(self) weakSelf = self;
//            MBProgressHUD *hud = [MBProgressHUD showMessag:NSLocalizedString(@"leaveMessage.leavemsg.uploadattachment", "Upload attachment") toView:self.view];
//            hud.layer.zPosition = 1.f;
//            __weak MBProgressHUD *weakHud = hud;
            NSString *fileName =[[recordPath componentsSeparatedByString:@"/"] lastObject];
            
            NSData *data = [NSData dataWithContentsOfFile:recordPath];
            
            SCLoginManager *lgM = [SCLoginManager shareLoginManager];
            
            [[HNetworkManager shareInstance] uploadWithTenantId:lgM.tenantId File:data parameters:@{@"fileName":fileName} completion:^(id responseObject, NSError *error) {
                if (!error) {
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        LeaveMsgAttachmentModel *attachment = [[LeaveMsgAttachmentModel alloc] initWithDictionary:nil];
                        NSArray * entities = [responseObject objectForKey:@"entities"];
                        if ([entities count] > 0) {
                            NSDictionary *entity = [entities objectAtIndex:0];
                            attachment.url = [NSString stringWithFormat:@"%@/%@",[responseObject objectForKey:@"uri"],[entity objectForKey:@"uuid"]];
                        }
                        attachment.name = fileName;
                        attachment.type = @"audio";
                        attachment.wavDuration =  [NSString stringWithFormat:@"%d",(int)aDuration];
                        [weakSelf.attachments addObject:attachment];
                        [weakSelf _reloadAttatchmentsView];
                    }
                } else {
                    
                }
            }];

        }else {
            [weakSelf showHudInView:self.view hint:NSLocalizedString(@"media.timeShort", @"The recording time is too short")];
            self.recordBtn.enabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                self.recordBtn.enabled = YES;
            });
        }
    }];
  
    [self.recordView removeFromSuperview];
}

- (void)recordDragOutside
{
    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)self.recordView recordButtonDragOutside];
    }
}

- (void)recordDragInside
{
    if ([self.recordView isKindOfClass:[DXRecordView class]]) {
        [(DXRecordView *)self.recordView recordButtonDragInside];
    }
}

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sendButton setTitle:NSLocalizedString(@"send", @"Send") forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    [self.navigationItem setRightBarButtonItem:sendItem];
}

#pragma mark - getter

- (FLTextView *)textView
{
    if (_textView == nil) {
        _textView = [[FLTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 124.f)];
        [_textView setPlaceholderText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"title.reply", @"Reply"),@"..."]];
        _textView.fontSize = 13.0;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), kScreenWidth, 0.5f)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
    }
    return _textView;
}

- (UIButton*)addButton
{
    if (_addButton == nil) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(20.f,130 + 10.f, 98.f, 28.f);
        [_addButton setTitle:NSLocalizedString(@"leaveMessage.leavemsg.addattachment", @"Add Attachment") forState:UIControlStateNormal];
        [_addButton setTitleColor:RGBACOLOR(77, 178, 244, 1) forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _addButton.layer.borderColor = RGBACOLOR(77, 178, 244, 1).CGColor;
        _addButton.layer.borderWidth = 1.f;
        _addButton.layer.cornerRadius = 4.f;
        [_addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (NSMutableArray*)attachments
{
    if (_attachments == nil) {
        _attachments = [NSMutableArray array];
    }
    return _attachments;
}

- (UIScrollView*)attchmentView
{
    if (_attchmentView == nil) {
        _attchmentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_addButton.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(_addButton.frame) - 64.f - 100.0)];
    }
    return _attchmentView;
}

#pragma mark - action

- (void)sendAction
{
    if (_textView.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"leaveMessage.leavemsg.replyempty", @"Reply is empty") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectSendButtonWithParameters:)]) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableArray *attachments = [NSMutableArray array];
        for (LeaveMsgAttachmentModel *attachment in _attachments) {
            [attachments addObject:[attachment getContent]];
        }
        [parameters setObject:attachments forKey:@"attachments"];
        
        [parameters setObject:_textView.text forKey:@"content"];
        [self.delegate didSelectSendButtonWithParameters:parameters];
    }
}

//添加图片
- (void)addAction
{
    [_textView endEditing:YES];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        
        __weak typeof(self) weakSelf = self;
//        MBProgressHUD *hud = [MBProgressHUD showMessag:NSLocalizedString(@"leaveMessage.leavemsg.uploadattachment", "Upload attachment") toView:self.view];
//        hud.layer.zPosition = 1.f;
//        __weak MBProgressHUD *weakHud = hud;
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            NSString *fileName = [representation filename];
            NSData *data =UIImageJPEGRepresentation(orgImage, 0.5);
            
            SCLoginManager *lgM = [SCLoginManager shareLoginManager];
            [[HNetworkManager shareInstance] uploadWithTenantId:lgM.tenantId File:data parameters:@{@"fileName":fileName} completion:^(id responseObject, NSError *error) {
                if (!error) {
//                    [weakHud hide:YES];
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        LeaveMsgAttachmentModel *attachment = [[LeaveMsgAttachmentModel alloc] initWithDictionary:nil];
                        NSArray * entities = [responseObject objectForKey:@"entities"];
                        if ([entities count] > 0) {
                            NSDictionary *entity = [entities objectAtIndex:0];
                            attachment.url = [NSString stringWithFormat:@"%@/%@",[responseObject objectForKey:@"uri"],[entity objectForKey:@"uuid"]];
                        }
                        attachment.name = fileName;
                        attachment.type = @"image";
                        [weakSelf.attachments addObject:attachment];
                        [weakSelf _reloadAttatchmentsView];
                    }
                } else {
//                    [weakHud setLabelText:NSLocalizedString(@"leaveMessage.leavemsg.uploadattachment.failed", "Upload attachment failed")];
//                    [weakHud hide:YES afterDelay:0.5];
                }
            }];
           
        };
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
                      failureBlock:nil];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LeaveMsgAttatchmentViewDelegate

- (void)didRemoveAttatchment:(NSInteger)index
{
    index = index -baseTag;
    if ([_attachments count] > index) {
        [_attachments removeObjectAtIndex:index];
        [self _reloadAttatchmentsView];
    }
    [self clearTempWav];
}

- (void)_reloadAttatchmentsView
{
    for (UIView *subView in [_attchmentView subviews]) {
        [subView removeFromSuperview];
    }
    
    CGFloat left = kDefaultLeft;
    CGFloat height = 20;
    NSInteger index = 0;
    for (LeaveMsgAttachmentModel *attachment in self.attachments) {
        if (left + [LeaveMsgAttatchmentView widthForName:attachment.name maxWidth:kScreenWidth - kDefaultLeft - 10] > kScreenWidth) {
            left = kDefaultLeft;
            height += 50;
        }
        
        LeaveMsgAttatchmentView *attatchmentView = [[LeaveMsgAttatchmentView alloc] initWithFrame:CGRectMake(left, height, [LeaveMsgAttatchmentView widthForName:attachment.name maxWidth:kScreenWidth - kDefaultLeft - 10], 30) edit:YES model:attachment];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAttatchmentAction:)];
        tap.delegate = attatchmentView;
        tap.cancelsTouchesInView = NO;
        [attatchmentView addGestureRecognizer:tap];
        attatchmentView.delegate = self;
        attatchmentView.tag = index+baseTag;
        [_attchmentView addSubview:attatchmentView];
        index ++;
        left += [LeaveMsgAttatchmentView widthForName:attachment.name maxWidth:kScreenWidth - kDefaultLeft - 10] + kDefaultLeft + 10;
    }
    [_attchmentView setContentSize:CGSizeMake(kScreenWidth, height + 30.f)];
}

#pragma mark - action

- (void)tapAttatchmentAction:(UITapGestureRecognizer *)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    NSInteger index = tap.view.tag-baseTag;
    if ([_attachments count] > index) {
        LeaveMsgAttachmentModel *attachment = [_attachments objectAtIndex:index];
        if ([attachment.type isEqualToString:@"image"]) {
//            [[MessageReadManager defaultManager] showBrowserWithImages:@[[NSURL URLWithString:attachment.url]]];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = fKeyWindow.bounds;
            [button addTarget:self action:@selector(tapImageView:) forControlEvents:UIControlEventTouchUpInside];
            [button sd_setImageWithURL:[NSURL URLWithString:attachment.url] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor blackColor];
            [fKeyWindow addSubview:button];
        }
        if ([attachment.type isEqualToString:@"audio"]) {
            LeaveMsgAttatchmentView *view = (LeaveMsgAttatchmentView *)tap.view;
            _currentAnimationView = view;
            HNetworkManager *manager = [HNetworkManager shareInstance];
            kWeakSelf
            [manager downloadFileWithUrl:attachment.url completionHander:^(BOOL success, NSURL *filePath, NSError *error) {
                if (!error) {
                    NSString *toPath = [NSString stringWithFormat:@"%@/%ld.wav",NSTemporaryDirectory(),tap.view.tag];
                    BOOL success = [[EMCDDeviceManager new] convertAMR:[filePath path] toWAV:toPath];
                    if (success) {
                        [weakSelf playWithfilePath:toPath];
                    }
                }else{
                  
                    NSLog(@"下载文件失败");
                }
            }];
        }
    }
}

- (void)tapImageView:(UIButton *)sender {
    [sender removeFromSuperview];
}

- (void)playWithfilePath:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        [fm removeItemAtPath:path error:nil];
    }
    SCAudioPlay *play = [SCAudioPlay sharedInstance];
    play.delegate = self;
    if (play.isPlaying) {
        [play stopSound];
    }
    [play playSoundWithData:data];
}

- (void)AVAudioPlayerBeiginPlay {
    [_currentAnimationView startAnimating];
}

- (void)AVAudioPlayerDidFinishPlay {
    [_currentAnimationView stopAnimating];
}

- (void)clearTempWav {
    NSString *cachesPath = NSTemporaryDirectory();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:cachesPath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        if ([[filename pathExtension] isEqualToString:@"wav"]) {
            BOOL success =  [fileManager removeItemAtPath:[cachesPath stringByAppendingPathComponent:filename] error:NULL];
            if (success) {
                NSLog(@"success");
            }
        }
    }
}


+ (void)resetFile {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:cachesPath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        if ([[filename pathExtension] isEqualToString:@"amr"]) {
            BOOL success =  [fileManager removeItemAtPath:[cachesPath stringByAppendingPathComponent:filename] error:NULL];
            if (success) {
                NSLog(@"success");
            }
        }
    }
}
@end






