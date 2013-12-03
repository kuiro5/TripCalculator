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
//@property CLLocationCoordinate2D coordinate;

@end

@implementation jjkMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mapView.showsUserLocation = YES;
        //self.coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
    }
    return self;
}

-(void)geocodeAddress:(NSMutableArray*)locations
{
    for(NSString *address in locations)
    {
    
    self.geocoder = [[CLGeocoder alloc] init];
    
    __block CLLocationCoordinate2D coordinate;
    
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0)
        {
            NSLog(@"inside placemark count");
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            coordinate = location.coordinate;
            NSLog(@"latitude %f", coordinate.latitude);
            NSLog(@"longitude %f", coordinate.longitude);
            [self updateMapView:coordinate withName:address];
//            self.coordinatesLabel.text = [NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude];
            if ([placemark.areasOfInterest count] > 0)
            {
                //NSString *areaOfInterest = [placemark.areasOfInterest objectAtIndex:0];
                //self.nameLabel.text = areaOfInterest;
                NSLog(@"found");
            }
            else
            {
                NSLog(@"error");
            }
        }
    }];
    
    
    }
    
}




- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSMutableArray *locations = [[NSMutableArray alloc]initWithObjects:self.starting, self.destination, nil];
    
    [self geocodeAddress:locations];
    
}

- (void) updateMapView:(CLLocationCoordinate2D)currentCoordinate withName:(NSString*)name
{
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentCoordinate, 800, 800);
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
