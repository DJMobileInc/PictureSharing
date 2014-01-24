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
#import "SharedStore.h"
#import "Content.h"
#import "ContentPack.h"

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
       // NSLog(@" Img %@",img);
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
//NSString * const userRetrievedNotification = @"kUserRetrievedNotification";
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
            self.ff.debug = NO;
            [self.ff loginWithUserName:@"janek2004" andPassword:@"Stany174"];
            [[FatFractal main] registerClass:[User class] forClazz:@"FFUser"];

            
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

-(void)testRatings{
    Photo * p =      [self.ff getObjFromUri:@"/ff/resources/Photo/-y0-R7L8FEeoVsNjcjA0k6"];
    if(p){
        NSLog(@"Photo exists.");
        [p.ratings addObject:@"some stuff"];
        NSLog(@"added ");
        [p.ratings addObject:self.user];
        NSLog(@"added ");
        
    }
    [self.ff updateObj:p];
    
}

-(void)create100{
    SharedStore * store = [SharedStore sharedStore];
    NSMutableArray * items;
    if(store.allItems.count ==0){
        //get all items
        items = [store getAllItems];
    }
    else{
        items = store.allItems;
    }
    
    NSLog(@" Items %@",items);
    
  
    
    
    
    for(ContentPack *contentPack in items)
    {
         NSLog(@"Count of the  %d ",contentPack.freeContent.images.count);
        
        for(int i=0; i<contentPack.freeContent.images.count;i++){
         // UIImage * img =[UIImage imageNamed: [contentPack.freeContent.images objectAtIndex:i]];
            UIImage * img = [contentPack.freeContent.images objectAtIndex:i];
            NSLog(@"Img is %@",img);
            NSArray *a =@[@"zebra",@"horse",@"walen",@"panda"];
            NSString * description = [a objectAtIndex: arc4random()%a.count ];
            
            [self createNewPhotoWithDescription:description forAlbum:@"Y2K_iYcuEg8A_yuXnPny65" withData:UIImageJPEGRepresentation(img, 0.7) user:self.user];
       
        
        }
    }

}


#pragma mark login sheet message
UIViewController * currentViewController;

UIView * currentView;
-(void)displayActionSheetWithMessage:(NSString *)message forView:(UIView *)view navigationController:(UINavigationController *)nav andViewController:(id)viewController{
    currentViewController = viewController;
    if(nav){
        self.currentNavigationController = nav;
    }
      NSLog(@" current navigation controller %@  and nav %@ ",self.currentNavigationController, nav);
    
    currentView = view;
    loginActionSheet = [[UIActionSheet alloc]initWithTitle:@"You need to login to continue. Would you like to login now?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Yes", @"No",nil];
    
    NSLog(@"View for action sheet %@ ",view);
    [loginActionSheet showInView:view];
}

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

             [self displayMessage:@"We couldn't log in you at this time. Please try again."];


             if(theResponse.statusCode == 400){
                 NSLog(@"Error 1 %@",error.debugDescription);
                 error = nil;
                 FFUser *newUser = [[FFUser alloc] initWithFF:self.ff];
                 newUser.userName = userName;
                 [self.ff registerUser:newUser password:password error:&error];
                 if(error){
                     NSLog(@"Error %@",error.debugDescription);
                 }
             
             }

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


//Create and upload new photo
-(void)createNewPhotoWithDescription:(NSString *)description forAlbum:(NSString *)albumId withData:(NSData *)_imageData user :(User *)user{

    Photo * photo = [[Photo alloc]init];
    UIImage * ui = [UIImage imageWithData:_imageData];
   // ui = [ui imageByScalingProportionallyToSize:CGSizeMake(700, 700)];
    UIImage * thumbnail = [ui imageByScalingProportionallyToSize:CGSizeMake(300, 300)];
    
    NSData *thumbnailImageData = UIImageJPEGRepresentation(thumbnail,0.7); // 0.7 is JPG quality
    
    NSLog(@" thumbnail length %d %d", thumbnailImageData.length, _imageData.length);

    photo.thumbnailImageData = thumbnailImageData;
    photo.imageData= _imageData;
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

-(void)getFavoritePhotosForUser:(User *)user{
    

}


-(void)getNewestPhotos{
    
   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString * searchQuery = [NSString stringWithFormat:@"/ff/resources/Photo/(isPublic eq 1 and flag eq 0)?&count=500&start=0"];
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
             //NSLog(@"Photos Array %@",photosArray);
             
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
   /*
    if(image){
        [(ViewController *)vc setImageToDisplay:image];
        
    }
  */
    self.defaultImage = image;
    
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
        if(!popover){
            popover = [[UIPopoverController alloc]initWithContentViewController:lr];
        }
        else{
            [popover dismissPopoverAnimated:YES];
            popover = [[UIPopoverController alloc]initWithContentViewController:lr];
        }


        [popover presentPopoverFromRect:CGRectMake(view.center.x, view.frame.size.height,10, 10) inView:vc.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
     
        LoginRegisterViewController * lr = [storyboard  instantiateViewControllerWithIdentifier:@"LoginPopover"];
  
        [navigationController pushViewController:lr  animated:YES];

    }
}

-(void)showProfileForView:(UIView *)view andViewController:(id)vc fromNav:(BOOL)nav{
    if(self.user){
        PFProfileViewController * p;
        UIStoryboard * st;
        
        
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            st = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
            p =[st instantiateViewControllerWithIdentifier:@"PFProfileViewController"];
            p.user = self.user;
       
            
            if(nav){
                [[vc navigationController]pushViewController:p animated:YES];
    
            }
            else{
            
                
                if([self.profilePopover isPopoverVisible]){
                    [self.profilePopover dismissPopoverAnimated:YES];
                }
       
                if(!self.profilePopover)
                {
                    self.profilePopover = [[UIPopoverController alloc]initWithContentViewController:p];
                }
                else{
                    [self.profilePopover  presentPopoverFromRect:CGRectMake(view.center.x, view.frame.size.height,10, 10)  inView:view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
         
                }
            }
        }
        else{
            st = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            p =[st instantiateViewControllerWithIdentifier:@"PFProfileViewController"];
            p.user =self.user;
            [self.currentNavigationController pushViewController:p animated:YES];
            
        }
    }
    else
    {
        [self displayActionSheetWithMessage:@"You need to be logged in to continue." forView:view navigationController:self.currentNavigationController andViewController:vc];
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
