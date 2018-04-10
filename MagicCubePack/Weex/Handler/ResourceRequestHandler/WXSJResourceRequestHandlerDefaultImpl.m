//
//  WXSJResourceRequestHandlerDefaultImpl.m
//  DaRenShop
//
//  Created by LuisX on 2017/8/4.
//  Copyright © 2017年 YunRuo. All rights reserved.
//

#import "WXSJResourceRequestHandlerDefaultImpl.h"
#import "WXSJThreadSafeMutableDictionary.h"

@interface WXSJResourceRequestHandlerDefaultImpl () <NSURLSessionDataDelegate>

@end

@implementation WXSJResourceRequestHandlerDefaultImpl{
    NSURLSession *_session;
    WXSJThreadSafeMutableDictionary<NSURLSessionDataTask *, id<WXResourceRequestDelegate>> *_delegates;
}
#pragma mark - WXResourceRequestHandler
// 发起请求
- (void)sendRequest:(WXResourceRequest *)request withDelegate:(id<WXResourceRequestDelegate>)delegate{
    
    // 请求前setCookies
//    [[SJCookieHandle initSJCookieHandle] setCookiesFromArr];
    
    if (!_session) {
        NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        if ([WXAppConfiguration customizeProtocolClasses].count > 0) {
            NSArray *defaultProtocols = urlSessionConfig.protocolClasses;
            urlSessionConfig.protocolClasses = [[WXAppConfiguration customizeProtocolClasses] arrayByAddingObjectsFromArray:defaultProtocols];
        }
        _session = [NSURLSession sessionWithConfiguration:urlSessionConfig
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue mainQueue]];
        _delegates = [WXSJThreadSafeMutableDictionary new];
    }
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request];
    request.taskIdentifier = task;
    [_delegates setObject:delegate forKey:task];
    [task resume];
}

// 取消请求
- (void)cancelRequest:(WXResourceRequest *)request{
    if ([request.taskIdentifier isKindOfClass:[NSURLSessionTask class]]) {
        NSURLSessionTask *task = (NSURLSessionTask *)request.taskIdentifier;
        [task cancel];
        [_delegates removeObjectForKey:task];
    }
}

#pragma mark - NSURLSessionTaskDelegate & NSURLSessionDataDelegate
// 发送数据的进度
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    id<WXResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(WXResourceRequest *)task.originalRequest didSendData:bytesSent totalBytesToBeSent:totalBytesExpectedToSend];
}

// 接受到服务响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)task didReceiveResponse:(NSURLResponse *)response  completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    id<WXResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(WXResourceRequest *)task.originalRequest didReceiveResponse:(WXResourceResponse *)response];
    completionHandler(NSURLSessionResponseAllow);
}

// 接收到服务器响应数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)task didReceiveData:(NSData *)data{
    id<WXResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(WXResourceRequest *)task.originalRequest didReceiveData:data];
}

// 请求完成（成功或失败）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    id<WXResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    if (error) {
        [delegate request:(WXResourceRequest *)task.originalRequest didFailWithError:error];
    }else {
        // 请求后saveCacheCookie
//        [[SJCookieHandle initSJCookieHandle] saveCacheCookie];
        [delegate requestDidFinishLoading:(WXResourceRequest *)task.originalRequest];
    }
    [_delegates removeObjectForKey:task];
    
}

/*
#ifdef __IPHONE_10_0
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics
{
    id<WXResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(WXResourceRequest *)task.originalRequest didFinishCollectingMetrics:metrics];
}
#endif
*/

#pragma mark - 业务逻辑


@end
