//
//  HDTestViewController.m
//  CustomerSystem-ios
//
//  Created by houli on 2022/6/8.
//  Copyright © 2022 easemob. All rights reserved.
//

#import "HDTestViewController.h"
#import "MBProgressHUD+Add.h"
@interface HDTestViewController ()
{
    
    NSString * _uuid;
    
}
@property (weak, nonatomic) IBOutlet UITextView *welcomeTextView;
@property (weak, nonatomic) IBOutlet UITextView *skillTextView;
@property (weak, nonatomic) IBOutlet UITextField *lanTextField;

@end

@implementation HDTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.lanTextField.text = @"en";
    
}
- (IBAction)save:(id)sender {
    
    
    
    if (self.lanTextField.text.length >0) {
       
        // 随机生成 uuid
        
        _uuid = [self getUUID];
        
        NSLog(@"==getUUID==%@",_uuid);
        MBProgressHUD *hud = [MBProgressHUD showMessag:NSLocalizedString(@"设置中", "Upload attachment") toView:self.view];
        hud.layer.zPosition = 1.f;
        __weak MBProgressHUD *weakHud = hud;
        // 设置初始接口
        [[HDClient sharedClient] hd_SetVisitorLanguage:self.lanTextField.text withVisitorUserName:_uuid completion:^(id responseObject, HDError *aError) {
            
            [weakHud hideAnimated:YES];
            if (!aError) {
                [MBProgressHUD dismissInfo:@"设置成功"];
            }else{
                [MBProgressHUD dismissInfo:@"设置失败"];
            }
            
           
            NSLog(@"=======%@",responseObject);
        }];
        
    }else{
        
        [MBProgressHUD dismissInfo:@"设置语种不能为空"];
        
    }
    
  
    
    
}
- (IBAction)welcomeAction:(id)sender {
    
    kWeakSelf
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:NSLocalizedString(@"获取中", "Upload attachment") toView:self.view];
    hud.layer.zPosition = 1.f;
    __weak MBProgressHUD *weakHud = hud;
    
    [[HDClient sharedClient].chatManager getEnterpriseWelcomeWithVisitorUserName:_uuid WithCompletion:^(NSString *welcome, HDError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [weakHud hideAnimated:YES];
        if (!error) {
                
            weakSelf.welcomeTextView.text = welcome;
            
        }else{
            
            weakSelf.welcomeTextView.text = error.errorDescription;
        }
        
        
        });
       
        NSLog(@"=======%@",welcome);
        
    }];
}
- (IBAction)skillAction:(id)sender {
    
    kWeakSelf
    MBProgressHUD *hud = [MBProgressHUD showMessag:NSLocalizedString(@"获取中", "Upload attachment") toView:self.view];
    hud.layer.zPosition = 1.f;
    __weak MBProgressHUD *weakHud = hud;
    [[HDClient sharedClient].chatManager getSkillGroupMenuWithVisitorUserName:_uuid Completion:^(NSDictionary *info, HDError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakHud hideAnimated:YES];
        if (!error) {
            
            NSArray * array = [info objectForKey:@"entities"];
            
            if (array.count > 0) {
                
                weakSelf.skillTextView.text =  [weakSelf jsonStringFromDictionary:[array firstObject]];
            }
            

        }else{

    
            weakSelf.skillTextView.text = error.errorDescription;
    
        }
        });
        NSLog(@"=======%@",info);
    
    }];
}
- (NSString *)jsonStringFromDictionary:(NSDictionary *)aDict {
    if (!aDict || aDict.allKeys.count == 0) {
        return @"";
    }
    NSString *ret = @"";
    for (NSString *key in aDict.allKeys) {
        ret = [ret stringByAppendingString:key];
        ret = [ret stringByAppendingString:@"="];
        if ([aDict[key] isKindOfClass:[NSString class]]) {
            ret = [ret stringByAppendingString:aDict[key]];
        }
        ret = [ret stringByAppendingString:@"&"];
    }
    
    ret = [ret substringWithRange:NSMakeRange(0, [ret length] - 1)];
    
    return ret;
}


/**  卸载应用重新安装后会不一致*/
- (NSString *)getUUID{
    return [UIDevice currentDevice].identifierForVendor.UUIDString;;
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
