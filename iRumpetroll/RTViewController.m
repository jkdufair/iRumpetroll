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

@interface RTViewController ()
{
    RTModel *model;
    NSMutableDictionary *tadpoleViews;
}

@end

@implementation RTViewController

#pragma mark - RTModelDelegate implementation

- (void)tadpoleAdded:(RTTadpole *)tadpole key:(id)key
{
    UIView *newTadpoleView = [[UIView alloc] initWithFrame:CGRectMake([tadpole.x floatValue], [tadpole.y floatValue], 15, 15)];
    newTadpoleView.backgroundColor = [UIColor blueColor];
    [tadpoleViews setObject:newTadpoleView forKey:key];
    [self.view addSubview:newTadpoleView];
    NSLog(@"Tadpole added at [%@,%@]", tadpole.x, tadpole.y);
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
    tadpoleViews = [[NSMutableDictionary alloc] initWithCapacity:10];
    RTAppDelegate *appDelegate = (RTAppDelegate *)[[UIApplication sharedApplication] delegate];
    model = appDelegate.model;
    RTCamera *camera = [[RTCamera alloc] initWithView:self.view x:model.userTadpole.x y:model.userTadpole.y];
    model.camera = camera;
    model.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
