//
// Mike Green Josh Kuiros
// Final Project
// 12/16/13
//

#import "jjkCostViewController.h"

@interface jjkCostViewController ()

@property (strong, nonatomic) UIPickerView *costTypePicker;
@property(strong, nonatomic) jjkMapViewController *mapView;
@property (strong, nonatomic)NSArray *costTypes;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (weak, nonatomic) IBOutlet UITextField *typeOfCostTextField;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;

- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end

BOOL allowedToSave = NO;                    // checks for appropriate inputs

@implementation jjkCostViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _model = [Model sharedInstance];
        _mapView = [[jjkMapViewController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = self.view.frame.size;
    self.scrollView.delegate = self;
    UIEdgeInsets insets  = UIEdgeInsetsZero;
    self.scrollView.contentInset = insets;
    
    
    self.costLabel.text = @"Add New Cost";
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.currentLocation = [[CLLocation alloc] init];
    
    
    self.latitudeTextField.text = [NSString stringWithFormat:@"%.8f", self.currentLocation.coordinate.latitude];
    self.longitudeTextField.text = [NSString stringWithFormat:@"%.8f", self.currentLocation.coordinate.longitude];
    
    self.costTypePicker = [[UIPickerView alloc] init];
    self.costTypePicker.delegate = self;
    self.costTypePicker.showsSelectionIndicator = YES;
    
    self.costTypePicker.delegate = self;
    self.typeOfCostTextField.inputView = self.costTypePicker;
    
    self.costTypes = [[NSArray alloc] initWithObjects:@"", @"Food", @"Gas", @"Tolls", @"Misc", nil];
    
    [self locationForCosts];
}

-(void)viewWillAppear:(BOOL)animated
{
    UIEdgeInsets insets  = UIEdgeInsetsZero;
    self.scrollView.contentInset = insets;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// updates location as user moves, unable to test feature on simulator
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    
    return 1;//Or return whatever as you intend
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.costTypes count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.costTypes objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.typeOfCostTextField.text = [self.costTypes objectAtIndex:row];
    [self.typeOfCostTextField resignFirstResponder];
    
}

-(BOOL)textFieldShouldReturn: (UITextField*) textField
{
    [textField resignFirstResponder];
    
    UIEdgeInsets insets  = UIEdgeInsetsZero;
    self.scrollView.contentInset = insets;
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField*)textField
{
    if(textField.tag != 0 && textField.tag != 3 && textField.tag != 4)
    {
        UIEdgeInsets insets  = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0);
        self.scrollView.contentInset = insets;
    }
    
    if(textField.tag == 3 && textField.tag == 4)
    {
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
    UIEdgeInsets insets  = UIEdgeInsetsZero;
    self.scrollView.contentInset = insets;
}

- (IBAction)saveButtonPressed:(id)sender
{
    NSNumber *latitude = [NSNumber numberWithDouble:40.798938];
    NSNumber *longitude = [NSNumber numberWithDouble:-77.861298];
    
    NSDictionary *newCost = [[NSDictionary alloc] initWithObjectsAndKeys:self.typeOfCostTextField.text, @"cost type", self.moneyTextField.text, @"money cost", self.descriptionTextField.text, @"description", latitude, @"latitude", longitude, @"longitude",  nil];
    
    [self.model addNewCost:newCost];
    
    if([self.typeOfCostTextField.text isEqualToString:@""] || [self.moneyTextField.text isEqualToString:@""])
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hold On!"
                                                          message:@"You must enter a Type of Cost and Amount to save!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (IBAction)cancelButtonPressed:(id)sender
{
    self.typeOfCostTextField.text = @"";
    self.moneyTextField.text = @"";
    self.descriptionTextField.text = @"";
}

@end
