//
//  ReviewsViewController.m
//  Rotten Mangoes
//
//  Created by Rosalyn Kingsmill on 2016-05-23.
//  Copyright © 2016 Rosalyn Kingsmill. All rights reserved.
//

#import "ReviewsViewController.h"
#import "TableViewCell.h"

@interface ReviewsViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *reviewTableView;

@end

@implementation ReviewsViewController


//
//- (void)configureView {
//    // Update the user interface for the detail item.
//    if (self.reviewURL) {
//        
//        NSURLRequest* request = [NSURLRequest requestWithURL:self.reviewURL];
//        
//        NSURLSession *sharedSession = [NSURLSession sharedSession];
//        
//        NSURLSessionDataTask *apiTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//            });
//        }];
//        
//        [apiTask resume];
//        
//        
//    }
//}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSURLRequest *apiRequest = [NSURLRequest requestWithURL:self.reviewURL];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
   // NSData *data = [NSData dataWithContentsOfURL:self.reviewURL];
    
    NSURLSessionDataTask *apiTask = [sharedSession dataTaskWithRequest:apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"completed response");
        
        if (!error) {
            NSError *jsonError;
            
            //NSData *someBadData = [@"asdfasdfasdfa,sdfasdf[]" dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError) {
                NSLog(@"%@", parsedData);
                
                self.reviews = [NSMutableArray new];
                for (NSDictionary *reviewDict in parsedData[@"reviews"]) {
                    Review *newReview = [[Review alloc] init];
                    newReview.critic = reviewDict[@"critic"];
                    newReview.score = reviewDict[@"original_score"];
                    newReview.freshness = reviewDict[@"freshness"];
                    newReview.quote = reviewDict[@"quote"];
                    
                    [self.reviews addObject:newReview];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.reviewTableView reloadData];
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
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger i = (int) fmin (3, self.reviews.count);

       return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reviewCell" forIndexPath:indexPath];
    
    Review *review = self.reviews[indexPath.row];
    
    cell.reviewQuoteLabel.text = review.quote;
    cell.reviewCriticLabel.text = review.critic;
    cell.reviewRatingLabel.text = review.rating;
    cell.reviewFreshnessLabel.text = review.freshness;

    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
