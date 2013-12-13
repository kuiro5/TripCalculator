//
//  Model.m
//  TripCalculator
//
//  Created by Joshua Kuiros on 12/9/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "Model.h"
@interface Model ()
@property (strong,retain) NSMutableArray *costInformation;

@end

int seconds;
int minutes;
int hours;

@implementation Model

+(id)sharedInstance
{
    static id singleton = nil;
    if (!singleton)
    {
        singleton = [[self alloc] init];
    }
    return singleton;
}

// override
-(id) init
{
    self = [super init];
    if(self)
    {
        // initialization
//        NSDictionary *newCost = [[NSDictionary alloc] initWithObjectsAndKeys: @"gas", @"cost type", @"20", @"money cost", @"", @"description", @"", @"latitude", @"", @"longitude",  nil];
        self.tripInProgess = NO;

        self.costInformation = [[NSMutableArray alloc] init ];//]WithObjects:newCost, nil];
    }
    return self;
}

-(NSMutableArray*)currentCostInformation
{
  
    return _costInformation;
}

-(void)addNewCost:(NSDictionary*)newCost
{
   
    NSLog(@"adding new cost");
    [self.costInformation addObject:newCost];
}

#pragma mark-timer functions
- (void) startTimer {
    
    self.start = [NSDate date];
}

- (void) stopTimer {
    self.end = [NSDate date];
}

- (double) timeElapsedInSeconds {
    return fabs([self.start timeIntervalSinceNow]);
}

- (double) timeElapsedInMinutes {
    return [self timeElapsedInSeconds] / 60.0f;
}
- (double) timeElapsedInHours {
    return [self timeElapsedInMinutes] / 60.0f;
}

-(NSString*)timeTraveled{
    seconds = fmod([self timeElapsedInSeconds], 60);
    int tmpseconds = [self timeElapsedInSeconds];
    int tmphour = tmpseconds / 3600;
    int tmpminutes = tmpseconds / 60 - tmphour * 60;
    minutes = tmpminutes;
    hours = tmphour;
    
    self.timeElapsed = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    
    return self.timeElapsed;
}

-(void)clearTrip
{
    NSLog(@"clear trip");
    // clear costs with pins
    self.costInformation = [[NSMutableArray alloc] init ];
    
    //reset timer
    self.start = [NSDate date];
    [self.tripTimer invalidate];
    self.tripTimer = nil;

    
}


@end
