//
//  Model.h
//  TripCalculator
//
//  Created by Joshua Kuiros on 12/9/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

@interface Model : NSObject
+(id)sharedInstance;
-(void)addNewCost:(NSDictionary*)newCost;
-(NSMutableArray*)currentCostInformation;

- (void) startTimer;
- (void) stopTimer;
- (double) timeElapsedInSeconds;
- (double) timeElapsedInMinutes;
- (double) timeElapsedInHours;
-(NSString*)timeTraveled;

@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *end;
@property (strong, nonatomic) NSString *timeElapsed;
@property (strong, nonatomic) NSTimer *tripTimer;
@property BOOL tripInProgess;
-(void)clearTrip;
-(NSMutableArray*)totalsArray;
-(void)lastModifiedCost:(NSString*)costType;
@property (strong, nonatomic) NSString *costToUpdate;

@end
