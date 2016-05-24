//
//  MapViewController.m
//  Rotten Mangoes
//
//  Created by Rosalyn Kingsmill on 2016-05-24.
//  Copyright © 2016 Rosalyn Kingsmill. All rights reserved.
//

#import "MapViewController.h"
@import MapKit;
@import CoreLocation;
#import "Theatre.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *theatreMapView;
@property (assign, nonatomic) BOOL shouldZoomToUserLocation;
@property MKPointAnnotation *theatrePin;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSMutableArray *theatres;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shouldZoomToUserLocation = YES;
    self.theatreMapView.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 0;
        [self.theatreMapView setShowsUserLocation:YES];
        
        if ([CLLocationManager authorizationStatus] ==
            kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    
        }
                                     

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self.locationManager startUpdatingLocation];
        //[self.locationManager requestLocation];
        //[self.locationManager stopUpdatingLocation];
        
    } else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"User denied location tracking");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D userCoordinate = location.coordinate;
    NSLog(@"lat: %f, lng: %f", userCoordinate.latitude, userCoordinate.longitude);
    
    if (self.shouldZoomToUserLocation) {
        self.shouldZoomToUserLocation = NO;
        // Zoom to user's location
        
        MKCoordinateRegion userRegion = MKCoordinateRegionMake(userCoordinate, MKCoordinateSpanMake(0.008, 0.008));
        [self.theatreMapView setRegion:userRegion animated:YES];
        
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//        [geocoder geocodeAddressString:@"46 Spadina Ave, Toronto" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//            NSLog(@"Geocode Address: %@", placemarks);
//            
//            //CLPlacemark *placemark = placemarks[0];
//            //placemark.postalCode
//        }];
//
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            NSLog(@"Reverse Geocode: %@", placemarks);
            CLPlacemark *placemark = placemarks[0];
            self.postalCode = placemark.postalCode;
            NSLog (@"%@", self.postalCode);
        }];
        
        [self getTheatreList];
//        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
//        request.naturalLanguageQuery = @"Starbucks in Toronto";
//        
//        MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
//        [localSearch startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
//            for (MKMapItem *mapItem in response.mapItems) {
//                NSLog(@"%@", mapItem.placemark);
//            }
//        }];
    
}
}
#pragma mark - MKMapViewDelegate

//
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    
//    if (annotation == mapView.userLocation) {
//        return nil;
//    }
//    MKPinAnnotationView *theatrePin
//    MKAnnotationView *theatrePin = [mapView dequeueReusableAnnotationViewWithIdentifier:@"theatre"];
//    
//    if (!theatrePin) {
//        theatrePin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"theatre"];
//  
//        
//    }
//    
//    return theatrePin;
//    
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)getTheatreList {
    
    NSString *apiString = @"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json";
    self.postalCode = [self.postalCode stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *addressString = [@"?address=" stringByAppendingString:self.postalCode];
    NSString *stringWithAddress = [apiString stringByAppendingString:addressString];
    self.title = [self.title stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *movieString = [@"&movie=" stringByAppendingString:self.title];
    NSString *finalString = [stringWithAddress stringByAppendingString:movieString];
    
    NSURL *mapURL = [NSURL URLWithString:finalString];
    NSURLRequest *apiRequest = [NSURLRequest requestWithURL:mapURL];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *apiTask = [sharedSession dataTaskWithRequest:apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"completed response");
        
        if (!error) {
            NSError *jsonError;
            
            NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            //
            if (!jsonError) {
                NSLog(@"%@", parsedData);
                
                NSMutableDictionary *reposDictionary = [NSMutableDictionary dictionary];
                self.theatres = [NSMutableArray new];
                for (NSDictionary *theatreDict in parsedData[@"theatres"]) {
                    Theatre *newTheatre = [[Theatre alloc] init];
                    newTheatre.lat = theatreDict[@"lat"];
                    newTheatre.lon = theatreDict[@"lng"];
                    newTheatre.coordinate = CLLocationCoordinate2DMake([newTheatre.lat doubleValue], [newTheatre.lon doubleValue]);

                    [self.theatres addObject:newTheatre];
                }
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    //[self.theatreMapView reloadData];
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
                //
                
                // Do any additional setup after loading the view.
}

@end
