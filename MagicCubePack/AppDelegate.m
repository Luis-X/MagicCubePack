//
//  AppDelegate.m
//  MagicCubePack
//
//  Created by LuisX on 2018/3/20.
//  Copyright © 2018年 LuisX. All rights reserved.
//

#import "AppDelegate.h"
#import "WeexManager.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


// 七、当应用程序载入后执行
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self startMainUIWindow];
    [WeexManager start];
    return YES;
}

// 一、当应用程序将要进入非活动状态执行(在此期间,应用程序不接收消息或事件)
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

// 三、当应用程序被推送到后台时调用
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

// 四、当应用程序从后台将要重新回到前台时调用
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

// 二、当应用程序进入活动状态时执行
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

// 五、当应用程序要退出时调用(保存数据,退出前清理工作)
- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

// 六、当应用程序终止前会执行这个方法(内存清理,防止程序被终止)
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    
}

#pragma mark - 打开URL回调
// 十、苹果整合了八、九的功能到此方法(iOS9.0+)
// 优先级: 高
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [self managerHandleOpenURL:url sourceApplication:[options valueForKey:UIApplicationOpenURLOptionsSourceApplicationKey]];
}

// 九、通过sourceApplication判断来自哪个App决定是否唤醒自己的App(iOS4.2 – 9.0)
// 优先级: 中

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self managerHandleOpenURL:url sourceApplication:sourceApplication];
}

// 八、打开URL时执行(iOS2.0 – 9.0)
// 优先级: 低
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self managerHandleOpenURL:url sourceApplication:nil];
}


- (BOOL)managerHandleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
{
    
    NSLog(@"来源App: %@", sourceApplication);
    NSLog(@"url协议: %@", [url scheme]);
    NSLog(@"url参数: %@", [url query]);
    
//    // QQ
//    if ([TencentApiInterface canOpenURL:url delegate:[MagicShareQQ shareManager]]){
//        return [TencentApiInterface handleOpenURL:url delegate:[MagicShareQQ shareManager]];
//    }
//    // 微信
//    return [WXApi handleOpenURL:url delegate:[MagicShareWeChat shareManager]];
    return YES;
    
}

#pragma mark - 获取AppDelete实例
+ (AppDelegate *)shareAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - UIWindow
- (void)startMainUIWindow
{
    UIViewController *rootTabBarViewController = [self loadingUINavigationControllerWithController];
    //创建一个window对象,属于AppDelegate的属性
    //UIScreen:      表示屏幕硬件类
    //mainScreen:    获得主屏幕信息
    //bounds:        当前手机屏幕大小
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //对窗口的根视图控制器进行赋值操作
    //整个UIKit框架中只有一个根视图控制器,属于window的属性
    //视图控制器用来管理界面和处理界面的逻辑类对象
    //程序启动前必须对根视图控制器赋值
    self.window.rootViewController = rootTabBarViewController;
    //将window作为主视图并且显示
    [self.window makeKeyAndVisible];
}

- (UIViewController *)loadingUINavigationControllerWithController
{
    
    // QD自定义的全局样式渲染
    [QDCommonUI renderGlobalAppearances];
    // 预加载 QQ 表情，避免第一次使用时卡顿
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [QDUIHelper qmuiEmotions];
    });
    
    BaseTabBarViewController *tabBarViewController = [[BaseTabBarViewController alloc] init];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    homeViewController.hidesBottomBarWhenPushed = NO;
    BaseNavigationController *homeNavController = [[BaseNavigationController alloc] initWithRootViewController:homeViewController];
    homeNavController.tabBarItem = [QDUIHelper tabBarItemWithTitle:@"UI" image:[UIImageMake(@"icon_tabbar_uikit") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_uikit_selected") tag:1];
    
    // window root controller
    tabBarViewController.viewControllers = @[homeNavController];
    return tabBarViewController;
}
@end
