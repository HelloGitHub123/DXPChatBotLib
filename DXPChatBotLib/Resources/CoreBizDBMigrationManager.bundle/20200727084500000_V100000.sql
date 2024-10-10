
/* Add by mengmeng.zhang */

/* Update SQL */

/* touch "`ruby -e "puts Time.now.strftime('%Y%m%d%H%M%S%3N').to_i"`"_CreateMyAwesomeTable.sql   生成该文件的命令 */


/* 聊天记录 */

CREATE TABLE IF NOT EXISTS T_DB_CHAT(
userId text,
msgId text,
msgType integer,
createType integer,
mainInfo text,
sessionState text,
createTime text,
jumpMenu text,
needBtn text,
answerSource text,
messageId text,
isShowTime integer,
cellHeight integer,
isSubmit integer,
extend text,
nickName text,
agentPicture text,
isHTML integer
);



/* Nudges记录 */

CREATE TABLE IF NOT EXISTS T_DB_Nudges(
contactId text,
campaignId integer,
flowId integer,
processId text,
campaignExpDate text,
nudgesId integer,
nudgesName text,
remainTimes integer,
height integer,
width integer,
adviceCode text,
channelCode text,
nudgesType text,
pageName text,
findIndex text,
ownProp text,
position text,
appExtInfo text,
background text,
border text,
backdrop text,
dismiss text,
title text,
body text,
image text,
video text,
buttons text,
dismissButton text,
isShow integer
);



/* 频次记录 */

CREATE TABLE IF NOT EXISTS T_DB_Frequency(
repeatInterval integer,
sessionTimes integer,
hourTimes integer,
dayTimes integer,
weekTimes integer,
lastTime text
);



/* Rating记录 */

CREATE TABLE IF NOT EXISTS T_DB_Rating(
phoneNumber text,
ratingId text,
campaignName text,
effDate text,
expDate text,
state text,
stateDate text,
ratingDesc text,
priority text,
ratingRuleId text,
ruleName text,
seq text,
events text,
userType text,
userTags text,
triggerType text,
maxTimes text,
triggerInterval text,
triggerIntervalUnit text,
popupType text,
iosPopup text,
iosPopupName text,
iosPopupTemplate text,
createdBy text,
createdDate text,
updateBy text,
updateDate text,
showNumber integer,
lastTime text
);
