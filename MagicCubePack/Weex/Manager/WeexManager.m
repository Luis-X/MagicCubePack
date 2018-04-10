//
//  WeexManager.m
//  DaRenShop
//
//  Created by LuisX on 2017/8/4.
//  Copyright © 2017年 YunRuo. All rights reserved.
//

#import "WeexManager.h"
#import <WeexSDK/WeexSDK.h>
#import "WXImgLoaderDefaultImpl.h"
#import "WXSJNetworkDefaultlmpl.h"
#import "WXSJResourceRequestHandlerDefaultImpl.h"
#import "WeexViewController.h"


@implementation WeexManager

+ (void)start{
    
    //business configuration
    [WXAppConfiguration setAppGroup:@"AliApp"];
    [WXAppConfiguration setAppName:@"WeexDemo"];
    [WXAppConfiguration setExternalUserAgent:@"ExternalUA"];
    //init sdk environment
    [WXSDKEngine initSDKEnvironment];
    //register custom module and component，optional
//    [WXSDKEngine registerModule:@"shopBase" withClass:[BaseModule class]];
//    [WXSDKEngine registerModule:@"shopModal" withClass:[ShopModule class]];
    [WXSDKEngine registerHandler:[WXImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
    [WXSDKEngine registerHandler:[WXSJNetworkDefaultlmpl new] withProtocol:@protocol(WXURLRewriteProtocol)];
    [WXSDKEngine registerHandler:[WXSJResourceRequestHandlerDefaultImpl new] withProtocol:@protocol(WXResourceRequestHandler)];
    [WXSDKEngine registerComponent:@"a" withClass:NSClassFromString(@"WXPushComponent")];
    [WXSDKEngine registerComponent:@"pager" withClass:NSClassFromString(@"WXSJPagerComponent")];
    
    //set the log level
#ifdef DEBUG
    [WXDebugTool setDebug:YES];
    [WXLog setLogLevel:WXLogLevelLog];
#else
    [WXDebugTool setDebug:NO];
    [WXLog setLogLevel:WXLogLevelError];
#endif
    
}
@end
