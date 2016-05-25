//
//  Theatre.h
//  Rotten Mangoes
//
//  Created by Rosalyn Kingsmill on 2016-05-24.
//  Copyright © 2016 Rosalyn Kingsmill. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface Theatre : NSObject <MKAnnotation>

@property NSString* lat;
@property NSString* lon;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
