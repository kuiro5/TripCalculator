//
//  jjkViewController.m
//  TripCalculator
//
//  Created by Joshua Kuiros on 11/12/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "jjkViewController.h"
#import "jjkMapViewController.h"
#import "jjkGraphViewController.h"


@interface jjkViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *tripNameTextField;

@property (weak, nonatomic) IBOutlet UIButton *currentTripButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *startingTextField;
@property (weak, nonatomic) IBOutlet UITextField *destinationTextField;
@property (weak, nonatomic) IBOutlet UITextField *budgetTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
- (IBAction)calculatePressed:(id)sender;

@end

BOOL canStartTrip = NO;

@implementation jjkViewController



-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _model = [Model sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    
    //NSLog(@"Current identifier: %@", [[NSBundle mainBundle] bundleIdentifier]);
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.scrollView.contentSize = self.view.frame.size;
    
    UIEdgeInsets insets  = UIEdgeInsetsZero;
    self.scrollView.contentInset = insets;
    
    self.scrollView.delegate = self;
    
    self.scrollView.userInteractionEnabled = YES;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.tripNameTextField.text = @"";
    self.startingTextField.text = @"";
    self.destinationTextField.text = @"";
    self.budgetTextField.text = @"";
    self.timeTextField.text = @"";
    
    UIEdgeInsets insets  = UIEdgeInsetsZero;
    self.scrollView.contentInset = insets;
    
    if(self.model.tripInProgess == NO)
    {
        self.currentTripButton.enabled = NO;
    }
    else
    {
        self.currentTripButton.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calculatePressed:(id)sender
{
 //   NSLog(@"new trip");
    [self.model clearTrip];
    startTimer = YES;
    self.model.tripInProgess = YES;

    
    if([self.startingTextField.text isEqualToString:@""] || [self.destinationTextField.text isEqualToString:@""] || [self.budgetTextField.text isEqualToString:@""] || [self.timeTextField.text isEqualToString:@""])
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hold On!"
                                                          message:@"You must enter a Starting Location, Destination, Target Budget, and Time!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        
        canStartTrip = NO;
    }
    else
    {
        canStartTrip = YES;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"DirectionSegue"])
    {
        if(canStartTrip)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField*)textField
{
   // NSLog(@"inside did begin editing");
    UIEdgeInsets insets  = UIEdgeInsetsMake(0.0, 0.0, 216.0, 0.0);
    self.scrollView.contentInset = insets;
    
}

-(void)textFieldDidEndEditing:(UITextField*)textField
{
    //UIEdgeInsets insets  = UIEdgeInsetsZero;
    //self.scrollView.contentInset = insets;
    
}

-(BOOL)textFieldShouldReturn: (UITextField*) textField
{
    [textField resignFirstResponder];
    
    UIEdgeInsets insets  = UIEdgeInsetsZero;
    self.scrollView.contentInset = insets;

    
    return YES;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        if([segue.identifier isEqual: @"DirectionSegue"])
        {
            jjkMapViewController *mapViewController = segue.destinationViewController;
            mapViewController.starting = self.startingTextField.text;
            mapViewController.destination = self.destinationTextField.text;
            mapViewController.budget = self.budgetTextField.text;

        }
}
@end
