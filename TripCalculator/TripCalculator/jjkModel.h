//
//  jjkModel.h
//  TripCalculator
//
//  Created by MTSS User on 12/9/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface jjkModel : NSObject
- (void) startTimer;
- (void) stopTimer;
- (double) timeElapsedInSeconds;
- (double) timeElapsedInMinutes;
- (double) timeElapsedInHours;
-(NSString*)timeTraveled;

//- (void) updateTimeDisplay;

@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *end;
@property (strong, nonatomic) NSString *timeElapsed;
@end
