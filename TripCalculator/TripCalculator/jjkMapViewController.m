//
// Mike Green Josh Kuiros
// Final Project
// 12/16/13
//

#import "jjkMapViewController.h"

#define LONGITUDE_FACTOR 2
#define DELTA_FACTOR 1.2
#define LATITUDE 90
#define LONGITUDE 180
#define MAX_DISTANCE 99999999999999999
#define POLY_LINE_WIDTH 5.0
#define COORDINATE_OFFSET .01
#define ANNOTATION_OFFSET 5
#define DEFAULT_REGION 20000

@interface jjkMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property CLLocationCoordinate2D startingLocation;
@property CLLocationCoordinate2D destinationLocation;
@property (strong, nonatomic) NSMutableArray *geocodedAddresses;
@property (strong, nonatomic) NSMutableArray *routePoints;
@property (strong, nonatomic) MKDirectionsResponse *route;
@property (strong, nonatomic) MKRoute *shortestRoute;

@end

@implementation jjkMapViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _model = [Model sharedInstance];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self addCostsToMap];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.shortestRoute = [[MKRoute alloc] init];
    self.mapView.delegate = self;
    self.geocodedAddresses = [[NSMutableArray alloc] init];
    self.routePoints = [[NSMutableArray alloc] init];
    
    NSMutableArray *locations = [[NSMutableArray alloc]initWithObjects:self.starting, self.destination, nil];
    
    [self geocodeAddress:locations];
    
    [self addCostsToMap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)putObject:(MKMapItem*)mapItem            // function created to add mapItem within the geocode block
{
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
    
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {          // geocoder completion block
        
        if ([placemarks count] > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            coordinate = location.coordinate;
            
            [self.routePoints addObject:location];                  // add location to array used for scaling the map based on CLLocations
            
            MKPlacemark *srcMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
            srcItem = [[MKMapItem alloc] initWithPlacemark:srcMark];
            [self putObject:srcItem];                               // add geocoded addresses
         
            i++;
            
            [self updateMapView:coordinate withName:address];
        }
        
        if(i == 2)              // destination and source have been geocoded
        {
            
            [self scaleMapView:self.routePoints];
            [self calculateDirections:self.geocodedAddresses];
        }
    }];
    }
}

-(void)scaleMapView:(NSMutableArray*)routePoints            // scales map view based on max longitude/latitude of points
{
    CLLocationDegrees minLon = LONGITUDE;
    CLLocationDegrees maxLon = -LONGITUDE;
    CLLocationDegrees minLat = LATITUDE;
    CLLocationDegrees maxLat = -LATITUDE;
    int i;
    
    for(i = 0; i < routePoints.count; i++)
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
    region.center.latitude = (maxLat + minLat) / LONGITUDE_FACTOR;
    region.center.longitude = (maxLon + minLon) / LONGITUDE_FACTOR;
    region.span.latitudeDelta = (maxLat - minLat) * DELTA_FACTOR;
    region.span.longitudeDelta = (maxLon - minLon) * DELTA_FACTOR;
    
    [self.mapView setRegion:region];
}

-(void)calculateDirections:(NSMutableArray*)addresses
{
    MKMapItem *temporary =[addresses objectAtIndex:0];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = temporary;
    temporary =[addresses objectAtIndex:1];
    request.destination = temporary;
    request.requestsAlternateRoutes = YES;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:           // direction request block
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error)
         {
         }
         else
         {
             [self showRoute:response];
         }
     }];
}


-(void)showRoute:(MKDirectionsResponse *)response               // draws shortest route to be added to the map
{
    self.route = response;
    MKRoute *route;
    long double temporaryPath = MAX_DISTANCE;
    
    for (route in response.routes)                              // finds shortest route
    {
        if(route.distance < temporaryPath)
        {
            temporaryPath = route.distance;
            self.shortestRoute = route;
        }
    }
    
    
    [self.mapView addOverlay:self.shortestRoute.polyline level:MKOverlayLevelAboveRoads];

}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay        // draws route onto MKMapView
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = POLY_LINE_WIDTH;
    return renderer;
}

-(void)addCostsToMap                                            // drop pins for each cost added
{
    NSMutableArray *currentCosts = [[NSMutableArray alloc] init];
    currentCosts = [self.model currentCostInformation];
    
    for(int i = 0; i < [currentCosts count]; i++)
    {
        NSDictionary *costAdded = [currentCosts objectAtIndex:i];
        CLLocationDegrees latitude = self.mapView.centerCoordinate.latitude;            // would add at user's location, weren't able to test in simulator
        CLLocationDegrees longitude = self.mapView.centerCoordinate.longitude;          // adds in center of map with an offset to simulate location
        
        latitude = latitude + (i*COORDINATE_OFFSET);
        longitude = longitude + (i*COORDINATE_OFFSET);

        CLLocationCoordinate2D costCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        NSString *type = [costAdded objectForKey:@"cost type"];
        NSString *cost = [costAdded objectForKey:@"money cost"];
        
        MKPointAnnotation *newCostAnnotation = [[MKPointAnnotation alloc] init];
        [newCostAnnotation setCoordinate:costCoordinate];
        [newCostAnnotation setTitle:type];
        [newCostAnnotation setSubtitle:cost];
        
        [self.mapView addAnnotation:newCostAnnotation];
    }
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation           // changes pin colors for each cost type
{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPin"];
    
    annView.canShowCallout = YES;
    [annView setSelected:YES];
    
    if([annotation.title isEqualToString:@"Gas"])
    {
        annView.pinColor = MKPinAnnotationColorGreen;
    }
    else if ([annotation.title isEqualToString:@"Food"])
    {
        annView.pinColor = MKPinAnnotationColorPurple;
    }
    else if([annotation.title isEqualToString:@"Tolls"])
    {
        annView.pinColor = MKPinAnnotationColorGreen;
    }
    else if([annotation.title isEqualToString:@"Misc"])
    {
        annView.pinColor = MKPinAnnotationColorPurple;
    }
    
    annView.calloutOffset = CGPointMake(-ANNOTATION_OFFSET, ANNOTATION_OFFSET);
    annView.animatesDrop=YES;
    
    return annView;
}

- (void) updateMapView:(CLLocationCoordinate2D)currentCoordinate withName:(NSString*)name
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentCoordinate, DEFAULT_REGION, DEFAULT_REGION);
    [self.mapView setRegion:region];
    
    MKPointAnnotation *startAnnotation = [[MKPointAnnotation alloc] init];
    [startAnnotation setCoordinate:currentCoordinate];
    [startAnnotation setTitle:name];
    
    [self.mapView addAnnotation:startAnnotation];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ResultsTableSegue"])
    {
        jjkResultsTableViewController *resultsTableView = segue.destinationViewController;
        resultsTableView.shortestRoute = self.shortestRoute;
    }
}

@end
