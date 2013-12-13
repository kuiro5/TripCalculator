//
//  jjkGraphViewController.h
//  TripCalculator
//
//  Created by Joshua Kuiros on 12/5/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "Model.h"

@interface jjkGraphViewController : UIViewController <CPTPlotDataSource, UIActionSheetDelegate>
@property (strong,nonatomic) Model *model;
@end
static BOOL startTimer = YES;