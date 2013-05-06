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

@interface PFNotificationController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PFNotificationController
NSOperationQueue * queue;
Manager * manager;
NSMutableDictionary * userDictionary;


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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    userDictionary= [[NSMutableDictionary alloc]initWithCapacity:0];
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
    
    return self.user.notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
    
    NSString * g =[self getPhotoForPath:indexPath];
    if([userDictionary objectForKey:g])
    {
        User * user = (User *)[userDictionary objectForKey:g];
        // load picture
        cell.profileImageView.image = [UIImage imageWithData:[(User *)[userDictionary objectForKey:g]smallProfilePicture]];
        if([NSString stringWithFormat:@"%@",[[user.notifications objectAtIndex:indexPath.row]date]]){
        cell.dateLabel.text = [NSString stringWithFormat:@"%@",[[user.notifications objectAtIndex:indexPath.row]date]];
        }
            cell.message.text = [NSString stringWithFormat:@"%@",[[user.notifications objectAtIndex:indexPath.row]message]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return cell;
}

-(NSString *)getPhotoForPath: (NSIndexPath *)indexPath{
    NSBlockOperation * operation = [[NSBlockOperation alloc]init];
    NSBlockOperation * weakOperation = operation;
    
    Notification * notification =self.user.notifications[indexPath.row];
    NSString * guid = notification.from;
    
    if(![userDictionary objectForKey:guid]){
        
        [operation addExecutionBlock:^{
            if(!weakOperation.isCancelled){
                
                manager.ff.autoLoadBlobs = YES;
                NSError * error;
                User * newUser = [manager.ff getObjFromUri:[NSString stringWithFormat: @"/ff/resources/FFUser/(guid eq'%@')",guid] error:&error];
                manager.ff.autoLoadBlobs = NO;
                NSMutableDictionary * dict = [userDictionary mutableCopy];
                if(newUser)
                {
                    [dict setObject:newUser forKey:guid];
                }
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //reload cell?
                    userDictionary = dict;
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    NSLog(@"Reload");
                    
                }];
            }
        }];
        
        [queue addOperation:operation];
    }
    return guid;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * guid =[self.user.notifications[indexPath.row]from];
    NSLog(@"User Dictionary %@ guid %@ ",userDictionary,guid);
    User * user = [userDictionary objectForKey:guid];
    
    
    if(user){

        NSLog(@"User does exists ");
        [manager showProfileForView:self.view andViewController:self fromNav:YES];
    }
    else{
        NSLog(@"User doesn't exists");
    }

/*
    PFDisplayPhotoViewController * pdp;
    Photo * p;
    if(self.favoritesMode)
    {
        NSString * guid =  [self.user.favoritePictures objectAtIndex:indexPath.row];
        p = [currentPhotos objectForKey:guid];
        
    }
    else{
        p = [currentPhotoArray objectAtIndex:indexPath.row];
        
    }
    
    pdp= [self.storyboard instantiateViewControllerWithIdentifier:@"PFDisplayPhotoViewController"];
    pdp.photo = p;
    
    [self.navigationController pushViewController:pdp animated:YES];
    
    [pdp changeDescription:p.description];
    [pdp changeImage:[UIImage imageWithData:p.imageData]];
*/
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
