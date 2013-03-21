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

@interface UIImage (Extras)
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize ;
@end;
@implementation UIImage (Extras)
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
#pragma mark constants
NSString *baseUrl = @"http://djmobileinc.fatfractal.com/pictureframes";
NSString * const userRetrievedNotification = @"kUserRetrievedNotification";


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
            
            //delete all objects
           // [self deleteAll];
            
            
        }
    }
    return self;
}

-(void)deleteAll{
        NSArray * a = [[FatFractal main]getArrayFromUri:[NSString stringWithFormat:@"/ff/resources/Photo/"]];
    for(Photo * p in a){
        [self.ff deleteObj:p];
    }
    
    a = [[FatFractal main]getArrayFromUri:[NSString stringWithFormat:@"/ff/resources/PhotoFile/"]];
    for(id p in a){
        [self.ff deleteObj:p];
    }
   
    a = [[FatFractal main]getArrayFromUri:[NSString stringWithFormat:@"/ff/resources/PhotoFile/"]];
    for(id p in a){
        [self.ff deleteObj:p];
    }

    a = [[FatFractal main]getArrayFromUri:[NSString stringWithFormat:@"/ff/resources/Images/"]];
    for(id p in a){
        [self.ff deleteObj:p];
    }

    
}


#pragma mark message
-(void)displayMessage:(NSString *)message{

    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"User is: %@",self.user);
    NSLog(@"Username is: %@",self.user.userName);
    
}


#pragma mark user

//logging in:
-(void)loggingInWithFacebook{

}

-(void)loggingInWithName:(NSString *)userName andPassword: (NSString *)password{
   
//    NSError * error;
//    self.user = [[FatFractal main] loginWithUserName:userName andPassword:password error:&error];
//    
//    
    
       
    
    [[FatFractal main]loginWithUserName:userName andPassword:password onComplete: ^(NSError * error, id theObj, NSHTTPURLResponse * theResponse)
     {
         if(error){
             [self displayMessage:[error localizedDescription]];
         }
         else{
             self.user =  (FFUser *)theObj;
             [self displayMessage:@"Succesfully Logged In"];
             [self.delegate userLoggedIn:self.user];
         }

         
    }];
    
    
    
//    dispatch_async(
//                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
//                   ^{
//                       NSError * error;
//                       self.user = [[FatFractal main] loginWithUserName:userName andPassword:password error:&error];
//
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                           if(error){
//                               [self displayMessage:[error localizedDescription]];
//                           }
//                           else{
//                               [self displayMessage:@"Succesfully Logged In"];
//                               [self.delegate userLoggedIn:self.user];
//                           }
//  
//                       });
//                       
//    });
}

-(void)signUpWithName:(NSString *)userName andPassword: (NSString *)password{
    //for now using the auto registration
    //self.user = [[FatFractal main] loginWithUserName:userName andPassword:password];
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
    
    [self.ff createObj:album atUri:@"/Album" onComplete:
     ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
         if(!theErr){
             Album *album = theObj;
             [self.delegate createdAlbum:album];
             NSLog(@"Created album");
             
         }
         else{
             [self displayMessage:[theErr localizedDescription]];
              NSLog(@"Error while creating album");
         }
        
     }];
}


//Delete Albums
-(void)deleteAlbumOfName:(NSString *)name forUser:(NSString *)userId{
    
    
    
}

-(void)getPhotosForAlbum:(NSString *)albumId{
    [[FatFractal main]getArrayFromUri:[NSString stringWithFormat:@"/ff/resources/Photo/(albumId eq '%@')",albumId] onComplete:
     ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
         if(theErr){
             [self displayMessage:[theErr localizedDescription]];
         }
         else{
             //retrieved array of photos in album.
             NSArray * albumsArray = theObj;
             
             [self.delegate receivedPhotos:albumsArray];
         }
     }];
}



-(void)getAlbumsForUser:(NSString *)guid{
    
    [[FatFractal main]getArrayFromUri:[NSString stringWithFormat:@"/ff/resources/Album/(userId eq '%@')",guid] onComplete:
     ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
         if(theErr){
             [self displayMessage:[theErr localizedDescription]];
         }
         else{
             //retrieved array of albums.
             NSArray * albumsArray = theObj;
             [self.delegate receivedAlbums:albumsArray];

         }
     }];
}

//Album loaded..



#pragma mark photo

-(void)getOwnerOfPhoto:(Photo *) photo{
    //find album
    NSString * queryString  = [NSString stringWithFormat:@"/ff/resources/Album/(guid eq '%@')",photo.albumId];
    
    [[FatFractal main]getObjFromUri:queryString onComplete:
     ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
         if(theErr){
             //[self displayMessage:[theErr localizedDescription]];
         }
         else{
             //retrieved array of albums.
             Album * album = theObj;
             NSString * userGuid = album.userId;
             NSString * queryString  = [NSString stringWithFormat:@"/ff/resources/FFUser/%@",userGuid];
            //getting user
             [[FatFractal main]getObjFromUri:queryString onComplete:
              ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
              {
                  [[NSNotificationCenter defaultCenter] postNotificationName:userRetrievedNotification
                    object:theObj userInfo:nil];
              
              }];
         }
     }];
}

-(void)updateObject:(id)object{
    [self.ff updateObj:object onComplete:^(NSError *err, id obj, NSHTTPURLResponse *httpResponse) {
        if(!err)
        {
            NSLog(@" Object Updated");
        }

    }];
}


-(void)ratePhoto:(Photo *)photo{
    [self updateObject:photo];
}


//Create and upload new photo
-(void)createNewPhotoWithDescription:(NSString *)description forUser:(NSString *)userId forAlbum:(NSString *)albumId withData:(NSData *)_imageData{
    Photo * photo = [[Photo alloc]init];
    
    UIImage * ui = [UIImage imageWithData:_imageData];
    ui = [ui imageByScalingProportionallyToSize:CGSizeMake(800, 1024)];
    UIImage * thumbnail = [ui imageByScalingProportionallyToSize:CGSizeMake(100, 100)];

    NSData *thumbnailImageData = UIImageJPEGRepresentation(thumbnail, 0.7); // 0.7 is JPG quality
    NSData *imageData = UIImageJPEGRepresentation(ui, 0.7); // 0.7 is JPG quality
    
    photo.thumbnailImageData = thumbnailImageData;
    photo.imageData= imageData;
    photo.date = [NSDate new];
    photo.description= description;
    photo.albumId = albumId;

    
   //Upload file
    [self.ff createObj:photo atUri:@"/Photo" onComplete:
     ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
         if(!theErr){
             //Now we can update the file associated with it.
            //self.delegate pho
         }
         else{
             [self displayMessage:@"Error. File Couldn't be uploaded"];
         }
         
     }];
}


//Delete photo
-(void)deletePhotoWithId:(NSString *)photoId forUser:(NSString *)userId forAlbum:(NSString *)album{
    
}
//Download photo
-(void)downloadPhotoWithId:(NSString *)photoId forUser:(NSString *)userId andIndex:(NSIndexPath * )indexPath
{
    NSString * query = [NSString stringWithFormat:@"/ff/resources/Photo/(guid eq '%@')",photoId];
    
    [[FatFractal main]getObjFromUri:query onComplete:
     ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
         [self.delegate downloadedPhotoFile:(Photo *)theObj forIndex:indexPath];
     }];
}

-(void)getNewestPhotos{
//    NSString * query = [NSString stringWithFormat:@"/ff/resources/PhotoFile/(guid eq '%@')",photoId];
}

-(void)getPhotosWithSearchQuery:(NSString *)searchText{
//    NSString * searchQuery = [NSString stringWithFormat:@"/ff/resources/Photo/(title matches '\b%@\b' or description matches '\b%@\b')",searchText,searchText];
#warning TO DO fix the query
    NSString * searchQuery = [NSString stringWithFormat:@"/ff/resources/Photo/"];
        
    
    [[FatFractal main]getArrayFromUri:searchQuery onComplete:
     ^(NSError * theErr, id theObj, NSHTTPURLResponse * theResponse)
     {
         if(theErr){
             [self displayMessage:[theErr localizedDescription]];
         }
         else{
             //retrieved array of photos in album.
             NSArray * photosArray = theObj;
             NSLog(@"Photos Array %@",photosArray);
             [self.exploreDelegate searchCompletedWithResults:photosArray];
         }
     }];

    
}



-(void)testIt{
    //login user
    [self loggingInWithName:@"Janek2004" andPassword:@"Stany174"];
}









@end
