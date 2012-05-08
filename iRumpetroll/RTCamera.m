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

- (id)initWithView:(UIView *)aView x: (NSNumber *)anX y:(NSNumber *)aY
{
    if (self = [super init])
    {
        self.view = aView;
        self.x = anX;
        self.y = aY;
        self.minZoom = [NSNumber numberWithFloat:1.3f];
        self.maxZoom = [NSNumber numberWithFloat:1.8f];
        self.zoom = self.minZoom;
        float hue = (float)random()/RAND_MAX;
        backgroundColor = [UIColor colorWithHue:hue saturation:0.5f brightness:0.3f alpha:1.0f];
    }
    return self;
}

- (void)setUpContext
{
    float w = self.view.bounds.size.width;
    float h = self.view.bounds.size.height;
    float x = [self.x floatValue];
    float y = [self.y floatValue];
    float zoom = [self.zoom floatValue];
    float translateX = w / 2 - x * zoom;
    float translateY = h / 2 - y * zoom;
    [self.view setTransform:CGAffineTransformMakeTranslation(translateX, translateY)];
    [self.view setTransform:CGAffineTransformMakeScale(zoom, zoom)];    
}

@end
