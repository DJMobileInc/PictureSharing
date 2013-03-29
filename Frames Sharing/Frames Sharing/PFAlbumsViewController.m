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
@interface PFAlbumsViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *objects;
@property (strong, nonatomic)NSString *albumName;
@property (strong, nonatomic) IBOutlet UIView *addAlbumView;
@property (strong, nonatomic) IBOutlet UITextField *albumTxtField;


@end

@implementation PFAlbumsViewController
Manager * manager;
AlbumListData * albumsList;
- (void)viewDidLoad
{
    [super viewDidLoad];
    manager = [Manager sharedInstance];
    manager.delegate = self;
    [manager.ff setAutoLoadBlobs:NO];
    self.user = manager.user;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(albumsRetrieved:) name:albumsRetrievedNotification object:nil];
    
    if(self.user){
        [manager getAlbumsForUser:[manager.ff metaDataForObj:self.user].guid];
    }
    else{
        //[manager displayMessage:@"You need to login to see the albums."];
    }

    //hide elements if not my album
    if(self.user !=manager.user){
        
    }
    
    albumsList = [[AlbumListData alloc]init];
    albumsList.storyboard  = self.storyboard;
    albumsList.navigationController = self.navigationController;
    
    self.tableView.dataSource  = albumsList;
    self.tableView.delegate = albumsList;
    
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
        
        NSLog(@"album name is %@ %d",self.albumName,self.albumName.length );
        
        if(self.albumName.length>0){
            [self createAlbum:self.albumName];
        }
        else{
            NSLog(@"Length is wrong ??? album name is %@ %d",self.albumName,self.albumName.length );

            [manager displayMessage:@"Don't forget about album's title."];
        }
    }
}


-(void)createAlbum:(NSString *)name{
   
    if(manager.user){
        [manager createNewAlbumOfName:name forUser:[manager getGUID:manager.user] privacy:YES];
    }
    else{
        [manager displayMessage:@"You need to be logged in to create new album on the cloud."];
    }
}

//delegate methods
-(void)createdAlbum:(Album *)album{
//    NSLog(@"Album Created: %@", album);
    [self.objects addObject:album];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.objects.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}




@end
