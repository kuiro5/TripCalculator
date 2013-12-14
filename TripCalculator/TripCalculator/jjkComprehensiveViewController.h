//
//  jjkComprehensiveViewController.h
//  TripCalculator
//
//  Created by Joshua Kuiros on 12/14/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface jjkComprehensiveViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong,nonatomic) Model *model;
@property (strong, nonatomic)NSString *costType;
@end
