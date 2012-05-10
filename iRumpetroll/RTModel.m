//
//  RTModel.m
//  iRumpetroll
//
//  Created by Jason Dufair on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RTModel.h"

@implementation RTModel

@synthesize tadpoles = _tadpoles;
@synthesize userTadpole = _userTadpole;
@synthesize camera = _camera;
@synthesize delegate = _delegate;
@synthesize remoteDelegate = _remoteDelegate;

- (NSMutableDictionary *)tadpoles
{
    if (_tadpoles == nil)
    {
        _tadpoles = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return _tadpoles;
}

- (void)addTadpole:(RTTadpole *)tadpole withId:(id)key
{
    tadpole.id = key;
    [self.tadpoles setObject:tadpole forKey:key];
    [self.delegate tadpoleAdded:tadpole key:key];
    [self.remoteDelegate userTadpoleUpdated:self.userTadpole];
}

- (void)removeTadpole:(id)key
{
    [self.tadpoles removeObjectForKey:key];
    [self.delegate tadpoleRemoved:key];
}

- (RTTadpole *)tadpoleForKey:(id)key
{
    return [self.tadpoles objectForKey:key];
}

- (void)updateTadpole:(RTTadpole *)tadpole withProperties:(NSDictionary *)data
{
    [tadpole updateProperties:data];
    [self.delegate tadpoleMoved:tadpole key:tadpole.id];
}

- (void)updateUserTadpole
{
    [self.remoteDelegate userTadpoleUpdated:self.userTadpole];
    [self.camera updateTranslateAndScale];
}
@end
