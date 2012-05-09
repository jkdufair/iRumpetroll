//
//  RTViewController.h
//  iRumpetroll
//
//  Created by Jason Dufair on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTModel.h"

@interface RTViewController : UIViewController <RTModelDelegate>
@property (weak, nonatomic) IBOutlet UIView *tadpoleDrawingView;

@end
