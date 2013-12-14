//
//  jjkResultsTableViewController.h
//  TripCalculator
//
//  Created by Joshua Kuiros on 12/5/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "jjkResultsCell.h"

@interface jjkResultsTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MKDirectionsResponse *route;
@property(strong, nonatomic) NSString *totalMiles; 
@property (strong, nonatomic) MKRoute *shortestRoute;
@end
