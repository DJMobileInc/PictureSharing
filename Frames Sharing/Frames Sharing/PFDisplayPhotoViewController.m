//
//  PFDisplayPhotoViewController.m
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/19/13.


#import "PFDisplayPhotoViewController.h"
#import "Manager.h"
#import "PFProfileViewController.h"
#import "User.h"
#import "PFUsersViewController.h"

@interface PFDisplayPhotoViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ratingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIButton *authorButton;
- (IBAction)flagPhoto:(id)sender;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomToolbar;

@end

@implementation PFDisplayPhotoViewController
Manager * manager;
UIPopoverController * profilePopover;
UIPopoverController * likePopover;
UIBarButtonItem * newBarButtonItem;

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
    [manager displayActionSheetWithMessage:@"You need to be logged in to continue." forView:self.view navigationController:self.navigationController  andViewController:self];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    manager = [Manager sharedInstance];
       
    self.user = self.photo.owner;
    [self changeRatings:self.photo.ratings.count];
    [self.authorButton setTitle:self.user.userName forState: UIControlStateNormal];
    [self.authorButton addTarget:self action:@selector(authorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [manager.ff loadBlobsForObj:self.user  onComplete:^
     (NSError *theErr, id theObj, NSHTTPURLResponse *theResponse){
         self.profilePicture.image = [UIImage imageWithData:[(User *)theObj profilePicture]];
         
     }];
    //if the image data is null, load it and place the image in the imageView
    if(!self.photo.imageData || !self.photo.thumbnailImageData) {
        [MBProgressHUD showHUDAddedTo:self.imageView animated:YES];
        [manager.ff loadBlobsForObj:self.photo onComplete:^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse) {
            if(!theErr){
                self.photo = (Photo *)theObj;
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.imageView.image = [UIImage imageWithData:self.photo.imageData];
                    [MBProgressHUD hideAllHUDsForView:self.imageView animated:NO];
                }];
            }
            else {
                NSLog(@"%@", theErr.localizedDescription); //maybe put an actual error message for the user in here.
                [MBProgressHUD hideAllHUDsForView:self.imageView animated:NO];
            }
        }];
    }

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


- (IBAction)showUsersThatLike:(id)sender {
    if(manager.user){
        

        PFUsersViewController * p;
        UIStoryboard *  st = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        p = [st instantiateViewControllerWithIdentifier:@"PFUsersViewController"];
        p.photo = self.photo;

        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){

            UINavigationController * navCon = [[UINavigationController alloc]initWithRootViewController:p];
            if(!likePopover)
            {
                likePopover = [[UIPopoverController alloc]initWithContentViewController:navCon];
            }
            if([profilePopover isPopoverVisible]){
                [profilePopover dismissPopoverAnimated:YES];
            }
            if([likePopover isPopoverVisible]){
                [likePopover dismissPopoverAnimated:YES];
            }
           
            
            else{
                likePopover.popoverContentSize = CGSizeMake(320, 420);
                if(newBarButtonItem){
                    [likePopover presentPopoverFromBarButtonItem:newBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
                else{
                    
                    [likePopover presentPopoverFromRect:self.authorButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
            }
        }
        else{
           [self.navigationController pushViewController:p animated:YES];
            
        }
        
    }
    else{
        [manager displayActionSheetWithMessage:@"You need to be logged in to continue." forView:self.view navigationController:self.navigationController andViewController:self];

    
    }

}


-(void)changeRatings :(int)ratings{
     NSString * guid = [manager getGUID:manager.user];
    if(UI_USER_INTERFACE_IDIOM()!= UIUserInterfaceIdiomPad){
        if([self.photo.ratings containsObject:guid])
        {
            [self.voteButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        }
        else{
            [self.voteButton setImage:[UIImage imageNamed:@"nonstar"] forState:UIControlStateNormal];
        }
    }
    else{
        if([self.photo.ratings containsObject:guid])
        {
            [self.voteButton setImage:[UIImage imageNamed:@"buttonLike"] forState:UIControlStateNormal];
        }
        else{
            [self.voteButton setImage:[UIImage imageNamed:@"buttonLikeUnselected"] forState:UIControlStateNormal];
        }
    }
     NSString * s = [NSString stringWithFormat:@"%d Stars",ratings];
    if(ratings == 1){
        s = [NSString stringWithFormat:@"%d Star",ratings];
 
    }
   
   newBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:s style:UIBarButtonItemStyleBordered target:self action:@selector(showUsersThatLike:)];
    

    NSMutableArray * a =[NSMutableArray arrayWithArray:self.bottomToolbar.items];
    if(newBarButtonItem){
        [a replaceObjectAtIndex:2 withObject:newBarButtonItem];
    }
    [self.bottomToolbar setItems:a animated:YES];
    
    
}



- (IBAction)voteForPhoto:(id)sender {
    
   
    if(manager.user){

    //increase or decrease count
        NSString * guid = [manager getGUID:manager.user];
        NSString * photoGuid = [manager getGUID:self.photo];
        
        if([self.photo.ratings containsObject:guid])
        {
            NSMutableArray * a = self.photo.ratings.mutableCopy;
            
            [a removeObject:guid];
            self.photo.ratings = a;

        }
        else{
            if(manager.user){
               [self.photo.ratings addObject:guid];
               //send notification
                
                [self sendNotificationFrom:guid forToGuid:self.photo.owner forPhoto:photoGuid];
                NSMutableArray * fav =[NSMutableArray arrayWithArray: manager.user.favoritePictures];
                if(!fav)
                {
                    fav = [[NSMutableArray alloc]init];
                }
                
                if(![fav containsObject:photoGuid])
                {
                    [fav addObject:photoGuid];
                 }
                manager.user.favoritePictures  = fav;
            
            }
            else{
              
            }
        }
        
        [manager.ff updateObj:self.photo  onComplete:^
         (NSError *theErr, id theObj, NSHTTPURLResponse *theResponse){
             if(theObj){
                 self.photo = theObj;
            }
         }];
         
        [manager.ff updateObj:manager.user];

        [self changeRatings:self.photo.ratings.count];

    }
    else{
        [manager displayActionSheetWithMessage:@"You need to be logged in to continue." forView:self.view navigationController:self.navigationController andViewController:self];

    }
}

-(void)sendNotificationFrom:(NSString *)myGuid forToGuid:(User *)owner forPhoto:(NSString *)photoGuid{
    //get user. add notification.
    Notification * notification = [[Notification alloc]init];
    notification.read=NO;
    notification.message = [NSString stringWithFormat:@"%@ likes your photo.",owner.userName];
    notification.from =myGuid;
    notification.to = [manager getGUID:owner];
    notification.date = [NSDate new];
    notification.photoGuid = [manager getGUID: self.photo];
    
    ///get notifications
    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:owner.notifications];
    if(!array){
        array = [[NSMutableArray alloc]initWithCapacity:0];
    }
    [array addObject:notification];
    owner.notifications = array;
    //update object

    [manager.ff updateObj:owner onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if(!err)
        {
            User * u = obj;
            NSLog(@" Object Updated %@ %@", u, u.notifications);
            
            [manager.ff postObj:notification  toExtension:@"pushExtension" onComplete:^(NSError *err, id obj, NSHTTPURLResponse *response) {
                
              
                
            }];

        }
        else{
            NSLog(@" Object Not Updated %@",[err debugDescription]);
        }
        
    }];
    
    
}



- (IBAction)authorButtonPressed:(id)sender {
    if(manager.user){
        PFProfileViewController * p;
        UIStoryboard * st;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            st = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
            p =[st instantiateViewControllerWithIdentifier:@"PFProfileViewController"];
            p.user = self.user;
            
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
        [manager displayActionSheetWithMessage:@"You need to be logged in to continue." forView:self.view navigationController:self.navigationController  andViewController:self];
    }
}




@end
