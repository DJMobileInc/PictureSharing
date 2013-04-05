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
        [manager showLoginScreenForViewController:self fromStoryboard:self.storyboard];
    
    }
}
AlbumDetailsData * albumDetails;
Manager * manager;

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
   // [self getAlbums];
    albumDetails.manager = manager;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(albumsRetrieved:) name:albumsRetrievedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(photosRetrieved:) name:photosRetrievedNotification object:nil]; 
    
#warning remove it 
    [manager loggingInWithName:@"Janek2004" andPassword:@"Stany174"];
    // [manager loggingInWithName:@"mobiledjapps@gmail.com" andPassword:@"Stany174"];
}

-(void)albumsRetrieved:(NSNotification *)notification{
    albumsList.objects = notification.object;
    [self.tableView reloadData];
    
    NSLog(@"Albums Retrieved %@",notification.object);
}

-(void)photosRetrieved:(NSNotification *)notification{
  //  NSLog(@"Photo Retrieved %@",notification.object);
    albumDetails.photoArray  = notification.object;
    [self.collectionView reloadData];
}


-(void)getAlbums{
     [manager getAlbumsForUser:[manager getGUID:self.user]];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:albumsRetrievedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:photosRetrievedNotification object:nil];
 
    
}


@end
