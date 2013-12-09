//
//  jjkGraphViewController.m
//  TripCalculator
//
//  Created by Joshua Kuiros on 12/5/13.
//  Copyright (c) 2013 Joshua Kuiros. All rights reserved.
//

#import "jjkGraphViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "jjkCostViewController.h"

@interface jjkGraphViewController ()
@property (strong, nonatomic) CPTGraphHostingView *hostView;
@property (strong, nonatomic) CPTTheme *selectedTheme;
@end

@implementation jjkGraphViewController

//- (void)initPlot {
//    [self configureHost];
//    [self configureGraph];
//    [self configureChart];
//    [self configureLegend];
//}
//
//-(void)configureHost {
//    // Set up view frame
//    CGRect parentRect = self.view.bounds;
//    //CGSize toolbarSize = self.toolbar.bounds.size;
//    parentRect = CGRectMake(parentRect.origin.x, parentRect.origin.y, parentRect.size.width, parentRect.size.height);
//    
//    // Create host view
//    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
//    self.hostView.allowPinchScaling = NO;
//    [self.view addSubview:self.hostView];
//}
//
//-(void)configureGraph {
//    //Create and initialize graph
//    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
//    self.hostView.hostedGraph = graph;
//    graph.paddingLeft = 0.0f;
//    graph.paddingTop = 0.0f;
//    graph.paddingRight = 0.0f;
//    graph.paddingBottom = 0.0f;
//    graph.axisSet = nil;
//    
//    // Set up text stile
//    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
//    textStyle.color = [CPTColor grayColor];
//    textStyle.fontName = @"Helvetica-Bold";
//    textStyle.fontSize = 16.0f;
//    
//    // Configure title
//    NSString *title = @"Costs";
//    graph.title = title;
//    graph.titleTextStyle = textStyle;
//    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
//    graph.titleDisplacement = CGPointMake(0.0f, -12.0f);
//    // Set theme
//    self.selectedTheme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
//    [graph applyTheme:self.selectedTheme];
//}
//
//-(void)configureChart {
//    // 1 - Get reference to graph
//    CPTGraph *graph = self.hostView.hostedGraph;
//    // 2 - Create chart
//    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
//    //pieChart.dataSource = self;
//    pieChart.delegate = self;
//    pieChart.pieRadius = (self.hostView.bounds.size.height * 0.7) / 2;
//    pieChart.identifier = graph.title;
//    pieChart.startAngle = M_PI_4;
//    pieChart.sliceDirection = CPTPieDirectionClockwise;
//    // 3 - Create gradient
//    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
//    overlayGradient.gradientType = CPTGradientTypeRadial;
//    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
//    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
//    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
//    // 4 - Add chart to graph
//    [graph addPlot:pieChart];
//}
//
//-(void)configureLegend {
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:YES];
//    [self initPlot];
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        jjkCostViewController *costViewController = segue.destinationViewController;
        //costViewController.delegate = self;
        
}

////#pragma mark - CPTPlotDataSource methods
//- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
//{
//    return 5;
//}

//- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
//{
//    if (CPTPieChartFieldSliceWidth == fieldEnum)
//    {
//        return [[[CPDStockPriceStore sharedInstance] dailyPortfolioPrices] objectAtIndex:idx];
//    }
//    return [NSDecimalNumber zero];
//}
//
//- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx {
//    static CPTMutableTextStyle *labelText = nil;
//    if (!labelText) {
//        labelText= [[CPTMutableTextStyle alloc] init];
//        labelText.color = [CPTColor grayColor];
//    }
//    // 2 - Calculate portfolio total value
//    NSDecimalNumber *portfolioSum = [NSDecimalNumber zero];
//    for (NSDecimalNumber *price in [[CPDStockPriceStore sharedInstance] dailyPortfolioPrices]) {
//        portfolioSum = [portfolioSum decimalNumberByAdding:price];
//    }
//    // 3 - Calculate percentage value
//    NSDecimalNumber *price = [[[CPDStockPriceStore sharedInstance] dailyPortfolioPrices] objectAtIndex:idx];
//    NSDecimalNumber *percent = [price decimalNumberByDividingBy:portfolioSum];
//    // 4 - Set up display label
//    NSString *labelValue = [NSString stringWithFormat:@"$%0.2f USD (%0.1f %%)", [price floatValue], ([percent floatValue] * 100.0f)];
//    // 5 - Create and return layer with label text
//    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
//}
//
//-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
//    return @"";
//}

//#pragma mark - UIActionSheetDelegate methods
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//}

@end
