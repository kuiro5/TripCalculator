//
//  jjkCostViewController.m
//  TripCalculator
//
//  Created by Joshua Kuiros on 12/9/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "jjkCostViewController.h"
#import "jjkMapViewController.h"

@interface jjkCostViewController ()
@property (strong, nonatomic) UIPickerView *costTypePicker;
@property (weak, nonatomic) IBOutlet UITextField *typeOfCostTextField;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
@property(strong, nonatomic)jjkMapViewController *mapView;

@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic)NSArray *costTypes;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
//@property (retain, nonatomic) NSDictionary *newCost;
@end

@implementation jjkCostViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _model = [Model sharedInstance];
        _mapView = [[jjkMapViewController alloc] init];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

-(void)locationForCosts
{
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.currentLocation = [[CLLocation alloc] init];
    
    
    self.latitudeTextField.text = [NSString stringWithFormat:@"%.8f", self.currentLocation.coordinate.latitude];
    self.longitudeTextField.text = [NSString stringWithFormat:@"%.8f", self.currentLocation.coordinate.longitude];
    
    self.costTypePicker = [[UIPickerView alloc] init];
    self.costTypePicker.delegate = self;
    self.costTypePicker.showsSelectionIndicator = YES;
    
    self.costTypePicker.delegate = self;
    self.typeOfCostTextField.inputView = self.costTypePicker;
    
    self.costTypes = [[NSArray alloc] initWithObjects:@"Food", @"Gas", @"Tolls", @"Misc", nil];
    
    [self locationForCosts];
	// Do any additional setup after loading the view.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;//Or return whatever as you intend
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.costTypes count];//Or, return as suitable for you...normally we use array for dynamic
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.costTypes objectAtIndex:row];//Or, your suitable title; like Choice-a, etc.
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //Here, like the table view you can get the each section of each row if you've multiple sections
    //NSLog(@"Selected Color: %@. Index of selected color: %i", [arrayColors objectAtIndex:row], row);
    
    //Now, if you want to navigate then;
    // Say, OtherViewController is the controller, where you want to navigate:
    self.typeOfCostTextField.text = [self.costTypes objectAtIndex:row];
    
}

-(BOOL)textFieldShouldReturn: (UITextField*) textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField*)textField
{
    NSLog(@"inside did begin editing");
    if(textField.tag != 0 && textField.tag != 3 && textField.tag != 4)
    {
        UIEdgeInsets insets  = UIEdgeInsetsMake(0.0, 0.0, 216.0, 0.0);
        self.scrollView.contentInset = insets;
    }
    
    if(textField.tag == 3 && textField.tag == 4)
    {
        //UIEdgeInsets insets  = UIEdgeInsetsZero;
        //self.scrollView.contentInset = insets;
        [textField resignFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 0 || textField.tag == 3 || textField.tag == 4)
    {
        return NO;
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField*)textField
{
    //if(textField.tag != 0)
    //{
        UIEdgeInsets insets  = UIEdgeInsetsZero;
        self.scrollView.contentInset = insets;
    //}
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonPressed:(id)sender
{
    NSLog(@"save getting pressed");
    NSNumber *latitude = [NSNumber numberWithDouble:40.798938];
    NSNumber *longitude = [NSNumber numberWithDouble:-77.861298];
    
    NSDictionary *newCost = [[NSDictionary alloc] initWithObjectsAndKeys:self.typeOfCostTextField.text, @"cost type", self.moneyTextField.text, @"money cost", self.descriptionTextField.text, @"description", latitude, @"latitude", longitude, @"longitude",  nil];
    NSLog(@"after dictionary");
    
    [self.model addNewCost:newCost];
    
    //[self.mapView addCostsToMap];
}

- (IBAction)cancelButtonPressed:(id)sender {
}
@end
