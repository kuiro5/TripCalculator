//
// Mike Green Josh Kuiros
// Final Project
// 12/16/13
//

#import "Model.h"

#define NUMBER_OF_COSTS 4
#define HOUR_CONVERSION 3600
#define MINUTE_CONVERSION 60

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


-(id) init
{
    self = [super init];
    if(self)
    {
        self.tripInProgess = NO;
        self.timestopped = NO;
        self.timeEnded = @"";
        self.tripName = @"";

        self.costInformation = [[NSMutableArray alloc] init ];
        self.totalCostsInformation = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_COSTS];
        self.gasCostArray = [[NSMutableArray alloc] init];
        self.tollCostArray = [[NSMutableArray alloc] init];
        self.miscCostArray = [[NSMutableArray alloc] init];
        self.foodCostArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(NSMutableArray*)currentCostInformation            // array with every single cost added
{
    return _costInformation;
}


-(void)addNewCost:(NSDictionary*)newCost
{
    [self.costInformation addObject:newCost];
    
    if([[newCost objectForKey:@"cost type"] isEqualToString:@"Gas"])
    {
        [self.gasCostArray addObject:newCost];
    }
    if([[newCost objectForKey:@"cost type"] isEqualToString:@"Food"])
    {
        [self.foodCostArray addObject:newCost];
    }
    if([[newCost objectForKey:@"cost type"] isEqualToString:@"Misc"])
    {
        [self.miscCostArray addObject:newCost];
    }
    if([[newCost objectForKey:@"cost type"] isEqualToString:@"Tolls"])
    {
        [self.tollCostArray addObject:newCost];
    }
}

- (void) startTimer
{
    
    self.start = [NSDate date];
}

- (void) stopTimer
{
    self.end = [NSDate date];
    [self.tripTimer invalidate];
    self.tripTimer = nil;
    self.timestopped = YES;
}

- (double) timeElapsedInSeconds
{
    return fabs([self.start timeIntervalSinceNow]);
}

-(NSString*)timeTraveled
{
    seconds = fmod([self timeElapsedInSeconds], MINUTE_CONVERSION);
    int tmpseconds = [self timeElapsedInSeconds];
    int tmphour = tmpseconds / HOUR_CONVERSION;
    int tmpminutes = tmpseconds / MINUTE_CONVERSION - tmphour * MINUTE_CONVERSION;
    minutes = tmpminutes;
    hours = tmphour;
    
    self.timeElapsed = [[NSString alloc] initWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    
    return self.timeElapsed;
}

-(void)clearTrip
{
    // clear costs with pins
    self.costInformation = [[NSMutableArray alloc] init ];
    self.gasCostArray = [[NSMutableArray alloc] init];
    self.tollCostArray = [[NSMutableArray alloc] init];
    self.miscCostArray = [[NSMutableArray alloc] init];
    self.foodCostArray = [[NSMutableArray alloc] init];
    
    //reset timer
    self.start = [NSDate date];
    [self.tripTimer invalidate];
    self.tripTimer = nil;
    
}

-(NSMutableArray*)totalsArray           // update total cost for each type
{
    NSNumber *initValue = [NSNumber numberWithFloat:0.0];

    NSMutableDictionary *foodCost = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Food", @"type", initValue, @"total", nil];
    NSMutableDictionary *gasCost = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Gas", @"type", initValue, @"total", nil];
    NSMutableDictionary *tollCost = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Tolls", @"type", initValue, @"total", nil];
    NSMutableDictionary *miscCost = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Misc", @"type", initValue, @"total", nil];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    for(NSDictionary *cost in self.costInformation)                 //
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
    
    [self.totalCostsInformation setObject:foodCost atIndexedSubscript:0];               // add all cost dictionaries
    [self.totalCostsInformation setObject:gasCost atIndexedSubscript:1];
    [self.totalCostsInformation setObject:tollCost atIndexedSubscript:2];
    [self.totalCostsInformation setObject:miscCost atIndexedSubscript:3];
    
    return self.totalCostsInformation;
    
}

-(NSMutableArray*)currentTotalCostInformation           // array with dictionaries for each cost 
{
    return self.totalCostsInformation;
}

-(void)setBudgetValue:(NSString*)budget
{
     targetBudget = [budget floatValue];
    
}

-(float)budgetValue
{
    return  targetBudget;
}

-(void)timeTripEnded:(NSString*)time
{
    self.timeEnded = time;
    
}

-(void)tripTitle:(NSString*)trip
{
    self.tripName = trip;
}

@end
