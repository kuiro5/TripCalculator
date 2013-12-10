//
//  jjkModel.m
//  TripCalculator
//
//  Created by MTSS User on 12/9/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "jjkModel.h"

@implementation jjkModel
@synthesize start;
@synthesize timeElapsed;
@synthesize end;

+(id)sharedInstance{
    
    static id singleton = nil;
    if(!singleton){
        singleton = [[self alloc] init ];
    }
    
    return singleton;
}
- (void) startTimer {

    start = [NSDate date];
}

- (void) stopTimer {
    end = [NSDate date];
}

- (double) timeElapsedInSeconds {
    return fabs([start timeIntervalSinceNow]);
}

- (double) timeElapsedInMinutes {
    return [self timeElapsedInSeconds] / 60.0f;
}
- (double) timeElapsedInHours {
    return [self timeElapsedInMinutes] / 60.0f;
}

-(NSString*)timeTraveled{
    int seconds = fmod([self timeElapsedInSeconds], 60);
    int tmpseconds = [self timeElapsedInSeconds];
    int tmphour = tmpseconds / 3600;
    int tmpminutes = tmpseconds / 60 - tmphour * 60;
    int minutes = tmpminutes;
    int hours = tmphour;

    self.timeElapsed = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    
    return timeElapsed;
}



@end
