//
//  Manager.h
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/12/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"
@class Photo;
@class User;
@interface UIImage (Extras)
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize ;
- (UIImage *)crop:(CGRect)rect;
+ (void)saveImage:(UIImage *)image withName:(NSString *)name;
+ (UIImage *)loadImage:(NSString *)name;


@end;
@interface Manager : NSObject
extern  NSString * const userRetrievedNotification;
extern  NSString * const albumsRetrievedNotification;
extern  NSString * const photosRetrievedNotification;
extern  NSString * const loginSucceededNotification;
extern  NSString * const albumCreatedNotification;
extern  NSString * const photosRetrievedFromSearchNotification;
extern  NSString * const objectDeletedNotification;
extern  NSString * const photoCreatedNotification;
extern  NSString * const appURLString;


-(void)loggingInWithName:(NSString *)userName andPassword: (NSString *)password;
-(void)loggingInWithFacebook;

-(void)signUpWithName:(NSString *)userName andPassword: (NSString *)password;
-(void)updateUsernameForUserId:(NSString *)userId withName: (NSString *)name;

-(void)createNewAlbumOfName:(NSString *)name forUser:(NSString *)userId privacy:(BOOL)visible;
-(void)getPhotosForAlbum:(NSString *)albumId;

-(void)ratePhoto:(Photo *)photo;
-(void)createNewPhotoWithDescription:(NSString *)name forUser:(NSString *)userId forAlbum:(NSString *)albumId withData:(NSData *)imageData;
-(void)getAlbumsForUser:(NSString *)userId;
-(void)displayMessage:(NSString *)message;
-(void)getNewestPhotos;
-(void)getHighestRatedPhotos;
-(void)getPhotosWithSearchQuery:(NSString *)searchQuery;
-(void)updateObject:(id)object;
-(void)getOwnerOfPhoto:(Photo *) photo asynchronusly:(BOOL)yes;

-(void)showLoginScreenForViewController:(UIViewController *)vc fromStoryboard:(UIStoryboard *)storyboard;

-(void)showSharingCenterForPhoto:(UIImage *)resultImage andPopover:(UIPopoverController*)sharingCenterPopoverController inView:(UIView *)view andNavigationController: (id)navigationController fromBarButton:(UIButton *)button;

-(void)showPhotoEditorForNavigationController:(id)navigationController editImage:(UIImage *)image;

+ (Manager *)sharedInstance;
-(void)testIt;
-(NSString *)getGUID:(id)object;

@property (nonatomic, strong) UIImage * defaultImage;
@property (nonatomic, strong) UIImage * defaultFrame;
@property (nonatomic,strong) UIImage * modifiedImage;
@property (strong, nonatomic) FatFractal *ff;
@property(strong,nonatomic) User *  user;




@end
