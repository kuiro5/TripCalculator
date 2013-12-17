//
// Mike Green Josh Kuiros
// Final Project
// 12/16/13
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "Model.h"
#import "jjkResultsTableViewController.h"

@interface jjkMapViewController : UIViewController<MKMapViewDelegate>

@property(strong,nonatomic)NSString *starting;
@property(strong,nonatomic)NSString *destination;
@property(strong,nonatomic)NSString *budget;
@property (strong,nonatomic) Model *model;
-(void)addCostsToMap;

@end
