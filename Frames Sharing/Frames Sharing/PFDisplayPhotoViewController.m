//
//  PFDisplayPhotoViewController.m
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/19/13.


#import "PFDisplayPhotoViewController.h"
#import "Manager.h"
#import "PFProfileViewController.h"
#import "User.h"

@interface PFDisplayPhotoViewController ()
@property (strong, nonatomic) IBOutlet UIButton *authorButton;
- (IBAction)flagPhoto:(id)sender;

@end

@implementation PFDisplayPhotoViewController
Manager * manager;
UIPopoverController * profilePopover;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)flagPhoto:(id)sender {
    if(manager.user){
        self.photo.flag = YES;
        [manager updateObject:self.photo];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
    [manager displayActionSheetWithMessage:@"You need to be logged in to continue." forView:self.view navigationController:self.navigationController storyboard:self.storyboard andViewController:self];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    manager = [Manager sharedInstance];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userReceived:) name:userRetrievedNotification object:nil];
    
    [self getUser];
    [self changeRatings:self.photo.ratings.count];
    
}

-(void)getUser{
    [manager getOwnerOfPhoto:self.photo asynchronusly:YES];
}

-(void)userReceived:(NSNotification *)notification{
    self.user = notification.object;
    [self displayAuthor:self.user.userName];
    NSLog(@"User Retrieved %@ ",self.user);
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
    [self.authorButton setTitle:author forState:UIControlStateNormal];
}

- (IBAction)voteForPhoto:(id)sender {
    
    if(manager.user){
    //get guid
    NSString * userguid = [manager getGUID:manager.user];
    //increase or decrease count
    NSMutableArray * ratings = [[NSMutableArray alloc]initWithArray:self.photo.ratings];
    
    if([ratings containsObject:userguid])
    {
        [ratings removeObject:userguid];

    }
    else{
        [ratings addObject:userguid];
    }
    self.photo.ratings = ratings;
    //update object
    [manager ratePhoto:self.photo];
    //update ratings
  
    [self changeRatings:self.photo.ratings.count];
    }else{
        [manager displayMessage:@"You need to log in to do it."];
    
    }
}

- (IBAction)authorButtonPressed:(id)sender {
    if(manager.user){
        PFProfileViewController * p;
        UIStoryboard * st;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            st = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
            p =[st instantiateViewControllerWithIdentifier:@"PFProfileViewController"];
            NSLog(@" self.user %@ ",self.user);
            p.user = self.user;
               NSLog(@"p.user %@ ",p.user);
            
            if(!profilePopover)
            {
                profilePopover = [[UIPopoverController alloc]initWithContentViewController:p];
            }
            if([profilePopover isPopoverVisible]){
                [profilePopover dismissPopoverAnimated:YES];
            }
            else{
                [profilePopover presentPopoverFromRect:self.authorButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }  
        }
        else{
            st = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            p =[st instantiateViewControllerWithIdentifier:@"PFProfileViewController"];
            p.user = self.user;
            [self.navigationController pushViewController:p animated:YES];
            
        }
    }
    else
    {
        [manager displayActionSheetWithMessage:@"You need to be logged in to continue." forView:self.view navigationController:self.navigationController storyboard:self.storyboard andViewController:self];
    }
}




@end
