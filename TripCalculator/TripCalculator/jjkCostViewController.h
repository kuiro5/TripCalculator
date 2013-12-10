//
//  jjkCostViewController.h
//  TripCalculator
//
//  Created by MTSS User on 12/5/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "jjkViewController.h"
#import "jjkModel.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface jjkCostViewController : UIViewController
@property (strong, nonatomic) NSString *budgetValue;
@property (nonatomic, strong) jjkModel *model;
@property (strong, nonatomic) NSTimer *tripTimer;
- (void) updateTimeDisplay;
@end

static BOOL startTimer = YES;
