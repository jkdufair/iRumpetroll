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
    id ident = [data objectForKey:@"id"];
    NSString *tempKey = @"temporary";
    RTTadpole *tadpole = [model tadpoleForKey:tempKey];
    [model addTadpole:tadpole withId:ident];
    [model removeTadpole:tempKey];
}

- (void)updateHandler:(NSDictionary *)data
{
    id ident = [data objectForKey:@"id"];
    BOOL newTadpole = NO;
    if ([model.tadpoles objectForKey:[data objectForKey:@"id"]] == nil)
    {
        newTadpole = YES;
        RTTadpole *tadpole = [[RTTadpole alloc] init];
        [model addTadpole:tadpole withId:ident];
        [model removeTadpole:@"temporary"];
    }
    
    RTTadpole *tadpole = [model tadpoleForKey: ident];
   
    if (tadpole == model.userTadpole)
        return;
    
    if (newTadpole)
    {
        [tadpole setInitialProperties:(NSDictionary *)data];
    } else {
        [tadpole updateProperties:(NSDictionary *)data];
    }        
}

- (void)closedHandler:(NSDictionary *)data
{
    if ([model tadpoleForKey:[data objectForKey:@"id"]] != nil)
    {
        [model removeTadpole: [data objectForKey:@"id"]];
    }
}

@end
