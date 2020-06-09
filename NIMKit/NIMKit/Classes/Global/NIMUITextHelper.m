//
//  NIMUITextHelper.m
//  WLIMUIKit
//
//  Created by 敏 on 2020/5/26.
//

#import "NIMUITextHelper.h"


@interface NIMUITextHelper ()

@property (nonatomic, copy, class) NSDictionary *languageDict;


@end

static NSDictionary *languageDict_t;
static NSString *languageCode_t;

@implementation NIMUITextHelper

+ (NSDictionary *)languageDict{
    return languageDict_t;
}

+ (void)setLanguageDict:(NSDictionary *)languageDict{
    languageDict_t = languageDict;
}

+ (NSString *)languageCode{
    return languageCode_t;
}

+ (void)setLanguageCode:(NSString *)languageCode{
    languageCode_t = languageCode;
}

/**
 想和Ta说点什么？
*/
+ (NSString *)UITextPlaceHolderIMInput{
    return @"想和Ta说点什么？";
}

/**
   拍照
 */
+ (NSString *)UITextFeedPublicFeedWayCamera {
    return @"拍照";
}

/**
   照片
 */
+ (NSString *)UITextFeedPublicFeedWayAlbum {
    return @"照片";
}

/**
 按住说话
 */
+ (NSString *)UITextMsgInputVoiceContainerAlert {
    return @"按住说话";
}

/**
 说话时间太短!!!
 */
+ (NSString *)UITextMsgSessionAudioRecordTimeShort {
    return @"说话时间太短!!!";
}

/**
 星期一
*/
+ (NSString *)UITextWithTimeAlertMonday {
    return @"星期一";
}
/**
 星期二
*/
+ (NSString *)UITextWithTimeAlertTuesday {
    return @"星期二";
}
/**
 星期三
*/
+ (NSString *)UITextWithTimeAlertWednesday {
    return @"星期三";
}
/**
 星期四
*/
+ (NSString *)UITextWithTimeAlertThursday {
    return @"星期四";
}
/**
 星期五
*/
+ (NSString *)UITextWithTimeAlertThursday {
    return @"星期五";
}
/**
 星期六
*/
+ (NSString *)UITextWithTimeAlertSaturday {
    return @"星期六";
}
/**
 星期日
*/
+ (NSString *)UITextWithTimeAlertSunday {
    return @"星期日";
}

/**
 昨天
*/
+ (NSString *)UITextWithTimeAlertYesterday {
    return @"昨天";
}
/**
 前天
*/
+ (NSString *)UITextWithTimeAlertBeforeYesterday {
    return @"前天";
}

+ (NSString *)localizableStringWithKey:(NSString *)key{
    if (!self.languageDict) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        
        NSString *filepath = [bundle pathForResource:@"NIMCustomLanguage" ofType:@"plist"];
        if (filepath) {
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filepath];
            self.languageDict = dic;
        }
    }
    NSString *currentLanguage = self.languageCode;
    if (currentLanguage) {
        return self.languageDict[key][currentLanguage];
    }
    return @"";
  
}



@end
