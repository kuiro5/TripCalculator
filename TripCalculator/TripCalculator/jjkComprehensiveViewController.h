//
// Mike Green Josh Kuiros
// Final Project
// 12/16/13
//


#import <UIKit/UIKit.h>
#import "Model.h"
#import "jjkResultsCell.h"

@interface jjkComprehensiveViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) Model *model;
@property (strong, nonatomic)NSString *costType;

@end
