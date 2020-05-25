//
//  NIMUIConfig.m
//  WLIMUIKit
//
//  Created by 敏 on 2020/5/25.
//

#import "NIMUIConfig.h"
#import "NIMGlobalMacro.h"
@implementation NIMUIConfig
+ (CGFloat)topInputViewHeight
{
    return 90 * NIMKit_ScaleX;
}

+ (CGFloat)inputTextViewHeight
{
    return 33 * NIMKit_ScaleX;
}


+ (CGFloat)bottomInputViewHeight
{
    return 216.0;
    //return 245 * NIMKit_ScaleX;
}

+ (NSInteger)messageLimit
{
    return 20;
}

+ (NSTimeInterval)messageTimeInterval
{
    return 5 * 60.0;
}
@end
