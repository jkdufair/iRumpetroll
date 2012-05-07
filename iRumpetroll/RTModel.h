//
//  RTModel.h
//  iRumpetroll
//
//  Created by Jason Dufair on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTTadpole.h"

@interface RTModel : NSObject

@property (nonatomic, strong) NSMutableDictionary *tadpoles;
@property (nonatomic, strong) RTTadpole *userTadpole;

@end
