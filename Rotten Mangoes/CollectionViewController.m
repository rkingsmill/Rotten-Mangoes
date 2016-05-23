//
//  CollectionViewController.m
//  Rotten Mangoes
//
//  Created by Rosalyn Kingsmill on 2016-05-23.
//  Copyright © 2016 Rosalyn Kingsmill. All rights reserved.
//

#import "CollectionViewController.h"
#import "Movie.h"
#import "DetailViewController.h"
#import "CustomCollectionViewCell.h"

@interface CollectionViewController ()

@property NSMutableArray *movieObjects;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *movieURL = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=j9fhnct2tp8wu2q9h75kanh9"];
    NSURLRequest *apiRequest = [NSURLRequest requestWithURL:movieURL];
    
    //NSData *data = [NSData dataWithContentsOfURL:movieURL];
    
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *apiTask = [sharedSession dataTaskWithRequest:apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"completed response");
        
        if (!error) {
            NSError *jsonError;
            
            //NSData *someBadData = [@"asdfasdfasdfa,sdfasdf[]" dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError) {
                NSLog(@"%@", parsedData);
                
                //NSMutableDictionary *reposDictionary = [NSMutableDictionary dictionary];
                self.movieObjects = [NSMutableArray new];
                for (NSDictionary *movieDict in parsedData[@"movies"]) {
                    Movie *newMovie = [[Movie alloc] init];
                    newMovie.title = movieDict[@"title"];
                    newMovie.year = movieDict[@"year"];
                    newMovie.rating = movieDict[@"mpaa_rating"];
                    newMovie.synopsis = movieDict[@"synopsis"];
                    newMovie.movieImage = movieDict[@"posters"][@"thumbnail"];
                    
                    [self.movieObjects addObject:newMovie];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
                
            } else {
                NSLog(@"Error parsing JSON: %@", [jsonError localizedDescription]);
            }
            
        } else {
            NSLog(@"%@", [error localizedDescription]);
        }
        
    }];
    
    NSLog(@"Before resume");
    [apiTask resume];
    NSLog(@"After resume");
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        Movie *movie = self.movieObjects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setMovie:movie];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.movieObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    Movie *movie = self.movieObjects[indexPath.row];
    
    NSURL *url = [NSURL URLWithString:movie.movieImage];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    
    //NSData *data = [NSData dataWithContentsOfURL:movieURL];
    
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *apiTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.cellImageView.image = [UIImage imageWithData:data];
        });
    }];
    
    [apiTask resume];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
