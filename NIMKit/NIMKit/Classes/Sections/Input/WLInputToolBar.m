//
//  WLInputToolBar.m
//  WLIMUIKit
//
//  Created by 敏 on 2020/5/24.
//

#import "WLInputToolBar.h"
#import <Masonry/Masonry.h>
#import "NIMGlobalMacro.h"

@interface WLInputToolBar ()


@property (nonatomic, strong) NSMutableArray<UIButton *> *itemsArray;
@end

@implementation WLInputToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    NSArray *imageArr = [self imageNameArray];
    [imageArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *normalName = [NSString stringWithFormat:@"%@nor",obj];
        NSString *selectName = [NSString stringWithFormat:@"%@sel",obj];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1200 + idx;
        [btn setImage:[UIImage imageNamed:normalName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectName] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemsArray addObject:btn];
        [self addSubview:btn];
        
        CGFloat btnWidth = 52 * NIMKit_ScaleX;
        CGFloat itemWith = NIMKit_UIScreenWidth/imageArr.count;
        CGFloat leftMagin = (itemWith - btnWidth)/2;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(btnWidth);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.mas_offset(0);
            }
            make.leading.mas_offset(leftMagin + itemWith * idx);
        }];
        
    }];
    
}

- (void)itemClick:(UIButton *)sender{
    NSInteger index = sender.tag - 1200;
    
    
}

#pragma mark - setter、getter

- (NSArray<NSString *> *)imageNameArray{
    return @[@"WL_inputBar_emj_",
             @"WL_inputBar_voice_",
             @"WL_inputBar_gift_",
             @"WL_inputBar_truth_",
             @"WL_inputBar_more_" ];
}

- (NSMutableArray *)itemsArray {
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}
@end
