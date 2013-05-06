//
//  PFiPadAlbumsViewController.m
//  Frames Sharing
//
//  Created by Janusz Chudzynski on 3/25/13.
//  Copyright (c) 2013 Blue Plover Productions. All rights reserved.
//

#import "PFiPadAlbumsViewController.h"
#import "AlbumListData.h"
#import "AlbumDetailsData.h"
#import "Manager.h"
#import "User.h"

@interface PFiPadAlbumsViewController()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSString * albumName;
- (IBAction)refreshAlbums:(id)sender;
- (IBAction)makeNewAlbum:(UIBarButtonItem *)sender;

@end

@implementation PFiPadAlbumsViewController
AlbumListData * albumsList;
- (IBAction)refreshAlbums:(id)sender {
 
    if(manager.user){
        if(!self.user){
            self.user = manager.user;
            [self getAlbums];
        }
        else{
            [self getAlbums];
        }
    }
    else{
    
    }
}
AlbumDetailsData * albumDetails;
Manager * manager;


- (IBAction)showMenu:(id)sender {
}




- (IBAction)makeNewAlbum:(UIBarButtonItem *)sender {
    if (!albumsList.objects) {
        albumsList.objects = [[NSMutableArray alloc] init];
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
                //[manager displayMessage:@"You need to be logged in to create new album on the cloud."];
                [manager displayActionSheetWithMessage:@"" forView:self.view navigationController:self.navigationController  andViewController:self];
            }
        }
        else{
            
            [manager displayMessage:@"Don't forget about album's title."];
        }
    }
}


-(void)viewDidLoad{
    albumsList = [[AlbumListData alloc]init];
    albumDetails = [[AlbumDetailsData alloc]init];
    self.collectionView.dataSource = albumDetails;
    self.collectionView.delegate = albumDetails;
    self.tableView.dataSource =  albumsList;
    
    albumsList = [[AlbumListData alloc]init];
    albumsList.storyboard  = self.storyboard;
    albumsList.navigationController = self.navigationController;
    albumDetails.navigationController=self.navigationController;
    albumDetails.storyboard = self.storyboard;
    
    self.tableView.dataSource  = albumsList;
    self.tableView.delegate = albumsList;
    manager = [Manager sharedInstance];
    
    albumDetails.manager = manager;
    
    
    if(manager.user){
        if(!self.user){
            self.user = manager.user;
        }
    }
    [self getAlbums];
}

-(void)albumCreated:(NSNotification *)notification{
    [self getAlbums];
}

-(void)albumsRetrieved:(NSNotification *)notification{
    albumsList.objects = notification.object;
    [self.tableView reloadData];
    
    NSLog(@"Albums Retrieved %@",notification.object);

    
}

-(void)photosRetrieved:(NSNotification *)notification{
 
    albumDetails.photoArray  = notification.object;
    [self.collectionView reloadData];
}


-(void)getAlbums{
  
    [manager getAlbumsForUser:[manager getGUID:self.user]];
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(albumsRetrieved:) name:albumsRetrievedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(photosRetrieved:) name:photosRetrievedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(albumCreated:) name:albumCreatedNotification object:nil];
    
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:albumsRetrievedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:photosRetrievedNotification object:nil];
 
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"menu"]) {
        [segue.destinationViewController performSelector:@selector(setCurrentNavigationController:)
                                              withObject:self.navigationController];
        NSLog(@"Segue menu");
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(    NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.collectionView reloadData];
}


@end
