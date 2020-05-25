//
//  NIMUIConfig.h
//  WLIMUIKit
//
//  Created by 敏 on 2020/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NIMUIConfig : NSObject
//输入框上部高度
+ (CGFloat)topInputViewHeight;
//输入框高度
+ (CGFloat)inputTextViewHeight;
//输入框下部高度(内容区域)
+ (CGFloat)bottomInputViewHeight;
//默认消息条数
+ (NSInteger)messageLimit;

//会话列表中时间打点间隔
+ (NSTimeInterval)messageTimeInterval;
@end

NS_ASSUME_NONNULL_END
