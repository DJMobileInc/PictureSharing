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
@optional
    -(void)createdAlbum:(Album *)album;
    -(void)receivedAlbums:(NSArray *)albums;
    -(void)receivedPhotos:(NSArray *)photos;
    -(void)userLoggedIn:(id) user;
    -(void)uploadedPhoto;
    -(void)downloadedPhotoFile:(Photo *)file forIndex:(NSIndexPath *)indexPath;
@end

@protocol ManagerDownloadDelegate

@end

@protocol ManagerExploreDelegate
    -(void)searchCompletedWithResults:(NSArray *)array;
@end


@interface Manager : NSObject

-(void)loggingInWithName:(NSString *)userName andPassword: (NSString *)password;
-(void)loggingInWithFacebook;
-(void)signUpWithName:(NSString *)userName andPassword: (NSString *)password;
-(void)updateUsernameForUserId:(NSString *)userId withName: (NSString *)name;

-(void)createNewAlbumOfName:(NSString *)name forUser:(NSString *)userId privacy:(BOOL)visible;
-(void)deleteAlbumOfName:(NSString *)name forUser:(NSString *)userId;
-(void)getPhotosForAlbum:(NSString *)albumId;

-(void)ratePhotoByUserWithId:(NSString *)userId;
-(void)createNewPhotoWithDescription:(NSString *)name forUser:(NSString *)userId forAlbum:(NSString *)albumId withData:(NSData *)imageData;
-(void)deletePhotoWithId:(NSString *)photoId forUser:(NSString *)userId forAlbum:(NSString *)album;
-(void)downloadPhotoWithId:(NSString *)photoId forUser:(NSString *)userId andIndex:(NSIndexPath * )indexPath;
-(void)getAlbumsForUser:(NSString *)userId;
-(void)displayMessage:(NSString *)message;

-(void)getNewestPhotos;
-(void)getPhotosWithSearchQuery:(NSString *)searchQuery;

@property (strong, nonatomic) FatFractal *ff;
@property(strong,nonatomic) FFUser *  user;
@property (assign) id <ManagerDelegate> delegate;
@property (assign) id <ManagerExploreDelegate> exploreDelegate;

+ (Manager *)sharedInstance;
-(void)testIt;
-(NSString *)getGUID:(id)object;

@end
