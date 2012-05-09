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

- (void)tadpoleMoved:(RTTadpole *)tadpole key:(id)key
{
    UIView *tadpoleView = [tadpoleViews objectForKey:key];
    [tadpoleView setFrame:CGRectMake(tadpole.x, tadpole.y, tadpole.size, tadpole.size)];
}

- (void)tadpoleAdded:(RTTadpole *)tadpole key:(id)key
{
    UIView *newTadpoleView = [[UIView alloc] initWithFrame:CGRectMake(tadpole.x, tadpole.y, tadpole.size, tadpole.size)];
    newTadpoleView.backgroundColor = [UIColor blueColor];
    [tadpoleViews setObject:newTadpoleView forKey:key];
    [self.view addSubview:newTadpoleView];
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
    tadpoleViews = [[NSMutableDictionary alloc] initWithCapacity:10];
    RTAppDelegate *appDelegate = (RTAppDelegate *)[[UIApplication sharedApplication] delegate];
    model = appDelegate.model;
    RTCamera *camera = [[RTCamera alloc] initWithView:self.view x:model.userTadpole.x y:model.userTadpole.y model:model];
    model.camera = camera;
    model.delegate = self;
    [self tadpoleAdded:model.userTadpole key:model.userTadpole.id];
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

- (void)viewDidAppear:(BOOL)animated
{
    [model.camera updateTranslateAndScale];
    [super viewDidAppear:animated];
}

@end
