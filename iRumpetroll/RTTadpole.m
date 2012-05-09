//
//  RTTadpole.m
//  iRumpetroll
//
//  Created by Jason Dufair on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RTTadpole.h"

@implementation RTTadpole

@synthesize id = _id;
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
@synthesize maxMomentum = _maxMomentum;
@synthesize size = _size;

- (id)init
{
    if (self = [super init]) {
        self.x = (float)arc4random()/0x100000000 * 300 - 150;
        self.y = (float)arc4random()/0x100000000 * 300 - 150;
        self.age = 0;
        self.momentum = 0.0f;
        self.maxMomentum = 3.0f;
        self.angle = 0.0f;
        self.targetX = 0.0f;
        self.targetY = 0.0f;
        self.targetMomentum = 0.0f;
        self.timeSinceLastServerUpdate = 0;
        self.size = 4.0f;
    }
    return self;    
}

- (void)setProperties:(NSDictionary *)data
{
    self.angle = [[data objectForKey:@"angle"] floatValue];
    self.momentum = [[data objectForKey:@"momentum"] floatValue];
    self.name = [data objectForKey:@"name"];
    self.timeSinceLastServerUpdate = 0;
}

- (void)setInitialProperties:(NSDictionary *)data
{
    self.x = [[data objectForKey:@"x"] floatValue];
    self.y = [[data objectForKey:@"y"] floatValue];
    self.id = [data objectForKey:@"id"];
    [self setProperties:data];
}

- (void)updateProperties:(NSDictionary *)data
{
    float x = [[data objectForKey:@"x"] floatValue];
    float y = [[data objectForKey:@"y"] floatValue];
    if (x == NAN || y == NAN) {
        return;
    }
    self.targetX = x;
    self.targetY = y;
    //temporary
    self.x = x;
    self.y = y;
    [self setProperties:data];
}

@end
