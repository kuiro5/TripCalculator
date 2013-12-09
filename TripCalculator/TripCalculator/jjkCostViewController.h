//
//  jjkCostViewController.h
//  TripCalculator
//
//  Created by Joshua Kuiros on 12/9/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "Model.h"

@interface jjkCostViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate>
@property (strong,nonatomic) Model *model;
@end
