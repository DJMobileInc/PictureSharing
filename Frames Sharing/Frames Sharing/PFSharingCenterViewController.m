//
//  PFSharingCenterViewController.m
//  Frames Sharing
//
//  Created by sadmin on 4/3/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFSharingCenterViewController.h"
#import "Manager.h"
#import "SocialHelper.h"
#import "PFPickAlbumViewController.h"

@interface PFSharingCenterViewController ()

@end
Manager * manager;
SocialHelper * helper;


@implementation PFSharingCenterViewController
- (IBAction)shareWithTwitter:(id)sender {
    [helper postMessage:@"Message" image:self.imageToShare  andURL:[NSURL URLWithString: appURLString]        forService:SLServiceTypeTwitter andTarget:self];

}
- (IBAction)saveToRemoteAlbum:(id)sender {
    if(manager.user){
    PFPickAlbumViewController * pf = [self.storyboard instantiateViewControllerWithIdentifier:@"PFPickAlbumsViewController"];
    pf.user = manager.user;
    pf.imageToShare = self.imageToShare;
    [self.navigationController pushViewController:pf animated:YES];
    }
    else{
        [manager displayMessage:@"You need to login to complete this operation."];
    }
}

- (IBAction)shareWithFacebook:(id)sender {
     [helper postMessage:@"Message" image:self.imageToShare  andURL:[NSURL URLWithString: appURLString] forService:SLServiceTypeFacebook andTarget:self];
}

- (IBAction)shareWithEmail:(id)sender {
    MFMailComposeViewController  * mf=[[MFMailComposeViewController alloc]init];
    mf.mailComposeDelegate=self;
    
    //Setting Subject
    NSMutableString * body=[[NSMutableString alloc]initWithCapacity:0];
    NSString * tempString= [NSString stringWithFormat:@"<a href=\"%@\">Download App!</a>\n",[NSURL URLWithString: appURLString]];
    
    [body appendString:tempString];
    
    [mf setSubject:@"Hey, look at this!"];
    [mf setMessageBody:body isHTML:YES];
                            
    NSData *imageData = UIImagePNGRepresentation(self.imageToShare);
    [mf addAttachmentData:imageData mimeType:@"image/png" fileName:@"Image"];
    [self presentViewController:mf animated:YES completion:nil];
    
}

- (IBAction)saveToAlbumDevice:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.imageToShare, self, @selector(image:didFinishWithError:contextInfo:), nil);

}

- (IBAction)shareWithSinaWeibo:(id)sender {
   [helper postMessage:@"Message" image:self.imageToShare  andURL:[NSURL URLWithString: appURLString] forService:SLServiceTypeSinaWeibo andTarget:self];
}


#pragma mark email
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
    {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
                            
-(void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
                                    
                                
    }



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
    helper = [[SocialHelper alloc]init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) image: (UIImage *) image
didFinishWithError: (NSError *) error
   contextInfo: (void *) contextInfo{
    if(error!=nil)
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Image couldn't be saved at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
    }
    else{
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Image was successfully saved." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}


@end
