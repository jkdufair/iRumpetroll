//
//  RTWebSocketService.m
//  iRumpetroll
//
//  Created by Jason Dufair on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RTWebSocketService.h"
#import "SBJson.h"

@implementation RTWebSocketService
{
    RTModel *model;
    SRWebSocket *socket;
}

#pragma mark - Initialization

- (id)initWithModel:(RTModel *)aModel socket: (SRWebSocket *)aSocket
{
    if (self = [super init])
    {
        model = aModel;
        socket = aSocket;
    }
    return self;
}

- (id)init
{
    return [self initWithModel:nil socket:nil];
}

#pragma mark - Messaging

- (void) processMessage:(NSDictionary *)data
{
    NSString *handler = [NSString stringWithFormat:@"%@%@", [data objectForKey:@"type"], @"Handler:"];
    SEL selector = NSSelectorFromString(handler);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"    
    [self performSelector:selector withObject:data];
#pragma clang diagnostic pop
}

- (void) sendUpdate:(RTTadpole *)tadpole
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          @"update", @"type",
                          [NSString stringWithFormat:@"%.1f", [tadpole.x floatValue]], @"x",
                          [NSString stringWithFormat:@"%.1f", [tadpole.y floatValue]], @"y",
                          [NSString stringWithFormat:@"%.3f", [tadpole.angle floatValue]], @"angle",
                          [NSString stringWithFormat:@"%.3f", [tadpole.momentum floatValue]], @"momentum",
                          nil];
    if (tadpole.name != nil)
    {
        [dict setObject:tadpole.name forKey:@"name"];
    }
    [socket send:[dict JSONRepresentation]];
}

#pragma mark - Handlers

- (void)welcomeHandler:(NSDictionary *)data
{
    NSLog(@"welcomeHandler");    
    model.userTadpole.identifier = [data objectForKey:@"id"];
    [model.tadpoles setObject:model.userTadpole forKey:model.userTadpole.identifier];
    [model.tadpoles removeObjectForKey:@"temporary"];
}

- (void)updateHandler:(NSDictionary *)data
{
    NSLog(@"updateHandler");
    BOOL newTadpole = NO;
    if ([model.tadpoles objectForKey:[data objectForKey:@"id"]] == nil)
    {
        newTadpole = YES;
        [model.tadpoles setObject:[[RTTadpole alloc] init] forKey:[data objectForKey:@"id"]];
    }
    
    RTTadpole *tadpole = [model.tadpoles objectForKey:[data objectForKey:@"id"]];
    tadpole.name = [data objectForKey:@"name"];
    
    if (tadpole.identifier == model.userTadpole.identifier)
        return;
    
    if (newTadpole)
    {
        tadpole.x = [data objectForKey:@"x"];
        tadpole.y = [data objectForKey:@"y"];
    } else {
        tadpole.targetX = [data objectForKey:@"x"];
        tadpole.targetY = [data objectForKey:@"y"];
    }
    
    tadpole.angle = [data objectForKey:@"angle"];
    tadpole.momentum = [data objectForKey:@"momentum"];
    
    tadpole.timeSinceLastServerUpdate = 0;
        
}

- (void)closedHandler:(NSDictionary *)data
{
    NSLog(@"closedHandler");
    if ([model.tadpoles objectForKey:[data objectForKey:@"id"]] != nil)
    {
        [model.tadpoles removeObjectForKey:[data objectForKey:@"id"]];
    }
}

@end
