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

@protocol ManagerDelegate
//@optional
//    -(void)downloadedPhotoFile:(Photo *)file forIndex:(NSIndexPath *)indexPath;
@end

@protocol ManagerDownloadDelegate

@end

@protocol ManagerExploreDelegate
    -(void)searchCompletedWithResults:(NSArray *)array;
@end


@interface Manager : NSObject
extern  NSString * const userRetrievedNotification;
extern  NSString * const albumsRetrievedNotification;
extern  NSString * const photosRetrievedNotification;
extern  NSString * const loginSucceededNotification;
extern  NSString * const albumCreatedNotification;


-(void)loggingInWithName:(NSString *)userName andPassword: (NSString *)password;
-(void)loggingInWithFacebook;

-(void)signUpWithName:(NSString *)userName andPassword: (NSString *)password;
-(void)updateUsernameForUserId:(NSString *)userId withName: (NSString *)name;

-(void)createNewAlbumOfName:(NSString *)name forUser:(NSString *)userId privacy:(BOOL)visible;
-(void)deleteAlbumOfName:(NSString *)name forUser:(NSString *)userId;
-(void)getPhotosForAlbum:(NSString *)albumId;

-(void)ratePhoto:(Photo *)photo;
-(void)createNewPhotoWithDescription:(NSString *)name forUser:(NSString *)userId forAlbum:(NSString *)albumId withData:(NSData *)imageData;
-(void)deletePhotoWithId:(NSString *)photoId forUser:(NSString *)userId forAlbum:(NSString *)album;
-(void)downloadPhotoWithId:(NSString *)photoId forUser:(NSString *)userId andIndex:(NSIndexPath * )indexPath;
-(void)getAlbumsForUser:(NSString *)userId;
-(void)displayMessage:(NSString *)message;
-(void)getNewestPhotos;
-(void)getHighestRatedPhotos;
-(void)getPhotosWithSearchQuery:(NSString *)searchQuery;
-(void)updateObject:(id)object;
-(void)getOwnerOfPhoto:(Photo *) photo;

-(void)showLoginScreenForViewController:(UIViewController *)vc fromStoryboard:(UIStoryboard *)storyboard;

@property (strong, nonatomic) FatFractal *ff;
@property(strong,nonatomic) FFUser *  user;
@property (assign) id <ManagerDelegate> delegate;
@property (assign) id <ManagerExploreDelegate> exploreDelegate;

+ (Manager *)sharedInstance;
-(void)testIt;
-(NSString *)getGUID:(id)object;

@end
