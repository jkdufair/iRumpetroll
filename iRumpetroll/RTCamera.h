//
//  RTCamera.h
//  iRumpetroll
//
//  Created by Jason Dufair on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTCamera : NSObject

@property UIView *view;
@property NSNumber *x;
@property NSNumber *y;
@property NSNumber *minZoom;
@property NSNumber *maxZoom;
@property NSNumber *zoom;

- (id)initWithView:(UIView *)aView x: (NSNumber *)anX y:(NSNumber *)aY;
- (void)setUpContext;

@end
