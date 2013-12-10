//
//  jjkMapViewController.h
//  TripCalculator
//
//  Created by Joshua Kuiros on 11/12/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "Model.h"


@interface jjkMapViewController : UIViewController<MKMapViewDelegate>

@property(strong,nonatomic)NSString *starting;
@property(strong,nonatomic)NSString *destination;
@property(strong,nonatomic)NSString *budget;
@property (strong,nonatomic) Model *model;
-(void)addCostsToMap;//:(NSDictionary*)costAdded;

@end
