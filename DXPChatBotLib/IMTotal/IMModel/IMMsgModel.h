//
//  IMMsgModel.h
//  IMDemo
//
//  Created by mac on 2020/6/9.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCCHeader.h"
#import "IMSatisfyMainInfoModel.h"
#import <FMDB/FMResultSet.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMMsgModel : NSObject <NSCopying>

/*----------------------------------------------
 *  DB 建表所用的字段 Fields used to create tables
 ----------------------------------------------*/

/* 唯一标识 Unique identification */
@property (nonatomic, strong) NSString *msgId;

/* 消息类型 Message type */
@property (nonatomic, assign) IMMsgContentType msgType;

/* 消息创建类型 Message creation type */
@property (nonatomic, assign) IMMsgCreateType createType;

/* mainInfo 消息内容 Message content, the biggest difference of each message */
@property (nonatomic, strong) NSString *mainInfo;

/* 消息状态 Message status
 C-机器人聊天  Robot
 Q-排队中 In line
 S-人工服务状态 Artificial services
 E-评价状态 Evaluation services
 F-会话结束 End of session */
@property (nonatomic, strong) NSString *sessionState;

/* 消息创建时间 Message creation time */
@property (nonatomic, strong) NSString *createTime;

/* 跳转界面参数 Jump interface parameters */
@property (nonatomic, strong) NSString *jumpMenu;

/* 点击confirm进入人工咨询 Click confirm to enter the manual consultation */
@property (nonatomic, strong) NSString *needBtn;

/* 人工客服头像 Avatar of manual customer service */
@property (nonatomic, strong) NSString *agentPicture;

/* 人工客服姓名 Name of manual customer service */
@property (nonatomic, strong) NSString *nickName;

/* 用于显示点赞/点踩 Used to display like / dislike */
@property (nonatomic, strong) NSString *answerSource;

/* 在mainInfo里面用于接口入参 In maininfo, it is used for interface input parameters */
@property (nonatomic, strong) NSString *messageId;

/* 用于是否显示消息创建时间 Whether to display the message creation time */
@property (nonatomic, assign) BOOL isShowTime;

/* 每一条消息在界面中的高度 The height of each message in the interface */
@property (nonatomic, assign) NSInteger cellHeight;

/* 消息底部是否有提交按钮 a submit button at the bottom of the message */
@property (nonatomic, assign) BOOL isSubmit;

/* 设置扩展字段，用于自定义 Set extended fields for customization */
@property (nonatomic, strong) NSString *extend;

/* 消息是否是富文本 */
@property (nonatomic, assign) BOOL isHTML;

/* 富文本是否加载完成 */
@property (nonatomic, assign) BOOL isHtmlReload;

/* 消息是否发送成功 */
@property (nonatomic, assign) BOOL isMsgSend;

/* helpful */
@property (nonatomic, assign) BOOL needHelpful;
/* helpful 展示*/
@property (nonatomic, assign) BOOL showHelpful;

// 是否正在输入状态 T:正在输入  N:停止输入  B:已读
@property (nonatomic, strong) NSString *status;

// 0:未读 1:已读
@property (nonatomic, assign) BOOL isSeen;
// 已读未读的msgId
@property (nonatomic, strong) NSString *msgSeenId;
// 已读消息列表
@property (nonatomic, strong) NSArray *msgIdList;



/*----------------------------------------------
 *  临时字段 Temporary Fields
 ----------------------------------------------*/

/* 满意度模型 Satisfaction Model */
@property (nonatomic, strong) IMSatisfyMainInfoModel *satisfyMainInfoModel;

/* 评价满意度选项的数目 Number of evaluation satisfaction options */
@property (nonatomic, strong) NSMutableArray *menuList;

/* 点踩原因的数目 Number of dislike options */
@property (nonatomic, strong) NSMutableArray *dislikeList;



- (id)initWithMsgDic:(NSDictionary *)msgDic;

- (id)initText;

- (id)initImage;

- (id)initWithResultSet:(FMResultSet *)rs;

- (id)initUserInfo;

@end

NS_ASSUME_NONNULL_END
