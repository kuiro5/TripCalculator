//
// Mike Green Josh Kuiros
// Final Project
// 12/16/13
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "Model.h"
#import "jjkCostViewController.h"
#import "jjkComprehensiveViewController.h"

@interface jjkGraphViewController : UIViewController <CPTPlotDataSource, UIActionSheetDelegate>

@property (strong,nonatomic) Model *model;

@end

static BOOL startTimer = YES;