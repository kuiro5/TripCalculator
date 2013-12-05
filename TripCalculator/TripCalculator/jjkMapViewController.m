//
//  jjkMapViewController.m
//  TripCalculator
//
//  Created by Joshua Kuiros on 11/12/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "jjkMapViewController.h"

@interface jjkMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property CLLocationCoordinate2D startingLocation;
@property CLLocationCoordinate2D destinationLocation;
@property (strong, nonatomic) NSMutableArray *geocodedAddresses;
@property (strong, nonatomic) NSMutableArray *routePoints;

@end

@implementation jjkMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"check");
        self.mapView.showsUserLocation = YES;
        
    }
    return self;
}

-(void)putObject:(MKMapItem*)mapItem
{
   
    NSLog(@"inside put object");
    [self.geocodedAddresses addObject:mapItem];
}

-(void)geocodeAddress:(NSMutableArray*)locations
{
    
    
    __block NSInteger i = 0;
    
    
    for(NSString *address in locations)
    {
    
    self.geocoder = [[CLGeocoder alloc] init];
    __block CLLocationCoordinate2D coordinate;
    __block MKMapItem *srcItem;
   // __block NSMutableArray *geocodedAddresses =[[NSMutableArray alloc]initWithCapacity:4];
    
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if ([placemarks count] > 0)
        {
            NSLog(@"inside placemark count");
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            coordinate = location.coordinate;
            
            [self.routePoints addObject:location];
            
            MKPlacemark *srcMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
            srcItem = [[MKMapItem alloc] initWithPlacemark:srcMark];
            [self putObject:srcItem];
            //[self.geocodedAddresses addObject:srcItem];
            i++;
            
            [self updateMapView:coordinate withName:address];
        }
        
        
        NSLog(@"%d",i);
        
        if(i == 2)
        {
            [self scaleMapView:self.routePoints];
            [self calculateDirections:self.geocodedAddresses];
        }
        
    }];
    
        
    }
    
    
}

-(void)scaleMapView:(NSMutableArray*)routePoints
{
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    
    for(int i = 0; i < routePoints.count; i++)
    {
        CLLocation *currentLocation = [self.routePoints objectAtIndex:i];
        if(currentLocation.coordinate.latitude > maxLat)
            maxLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.latitude < minLat)
            minLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.longitude > maxLon)
            maxLon = currentLocation.coordinate.longitude;
        if(currentLocation.coordinate.longitude < minLon)
            minLon = currentLocation.coordinate.longitude;
    }
    
    MKCoordinateRegion region;
    region.center.latitude = (maxLat + minLat) / 2;
    region.center.longitude = (maxLon + minLon) / 2;
    region.span.latitudeDelta = (maxLat - minLat) * 1.2;
    region.span.longitudeDelta = (maxLon - minLon) * 1.2;
    
    [self.mapView setRegion:region];
    
    
}

-(void)calculateDirections:(NSMutableArray*)addresses
{
    NSLog(@"getting called");
    
    MKMapItem *temporary =[addresses objectAtIndex:0];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = temporary;
    
    temporary =[addresses objectAtIndex:1];
    
    request.destination = temporary;
    
    request.requestsAlternateRoutes = YES;
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle Error
         } else {
             [self showRoute:response];
         }
     }];
    
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    self.geocodedAddresses = [[NSMutableArray alloc] init];
    self.routePoints = [[NSMutableArray alloc] init];
    
    NSMutableArray *locations = [[NSMutableArray alloc]initWithObjects:self.starting, self.destination, nil];
    
    [self geocodeAddress:locations];
    
}

- (void) updateMapView:(CLLocationCoordinate2D)currentCoordinate withName:(NSString*)name
{
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentCoordinate, 20000, 20000);
    [self.mapView setRegion:region];
    
    //[self.mapView removeAnnotations:[self.mapView annotations]];
    
    MKPointAnnotation *startAnnotation = [[MKPointAnnotation alloc] init];
    [startAnnotation setCoordinate:currentCoordinate];
    [startAnnotation setTitle:name];
    [startAnnotation setSubtitle:[NSString stringWithFormat:@"%f, %f", currentCoordinate.longitude, currentCoordinate.latitude]];
    [self.mapView addAnnotation:startAnnotation];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

}

@end
