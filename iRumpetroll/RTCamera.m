//
//  RTCamera.m
//  iRumpetroll
//
//  Created by Jason Dufair on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RTCamera.h"
#include <stdlib.h>

@implementation RTCamera
{
    UIColor *backgroundColor;
}

@synthesize view = _view;
@synthesize x = _x;
@synthesize y = _y;
@synthesize minZoom = _minZoom;
@synthesize maxZoom = _maxZoom;
@synthesize zoom = _zoom;
@synthesize model = _model;

- (id)initWithView:(UIView *)aView x:(float)anX y:(float)aY model:(RTModel *)model
{
    if (self = [super init])
    {
        self.view = aView;
        self.x = anX;
        self.y = aY;
        self.minZoom = 1.3f;
        self.maxZoom = 1.8f;
        self.zoom = self.minZoom;
        float hue = (float)random()/RAND_MAX;
        backgroundColor = [UIColor colorWithHue:hue saturation:0.5f brightness:0.3f alpha:1.0f];
        self.model = model;
    }
    return self;
}

- (void)updateTranslateAndScale
{
    [self updateFromModel];
    [self translateAndScale];
}

- (void)updateFromModel
{
    float targetZoom = (self.maxZoom + (self.minZoom - self.maxZoom) * MIN(self.model.userTadpole.momentum, self.model.userTadpole.maxMomentum) / self.model.userTadpole.maxMomentum);
    self.zoom += (targetZoom - self.zoom) / 60;
    CGPoint delta = CGPointMake((self.model.userTadpole.x - self.x) / 30, (self.model.userTadpole.y - self.y) / 30);
    if (ABS(delta.x) + ABS(delta.y) > 0.1)
    {
        self.x += delta.x;
        self.y += delta.y;
    }
}

- (void)translateAndScale
{
    float w = self.view.bounds.size.width;
    float h = self.view.bounds.size.height;
    float translateX = w / 2 - self.x * self.zoom;
    float translateY = h / 2 - self.y * self.zoom;
    translateX = w / 2 - self.x;
    translateY = h / 2 - self.y;
    [self.view setTransform:CGAffineTransformMakeTranslation(translateX, translateY)];
    //[self.view setTransform:CGAffineTransformScale(self.view.transform, self.zoom, self.zoom)];
}

@end
