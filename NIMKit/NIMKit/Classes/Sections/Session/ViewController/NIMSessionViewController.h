//
//  NIMSessionViewController.h
//  NIMKit
//
//  Created by NetEase.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>
#import "NIMSessionConfig.h"
#import "NIMMessageCellProtocol.h"
#import "NIMSessionConfigurateProtocol.h"
#import "NIMInputView.h"
#import "NIMAdvanceMenu.h"

@interface NIMSessionViewController : UIViewController<NIMSessionInteractorDelegate,NIMInputActionDelegate,NIMMessageCellDelegate,NIMChatManagerDelegate,NIMConversationManagerDelegate,NIMChatExtendManagerDelegate>

@property (nonatomic, strong)  UITableView *tableView;

@property (nonatomic, strong)  NIMInputView *sessionInputView;


@property (nonatomic, strong)  NIMSession *session;

@property (nonatomic,weak)    id<NIMSessionInteractor> interactor;

- (instancetype)initWithSession:(NIMSession *)session;
- (id<NIMSessionConfig>)sessionConfig;
- (void)sendMessage:(NIMMessage *)message;

#pragma mark - 菜单
- (NIMMessage *)messageForMenu;

#pragma mark - 录音相关接口
- (void)sendAudoMessageWithPath:(NSString *)filePath duration:(NSTimeInterval)duration;
- (void)onRecordFailed:(NSError *)error;
- (BOOL)recordFileCanBeSend:(NSString *)filepath;
- (void)showRecordFileNotSendReason;

#pragma mark - 操作接口
- (void)uiAddMessages:(NSArray *)messages;
- (void)uiInsertMessages:(NSArray *)messages;
- (NIMMessageModel *)uiDeleteMessage:(NIMMessage *)message;
- (void)uiUpdateMessage:(NIMMessage *)message;
- (void)uiPinMessage:(NIMMessage *)message;

#pragma mark - cellHandle
- (BOOL)onTapCell:(NIMKitEvent *)event;
- (void)handleLongPressCell:(NIMMessage *)message
                     inView:(UIView *)view;


- (void)copyText:(id)sender;
- (void)deleteMsg:(id)sender;

@end
