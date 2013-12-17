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
#import "jjkMapViewController.h"
#import "jjkComprehensiveViewController.h"

@interface jjkCostViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate, UIScrollViewDelegate>

@property (strong,nonatomic) Model *model;

@end


