//
//  User.h
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/12/13.
//

#import <Foundation/Foundation.h>
#import "Notification.h"

@interface User : FFUser
//since we are extending the class we need to make sure to use backend.
@property (nonatomic, retain) NSString * aboutDescription;
@property (nonatomic, retain) NSData * profilePicture;
@property (nonatomic, retain) NSData * smallProfilePicture;
@property (nonatomic, retain) NSMutableArray * favoritePictures; //either guid or photo by itself.
@property(nonatomic,retain) NSMutableArray * notifications;


@end
