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
#import "PFUsersViewController.h"

@interface PFDisplayMyPhotoViewController ()
@property (strong, nonatomic) IBOutlet UIView *buttonsView;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomToolbar;

@end

@implementation PFDisplayMyPhotoViewController
Manager * manager;
UIActionSheet * photoAction;
UIPopoverController * sharingPopover;
UIPopoverController * likePopover;
UIBarButtonItem * newBarButtonItem;


- (IBAction)showActionMenuForPhoto:(id)sender {
    photoAction = [[UIActionSheet alloc]initWithTitle:@"Photo Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share",@"Edit",@"Delete", nil];
    [photoAction showFromRect:_buttonsView.frame inView:self.view animated:YES ];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [manager showSharingCenterForPhoto:self.imageView.image andPopover:sharingPopover inView:self.view andNavigationController:self.navigationController fromBarButton:nil];
        }
            break;
        case 1:{
            [self showPhotoEditor:nil];
            
        }
            break;
        case 2:{
            [manager delete:self.photo];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
    
        default:
            break;
    }

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)deletePhoto:(id)sender {
    [manager delete:self.photo];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    manager = [Manager sharedInstance];
    self.description.delegate = self;
    [self changePrivacy:!self.photo.isPublic];
    [self changeRatings:self.photo.ratings.count];

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

- (IBAction)showPhotoEditor:(id)sender {
    [manager showPhotoEditorForNavigationController:self.navigationController editImage:self.imageView.image];
}

-(void)done{
    [self.description resignFirstResponder];
     self.navigationItem.rightBarButtonItem =nil;
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = anotherButton;

}
-(void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    self.navigationItem.rightBarButtonItem =nil;
    self.photo.description = self.description.text;
    [manager updateObject:self.photo];
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
            if([sharingPopover isPopoverVisible]){
                [sharingPopover dismissPopoverAnimated:YES];
            }
            if([likePopover isPopoverVisible]){
                [likePopover dismissPopoverAnimated:YES];
            }
            
            
            else{
                likePopover.popoverContentSize = CGSizeMake(320, 420);
                [likePopover presentPopoverFromBarButtonItem:[self.bottomToolbar.items objectAtIndex:0] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    
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
   // NSString * guid = [manager getGUID:manager.user];
    NSString * s = [NSString stringWithFormat:@"%d Stars",ratings];
    if(ratings == 1){
        s = [NSString stringWithFormat:@"%d Star",ratings];
        
    }
   
    NSLog(@" Ratings are : %@ %@",self.photo.ratings, self.photo);
    
    newBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:s style:UIBarButtonItemStyleBordered target:self action:@selector(showUsersThatLike:)];
    
    
    NSMutableArray * a =[NSMutableArray arrayWithArray:self.bottomToolbar.items];
    if(newBarButtonItem){
        [a replaceObjectAtIndex:0 withObject:newBarButtonItem];
    }
    [self.bottomToolbar setItems:a animated:YES];
    NSLog(@" ");
    
}



@end
