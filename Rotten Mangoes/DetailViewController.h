//
//  DetailViewController.h
//  Rotten Mangoes
//
//  Created by Rosalyn Kingsmill on 2016-05-23.
//  Copyright © 2016 Rosalyn Kingsmill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailRatingslabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) Movie* movie;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

