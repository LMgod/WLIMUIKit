//
//  NIMUITextHelper.m
//  WLIMUIKit
//
//  Created by 敏 on 2020/5/26.
//

#import "NIMUITextHelper.h"
#import "NSString+NIMKit.h"



@implementation NIMUITextHelper

/**
 想和Ta说点什么？
*/
+ (NSString *)UITextPlaceHolderIMInput{
    return [self localizableStringWithKey:@"想和Ta说点什么？"];
}

/**
   拍照
 */
+ (NSString *)UITextFeedPublicFeedWayCamera {
    return [self localizableStringWithKey:@"拍照"];
}

/**
   照片
 */
+ (NSString *)UITextFeedPublicFeedWayAlbum {
    return [self localizableStringWithKey:@"照片"];
}

/**
 按住说话
 */
+ (NSString *)UITextMsgInputVoiceContainerAlert {
    return [self localizableStringWithKey:@"按住说话"];
}

/**
 说话时间太短!!!
 */
+ (NSString *)UITextMsgSessionAudioRecordTimeShort {
    return [self localizableStringWithKey:@"说话时间太短!!!"];
}

/**
 星期一
*/
+ (NSString *)UITextWithTimeAlertMonday {
    return [self localizableStringWithKey:@"星期一"];
}
/**
 星期二
*/
+ (NSString *)UITextWithTimeAlertTuesday {
    return [self localizableStringWithKey:@"星期二"];
}
/**
 星期三
*/
+ (NSString *)UITextWithTimeAlertWednesday {
    return [self localizableStringWithKey:@"星期三"];
}
/**
 星期四
*/
+ (NSString *)UITextWithTimeAlertThursday {
    return [self localizableStringWithKey:@"星期四"];
}
/**
 星期五
*/
+ (NSString *)UITextWithTimeAlertFriday {
    return [self localizableStringWithKey:@"星期五"];
}
/**
 星期六
*/
+ (NSString *)UITextWithTimeAlertSaturday {
    return [self localizableStringWithKey:@"星期六"];
}
/**
 星期日
*/
+ (NSString *)UITextWithTimeAlertSunday {
    return [self localizableStringWithKey:@"星期日"];
}

/**
 昨天
*/
+ (NSString *)UITextWithTimeAlertYesterday {
    return [self localizableStringWithKey:@"昨天"];
}
/**
 前天
*/
+ (NSString *)UITextWithTimeAlertBeforeYesterday {
    return [self localizableStringWithKey:@"前天"];
}

+ (NSString *)localizableStringWithKey:(NSString *)key{
    return key.nim_localized;
  
}



@end
