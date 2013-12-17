//
// Mike Green Josh Kuiros
// Final Project
// 12/16/13
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

+(id)sharedInstance;

-(void)addNewCost:(NSDictionary*)newCost;
-(void) startTimer;
-(void)timeTripEnded:(NSString*)time;
-(void)tripTitle:(NSString*)trip;
-(void)setBudgetValue:(NSString*)budget;
-(void)clearTrip;
-(void) stopTimer;

-(double) timeElapsedInSeconds;
-(float)budgetValue;

-(NSMutableArray*)totalsArray;
-(NSString*)timeTraveled;
-(NSMutableArray*)currentTotalCostInformation;
-(NSMutableArray*)currentCostInformation;

@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *end;
@property (strong, nonatomic) NSString *timeElapsed;
@property (strong, nonatomic) NSTimer *tripTimer;
@property (strong, nonatomic) NSString *costToUpdate;
@property (strong, nonatomic)NSMutableArray *gasCostArray;
@property (strong, nonatomic)NSMutableArray *tollCostArray;
@property (strong, nonatomic)NSMutableArray *miscCostArray;
@property (strong, nonatomic)NSMutableArray *foodCostArray;
@property (strong, nonatomic)NSString *timeEnded;
@property (strong, nonatomic)NSString *tripName;

@property BOOL tripInProgess;
@property BOOL timestopped;

@end

float targetBudget;

