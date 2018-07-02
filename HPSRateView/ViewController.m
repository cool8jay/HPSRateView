#import "ViewController.h"
#import "HPSRateView.h"

@interface ViewController(){
}

@property (weak) IBOutlet HPSRateView *rateView1;
@property (weak) IBOutlet HPSRateView *rateView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rateView1.type = HPSRateViewTypeText;
    _rateView1.labelColor = [NSColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1];
    
    _rateView2.type = HPSRateViewTypeImage;
    
    _rateView2.onImage = [NSImage imageNamed:@"star-on"];
    _rateView2.offImage = [NSImage imageNamed:@"star-off"];
}

- (IBAction)rateViewAction1:(id)sender{
    NSLog(@"rate=%d", _rateView1.rate);
    _rateView2.rate = _rateView1.rate;
}

- (IBAction)rateViewAction2:(id)sender{
    NSLog(@"rate=%d", _rateView2.rate);
    _rateView1.rate = _rateView2.rate;
}

@end
