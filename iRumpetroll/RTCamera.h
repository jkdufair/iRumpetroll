//
//  RTCamera.h
//  iRumpetroll
//
//  Created by Jason Dufair on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTModel.h"

@class RTModel;

@interface RTCamera : NSObject

@property UIView *view;
@property float x;
@property float y;
@property float minZoom;
@property float maxZoom;
@property float zoom;
@property RTModel *model;

- (id)initWithView:(UIView *)aView x:(float)anX y:(float)aY model:(RTModel *)model;
- (void)updateTranslateAndScale;

@end
