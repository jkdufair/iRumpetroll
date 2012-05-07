//
//  RTTadpole.h
//  iRumpetroll
//
//  Created by Jason Dufair on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTTadpole : NSObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSNumber *x;
@property (nonatomic, strong) NSNumber *y;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSNumber *angle;
@property (nonatomic, strong) NSNumber *momentum;
@property (nonatomic, strong) NSNumber *targetX;
@property (nonatomic, strong) NSNumber *targetY;
@property (nonatomic, strong) NSNumber *targetMomentum;
@property (nonatomic, strong) NSNumber *timeSinceLastServerUpdate;

@end
