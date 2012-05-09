//
//  RTWebSocketService.h
//  iRumpetroll
//
//  Created by Jason Dufair on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
#import "RTModel.h"

@interface RTWebSocketService : NSObject <RTModelRemoteDelegate>

- (id)initWithModel:(RTModel *)aModel socket: (SRWebSocket *)aSocket;
- (void)processMessage:(NSDictionary *)data;
- (void) sendUpdate:(RTTadpole *)tadpole;
- (void)userTadpoleUpdated:(RTTadpole *)tadpole;

@end
