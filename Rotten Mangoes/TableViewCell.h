//
//  TableViewCell.h
//  Rotten Mangoes
//
//  Created by Rosalyn Kingsmill on 2016-05-23.
//  Copyright © 2016 Rosalyn Kingsmill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *reviewQuoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewCriticLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewFreshnessLabel;

@end
