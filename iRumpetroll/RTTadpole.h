//
//  RTTadpole.h
//  iRumpetroll
//
//  Created by Jason Dufair on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTTadpole : NSObject

@property (nonatomic, strong) id id;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) float angle;
@property (nonatomic, assign) float momentum;
@property (nonatomic, assign) float targetX;
@property (nonatomic, assign) float targetY;
@property (nonatomic, assign) float targetMomentum;
@property (nonatomic, assign) int timeSinceLastServerUpdate;
@property (nonatomic, assign) float maxMomentum;
@property (nonatomic, assign) float size;

- (void)setInitialProperties:(NSDictionary *)data;
- (void)updateProperties:(NSDictionary *)data;

@end
