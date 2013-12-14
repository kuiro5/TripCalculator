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
@property (strong, retain) NSMutableArray *totalCostsInformation;

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
        self.totalCostsInformation = [[NSMutableArray alloc] initWithCapacity:4];
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

-(NSMutableArray*)totalsArray
{
    NSNumber *initValue = [NSNumber numberWithFloat:0.0];

    
    NSMutableDictionary *foodCost = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Food", @"type", initValue, @"total", nil];
    NSMutableDictionary *gasCost = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Gas", @"type", initValue, @"total", nil];
    NSMutableDictionary *tollCost = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Tolls", @"type", initValue, @"total", nil];
    NSMutableDictionary *miscCost = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Misc", @"type", initValue, @"total", nil];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    for(NSDictionary *cost in self.costInformation)
    {
        NSString *type = [cost objectForKey:@"cost type"];
        
        if([type isEqualToString:@"Food"])
        {
            NSString *costAmount = [cost objectForKey:@"money cost"];
            NSNumber * myNumber = [f numberFromString:costAmount];
            NSNumber *currentCostAmount = [foodCost objectForKey:@"total"];
            NSNumber *sum = @([currentCostAmount floatValue] + [myNumber floatValue]);
            
            [foodCost setValue:sum forKey:@"total"];
            
        }
        if([type isEqualToString:@"Gas"])
        {
            NSString *costAmount = [cost objectForKey:@"money cost"];
            NSNumber * myNumber = [f numberFromString:costAmount];
            NSNumber *currentCostAmount = [gasCost objectForKey:@"total"];
            NSNumber *sum = @([currentCostAmount floatValue] + [myNumber floatValue]);
        
            [gasCost setValue:sum forKey:@"total"];
        }
        if([type isEqualToString:@"Tolls"])
        {
            NSString *costAmount = [cost objectForKey:@"money cost"];
            NSNumber * myNumber = [f numberFromString:costAmount];
            NSNumber *currentCostAmount = [tollCost objectForKey:@"total"];
            NSNumber *sum = @([currentCostAmount floatValue] + [myNumber floatValue]);

            [tollCost setValue:sum forKey:@"total"];
        }
        if([type isEqualToString:@"Misc"])
        {
            NSString *costAmount = [cost objectForKey:@"money cost"];
            NSNumber * myNumber = [f numberFromString:costAmount];
            NSNumber *currentCostAmount = [miscCost objectForKey:@"total"];
            NSNumber *sum = @([currentCostAmount floatValue] + [myNumber floatValue]);

            [miscCost setValue:sum forKey:@"total"];
        }
        
    }
    
    [self.totalCostsInformation setObject:foodCost atIndexedSubscript:0];
    [self.totalCostsInformation setObject:gasCost atIndexedSubscript:1];
    [self.totalCostsInformation setObject:tollCost atIndexedSubscript:2];
    [self.totalCostsInformation setObject:miscCost atIndexedSubscript:3];
    
    return self.totalCostsInformation;
    
}

-(void)lastModifiedCost:(NSString*)costType
{
    self.costToUpdate = costType;
}


@end
