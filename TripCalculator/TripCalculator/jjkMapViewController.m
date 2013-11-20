//
//  jjkMapViewController.m
//  TripCalculator
//
//  Created by Joshua Kuiros on 11/12/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "jjkMapViewController.h"
#import "jjkMapServices.h"
#import <GoogleMaps/GoogleMaps.h>

@interface jjkMapViewController ()
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) NSDictionary *geocodeStarting;
@property (strong, nonatomic) NSDictionary *geocodeDestination;
@property (strong, nonatomic) NSDictionary *temporaryDictionary;
@property (strong,nonatomic) NSData *data;
@property (strong,nonatomic) NSMutableArray *waypoints;
@property (strong,nonatomic) NSMutableArray *waypointStrings;
@end

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation jjkMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.geocodeStarting = [[NSDictionary alloc]initWithObjectsAndKeys:@"0.0",@"lat",@"0.0",@"lng",@"Null Island",@"address",nil];
        self.geocodeDestination = [[NSDictionary alloc]initWithObjectsAndKeys:@"0.0",@"lat",@"0.0",@"lng",@"Null Island",@"address",nil];
    }
    return self;
}

- (NSDictionary*)geocodeAddress:(NSString *)address{
    NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
    NSString *url = [NSString stringWithFormat:@"%@address=%@&sensor=false", geocodingBaseUrl,address];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
    dispatch_sync(kBgQueue, ^{
        
        NSData *data = [NSData dataWithContentsOfURL: queryUrl];
        
       self.temporaryDictionary = [self fetchedData:data];
        
    });
    
    return self.temporaryDictionary;
    
}

- (NSDictionary*)fetchedData:(NSData *)data{
    
    NSError* error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    NSArray* results = [json objectForKey:@"results"];
    NSDictionary *result = [results objectAtIndex:0];
    NSString *address = [result objectForKey:@"formatted_address"];
    NSDictionary *geometry = [result objectForKey:@"geometry"];
    NSDictionary *location = [geometry objectForKey:@"location"];
    NSString *lat = [location objectForKey:@"lat"];
    NSString *lng = [location objectForKey:@"lng"];
    
    NSDictionary *gc = [[NSDictionary alloc]initWithObjectsAndKeys:lat,@"lat",lng,@"lng",address,@"address",nil];
    
    return gc;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    self.geocodeStarting = [self geocodeAddress:self.starting];
    self.geocodeDestination = [self geocodeAddress:self.destination];
    //[self geocodeAddress:self.destination withDictionary:self.geocodeDestination];
    
    NSString *latitudeStart = [self.geocodeStarting objectForKey:@"lat"];
    NSString *longitudeStart = [self.geocodeStarting objectForKey:@"lng"];
    NSString *addressStart = [self.geocodeStarting objectForKey:@"address"];
    
    CLLocationDegrees latitude = [latitudeStart doubleValue];
    CLLocationDegrees longitude = [longitudeStart doubleValue];
    
    NSString *latitudeStop = [self.geocodeDestination objectForKey:@"lat"];
    NSString *longitudeStop = [self.geocodeDestination objectForKey:@"lng"];
    NSString *addressStop = [self.geocodeDestination objectForKey:@"address"];
    
    CLLocationDegrees latitudeStopDegrees = [latitudeStop doubleValue];
    CLLocationDegrees longitudeStopDegrees = [longitudeStop doubleValue];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:15];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
    marker.title = addressStart;
    marker.map = self.mapView;
    
    GMSMarker *markerStop = [[GMSMarker alloc] init];
    markerStop.position = CLLocationCoordinate2DMake(latitudeStopDegrees, longitudeStopDegrees);
    markerStop.title = addressStop;
    markerStop.map = self.mapView;
    
    
    
    
}


//- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
//{
//    NSLog(@"gettin called!");
//    
//    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
//                                                                 coordinate.latitude,
//                                                                 coordinate.longitude);
//    GMSMarker *marker = [GMSMarker markerWithPosition:position];
//    marker.map = self.mapView;
//    [self.waypoints addObject:marker];
//    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
//                                coordinate.latitude,coordinate.longitude];
//    [self.waypointStrings addObject:positionString];
//    if([self.waypoints count]>1){
//        NSString *sensor = @"false";
//        NSArray *parameters = [NSArray arrayWithObjects:sensor, self.waypointStrings,
//                               nil];
//        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
//        NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
//                                                          forKeys:keys];
//        jjkMapServices *mds=[[jjkMapServices alloc] init];
//        SEL selector = @selector(addDirections:);
//        [mds setDirectionsQuery:query
//                   withSelector:selector
//                   withDelegate:self];
//    }
//}
//
//
//
//
//- (void)addDirections:(NSDictionary *)json {
//    
//    NSDictionary *routes = [json objectForKey:@"routes"][0];
//    
//    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
//    NSString *overview_route = [route objectForKey:@"points"];
//    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
//    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
//    polyline.map = self.mapView;
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
