//
//  RotatingNavigationControllerViewController.m
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 4/19/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "RotatingNavigationControllerViewController.h"

@interface RotatingNavigationControllerViewController ()

@end

@implementation RotatingNavigationControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}


@end
