//
//  PFAlbumsViewController.m
//  Frames Sharing
//
//  Created by Terry Lewis II on 3/4/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFAlbumsViewController.h"
#import "Album.h"
#import "AlbumListData.h"
#import "PFAlbumDetailsViewController.h"
@interface PFAlbumsViewController () <UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *objects;
@property (strong, nonatomic)NSString *albumName;
@property (strong, nonatomic) IBOutlet UITextField *albumTxtField;


@end

@implementation PFAlbumsViewController
Manager * manager;
AlbumListData * albumsList;
UIActionSheet * loginActionSheet;

- (void)viewDidLoad
{
    [super viewDidLoad];
    manager = [Manager sharedInstance];
    self.user = manager.user;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(albumsRetrieved:) name:albumsRetrievedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(albumsRetrieved:) name:albumCreatedNotification object:nil];
    [self getAlbums:nil];
  
    albumsList = [[AlbumListData alloc]init];
    albumsList.storyboard  = self.storyboard;
    albumsList.navigationController = self.navigationController;
    
    self.tableView.dataSource  = albumsList;
    self.tableView.delegate = albumsList;
}

-(IBAction)getAlbums:(id)sender
{
    if(self.user){
        [manager getAlbumsForUser:[manager.ff metaDataForObj:self.user].guid];
    }
    else{
        [manager displayMessage:@"You need to login to see the albums."];
    }
 
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(void)albumsRetrieved:(NSNotification *)notification{
    albumsList.objects = notification.object;
    [self.tableView reloadData];
    
    
    
    NSLog(@"Albums Retrieved %@",notification.object);
}



- (IBAction)makeNewAlbum:(UIBarButtonItem *)sender {
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Album Name" message:@"Name this album" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK" , nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        self.albumName = [alertView textFieldAtIndex:0].text;
        
       
        
        if(self.albumName.length>0){
            if(manager.user){
                [manager createNewAlbumOfName:self.albumName forUser:[manager getGUID:manager.user] privacy:YES];
            }
            else{
             loginActionSheet = [[UIActionSheet alloc]initWithTitle:@"You need to login to continue. Would you like to login now?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
            }

        }
        else{
            NSLog(@"Length is wrong ??? album name is %@ %d",self.albumName,self.albumName.length );

            [manager displayMessage:@"Don't forget about album's title."];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0)
    {
        
    }
    else{
        
    }
}





//delegate methods
-(void)createdAlbum:(NSNotification*)notification{
    if(notification.object){
        Album * album = notification.object;
    
    
    [self.objects addObject:album];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.objects.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
}




@end
