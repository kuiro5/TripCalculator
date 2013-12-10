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

-(id) init{
    
    self = [super init];
    if(self){
        //[self startTimer];
        //NSString *timeElapsed = [[NSString alloc] init];
//        [self updateTimeDisplay];
//        [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(timeTraveled) userInfo:nil repeats:YES];
    }
    
    return self;
}
- (void) startTimer {
    NSLog(@"start Timer");
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
    int seconds = [self timeElapsedInSeconds];
    int temp = seconds % 60;
    int minutes = temp / 60;
    int hours = seconds / 3600;
    NSLog(@"%d", seconds);
//    int minutes = [self timeElapsedInMinutes];
//    int hours = [self timeElapsedInHours];
    self.timeElapsed = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    
    return timeElapsed;
}



@end
