//
//  jjkViewController.m
//  TripCalculator
//
//  Created by Joshua Kuiros on 11/12/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "jjkViewController.h"
#import "jjkMapViewController.h"

@interface jjkViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *startingTextField;
@property (weak, nonatomic) IBOutlet UITextField *destinationTextField;
@property (weak, nonatomic) IBOutlet UITextField *budgetTextField;
- (IBAction)calculatePressed:(id)sender;

@end

@implementation jjkViewController

- (void)viewDidLoad
{
    
    //NSLog(@"Current identifier: %@", [[NSBundle mainBundle] bundleIdentifier]);
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.scrollView.userInteractionEnabled = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calculatePressed:(id)sender
{
    
}

-(void)textFieldDidBeginEditing:(UITextField*)textField
{
    NSLog(@"inside did begin editing");
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

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
//   if(self.startingTextField.text.length == 0 || self.destinationTextField.text.length == 0){
//        return NO;
//    
//    }
//    else
//    {
        return YES;
//    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
       jjkMapViewController *mapViewController = segue.destinationViewController;
        mapViewController.starting = self.startingTextField.text;
        mapViewController.destination = self.destinationTextField.text;
        mapViewController.budget = self.budgetTextField.text;
}
@end
