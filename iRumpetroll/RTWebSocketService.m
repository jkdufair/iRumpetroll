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
    if ([self respondsToSelector:selector])
        [self performSelector:selector withObject:data];
#pragma clang diagnostic pop
}

- (void) sendUpdate:(RTTadpole *)tadpole
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          @"update", @"type",
                          [NSString stringWithFormat:@"%.1f", tadpole.x], @"x",
                          [NSString stringWithFormat:@"%.1f", tadpole.y], @"y",
                          [NSString stringWithFormat:@"%.3f", tadpole.angle], @"angle",
                          [NSString stringWithFormat:@"%.3f", tadpole.momentum], @"momentum",
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
    id id = [data objectForKey:@"id"];
    NSString *tempKey = @"temporary";
    RTTadpole *tadpole = [model tadpoleForKey:tempKey];
    [model addTadpole:tadpole withId:id];
    [model removeTadpole:tempKey];
}

- (void)updateHandler:(NSDictionary *)data
{
    id ident = [data objectForKey:@"id"];
    BOOL newTadpole = NO;
    if ([model.tadpoles objectForKey:ident] == nil)
    {
        newTadpole = YES;
        RTTadpole *tadpole = [[RTTadpole alloc] init];
        [tadpole setInitialProperties:(NSDictionary *)data];
        [model addTadpole:tadpole withId:ident];
    }
    
    RTTadpole *tadpole = [model tadpoleForKey:ident];
    if (tadpole != model.userTadpole && !newTadpole)
        [model updateTadpole:tadpole withProperties:(NSDictionary *)data];
}

- (void)closedHandler:(NSDictionary *)data
{
    if ([model tadpoleForKey:[data objectForKey:@"id"]] != nil)
    {
        [model removeTadpole: [data objectForKey:@"id"]];
    }
}

@end
