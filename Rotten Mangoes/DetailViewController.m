//
//  DetailViewController.m
//  Rotten Mangoes
//
//  Created by Rosalyn Kingsmill on 2016-05-23.
//  Copyright © 2016 Rosalyn Kingsmill. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setMovie:(Movie*)movie {
    if (movie != _movie) {
        _movie = movie;
            
        // Update the view.
        //[self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.movie) {
        self.detailDescriptionLabel.text = self.movie.synopsis;
        self.detailTitleLabel.text = self.movie.title;
        NSString *year = [self.movie.year stringValue];
        self.detailYearLabel.text = year;
        self.detailRatingslabel.text = self.movie.rating;
        
        NSURL *url = [NSURL URLWithString:self.movie.movieImage];
        
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        
        //NSData *data = [NSData dataWithContentsOfURL:url];
        
        NSURLSession *sharedSession = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *apiTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.detailImageView.image = [UIImage imageWithData:data];
            });
        }];
        
        [apiTask resume];

        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
