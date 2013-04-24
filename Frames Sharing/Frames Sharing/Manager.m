//
//  Manager.m
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/12/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "Manager.h"
#import "Photo.h"
#import "User.h"
#import "Album.h"
#import "PFProfileViewController.h"
#import "PFSharingCenterViewController.h"
#import "LoginRegisterViewController.h"
#import "ViewController.h"


@implementation UIImage (Extras)
+ (void)saveImage:(UIImage *)image withName:(NSString *)name {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:name];
    NSLog(@" Full path %@",fullPath);
    
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
}

+ (UIImage *)loadImage:(NSString *)name {
    NSString *fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:name];
    
    UIImage *img = [UIImage imageWithContentsOfFile:fullPath];
        NSLog(@" Img %@",img);
    return img;
}


- (UIImage *)crop:(CGRect)rect {
    
    rect = CGRectMake(rect.origin.x*self.scale,
                      rect.origin.y*self.scale,
                      rect.size.width*self.scale,
                      rect.size.height*self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:self.scale
                                    orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}



+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // this is actually the interesting part:
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    return newImage ;
}

@end;


@implementation Manager
@synthesize ff = _ff;
@synthesize popover;

#pragma mark constants
NSString *baseUrl = @"http://djmobileinc.fatfractal.com/pictureframes";
NSString * const userRetrievedNotification = @"kUserRetrievedNotification";
NSString * const albumsRetrievedNotification = @"kAlbumsRetrievedNotification";
NSString * const albumCreatedNotification = @"kAlbumsCreatedNotification";
NSString * const photosRetrievedNotification = @"kPhotosRetrievedNotification";
NSString * const loginSucceededNotification = @"kLoginNotification";
NSString * const objectDeletedNotification = @"objectDeletedNotification";
NSString * const photoCreatedNotification = @"photoCreatedNotification";;

NSString * const photosRetrievedFromSearchNotification=@"kPhotosRetrievedFromSearchNotification";
NSString * const appURLString = @"https://itunes.apple.com/us/app/ipicture-frames-lt/id508059391?ls=1&mt=8";

UIActionSheet *  loginActionSheet;

-(void)dismissPopovers{
    
    if(popover.isPopoverVisible){
        [popover dismissPopoverAnimated:YES];
    }
}

-(void)dismissPopover:(id)vc{

}


+ (Manager *)sharedInstance
{
    //  Static local predicate must be initialized to 0
    static Manager *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Manager alloc] init];
        // Do any other initialisation stuff here        
     });
    
    return sharedInstance;
}

-(id)init{
    if(self = [super init])
    {
        if(!_ff){
            self.ff = [[FatFractal alloc] initWithBaseUrl:baseUrl];
            self.ff.autoLoadBlobs = NO;
             [[FatFractal main] registerClass:[User class] forClazz:@"FFUser"];
           // [self deleteAll];
            
        }
        [self.ff registerClass:[User class] forClazz:@"FFUser"];
    }
    return self;
}

-(void)deleteAll{
        NSArray * a = [self.ff getArrayFromUri:[NSString stringWithFormat:@"/ff/resources/Photo/"]];
    for(Photo * p in a){
        [self.ff deleteObj:p];
    }
    
    a = [self.ff getArrayFromUri:[NSString stringWithFormat:@"/ff/resources/PhotoFile/"]];
    for(id p in a){
        [self.ff deleteObj:p];
    }
   
    a = [self.ff getArrayFromUri:[NSString stringWithFormat:@"/ff/resources/Album/"]];
    for(id p in a){
        [self.ff deleteObj:p];
    }

    a = [self.ff getArrayFromUri:[NSString stringWithFormat:@"/ff/resources/Images/"]];
    for(id p in a){
        [self.ff deleteObj:p];
    }

    
}

#pragma mark login sheet message
UIViewController * currentViewController;

UIView * currentView;
-(void)displayActionSheetWithMessage:(NSString *)message forView:(UIView *)view navigationController:(UINavigationController *)nav storyboard:(UIStoryboard *)storyboard andViewController:(id)viewController{
    currentViewController = viewController;
  
    self.currentNavigationController = nav;
    
      NSLog(@" %@ %@ ",self.currentNavigationController, nav);
    
    currentView = view;
    loginActionSheet = [[UIActionSheet alloc]initWithTitle:@"You need to login to continue. Would you like to login now?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Yes", @"No",nil];
    
    NSLog(@"View for action sheet %@ ",view);
    [loginActionSheet showInView:view];
}
/*
showLoginScreenForViewController:(UIViewController *)vc andNavigationController: (id)navigationController fromRectView:(UIView *)view
*/

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0)
    {
               
        [self showLoginScreenForViewController: currentViewController andNavigationController:self.currentNavigationController fromRectView:currentView];
         NSLog(@" Currrrrrent %@",self.currentNavigationController);
    }
    else{
        NSLog(@"1");        
    }
}

#pragma mark message
-(void)displayMessage:(NSString *)message{

    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


#pragma mark user


//logging in:
-(void)loggingInWithFacebook{

}

-(void)loggingInWithName:(NSString *)userName andPassword: (NSString *)password{

   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.ff loginWithUserName:userName andPassword:password onComplete: ^(NSError * error, id theObj, NSHTTPURLResponse * theResponse)
     {
         if(error){
             [self displayMessage:[error localizedDescription]];
         }
         else{
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             self.user =  theObj;
            [self displayMessage:@"Succesfully Logged In"];
             [[NSNotificationCenter defaultCenter]postNotificationName:loginSucceededNotification object:theObj];
             if([popover isPopoverVisible]){
                 [popover dismissPopoverAnimated:YES];
             }
         }

         
    }];
}

-(void)signUpWithName:(NSString *)userName andPassword: (NSString *)password{
    //for now using the auto registration
    
    [self loggingInWithName:userName andPassword:password];
    
}

-(void)updateUsernameForUserId:(NSString *)userId withName: (NSString *)name{
    
    
}

-(NSString *)getGUID:(id)object{
    
    NSString * guid = [[self.ff metaDataForObj:object]guid];
    return guid;
}


#pragma mark albums
//Create a new album
-(void)createNewAlbumOfName:(NSString *)name forUser:(NSString *)userId privacy:(BOOL)privacy{
   
       Album * album = [[Album alloc]init];
      // album.privacy = privacy;
       album.userId = userId;
       album.name=name;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.ff createObj:album atUri:@"/Album" onComplete:
     ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         if(!theErr){
             Album *album = theObj;
             [[NSNotificationCenter defaultCenter]postNotificationName:albumCreatedNotification object:album];
             
             NSLog(@"Created album");
             
         }
         else{
             [self displayMessage:[theErr localizedDescription]];
              NSLog(@"Error while creating album");
         }
        
     }];
}


-(void)getPhotosForAlbum:(NSString *)albumId{
   
   // [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.ff getArrayFromUri:[NSString stringWithFormat:@"/ff/resources/Photo/(albumId eq '%@')",albumId] onComplete:
     ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
        
         NSLog(@"Get Photos for Album retrieved");
         if(theErr){
             [self displayMessage:[theErr localizedDescription]];
         }
         else{
             //retrieved array of photos in album.
             [[NSNotificationCenter defaultCenter] postNotificationName:photosRetrievedNotification
                                                                 object:theObj userInfo:nil];
         }
        // [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
     }];
}


-(void)getAlbumsForUser:(NSString *)guid{
    
   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.ff getArrayFromUri:[NSString stringWithFormat:@"/ff/resources/Album/(userId eq '%@')",guid] onComplete:
     ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         if(theErr){
             [self displayMessage:[theErr localizedDescription]];
         }
         else{
             //retrieved array of albums.
             [[NSNotificationCenter defaultCenter] postNotificationName:albumsRetrievedNotification
                                                                 object:theObj userInfo:nil];
         }
     }];
}

//Album loaded..



#pragma mark photo

-(void)getOwnerOfPhoto:(Photo *) photo asynchronusly:(BOOL)yes{
    //find album
    NSString * queryString  = [NSString stringWithFormat:@"/ff/resources/Album/(guid eq '%@')",photo.albumId];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.ff getObjFromUri:queryString onComplete:
     ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         if(theErr){
             //[self displayMessage:[theErr localizedDescription]];
         }
         else{
             //retrieved array of albums.
             Album * album = theObj;
             NSString * userGuid = album.userId;
             NSString * queryString  = [NSString stringWithFormat:@"/ff/resources/FFUser/%@",userGuid];
            //getting user
             [self.ff getObjFromUri:queryString onComplete:
              ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
              {
                  [[NSNotificationCenter defaultCenter] postNotificationName:userRetrievedNotification
                    object:theObj userInfo:nil];
              
              }];
         }
     }];
}

-(void)updateObject:(id)object{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.ff updateObj:object onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if(!err)
        {
            NSLog(@" Object Updated %@", obj);
            if([obj isKindOfClass:[User class]]){
                self.user = (User *)obj;
            }
        }
        else{
            NSLog(@" Object Not Updated %@",[err debugDescription]);
        }

    }];
}


-(void)ratePhoto:(Photo *)photo{
    [self updateObject:photo];
}


//Create and upload new photo
-(void)createNewPhotoWithDescription:(NSString *)description forUser:(NSString *)userId forAlbum:(NSString *)albumId withData:(NSData *)_imageData user :(User *)user{

    Photo * photo = [[Photo alloc]init];
    UIImage * ui = [UIImage imageWithData:_imageData];
    ui = [ui imageByScalingProportionallyToSize:CGSizeMake(800, 1024)];
    UIImage * thumbnail = [ui imageByScalingProportionallyToSize:CGSizeMake(300, 300)];
    
    NSData *thumbnailImageData = UIImagePNGRepresentation(thumbnail); // 0.7 is JPG quality
    NSData *imageData = UIImagePNGRepresentation(ui); // 0.7 is JPG quality
    
    photo.thumbnailImageData = thumbnailImageData;
    photo.imageData= imageData;
    photo.date = [NSDate new];
    photo.description= description;
    photo.albumId = albumId;
    photo.owner =self.user;
    photo.isPublic = 0;
    
    
   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //Upload file
    [self.ff createObj:photo atUri:@"/Photo" onComplete:
     ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         if(theErr==nil){
             //Now we can update the file associated with it.
            //self.delegate pho
             [[NSNotificationCenter defaultCenter]postNotificationName:photoCreatedNotification object:nil];
                    
         }
         else{
             [self displayMessage:@"Error. File Couldn't be uploaded"];
         }
         
     }];
}

-(void)delete:(id)object{
   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.ff deleteObj:object onComplete: ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         if(theErr==nil){
             [[NSNotificationCenter defaultCenter]postNotificationName:objectDeletedNotification object:object];
             NSLog(@" object deleted ");
         }
         else{
             NSLog(@" object error deleted %@",[theErr debugDescription]);
         }
     }
             onOffline:^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
         if(theErr==nil){
             //[self displayMessage:@"Your device is offline"];
             
         }
     }];

}

-(void)getNewestPhotos{
    
   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString * searchQuery = [NSString stringWithFormat:@"/ff/resources/Photo/(isPublic eq 1 and flag eq 0)"];
    [self.ff getArrayFromUri:searchQuery onComplete:
     ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         if(theErr){
             [self displayMessage:[theErr localizedDescription]];
         }
         else{
             //retrieved array of photos in album.
             NSArray * photosArray = theObj;
             NSLog(@"Photos Array %@",photosArray);
             
             [[NSNotificationCenter defaultCenter]postNotificationName:photosRetrievedFromSearchNotification object:photosArray];
         }
     }];

}

-(void)getHighestRatedPhotos{
    

}


-(void)getPhotosWithSearchQuery:(NSString *)searchText{
    NSString * searchQuery = [NSString stringWithFormat:@"/ff/resources/Photo/(description matches '.*%@.*' and isPublic eq 1 and flag eq 0)", searchText];
    
[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.ff getArrayFromUri:searchQuery onComplete:
     ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         if(theErr){
             [self displayMessage:[theErr localizedDescription]];
         }
         else{
             //retrieved array of photos in album.
             NSArray * photosArray = theObj;
             [[NSNotificationCenter defaultCenter]postNotificationName:photosRetrievedFromSearchNotification object:photosArray];
             
             NSLog(@" search finished with photo array %@ ",photosArray);
             
         }
     }];
}


-(void)testIt{
    //login user
    [self loggingInWithName:@"Janek2004" andPassword:@"Stany174"];
}

-(void)showPhotoEditorForNavigationController:(id)navigationController editImage:(UIImage *)image{
    UIViewController *vc;
    if(UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
    {
        UIStoryboard *iPhoneStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        vc = [iPhoneStoryboard instantiateInitialViewController];
    }
    else{
        UIStoryboard *iPadStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
        vc =[iPadStoryboard instantiateInitialViewController];
    }
    if(image){
        [(ViewController *)vc setImageToDisplay:image];
        
    }
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if([vc isKindOfClass:[UINavigationController class]])
    {
       [navigationController pushViewController:[(UINavigationController * )vc topViewController] animated:YES];
    }
    else{
        [navigationController pushViewController:vc animated:YES];
    }
}

-(void)showLoginScreenForViewController:(UIViewController *)vc andNavigationController: (id)navigationController fromRectView:(UIView *)view{

    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
        
        LoginRegisterViewController * lr = [storyboard  instantiateViewControllerWithIdentifier:@"LoginPopover"];

        popover = [[UIPopoverController alloc]initWithContentViewController:lr];
        
        [popover presentPopoverFromRect:CGRectMake(view.center.x, view.frame.size.height,10, 10) inView:vc.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
     
        LoginRegisterViewController * lr = [storyboard  instantiateViewControllerWithIdentifier:@"LoginPopover"];
  
        [navigationController pushViewController:lr  animated:YES];

    }
}

-(void)showSharingCenterForPhoto:(UIImage *)resultImage andPopover:(UIPopoverController*)sharingCenterPopoverController inView:(UIView *)view andNavigationController: (id)navigationController fromBarButton:(UIButton *)barButton{
    PFSharingCenterViewController *vc;
   
    if(UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
    {
        //pick right storyboard
        UIStoryboard *iPhoneStoryboard = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
        vc = [iPhoneStoryboard instantiateViewControllerWithIdentifier:@"sharingCenterViewController"];
        vc.imageToShare = resultImage;
        //present it in popover
        popover = sharingCenterPopoverController;
        if(!popover)
        {
             popover = [[UIPopoverController alloc]initWithContentViewController:vc];
        }
        if([ popover isPopoverVisible]){
            [ popover dismissPopoverAnimated:YES];
        }
        else{
            [popover presentPopoverFromRect:CGRectMake(view.center.x, view.frame.size.height,10, 10)  inView:view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        }
    }
    else{
        UIStoryboard *iPadStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        vc =(PFSharingCenterViewController *) [iPadStoryboard instantiateViewControllerWithIdentifier:@"sharingCenterViewController"];
        vc.imageToShare = resultImage;
        
        [navigationController pushViewController:vc animated:YES];
        
    }
}







@end
