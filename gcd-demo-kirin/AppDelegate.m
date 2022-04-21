//
//  AppDelegate.m
//  gcd-demo-kirin
//
//  Created by Admin on 2022-04-14.
//

#import "AppDelegate.h"
#import "HelloGCD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    HelloGCD *GCDDemoInstance = [[HelloGCD alloc] init];
    
    //串行队列+同步
    //[GCDDemoInstance syncOnSerialQueue];
    //串行队列+异步
    //[GCDDemoInstance asyncOnSerialQueue];
    
    //并发队列+同步
    //[GCDDemoInstance syncOnConcurrentQueue];
    //并发队列+异步
    [GCDDemoInstance asyncOnConcurrentQueue];
    //[NSThread sleepForTimeInterval:5];
    //NSLog(@"--- Main thread wakes up and continue---");
    //主队列+同步
    //[GCDDemoInstance syncOnMainQueue];
    //主队列+异步
    //[GCDDemoInstance asyncOnMainQueue];
    
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
