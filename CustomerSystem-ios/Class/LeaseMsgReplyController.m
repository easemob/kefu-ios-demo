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
#import "HDCDDeviceManager.h"
#import "HDCDDeviceManager+Media.h"
#import "FLTextView.h"
#import "LeaveMsgAttatchmentView.h"
#import "LeaveMsgDetailModel.h"
#import "HDMessageReadManager.h"
#import "MBProgressHUD+Add.h"
#import "HDMicView.h"
#import "SCAudioPlay.h"
#import "CustomButton.h"
#import "HDRecordView.h"
#define kDefaultLeft 20
const NSInteger baseTag=123;
@interface LeaseMsgReplyController () <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, LeaveMsgAttatchmentViewDelegate,SCAudioPlayDelegate, HDRecordViewDelegate, HDCDDeviceManagerDelegate>

@property (nonatomic, strong) FLTextView *textView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) UIScrollView *attchmentView;
@property (nonatomic, strong) NSMutableArray *attachments;

// 录音键盘切换按钮
@property (nonatomic,strong) UIButton *recordChangeBtn;
// 话筒view
@property (nonatomic,strong) HDMicView *micView;
// 录音按钮view
@property (nonatomic, strong) HDRecordView *recordButtonView;


@property (nonatomic,strong) UIView *maskingView;

@end

@implementation LeaseMsgReplyController
{
    LeaveMsgAttatchmentView *_currentAnimationView;
    SCAudioPlay *_audioPlayer;
    CGFloat _boardHeight;
    BOOL _status;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    [self clearTempWav];
    [LeaseMsgReplyController resetFile]; //清除amr缓存
    
    self.view.backgroundColor = RGBACOLOR(255, 255, 255, 1);
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.attchmentView];
    [self.view addSubview:self.recordChangeBtn];
    [self setupBarButtonItem];
    
    self.maskingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 200)];
    self.maskingView.backgroundColor = [UIColor clearColor];
    self.maskingView.userInteractionEnabled = YES;
    self.maskingView.tag = 33;

    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundLeaseMsgReply)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _boardHeight = keyboardRect.size.height;
    
    [self move];
}


//当键盘退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self hide];
}

- (void)appDidEnterBackgroundLeaseMsgReply
{
    [self _stopAudioPlayingWithChangeCategory];
}

- (UIView *)micView
{
    if (_micView == nil) {
        _micView = [[HDMicView alloc] initWithFrame:CGRectMake(90, 130, 60, 80)];
    }
    
    return _micView;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.view viewWithTag:33]) {
        if (_recordButtonView) {
            [self.recordButtonView removeFromSuperview];
            self.recordChangeBtn.selected = NO;
            [self.textView endEditing:YES];
            [self restoreButton];
        }
    }
}

- (UIButton *)recordChangeBtn {
    if (!_recordChangeBtn) {
        _recordChangeBtn = [[UIButton alloc] init];
        _recordChangeBtn.size = CGSizeMake(30, 30);
        _recordChangeBtn.center = CGPointMake(kScreenWidth/2 + kScreenWidth/3 + 30, kScreenHeight - 90);
        [_recordChangeBtn setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_comment_voice_btn_normal"] forState:UIControlStateNormal];
        [_recordChangeBtn setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_chatting_setmode_keyboard_btn_normal"] forState:UIControlStateSelected];
        [_recordChangeBtn addTarget:self action:@selector(recordChangButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _recordChangeBtn;
}

// 修改 录音按钮的点击事件
- (void)recordChangButtonAction:(id)sender
{

    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;

    
    if (button.selected) {
        [self.textView resignFirstResponder];
        
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _recordChangeBtn.originY = _recordChangeBtn.frame.origin.y - 140;
            _addButton.originY = _addButton.frame.origin.y - 140;
            _attchmentView.originY = _attchmentView.frame.origin.y - 140;
            self.recordButtonView = [[HDRecordView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_recordChangeBtn.frame), kScreenWidth, 140) mark:@"leaveView"];
            self.recordButtonView.delegate = self;
            self.recordButtonView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0];
            [self.view addSubview:self.recordButtonView];
            
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self.textView becomeFirstResponder];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self move];
            [_recordButtonView removeFromSuperview];
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    
}

// 录音
#pragma mark - HRecordViewDelegate
- (void)didHDStartRecordingVoiceAction:(UIView *)micView
{
    [self _stopAudioPlayingWithChangeCategory];
    [self.view addSubview:self.maskingView];
    [self.view bringSubviewToFront:self.maskingView];
    
    if ([micView isKindOfClass:[HDMicView class]]) {
        [(HDMicView *)micView recordButtonTouchDown];
    }
    
    
    if ([self _canRecord]) {
        [self.view addSubview:micView];
        [self.view bringSubviewToFront:micView];
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
        
        [[HDCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error)
         {
             if (error) {
                 NSLog(@"%@",NSEaseLocalizedString(@"message.startRecordFail", @"failure to start recording"));
             }
         }];
    }
}

- (void)didHDCancelRecordingVoiceAction:(UIView *)micView
{
    self.maskingView  = [self.view viewWithTag:33];
    [self.maskingView removeFromSuperview];
    [[HDCDDeviceManager sharedInstance] cancelCurrentRecording];
    if ([micView isKindOfClass:[HDMicView class]]) {
        [(HDMicView *)micView recordButtonTouchUpOutside];
    }
        [micView removeFromSuperview];
    
}

- (void)didHDFinishRecoingVoiceAction:(UIView *)micView
{
    self.maskingView  = [self.view viewWithTag:33];
    [self.maskingView removeFromSuperview];
    if ([micView isKindOfClass:[HDMicView class]]) {
        [(HDMicView *)micView recordButtonTouchUpInside];
    }
    
    __weak typeof(self) weakSelf = self;
    [[HDCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            __weak typeof(self) weakSelf = self;
            NSString *fileName =[[recordPath componentsSeparatedByString:@"/"] lastObject];
            
            NSData *data = [NSData dataWithContentsOfFile:recordPath];
            MBProgressHUD *hud = [MBProgressHUD showMessag:NSLocalizedString(@"uploading...", "Upload attachment") toView:self.view];
            hud.layer.zPosition = 1.f;
            __weak MBProgressHUD *weakHud = hud;
            CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
            //此方法只为演示用，用户应把录制的附件放到自己服务器，环信服务器不存储留言的附件
            [[[HDClient sharedClient] leaveMsgManager] uploadWithTenantId:lgM.tenantId File:data parameters:@{@"fileName":fileName} completion:^(id responseObject, NSError *error) {
                if (!error) {
                    [weakHud hide:YES];
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
                    [weakHud setLabelText:NSLocalizedString(@"failed", "Upload attachment failed")];
                    [weakHud hide:YES afterDelay:0.5];
                }
            }];
            
        }else {
            [weakSelf showHudInView:self.view hint:NSLocalizedString(@"media.timeShort", @"The recording time is too short")];
            self.recordChangeBtn.enabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                self.recordChangeBtn.enabled = YES;
            });
        }
    }];
    
    [micView removeFromSuperview];

}

- (void)didHDDragOutsideAction:(UIView *)micView
{
    if ([micView isKindOfClass:[HDMicView class]]) {
        [(HDMicView *)micView recordButtonDragInside];
    }
}

- (void)didHDDragInsideAction:(UIView *)micView
{
    if ([micView isKindOfClass:[HDMicView class]]) {
        [(HDMicView *)micView recordButtonDragOutside];
    }
}

- (void)dealloc
{
    [self _stopAudioPlayingWithChangeCategory];
    
    if (_imagePicker){
        [_imagePicker dismissViewControllerAnimated:NO completion:nil];
        _imagePicker = nil;
    }
}



- (void)setupBarButtonItem
{
    CustomButton * backButton = [CustomButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
    [backButton setTitle:NSLocalizedString(@"title.reply", @"Reply") forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:RGBACOLOR(184, 22, 22, 1) forState:UIControlStateHighlighted];
    backButton.imageRect = CGRectMake(10, 6.5, 16, 16);
    backButton.titleRect = CGRectMake(28, 0, 83, 29);
    [self.view addSubview:backButton];
    backButton.frame = CGRectMake(0, 0, 120, 29);
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -16;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,backItem];
    
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [sendButton setTitle:NSLocalizedString(@"send", @"Send") forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    UIBarButtonItem *sendNagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    sendNagetiveSpacer.width = -12;
    self.navigationItem.rightBarButtonItems = @[sendNagetiveSpacer,sendItem];
}

- (void)back
{
    [self _stopAudioPlayingWithChangeCategory];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - getter

- (FLTextView *)textView
{
    if (_textView == nil) {
        _textView = [[FLTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.3)];
        [_textView setPlaceholderText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"title.reply", @"Reply"),@"..."]];
        _textView.fontSize = 13.0;
        _textView.font = [UIFont systemFontOfSize:18];
        _textView.layer.borderColor = [UIColor clearColor].CGColor;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.delegate = self;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), kScreenWidth, 0.5f)];
//        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
    }
    return _textView;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self restoreButton];
        [self.recordButtonView removeFromSuperview];
        self.recordChangeBtn.selected = NO;
        [_textView endEditing:YES];
        return NO;
    }
    return YES;
}

- (UIButton*)addButton
{
    
    if (_addButton == nil) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.size = CGSizeMake(30, 30);
        _addButton.center = CGPointMake(kScreenWidth/2 + kScreenWidth/3 - 10, kScreenHeight - 90);
        [_addButton setImage:[UIImage imageNamed:@"HelpDeskUIResource.bundle/hd_chatting_setmode_attachment_btn_normal"] forState:UIControlStateNormal];
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
        _attchmentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 170, kScreenWidth * 0.6, 100)];
        _attchmentView.showsVerticalScrollIndicator = YES;
        _attchmentView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
        _attchmentView.directionalLockEnabled = YES;
    }
    return _attchmentView;
}

#pragma mark - action

- (void)sendAction
{
    [self _stopAudioPlayingWithChangeCategory];
    if (_textView.text.length == 0 && _attachments.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"leaveMessage.leavemsg.replyempty", @"Reply is empty") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
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
    _recordChangeBtn.selected = NO;
    [_recordButtonView removeFromSuperview];
    [self restoreButton];
    [self _stopAudioPlayingWithChangeCategory];
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
        MBProgressHUD *hud = [MBProgressHUD showMessag:NSLocalizedString(@"uploading...", "Upload attachment") toView:self.view];
        hud.layer.zPosition = 1.f;
        __weak MBProgressHUD *weakHud = hud;
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            NSString *fileName = [representation filename];
            NSData *data =UIImageJPEGRepresentation(orgImage, 0.5);
            
            CSDemoAccountManager *lgM = [CSDemoAccountManager shareLoginManager];
            ////此方法只为演示用，用户应把录制的附件放到自己服务器，环信服务器不存储留言的附件
            [[[HDClient sharedClient] leaveMsgManager] uploadWithTenantId:lgM.tenantId File:data parameters:@{@"fileName":fileName} completion:^(id responseObject, NSError *error) {
                if (!error) {
                    [weakHud hide:YES];
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
                    [weakHud setLabelText:NSLocalizedString(@"failed", "Upload attachment failed")];
                    [weakHud hide:YES afterDelay:0.5];
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
    CGFloat height = 10;
    NSInteger index = 0;
    for (LeaveMsgAttachmentModel *attachment in self.attachments) {
        if (left + [LeaveMsgAttatchmentView widthForName:attachment.name maxWidth:kScreenWidth*0.6 - kDefaultLeft - 10] > kScreenWidth*0.6) {
            left = kDefaultLeft;
            height += 50;
        }
        
        LeaveMsgAttatchmentView *attatchmentView = [[LeaveMsgAttatchmentView alloc] initWithFrame:CGRectMake(left, height, [LeaveMsgAttatchmentView widthForName:attachment.name maxWidth:kScreenWidth*0.6 - kDefaultLeft - 10], 30) edit:YES model:attachment];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAttatchmentAction:)];
        tap.delegate = attatchmentView;
        tap.cancelsTouchesInView = NO;
        [attatchmentView addGestureRecognizer:tap];
        attatchmentView.delegate = self;
        attatchmentView.tag = index+baseTag;
        [_attchmentView addSubview:attatchmentView];
        index ++;
        left += [LeaveMsgAttatchmentView widthForName:attachment.name maxWidth:kScreenWidth*0.6 - kDefaultLeft - 10] + kDefaultLeft + 10;
    }
    [_attchmentView setContentSize:CGSizeMake(kScreenWidth*0.6, height + 10.f)];
}

#pragma mark - action

- (void)tapAttatchmentAction:(UITapGestureRecognizer *)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    NSInteger index = tap.view.tag-baseTag;
    if ([_attachments count] > index) {
        LeaveMsgAttachmentModel *attachment = [_attachments objectAtIndex:index];
        if ([attachment.type isEqualToString:@"image"]) {
            [[HDMessageReadManager defaultManager] showBrowserWithImages:@[[NSURL URLWithString:attachment.url]]];
        }
        if ([attachment.type isEqualToString:@"audio"]) {
            LeaveMsgAttatchmentView *view = (LeaveMsgAttatchmentView *)tap.view;
            _currentAnimationView = view;
            kWeakSelf
            [[[HDClient sharedClient] leaveMsgManager] downloadFileWithUrl:attachment.url completionHander:^(BOOL success, NSURL *filePath, NSError *error) {
                if (!error) {
                    NSString *toPath = [NSString stringWithFormat:@"%@/%ld.wav",NSTemporaryDirectory(),tap.view.tag];
                    BOOL success = [[HDCDDeviceManager new] convertAMR:[filePath path] toWAV:toPath];
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
- (void)playWithfilePath:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        [fm removeItemAtPath:path error:nil];
    }
    _audioPlayer = [SCAudioPlay sharedInstance];
    _audioPlayer.delegate = self;
    if (_audioPlayer.isPlaying) {
        [_audioPlayer stopSound];
    }
    [_audioPlayer playSoundWithData:data];
}

- (void)AVAudioPlayerBeiginPlay {
    if (_audioPlayer.attatchmentView != nil) {
        [_audioPlayer.attatchmentView stopAnimating];
    }
    _audioPlayer.attatchmentView = _currentAnimationView;;
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

- (void)move
{
    [self hide];
    _recordChangeBtn.originY = _recordChangeBtn.frame.origin.y - _boardHeight;
    _addButton.originY = _addButton.frame.origin.y - _boardHeight;
    [self scrollViewAsTheKeyboardMove];
}

- (void)hide
{
    _recordChangeBtn.center = CGPointMake(kScreenWidth/2 + kScreenWidth/3 + 30, kScreenHeight - 90);
    _addButton.center = CGPointMake(kScreenWidth/2 + kScreenWidth/3 - 10, kScreenHeight - 90);
    [self scrollViewAsTheButtonMove];
}

- (void)restoreButton
{
    _recordChangeBtn.center = CGPointMake(kScreenWidth/2 + kScreenWidth/3 + 30, kScreenHeight - 90);
    _addButton.center = CGPointMake(kScreenWidth/2 + kScreenWidth/3 - 10, kScreenHeight - 90);
    [self scrollViewFrame];
    
}


- (void)scrollViewAsTheButtonMove
{
    [self scrollViewFrame];
}

- (void)scrollViewAsTheKeyboardMove
{
    _attchmentView.originY = _attchmentView.frame.origin.y - _boardHeight;
}

- (void)scrollViewHide
{
    [self scrollViewFrame];
}

- (void)scrollViewFrame
{
    _attchmentView.originX = 0;
    _attchmentView.originY = kScreenHeight - 170;
}


- (void)_stopAudioPlayingWithChangeCategory
{
    //停止音频播放及播放动画
    if (_audioPlayer.isPlaying) {
        [_audioPlayer stopSound];
    }
    if (_audioPlayer.attatchmentView != nil) {
        [_audioPlayer.attatchmentView stopAnimating];
    }
}

@end






