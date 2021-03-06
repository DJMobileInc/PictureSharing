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
@interface Manager : NSObject <UIActionSheetDelegate> 
//extern  NSString * const userRetrievedNotification;
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

-(void)createNewPhotoWithDescription:(NSString *)name forAlbum:(NSString *)albumId withData:(NSData *)imageData user :(User *)user;
-(void)getAlbumsForUser:(NSString *)userId;
-(void)displayMessage:(NSString *)message;
-(void)getNewestPhotos;
-(void)getHighestRatedPhotos;
-(void)getPhotosWithSearchQuery:(NSString *)searchQuery;
-(void)updateObject:(id)object;
-(void)showProfileForView:(UIView *)view andViewController:(id)vc fromNav:(BOOL)nav;

-(void)showLoginScreenForViewController:(UIViewController *)vc andNavigationController: (id)navigationController fromRectView:(UIView *)view;


-(void)showSharingCenterForPhoto:(UIImage *)resultImage andPopover:(UIPopoverController*)sharingCenterPopoverController inView:(UIView *)view andNavigationController: (id)navigationController fromBarButton:(UIButton *)button;

-(void)showPhotoEditorForNavigationController:(id)navigationController editImage:(UIImage *)image;
-(void)displayActionSheetWithMessage:(NSString *)message forView:(UIView *)view navigationController:(UINavigationController *)nav  andViewController:(id)viewController;
/*it will retrieve the list of the photos that was like by user*/
-(void)getFavoritePhotosForUser:(User *)user;
+ (Manager *)sharedInstance;

-(void)testIt;
-(NSString *)getGUID:(id)object;

@property (nonatomic, strong) UIImage * defaultImage;
@property (nonatomic, strong) UIImage * defaultFrame;
@property (nonatomic,strong)  UIImage * modifiedImage;
@property (strong, nonatomic,readonly) FatFractal *ff;
@property(strong,nonatomic) User *  user;
@property (strong,nonatomic)UINavigationController * currentNavigationController;
@property (strong, nonatomic)  UIPopoverController * popover;
@property (strong, nonatomic)  UIPopoverController * profilePopover;
-(void)dismissPopovers;



@end
