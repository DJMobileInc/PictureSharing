//
//  PFDisplayMyPhotoViewController.m
//  Frames Sharing
//
//  Created by sadmin on 3/15/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFDisplayMyPhotoViewController.h"
#import "Manager.h"
#import "Photo.h"
@interface PFDisplayMyPhotoViewController ()

@end

@implementation PFDisplayMyPhotoViewController
Manager * manager;
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
    manager = [Manager sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentTappedOn:(id)sender {
    if(self.segmentedControl.selectedSegmentIndex ==0)
    {
        self.photo.isPublic = YES;
    }
    else{
        self.photo.isPublic = NO;
    }
    [manager updateObject:self.photo];

}

-(void)setPhoto:(Photo *)photo{
    NSLog(@"Set Photo Was Called.");
    
}


-(void)changePrivacy:(BOOL)private{
    if(!private){
        self.segmentedControl.selectedSegmentIndex =0;
    }
    else{
        self.segmentedControl.selectedSegmentIndex =1;
    }
}

-(void)changeDescription:(NSString *)desc{
    self.description.text = desc;
}

-(void)changeImage:(UIImage *)image{
    self.imageView.image = image;
}

-(void)changeRatings :(int)ratings{
    self.starsCount.text = [NSString stringWithFormat:@"%d",ratings];
}


@end
