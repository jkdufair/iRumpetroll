//
//  RTModel.h
//  iRumpetroll
//
//  Created by Jason Dufair on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTTadpole.h"
#import "RTCamera.h"

@protocol RTModelDelegate
- (void)tadpoleAdded:(RTTadpole *)tadpole key:(id)key;
- (void)tadpoleRemoved:(id)key;
@end

@interface RTModel : NSObject

@property (nonatomic, strong) NSMutableDictionary *tadpoles;
@property (nonatomic, strong) RTTadpole *userTadpole;
@property (nonatomic, strong) RTCamera *camera;
@property (assign) id <RTModelDelegate> delegate;

- (void)addTadpole:(RTTadpole *)tadpole withId:(id)key;
- (void)removeTadpole:(id)key;
- (RTTadpole *)tadpoleForKey:(id)key;

@end
