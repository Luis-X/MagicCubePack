//
//  WXSJNetworkDefaultlmpl.m
//  DaRenShop
//
//  Created by guo on 16/12/15.
//  Copyright © 2016年 YunRuo. All rights reserved.
//

#import "WXSJNetworkDefaultlmpl.h"
#import "WeexManager.h"

@implementation WXSJNetworkDefaultlmpl


- (NSURL *)rewriteURL:(NSString *)url withResourceType:(WXResourceType)resourceType withInstance:(WXSDKInstance *)instance{
    
    NSURL *completeURL = [NSURL URLWithString:url];
    if ([completeURL isFileURL]) {
        return completeURL;
    } else {
        return [instance completeURL:url];
    }
    
}



@end


