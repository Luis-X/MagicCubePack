//
//  WeexViewController.h
//  MagicCubePack
//
//  Created by LuisX on 2018/4/4.
//  Copyright © 2018年 LuisX. All rights reserved.
//

#import "BaseViewController.h"
#import <SRWebSocket.h>
@interface WeexViewController : BaseViewController <SRWebSocketDelegate>
@property (nonatomic, strong) NSString *script;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) SRWebSocket *hotReloadSocket;
@property (nonatomic, strong) NSString *source;
@end
