//
//  IMTapMorePushVC.m
//  UCC
//
//  Created by mac on 2021/1/20.
//

#import "IMTapMorePushVC.h"
#import "UCCHeader.h"

@implementation IMTapMorePushVC

+ (void)pushVCWithRouter:(NSDictionary *)routerDic {
	
	NSString *router = [routerDic valueForKey:@"router"];
	if (isEmptyString_IM(router)) {
		return;
	}
	// 处理跳转逻辑
	[[NSNotificationCenter defaultCenter] postNotificationName:IMNotificationRouterDeal object:router];
}

@end
