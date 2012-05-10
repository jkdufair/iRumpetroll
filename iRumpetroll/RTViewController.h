//
//  RTViewController.h
//  iRumpetroll
//
//  Created by Jason Dufair on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTModel.h"

extern CGPoint const BALANCE_POINT;
extern float const HYSTERESIS_VALUE;

@interface RTViewController : UIViewController <RTModelDelegate, UIAccelerometerDelegate>
@property (weak, nonatomic) IBOutlet UIView *tadpoleDrawingView;

@end
