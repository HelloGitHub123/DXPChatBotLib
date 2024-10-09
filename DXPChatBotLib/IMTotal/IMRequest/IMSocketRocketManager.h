//
//  IMSocketRocketManager.h
//  IMDemo
//
//  Created by mac on 2020/6/5.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SocketRocket.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSocketRocketManager : NSObject

/* instance socket */
+ (IMSocketRocketManager *)instance;

/* Connect socket*/
- (void)openSocket:(NSString *)flowNo;

/* Close socket*/
- (void)closeSocket;

@end

NS_ASSUME_NONNULL_END
