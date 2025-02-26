//
//  IMMsgModel.m
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import "IMMsgModel.h"
#import "NSString+IM.h"
#import "IMCellDataHelper.h"
#import "IMSatisfyMenuModel.h"
#import "IMDisLikeModel.h"
#import <fmdb/FMDB.h>
#import "FMResultSet.h"

@implementation IMMsgModel

- (id)init {
    self = [super init];
    if (self) {
        _msgId = @"";
        _msgType = IMMsgContentType_none;
        _createType = IMMsgCreateType_none;
        _mainInfo = @"";
        _sessionState = @"";
        _createTime = @"";
        _jumpMenu = @"";
        _needBtn = @"";
        _nickName = @"";
        _agentPicture = @"";
        _answerSource = @"";
        _messageId = @"";
        _isShowTime = YES;
        _cellHeight = 40;
        _isSubmit = NO;
        _extend = @"";
        _menuList = [[NSMutableArray alloc] init];
        _dislikeList = [[NSMutableArray alloc] init];
        _isHTML = NO;
        _isHtmlReload = NO;
        _isMsgSend = YES;
        _needHelpful = NO;
        _showHelpful = NO;
        // 正在输入状态
        _status = @"";
        _isSeen = NO;
    }
    return self;
}

- (id)initWithMsgDic:(NSDictionary *)msgDic {
    self = [super init];
    if (self) {
        
        NSString *severMsgId = [NSString imStringWithoutNil:[msgDic objectForKey:@"msgId"]];
        self.msgId = [NSString isIMBlankString:severMsgId]?[NSString getLocalMsgId]:severMsgId;

        self.createType = IMMsgCreateType_server;
        
        self.mainInfo = [NSString imStringWithoutNil:[msgDic objectForKey:@"mainInfo"] ];
        
        self.sessionState = [NSString imStringWithoutNil:[msgDic objectForKey:@"sessionState"]];
        
//        self.createTime = [NSString imStringWithoutNil:[msgDic objectForKey:@"createTime"]];
        self.createTime = [NSString getCurrentTimestamp];//因为发送文本/图片用的是本地时间，所以收消息暂且也有本地时间
      
        self.jumpMenu = [NSString imStringWithoutNil:[msgDic objectForKey:@"jumpMenu"]];
      
        self.needBtn = [NSString imStringWithoutNil:[msgDic objectForKey:@"needBtn"]];
      
        self.nickName = [NSString imStringWithoutNil:[msgDic objectForKey:@"nickName"]];
        
        self.agentPicture = [NSString imStringWithoutNil:[msgDic objectForKey:@"agentPicture"]];
      
        self.answerSource = [NSString imStringWithoutNil:[msgDic objectForKey:@"answerSource"]];
      
        self.messageId = [NSString imStringWithoutNil:[msgDic objectForKey:@"messageId"]];
        
        self.isShowTime = [IMCellDataHelper getMsgTimeIsShow:self.createTime];
        
        self.cellHeight = kCellMinHeight;
        
        self.isSubmit = NO;
        
        self.extend = @"";
        
        self.isHTML = [IMCellDataHelper getMainInfoIsHtml:self.mainInfo];
        
        self.isHtmlReload = NO;
        
        self.isMsgSend = YES;
        
        self.needHelpful = NO;
        
        self.showHelpful = NO;
        
        self.isSeen = NO;
        
        // 正在输入状态
        if (isEmptyString_IM([msgDic objectForKey:@"status"])) {
            self.status = @"";
        } else {
            self.status = [NSString stringWithFormat:@"%@",[msgDic objectForKey:@"status"]];
        }
        
        NSInteger msgType = [[NSString imStringWithoutNil:[msgDic objectForKey:@"msgType"]] integerValue];
        if (msgType == 1 || msgType == 98) {
            self.msgType = IMMsgContentType_text;
        } else if (msgType == 2) {
            self.msgType = IMMsgContentType_image;
        } else if (msgType == 3) {
            self.msgType = IMMsgContentType_voice;
        } else if (msgType == 4) {
            self.msgType = IMMsgContentType_video;
        } else if (msgType == 5) {
            self.msgType = IMMsgContentType_file;
        } else if (msgType == 6) {
            self.msgType = IMMsgContentType_linkList;
        } else if (msgType == 61) {
            self.msgType = IMMsgContentType_menuList;
        } else if (msgType == 71) {
          self.msgType = IMMsgContentType_commonQuestion;
        } else if (msgType == 72) {
          self.msgType = IMMsgContentType_disLike;
        } else if (msgType == 73) {
          self.msgType = IMMsgContentType_quickQuesttion;
        } else if (msgType == 90) {
            self.msgType = IMMsgContentType_userInfo;
        } else if (msgType == 96) {
            self.msgType = IMMsgContentType_typing;
        } else if (msgType == 97) {
            self.msgType = IMMsgContentType_seen;
        } else if (msgType == 80) {
            self.msgType = IMMsgContentType_VOIP;
        } else if (msgType == 301) {
            self.msgType = IMMsgContentType_flowNoExpired;
        }
        else {
            self.msgType = IMMsgContentType_none;
            if ([NSString isIMBlankString:self.mainInfo]) {
                self.mainInfo = @"This message is not recognized";
            }
        }
        
        if (self.msgType == IMMsgContentType_seen && [self.status isEqualToString:@"B"]) {
            // 已读
            self.msgIdList = IsArrEmpty_IM([msgDic objectForKey:@"msgIdList"]) ? @[] : [msgDic objectForKey:@"msgIdList"];
            
        } else if (self.msgType == IMMsgContentType_linkList && [self.sessionState isEqualToString:@"Q"]) {
            
        } else if (self.msgType == IMMsgContentType_linkList && ![self.sessionState isEqualToString:@"C"]) {
            self.satisfyMainInfoModel = [[IMSatisfyMainInfoModel alloc] initWithDic:[self.mainInfo JSONValue]];
        } else if (self.msgType == IMMsgContentType_menuList) {
            self.menuList = [[NSMutableArray alloc] init];
            NSDictionary *mainInfoDic = [self.mainInfo JSONValue];
            NSArray *menuList = [mainInfoDic objectForKey:@"menuList"];
            for (NSDictionary *dic in menuList) {
                IMSatisfyMainInfoModel *infoModel = [[IMSatisfyMainInfoModel alloc] initWithDic:dic];
                [self.menuList addObject:infoModel];
            }
        } else if (self.msgType == IMMsgContentType_disLike) {
            self.dislikeList = [[NSMutableArray alloc] init];
            NSDictionary *mainInfoDic = [self.mainInfo JSONValue];
            NSArray *reasonList = [mainInfoDic objectForKey:@"reasonList"];
            for (NSDictionary *dic in reasonList) {
                IMDisLikeModel *disLikeModel = [[IMDisLikeModel alloc] initWithDic:dic];
                [self.dislikeList addObject:disLikeModel];
            }
        } else if (self.msgType == IMMsgContentType_text && [self.sessionState isEqualToString:@"C"] && [self.needBtn isEqualToString:@"Y"]) {
            self.mainInfo = [NSString stringWithFormat:@"%@ confirm", self.mainInfo];
        }
    }
    return self;
}

- (id)initText {
    self = [super init];
    if (self) {
        
        self.msgId = [NSString getLocalMsgId];

        self.createType = IMMsgCreateType_user;
        
        self.mainInfo = @"";
        
        self.sessionState = @"";
        
        self.createTime = [NSString getCurrentTimestamp];
      
        self.jumpMenu = @"";
      
        self.needBtn = @"";
      
        self.nickName = @"";
        
        self.agentPicture = @"";
      
        self.answerSource = @"";
      
        self.messageId = @"";
        
        self.isShowTime = [IMCellDataHelper getMsgTimeIsShow:self.createTime];
        
        self.cellHeight = kCellMinHeight;
        
        self.isSubmit = NO;
        
        self.extend = @"";
        
        self.isHTML = NO;
        
        self.isHtmlReload = NO;
        
        self.isMsgSend = YES;
        
        self.needHelpful = NO;
        
        self.showHelpful = NO;
        
        self.isSeen = NO;
        
        self.msgSeenId = @"";
        
        self.msgType = IMMsgContentType_text;
    }
    return self;
}

- (id)initImage {
    self = [super init];
    if (self) {
        
        self.msgId = [NSString getLocalMsgId];

        self.createType = IMMsgCreateType_user;
        
        self.mainInfo = @"";
        
        self.sessionState = @"";
        
        self.createTime = [NSString getCurrentTimestamp];
      
        self.jumpMenu = @"";
      
        self.needBtn = @"";
      
        self.nickName = @"";
      
        self.agentPicture = @"";
      
        self.answerSource = @"";
      
        self.messageId = @"";
        
        self.isShowTime = [IMCellDataHelper getMsgTimeIsShow:self.createTime];
        
        self.cellHeight = kCellMinHeight;
        
        self.isSubmit = NO;
        
        self.extend = @"";
        
        self.isHTML = NO;
        
        self.isHtmlReload = NO;
        
        self.isMsgSend = YES;
        
        self.needHelpful = NO;
        
        self.showHelpful = NO;
        
        self.isSeen = NO;
        
        self.msgType = IMMsgContentType_image;
    }
    return self;
}

- (id)initWithResultSet:(FMResultSet *)rs {
    self = [super init];
    if (self) {
        self.msgId = [rs stringForColumn:@"msgId"];
        self.msgType = [[rs stringForColumn:@"msgType"] integerValue];
        self.createType = [[rs stringForColumn:@"createType"] integerValue];
        self.mainInfo = [rs stringForColumn:@"mainInfo"];
        self.sessionState = [rs stringForColumn:@"sessionState"];
        self.createTime = [rs stringForColumn:@"createTime"];
        self.jumpMenu = [rs stringForColumn:@"jumpMenu"];
        self.needBtn = [rs stringForColumn:@"needBtn"];
        self.nickName = [rs stringForColumn:@"nickName"];
        self.agentPicture = [rs stringForColumn:@"agentPicture"];
        self.answerSource = [rs stringForColumn:@"answerSource"];
        self.messageId = [rs stringForColumn:@"messageId"];
        self.isShowTime = [[rs stringForColumn:@"isShowTime"] boolValue];
        self.cellHeight = [[rs stringForColumn:@"cellHeight"] integerValue];
        self.isSubmit = [[rs stringForColumn:@"isSubmit"] boolValue];
        self.extend = [rs stringForColumn:@"extend"];
        self.isHTML = [[rs stringForColumn:@"isHTML"] boolValue];
        self.isHtmlReload = [[rs stringForColumn:@"isHtmlReload"] boolValue];
        self.isMsgSend = [[rs stringForColumn:@"isMsgSend"] boolValue];
        self.needHelpful = [[rs stringForColumn:@"needHelpful"] boolValue];
        self.showHelpful = [[rs stringForColumn:@"showHelpful"] boolValue];
        self.isSeen =  [[rs stringForColumn:@"seen"] boolValue];
        
        if (self.msgType == IMMsgContentType_linkList && [self.sessionState isEqualToString:@"Q"]) {
            
        } else if (self.msgType == IMMsgContentType_linkList && ![self.sessionState isEqualToString:@"C"]) {
            self.satisfyMainInfoModel = [[IMSatisfyMainInfoModel alloc] initWithDic:[self.mainInfo JSONValue]];
        } else if (self.msgType == IMMsgContentType_menuList) {
            if (self.isSubmit) {
                NSDictionary *mainInfoDic = [self.mainInfo JSONValue];
                NSArray *menuList = [[mainInfoDic objectForKey:@"menuList"] JSONValue];
                for (NSDictionary *dic in menuList) {
                    IMSatisfyMainInfoModel *infoModel = [[IMSatisfyMainInfoModel alloc] initWithDic:dic];
                    [self.menuList addObject:infoModel];
                }
            } else {
                NSDictionary *mainInfoDic = [self.mainInfo JSONValue];
                NSArray *menuList = [mainInfoDic objectForKey:@"menuList"];
                for (NSDictionary *dic in menuList) {
                    IMSatisfyMainInfoModel *infoModel = [[IMSatisfyMainInfoModel alloc] initWithDic:dic];
                    [self.menuList addObject:infoModel];
                }
            }
        } else if (self.msgType == IMMsgContentType_disLike) {
            self.dislikeList = [[NSMutableArray alloc] init];
            NSDictionary *mainInfoDic = [self.mainInfo JSONValue];
            NSArray *reasonList = [mainInfoDic objectForKey:@"reasonList"];
            for (NSDictionary *dic in reasonList) {
                IMDisLikeModel *disLikeModel = [[IMDisLikeModel alloc] initWithDic:dic];
                [self.dislikeList addObject:disLikeModel];
            }
        }
    }
    return self;
}


- (id)copyWithZone:(NSZone *)zone {
    IMMsgModel *msgModel = [[[self class] allocWithZone:zone] init];
    msgModel.msgId = self.msgId;
    msgModel.msgType = self.msgType;
    msgModel.createType = self.createType;
    msgModel.mainInfo = self.mainInfo;
    msgModel.sessionState = self.sessionState;
    msgModel.createTime = self.createTime;
    msgModel.jumpMenu = self.jumpMenu;
    msgModel.needBtn = self.needBtn;
    msgModel.agentPicture = self.agentPicture;
    msgModel.nickName = self.nickName;
    msgModel.answerSource = self.answerSource;
    msgModel.messageId = self.messageId;
    msgModel.isShowTime = self.isShowTime;
    msgModel.cellHeight = self.cellHeight;
    msgModel.isSubmit = self.isSubmit;
    msgModel.extend = self.extend;
    msgModel.isHTML = self.isHTML;
    msgModel.isHtmlReload = self.isHtmlReload;
    msgModel.isMsgSend = self.isMsgSend;
    msgModel.menuList = self.menuList;
    msgModel.needHelpful = self.needHelpful;
    msgModel.showHelpful = self.showHelpful;
    msgModel.status = self.status; // 是否正在输入
    msgModel.isSeen = self.isSeen;
    
    if (msgModel.msgType == IMMsgContentType_disLike) {
        msgModel.dislikeList = [[NSMutableArray alloc] init];
        for (IMDisLikeModel *model in self.dislikeList) {
            IMDisLikeModel *disLikeModel = [model copy];
            [msgModel.dislikeList addObject:disLikeModel];
        }
    }
    return msgModel;
}

- (id)initUserInfo {
    self = [super init];
    if (self) {
        
        self.msgId = [NSString getLocalMsgId];

        self.createType = IMMsgCreateType_server;
        
        self.mainInfo = @"";
        
        self.sessionState = @"";
        
        self.createTime = [NSString getCurrentTimestamp];
      
        self.jumpMenu = @"";
      
        self.needBtn = @"";
      
        self.nickName = @"";
        
        self.agentPicture = @"";
      
        self.answerSource = @"";
      
        self.messageId = @"";
        
        self.isShowTime = [IMCellDataHelper getMsgTimeIsShow:self.createTime];
        
        self.cellHeight = kCellMinHeight;
        
        self.isSubmit = NO;
        
        self.extend = @"";
        
        self.isHTML = NO;
        
        self.isHtmlReload = NO;
        
        self.isMsgSend = YES;
        
        self.needHelpful = NO;
        
        self.showHelpful = NO;
        
        self.isSeen = NO;
        
        self.msgType = IMMsgContentType_userInfo;
    }
    return self;
}

@end
