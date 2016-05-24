//
//  Movie.h
//  Rotten Mangoes
//
//  Created by Rosalyn Kingsmill on 2016-05-23.
//  Copyright © 2016 Rosalyn Kingsmill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSNumber* year;
@property (strong, nonatomic) NSString* rating;
@property (strong, nonatomic) NSString* synopsis;
@property (strong, nonatomic) NSString* movieImage;
//@property (strong, nonatomic) NSArray* review;
@property (strong, nonatomic) NSString* reviewURL;

@end
