//
// Mike Green Josh Kuiros
// Final Project
// 12/16/13
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
