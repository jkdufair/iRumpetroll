//
//  RTViewController.m
//  iRumpetroll
//
//  Created by Jason Dufair on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RTViewController.h"
#import "SRWebSocket.h"
#import "RTModel.h"
#import "RTAppDelegate.h"

CGPoint const BALANCE_POINT = {0.0f, 0.0f};
float const HYSTERESIS_VALUE = 0.05f;

@interface RTViewController ()
{
    RTModel *model;
    NSMutableDictionary *tadpoleViews;
}

@end

@implementation RTViewController

#pragma mark - RTModelDelegate implementation
@synthesize tadpoleDrawingView;

- (void)tadpoleMoved:(RTTadpole *)tadpole key:(id)key
{
    UIView *tadpoleView = [tadpoleViews objectForKey:key];
    CGAffineTransform transform = CGAffineTransformMakeRotation(tadpole.angle);
    tadpoleView.transform = transform;
    [tadpoleView setCenter:CGPointMake(tadpole.x, tadpole.y)];
}

- (void)tadpoleAdded:(RTTadpole *)tadpole key:(id)key
{
    UIView *tadpoleContainer = [[UIView alloc] initWithFrame:CGRectMake(tadpole.x, tadpole.y, 100, 80)];
    
    UIImageView *newTadpoleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    newTadpoleView.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"0.png"],
                                      [UIImage imageNamed:@"1.png"],
                                      [UIImage imageNamed:@"2.png"],
                                      [UIImage imageNamed:@"3.png"],
                                      [UIImage imageNamed:@"4.png"],
                                      [UIImage imageNamed:@"5.png"],
                                      [UIImage imageNamed:@"6.png"],
                                      [UIImage imageNamed:@"7.png"],
                                      nil];
    newTadpoleView.animationDuration = 1.0f;
    newTadpoleView.animationRepeatCount = 0;
    [newTadpoleView startAnimating];
    [tadpoleContainer addSubview:newTadpoleView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 100, 30)];
    nameLabel.text = tadpole.name;
    nameLabel.font = [UIFont fontWithName:@"Arial" size:10.0f];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor whiteColor];
    [tadpoleContainer addSubview:nameLabel];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(tadpole.angle);
    tadpoleContainer.transform = transform;
    [self.tadpoleDrawingView addSubview:tadpoleContainer];    
    [tadpoleViews setObject:tadpoleContainer forKey:key];
    NSLog(@"Tadpole with id %@ added at [%.1f,%.1f]", key, tadpole.x, tadpole.y);
}

- (void)tadpoleRemoved:(id)key
{
    UIView *tadpoleView = [tadpoleViews objectForKey:key];
    [tadpoleView removeFromSuperview];
    [tadpoleViews removeObjectForKey:key];
    NSLog(@"Tadpole with id %@ removed", key);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    tadpoleViews = [[NSMutableDictionary alloc] initWithCapacity:10];
    RTAppDelegate *appDelegate = (RTAppDelegate *)[[UIApplication sharedApplication] delegate];
    model = appDelegate.model;
    RTCamera *camera = [[RTCamera alloc] initWithView:self.tadpoleDrawingView x:model.userTadpole.x y:model.userTadpole.y model:model];
    model.camera = camera;
    model.delegate = self;
    [self tadpoleAdded:model.userTadpole key:model.userTadpole.id];
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.1f];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

- (void)viewDidUnload
{
    [self setTadpoleDrawingView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return interfaceOrientation == UIInterfaceOrientationPortrait;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [model.camera updateTranslateAndScale];
    [super viewDidAppear:animated];
}

#pragma mark - Gesture handling

- (void) handleTap:(UIGestureRecognizer *)sender
{
    CGPoint tapPoint = [sender locationInView:self.view];
    if (tapPoint.x > self.view.bounds.size.width / 2) {
        model.userTadpole.x -= 20;
    } else {
        model.userTadpole.x += 20;
    }
    if (tapPoint.y > self.view.bounds.size.height / 2) {
        model.userTadpole.y -= 20;
    } else {
        model.userTadpole.y += 20;
    }
    [self tadpoleMoved:model.userTadpole key:model.userTadpole.id];
    [model updateUserTadpole];
    NSLog(@"tapped at %.1f, %.1f", tapPoint.x, tapPoint.y);
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    double x = acceleration.x;
    double y = acceleration.y;
//    if (acceleration.x - BALANCE_POINT.x > HYSTERESIS_VALUE) {
        model.userTadpole.x += (x - BALANCE_POINT.x) * 15;
//    }
//    if (acceleration.y - BALANCE_POINT.y > HYSTERESIS_VALUE) {
        model.userTadpole.y -= (y - BALANCE_POINT.y) * 15;
//    }
    double ratio = x == 0 ? INFINITY : y/x;
    double angle = M_PI * round(x - 0.5f) + copysign(1.0, x * y) * atan(ratio);
    model.userTadpole.angle = angle;
    double momentum = sqrt(pow(x, 2.0) + pow(y, 2.0)) * 3 / 1.4;
    model.userTadpole.momentum = momentum;
    [self tadpoleMoved:model.userTadpole key:model.userTadpole.id];
    [model updateUserTadpole];
}

@end
