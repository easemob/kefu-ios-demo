//
//  HDAnswerView.h
//  HLtest
//
//  Created by houli on 2022/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickOnBlock)(UIButton *btn);
typedef void(^ClickOffBlock)(UIButton *btn);
@interface HDAnswerView : UIView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *onBtn;
@property (nonatomic, strong) UIButton *offBtn;
@property (nonatomic, copy) ClickOnBlock clickOnBlock;
@property (nonatomic, copy) ClickOffBlock clickOffBlock;


@end

NS_ASSUME_NONNULL_END
