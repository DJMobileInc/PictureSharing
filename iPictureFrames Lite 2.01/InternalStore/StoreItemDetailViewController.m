//
//  StoreItemDetailViewController.m
//  GiftMaker
//
//  Created by Janusz Chudzynski on 11/30/12.
//  Copyright (c) 2012 Janusz Chudzynski. All rights reserved.
//

#import "StoreItemDetailViewController.h"

@interface StoreItemDetailViewController ()

@end

@implementation StoreItemDetailViewController
@synthesize imageView;


-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         NSLog(@"Image in Init %@ ",self.image);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if(self.image){
    NSLog(@"Image in Init View Did Load %@ ",self.image);
    self.imageView.image = self.image;

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
