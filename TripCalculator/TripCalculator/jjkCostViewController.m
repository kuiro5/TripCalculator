//
//  jjkCostViewController.m
//  TripCalculator
//
//  Created by MTSS User on 12/5/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "jjkCostViewController.h"

@interface jjkCostViewController ()
@property (weak, nonatomic) IBOutlet UILabel *foodTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *tollTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *grandTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

- (IBAction)calculateTotalsButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *tollsExpensesOutlet;
@property (weak, nonatomic) IBOutlet UITextField *gasExpensesOutlet;
@property (weak, nonatomic) IBOutlet UITextField *foodExpensesOutlet;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation jjkCostViewController
@synthesize model;
@synthesize budgetValue;
@synthesize tollsExpensesOutlet;
@synthesize gasExpensesOutlet;
@synthesize foodExpensesOutlet;
@synthesize scrollView;
@synthesize foodTotalLabel;
@synthesize tripTimer;
@synthesize gasTotalLabel;
@synthesize tollTotalLabel;
@synthesize grandTotalLabel;
@synthesize timerLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.model = [[jjkModel alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.model startTimer];
    

   // [self updateTimeDisplay];
    
	// Do any additional setup after loading the view.
    if(self.tripTimer == nil)
    {
    
        
    }
    
    
    if(startTimer)
    {
        [self.model startTimer];
        startTimer = NO;
    }
}

- (void) updateTimeDisplay {
    
    timerLabel.text = [self.model timeTraveled];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.tripTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0/60) target:self selector:@selector(updateTimeDisplay) userInfo:nil repeats:YES];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    //[self updateTimeDisplay];
    
}

- (IBAction)calculateTotalsButton:(id)sender {
    
    int foodValue = [foodExpensesOutlet.text intValue];
    int totalFoodValue = [foodTotalLabel.text intValue];
    NSString *foodLabel = [[NSString alloc] initWithFormat:@"%i", (foodValue + totalFoodValue)];
    
    int gasValue = [gasExpensesOutlet.text intValue];
    int totalGasValue = [gasTotalLabel.text intValue];
    NSString *gasLabel = [[NSString alloc] initWithFormat:@"%i", (gasValue + totalGasValue)];
    
    int tollsValue = [tollsExpensesOutlet.text intValue];
    int totalTollsValue = [tollTotalLabel.text intValue];
    NSString *tollsLabel = [[NSString alloc] initWithFormat:@"%i", (tollsValue + totalTollsValue)];
    
    int grandValue = totalGasValue + gasValue + totalFoodValue + foodValue + totalTollsValue + tollsValue;
    NSString *grandValueLabel = [[NSString alloc]  initWithFormat:@"%i", (grandValue)];
    grandTotalLabel.text = grandValueLabel;
    
    
    foodTotalLabel.text = foodLabel;
    gasTotalLabel.text = gasLabel;
    tollTotalLabel.text = tollsLabel;
    
    foodExpensesOutlet.text = @"";
    gasExpensesOutlet.text = @"";
    tollsExpensesOutlet.text = @"";
    
    [self costComparison];

}

-(void)costComparison{
    
    int grandValue = [grandTotalLabel.text intValue];
    int budgetValueInteger = [self.budgetValue intValue];
    
    if(grandValue > budgetValueInteger){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"\n\n\n\n" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
//        UITextView *someTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 35, 250, 100)];
//        someTextView.backgroundColor = [UIColor redColor];
//        someTextView.textColor = [UIColor clearColor];
//        someTextView.editable = NO;
//        someTextView.font = [UIFont systemFontOfSize:20];
//        someTextView.text = @"Budget Value Exceeded";
//        [alert addSubview:someTextView];
//        [alert show];
        grandTotalLabel.textColor = [UIColor redColor];
        
    }
    else{
        grandTotalLabel.textColor = [UIColor orangeColor];
    }
}

-(void)textFieldDidBeginEditing:(UITextField*)textField
{
    UIEdgeInsets insets  = UIEdgeInsetsMake(0.0, 0.0, 216.0, 0.0);
    self.scrollView.contentInset = insets;
    
}

-(void)textFieldDidEndEditing:(UITextField*)textField
{
    UIEdgeInsets insets  = UIEdgeInsetsZero;
    self.scrollView.contentInset = insets;
    
}

-(BOOL)textFieldShouldReturn: (UITextField*) textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
