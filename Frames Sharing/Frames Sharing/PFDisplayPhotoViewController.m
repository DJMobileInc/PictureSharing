//
//  PFDisplayPhotoViewController.m
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/19/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFDisplayPhotoViewController.h"
#import "Manager.h"
#import "PFAlbumsViewController.h"
@interface PFDisplayPhotoViewController ()
@property (strong, nonatomic) IBOutlet UIButton *authorButton;

@end

@implementation PFDisplayPhotoViewController
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
    [self changeRatings:self.photo.ratings.count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeDescription:(NSString *)desc{
    self.description.text = desc;
}

-(void)changeImage:(UIImage *)image{
    self.imageView.image = image;
}

-(void)changeRatings :(int)ratings{
    self.starsCount.text = [NSString stringWithFormat:@"%d",ratings];
    NSString * userguid = [manager getGUID:manager.user];
    //increase or decrease count
    if([self.photo.ratings containsObject:userguid])
    {
        [self.voteButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    }
    else{
        [self.voteButton setImage:[UIImage imageNamed:@"nonstar"] forState:UIControlStateNormal];
    }
}

-(void)displayAuthor :(NSString *)author{
    

}

- (IBAction)voteForPhoto:(id)sender {
    //get guid
    NSString * userguid = [manager getGUID:manager.user];
    //increase or decrease count
    NSLog(@"Ratings before: %d",self.photo.ratings.count);
    NSMutableArray * ratings = [[NSMutableArray alloc]initWithArray:self.photo.ratings];
    
    if([ratings containsObject:userguid])
    {
        [ratings removeObject:userguid];

    }
    else{
        [ratings addObject:userguid];
        NSLog(@"Add Rating");
    }
    self.photo.ratings = ratings;
    //update object
    [manager ratePhoto:self.photo];
    //update ratings
    NSLog(@"Ratings after: %d",self.photo.ratings.count);
    [self changeRatings:self.photo.ratings.count];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
//    UIStoryboardSegue * segue = [self.storyboard displayUserAlbum
    PFAlbumsViewController * albums = [self.storyboard instantiateViewControllerWithIdentifier:@"PFAlbumsViewController"];
    //get owner of the photo hmmm
    
    
}



@end
