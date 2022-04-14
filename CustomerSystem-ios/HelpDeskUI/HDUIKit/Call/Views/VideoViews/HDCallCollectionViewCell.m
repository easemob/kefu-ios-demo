//
//  HDCallCollectionViewCell.m
//  HLtest
//
//  Created by houli on 2022/3/7.
//

#import "HDCallCollectionViewCell.h"
#import "Masonry.h"

@interface HDCallCollectionViewCell ()
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIButton *muteBtn;

@property (nonatomic, strong) UIImageView *bgImgView;
@end
@implementation HDCallCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.callView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        [self addSubview:self.callView];
        
        [self addSubview: self.muteBtn];
        [self addSubview: self.nickNameLabel];
      
        //添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNoti:)
                                                     name:@"SelectedNotification"
                                                   object:nil];
        //添加 笑脸图片
        [self.callView addSubview:self.bgImgView];
        [self bringSubviewToFront:self.bgImgView];
        
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
               make.centerY.mas_equalTo(self.callView);
               make.centerX.mas_equalTo(self.callView);
               make.width.height.offset(22);
               
           }];
        [self.bgImgView layoutIfNeeded];
           UIImage * img = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:_bgImgView.size.width color:[[HDAppSkin mainSkin] contentColorGray1] ];
           _bgImgView.image = img;
        
    }
    return self;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.offset(-5);
        make.leading.offset(10);
        make.trailing.offset(-10);
        make.height.offset(20);
        
    }];
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.offset(0);
        make.leading.offset(0);
        make.height.offset(32);
        make.width.offset(32);
        
    }];
//    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.centerY.mas_equalTo(self.callView);
////        make.centerX.mas_equalTo(self.callView);
////        make.width.height.offset(22);
//        make.top.offset(0);
//        make.leading.offset(0);
//        make.height.offset(32);
//        make.width.offset(32);
//    }];
//    UIImage * img = [UIImage imageWithIcon:kXiaolian inFont:kfontName size:_bgImgView.size.width color:[[HDAppSkin mainSkin] contentColorGray1] ];
//    _bgImgView.image = img;
}
- (void)setAudioMuted:(BOOL)muted{
    
    
    self.muteBtn.selected = muted;
    
}

//每一组的偏移量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 50, 0, 0);
}
- (void)setItem:(HDCallCollectionViewCellItem *)item {
    _item = item;
   
//    for(UIView *review in [self.callView subviews])
//    {
//        [review removeFromSuperview];
//     }
    UIView *view =item.camView;
    [self.callView addSubview:view ];
    [self.callView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.bottom.offset(0);
        
    }];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.bottom.offset(0);
        
    }];
    if (_item.isSelected) {
        [self selected];
    }else {
        [self unSelected];
    }
    
    //小窗更新远端麦克风状态
    [self switchMuteBtnState:item.isMute];
    
    self.nickNameLabel.text =  _item.nickName;
}
- (UIImageView *)bgImgView{
    
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc]init];
//        _bgImgView.backgroundColor = [UIColor yellowColor];

    }
    return _bgImgView;
    
}

- (UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.backgroundColor = [UIColor lightGrayColor];
        _nickNameLabel.textAlignment=NSTextAlignmentCenter;
        _nickNameLabel.numberOfLines = 0;
        _nickNameLabel.layer.cornerRadius = 10;
        _nickNameLabel.layer.masksToBounds = YES;
        _nickNameLabel.alpha = 0.8;
        _nickNameLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _nickNameLabel;
}
- (UIButton *)muteBtn{
    if (!_muteBtn) {
        _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_muteBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        //为button赋值
//        _muteBtn.selected = YES;
        UIImage *img  = [UIImage imageWithIcon:kmaikefeng5 inFont:kfontName size:22 color:[UIColor colorWithRed:12.0/255.0 green:110.0/255.0 blue:254.0/255.0 alpha:1.000] ] ;
        [self.muteBtn setImage:img forState:UIControlStateNormal];
        UIImage *imgSel  = [UIImage imageWithIcon:kjinmai2 inFont:kfontName size:22 color:[UIColor colorWithRed:206.0/255.0 green:55.0/255.0 blue:56.0/255.0 alpha:1.000] ] ;
        [_muteBtn setImage:imgSel forState:UIControlStateSelected];
    }
    return _muteBtn;
}

- (void)switchMuteBtnState:(BOOL)muted{
    _muteBtn.selected = muted;
}

- (void)selected {

    // 发送被选中通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedNotification"
//                                                        object:nil
//                                                      userInfo:@{@"item_uid":self.item.uid}];
    _item.isSelected = YES;
}

// 接收被选中通知，如果被选中的不是self，则将self设置为未选中状态
- (void)receiveNoti:(NSNotification *)noti {
//
//    if (self.item.uid) {
//    NSString *uid = noti.userInfo[@"item_uid"];
//    if (![uid isEqualToString:self.item.uid]) {
//        [self unSelected];
//    }
//    _item.isSelected = NO;
//    }else{
//        NSString *uid = noti.userInfo[@"item_uid"];
//        if ( [uid isEqualToString: self.item.uid]) {
//            [self unSelected];
//        }
//        _item.isSelected = NO;
//
//
//    }
}
- (void)buttonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
- (void)unSelected {
//    self.avatarImageView.layer.borderWidth = 0;
}


@end

