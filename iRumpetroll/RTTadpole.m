//
//  RTTadpole.m
//  iRumpetroll
//
//  Created by Jason Dufair on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RTTadpole.h"

@implementation RTTadpole

@synthesize x = _x;
@synthesize y = _y;
@synthesize name = _name;
@synthesize age = _age;
@synthesize angle = _angle;
@synthesize momentum = _momentum;
@synthesize targetX = _targetX;
@synthesize targetY = _targetY;
@synthesize targetMomentum = _targetMomentum;
@synthesize timeSinceLastServerUpdate = _timeSinceLastServerUpdate;

- (id)init
{
    if (self = [super init]) {
        self.x = [NSNumber numberWithInt: arc4random() % 300 - 150];
        self.y = [NSNumber numberWithInt: arc4random() % 300 - 150];
        self.age = [NSNumber numberWithInt:0];
        self.momentum = [NSNumber numberWithFloat:0.0f];
        self.angle = [NSNumber numberWithFloat:0.0f];
        self.targetX = [NSNumber numberWithFloat:0];
        self.targetY = [NSNumber numberWithFloat:0];
        self.targetMomentum = [NSNumber numberWithFloat:0.0f];
        self.timeSinceLastServerUpdate = [NSNumber numberWithInt:0];
    }
    return self;    
}

- (void)setProperties:(NSDictionary *)data
{
    self.angle = [data objectForKey:@"angle"];
    self.momentum = [data objectForKey:@"momentum"];
    self.name = [data objectForKey:@"name"];
    self.timeSinceLastServerUpdate = [NSNumber numberWithInt:0];
}

- (void)setInitialProperties:(NSDictionary *)data
{
    self.x = [data objectForKey:@"x"];
    self.y = [data objectForKey:@"y"];
    [self setProperties:data];
}

- (void)updateProperties:(NSDictionary *)data
{
    self.targetX = [data objectForKey:@"x"];
    self.targetY = [data objectForKey:@"y"];
    [self setProperties:data];
}

@end
