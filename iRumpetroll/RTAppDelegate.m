//
//  RTAppDelegate.m
//  iRumpetroll
//
//  Created by Jason Dufair on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RTAppDelegate.h"
#import "SBJson.h"
#import "RTWebSocketService.h"

@implementation RTAppDelegate
{
    SRWebSocket *webSocket;
    RTWebSocketService *webSocketService;
    NSTimer *timer;
}

@synthesize window = _window;
@synthesize model = _model;

#pragma mark - Timer management

- (void)startTimer
{
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:0.0];
    timer = [[NSTimer alloc] initWithFireDate:fireDate interval:0.03 target:self selector:@selector(sendLocalUpdates) userInfo:nil repeats:YES];
    [currentRunLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    NSLog(@"Timer started");
}

#pragma mark - Socket Management

- (void)connectWebSocket;
{
    webSocket.delegate = nil;
    [webSocket close];
    
    webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://localhost:8181"]]];
    webSocket.delegate = self;
    
    [webSocket open];
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)payload
{
    NSString *message = [NSString stringWithString:payload];
    NSDictionary *dict = [message JSONValue];
    [webSocketService processMessage:dict];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    [self startTimer];
}

#pragma mark - Runloop
- (void) sendLocalUpdates
{
    if (webSocket.readyState == SR_OPEN)
    {
        [webSocketService sendUpdate:self.model.userTadpole];
    }
}

#pragma mark - Application events

- (void)initializeModel
{
    self.model = [[RTModel alloc] init];
    RTTadpole *tadpole = [[RTTadpole alloc] init];
    self.model.userTadpole = tadpole;
    [self.model addTadpole:tadpole withId:@"temporary"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initializeModel];
    [self connectWebSocket];
    webSocketService = [[RTWebSocketService alloc] initWithModel:self.model socket:webSocket];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [timer invalidate];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [timer invalidate];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self startTimer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self startTimer];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [timer invalidate];
}

@end
