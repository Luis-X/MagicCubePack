/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

#import "WXImgLoaderDefaultImpl.h"
#import <SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define MIN_IMAGE_WIDTH 36
#define MIN_IMAGE_HEIGHT 36

#if OS_OBJECT_USE_OBJC
#undef  WXDispatchQueueRelease
#undef  WXDispatchQueueSetterSementics
#define WXDispatchQueueRelease(q)
#define WXDispatchQueueSetterSementics strong
#else
#undef  WXDispatchQueueRelease
#undef  WXDispatchQueueSetterSementics
#define WXDispatchQueueRelease(q) (dispatch_release(q))
#define WXDispatchQueueSetterSementics assign
#endif

@interface WXImgLoaderDefaultImpl()

@property (WXDispatchQueueSetterSementics, nonatomic) dispatch_queue_t ioQueue;

@end

@implementation WXImgLoaderDefaultImpl

#pragma mark -
#pragma mark WXImgLoaderProtocol

- (instancetype)init{
    if (self) {
//        self.webpHost = [OnLineParameter getOnLineParameterArray:@"webpHost"];
    }
    return self;
}

- (id<WXImageOperationProtocol>)downloadImageWithURL:(NSString *)url imageFrame:(CGRect)imageFrame userInfo:(NSDictionary *)userInfo completed:(void(^)(UIImage *image,  NSError *error, BOOL finished))completedBlock
{
    
//    url = [WeexManager checkValidityWithUrl:url];
    
    if (nil != self.webpHost && self.webpHost.count > 0) {
        for (NSString *urlString in self.webpHost) {
            if ([url containsString:urlString] && ![url hasSuffix:@".webp"] && ![url hasSuffix:@".gif"]) {
                url = [url stringByAppendingString:@".webp"];
                break;
            }
        }
    }
    
    [self clearCacheImageFileWithUrl:url];
 
    return (id<WXImageOperationProtocol>)[[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url]
                                                                 options:0
                                                                progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                                                    
                                                                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                                                                    if (completedBlock) {
                                                                        completedBlock(image, error, finished);
                                                                    }
                                                                }];
    
}

- (void)clearCacheImageFileWithUrl:(NSString *)url
{
    if ([url hasPrefix:@"file://"]) {
        if ([[SDImageCache sharedImageCache] diskImageDataExistsWithKey:url]) {
            [[SDImageCache sharedImageCache] removeImageForKey:url fromDisk:YES withCompletion:NULL];
        }
    }
}
@end
