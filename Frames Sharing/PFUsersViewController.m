//
//  PFUsersViewController.m
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 4/27/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFUsersViewController.h"
#import "Manager.h"
#import "User.h"
#import "UserCell.h"

@interface PFUsersViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PFUsersViewController
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
    NSLog(@" Photo. %@ %d",self.photo,self.photo.ratings.count);
    [self.tableView reloadData];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.contentSizeForViewInPopover =  CGSizeMake(320, 420);
    }
    
}


#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"People that Liked it:";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.photo.ratings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    
  // NSString  * userGuid = self.photo.ratings[indexPath.row];
   //we need to 1 get all users 2 load metadata 3 load pictures
   

    NSString * g =[self getPhotoForPath:indexPath];
    if([userDictionary objectForKey:g])
    {
       User * user = (User *)[userDictionary objectForKey:g];
        // load picture
        cell.profilePictureImageView.image = [UIImage imageWithData:[(User *)[userDictionary objectForKey:g]smallProfilePicture]];
        cell.userNameLabel.text = user.userName;
        cell.descriptionLabel.text =user.aboutDescription;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return cell;
}

-(NSString *)getPhotoForPath: (NSIndexPath *)indexPath{
    NSBlockOperation * operation = [[NSBlockOperation alloc]init];
    NSBlockOperation * weakOperation = operation;

    NSString * guid =self.photo.ratings[indexPath.row];
    
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
        NSString * guid =self.photo.ratings[indexPath.row];
        User * user = [userDictionary objectForKey:guid];
        if(user){
        //show profile right?
            [manager showProfileForView:self.view andViewController:self fromNav:YES];
        }
        else{
            NSLog(@"User doesn't exists");
        }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
