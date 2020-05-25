//
//  WLInputToolBar.h
//  WLIMUIKit
//
//  Created by 敏 on 2020/5/24.
//

#import <UIKit/UIKit.h>
#import "NIMGrowingTextView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol WLInputToolBarDelegate <NSObject>

@optional

- (BOOL)textViewShouldBeginEditing;

- (void)textViewDidEndEditing;

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText;

- (void)textViewDidChange;

- (void)toolBarWillChangeHeight:(CGFloat)height;

- (void)toolBarDidChangeHeight:(CGFloat)height;

@end

@interface WLInputToolBar : UIView

@property (nonatomic, strong) NIMGrowingTextView *inputTextView;
@property (nonatomic, weak) id<WLInputToolBarDelegate>delegate;

@property (nonatomic,assign) BOOL showsKeyboard;
@property (nonatomic,copy) NSString *contentText;
@end


@interface WLInputToolBar(InputText)

- (NSRange)selectedRange;

- (void)setPlaceHolder:(NSString *)placeHolder;

- (void)insertText:(NSString *)text;

- (void)deleteText:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
