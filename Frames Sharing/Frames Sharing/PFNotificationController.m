//
//  PFNotificationController.m
//  Frames Sharing
//
//  Created by sadmin on 5/5/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFNotificationController.h"
#import "Manager.h"
#import "UserCell.h"
#import "NotificationCell.h"
#import "PFDisplayPhotoViewController.h"


@interface PFNotificationController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PFNotificationController
NSOperationQueue * queue;
Manager * manager;
NSMutableDictionary * userDictionary;
NSMutableDictionary * userOperations;
NSMutableArray * userNotifications;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}



-(void)viewWillDisappear:(BOOL)animated{
    [queue cancelAllOperations];
    manager.ff.autoLoadBlobs = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    userDictionary= [[NSMutableDictionary alloc]initWithCapacity:0];
    userNotifications = [[NSMutableArray alloc]initWithCapacity:0];
    
    if(self.user.notifications){
        for(int i = self.user.notifications.count-1; i>=0; i--)
        {
            [userNotifications addObject: [self.user.notifications objectAtIndex:i ]];
            
        }
    }
    
    queue = [[NSOperationQueue alloc]init];
  
    [self.tableView reloadData];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.contentSizeForViewInPopover =  CGSizeMake(320, 420);
    }
    
}


#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Notifications";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return userNotifications.count;
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
    
    NSString * g =[self getPhotoForPath:indexPath];
    if([userDictionary objectForKey:g])
    {
        User * user = (User *)[userDictionary objectForKey:g];
        // load picture
        cell.profileImageView.image = [UIImage imageWithData:[(User *)[userDictionary objectForKey:g]smallProfilePicture]];
        if([NSString stringWithFormat:@"%@",[[userNotifications objectAtIndex:indexPath.row]date]]){
        cell.dateLabel.text = [NSString stringWithFormat:@"%@",[[userNotifications objectAtIndex:indexPath.row]date]];
        }
            cell.message.text = [NSString stringWithFormat:@"%@",[[userNotifications objectAtIndex:indexPath.row]message]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return cell;
}

-(NSString *)getPhotoForPath: (NSIndexPath *)indexPath{
    NSBlockOperation * operation = [[NSBlockOperation alloc]init];
    NSBlockOperation * weakOperation = operation;
    
    Notification * notification =userNotifications[indexPath.row];
    NSString * guid = notification.from;
    if(!guid)
    {
        return @"";
    }
    
    if(![userDictionary objectForKey:guid]){
        
        [operation addExecutionBlock:^{
            if(!weakOperation.isCancelled){
                
                manager.ff.autoLoadBlobs = YES;
                NSError * error;
                User * newUser = [manager.ff getObjFromUri:[NSString stringWithFormat: @"/ff/resources/FFUser/(guid eq'%@')",guid] error:&error];
               
                NSMutableDictionary * dict = [userDictionary mutableCopy];
                if(newUser)
                {
                    [dict setObject:newUser forKey:guid];
                }
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //reload cell?
                    userDictionary = dict;
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                       
                }];
            }
        }];
        
        [queue addOperation:operation];
    }
    return guid;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSString * photoGuid =[userNotifications[indexPath.row]photoGuid];
    
    NSLog(@"Start");
    [manager.ff getObjFromUri:[NSString stringWithFormat:@"/ff/resources/Photo/(guid eq'%@')",photoGuid]  onComplete:^
                 (NSError *theErr, id theObj, NSHTTPURLResponse *theResponse){
                     if(!theErr)
                     {
                         PFDisplayPhotoViewController * pdp= [self.storyboard instantiateViewControllerWithIdentifier:@"PFDisplayPhotoViewController"];
                         Photo * p =  (Photo *)theObj;
                         pdp.photo =p;
                         [manager.currentNavigationController pushViewController:pdp animated:YES];
                         
                         [pdp changeDescription:p.description];
                         [pdp changeImage:[UIImage imageWithData:p.imageData]];

                     }
                     else{
                    
                     }
                     
                 }] ;
  
    
   

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
