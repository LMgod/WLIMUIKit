//
//  NIMKitDependency.h
//  NIMKit
//
//  Created by chris on 2017/5/3.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#ifndef NIMKitDependency_h
#define NIMKitDependency_h


#if __has_include(<M80AttributedLabel/M80AttributedLabel.h>)
#import <M80AttributedLabel/M80AttributedLabel.h>
#else
#import "M80AttributedLabel.h"
#endif

#if __has_include(<YYWebImage/YYWebImage.h>)
#import <YYWebImage/YYWebImage.h>
#elif __has_include("YYWebImage.h")
#import "YYWebImage.h"
#else
@import YYWebImage;
#endif





#if __has_include(<Toast/Toast.h>)
#import <Toast/Toast.h>
#elif __has_include("UIView+Toast.h")
#import "Toast/UIView+Toast.h"
#else
@import Toast;
#endif

#if __has_include(<HXPhotoPicker/HXPhotoPicker.h>)
#import <HXPhotoPicker/HXPhotoPicker.h>
#elif __has_include("HXPhotoPicker.h")
#import "HXPhotoPicker.h"
#else
@import HXPhotoPicker;
#endif


#endif /* NIMKitDependency_h */

