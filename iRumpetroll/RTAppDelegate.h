//
//  RTAppDelegate.h
//  iRumpetroll
//
//  Created by Jason Dufair on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"
#import "RTModel.h"

@interface RTAppDelegate : UIResponder <UIApplicationDelegate, SRWebSocketDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RTModel *model;

@end
