//
//  LeaseMsgReplyController.m
//  CustomerSystem-ios
//
//  Created by EaseMob on 16/7/25.
//  Copyright © 2016年 easemob. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "LeaseMsgReplyController.h"

#import "XHMessageTextView.h"
#import "LeaveMsgAttatchmentView.h"
#import "LeaveMsgDetailModel.h"
#import "EMHttpManager.h"
#import "EMIMHelper.h"
#import "MessageReadManager.h"
#import "MBProgressHUD+Add.h"
#import "UIViewController+DismissKeyboard.h"

#define kDefaultLeft 20

@interface LeaseMsgReplyController () <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, LeaveMsgAttatchmentViewDelegate>

@property (nonatomic, strong) XHMessageTextView *textView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) UIScrollView *attchmentView;
@property (nonatomic, strong) NSMutableArray *attachments;

@end

@implementation LeaseMsgReplyController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    self.title = NSLocalizedString(@"title.reply", @"Reply");
    self.view.backgroundColor = RGBACOLOR(238, 238, 245, 1);
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.attchmentView];
    [self setupBarButtonItem];
    
    [self setupForDismissKeyboard];
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

- (XHMessageTextView*)textView
{
    if (_textView == nil) {
        _textView = [[XHMessageTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 124.f)];
        [_textView setPlaceHolder:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"title.reply", @"Reply"),@"..."]];
        _textView.delegate = self;
        
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
        _addButton.frame = CGRectMake(20.f, CGRectGetMaxY(_textView.frame) + 10.f, 98.f, 28.f);
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
        _attchmentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_addButton.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(_addButton.frame) - 64.f)];
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
        MBProgressHUD *hud = [MBProgressHUD showMessag:NSLocalizedString(@"leaveMessage.leavemsg.uploadattachment", "Upload attachment") toView:self.view];
        hud.layer.zPosition = 1.f;
        __weak MBProgressHUD *weakHud = hud;
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            NSString *fileName = [representation filename];
            
            NSData *data = UIImagePNGRepresentation(orgImage);
            
            [[EMHttpManager sharedInstance] uploadWithTenantId:[EMIMHelper defaultHelper].tenantId File:data parameters:@{@"fileName":fileName} completion:^(id responseObject, NSError *error) {
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
                    [weakHud setLabelText:NSLocalizedString(@"leaveMessage.leavemsg.uploadattachment.failed", "Upload attachment failed")];
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
    if ([_attachments count] > index) {
        [_attachments removeObjectAtIndex:index];
        [self _reloadAttatchmentsView];
    }
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
        [attatchmentView addGestureRecognizer:tap];
        attatchmentView.delegate = self;
        attatchmentView.tag = index;
        [_attchmentView addSubview:attatchmentView];
        index ++;
        left += [LeaveMsgAttatchmentView widthForName:attachment.name maxWidth:kScreenWidth - kDefaultLeft - 10] + kDefaultLeft + 10;
    }
    [_attchmentView setContentSize:CGSizeMake(kScreenWidth, height + 30.f)];
}

#pragma mark - action

- (void)tapAttatchmentAction:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    NSInteger index = tap.view.tag;
    if ([_attachments count] > index) {
        LeaveMsgAttachmentModel *attachment = [_attachments objectAtIndex:index];
        if ([attachment.type isEqualToString:@"image"]) {
            [[MessageReadManager defaultManager] showBrowserWithImages:@[[NSURL URLWithString:attachment.url]]];
        }
    }
}
 

@end
