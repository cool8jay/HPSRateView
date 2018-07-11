#import "HPSRateView.h"
#import "HPSRateTableCellView.h"

@interface  HPSRateTableCellView(){
    NSTrackingArea *_trackingArea;
}

@property (weak) IBOutlet NSView *view;
@property (weak) IBOutlet HPSRateView *rateView;

@end

@implementation HPSRateTableCellView

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    [self _setUp];
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    [self _setUp];
    return self;
}

- (void)_setUp{
    if ([[NSBundle mainBundle] loadNibNamed:[self className]
                                      owner:self
                            topLevelObjects:nil]) {
        [self.view setFrame:self.bounds];

        [self addSubview:self.view];
    }
}

- (IBAction)rateViewAction:(id)sender{
     NSLog(@"rate=%d", _rateView.rate);
}

- (void)updateTrackingAreas{
    [super updateTrackingAreas];
    
    [self removeTrackingArea:_trackingArea];
    
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                 options:(NSTrackingMouseEnteredAndExited |NSTrackingActiveInActiveApp | NSTrackingInVisibleRect)
                                                   owner:self
                                                userInfo:nil];
    
    [self addTrackingArea:_trackingArea];
    
    [self checkMouseLocation];
}

- (void)checkMouseLocation{
    NSPoint mouseLocation = [[self window] mouseLocationOutsideOfEventStream];
    mouseLocation = [self convertPoint: mouseLocation
                              fromView: nil];
    
    if (NSPointInRect(mouseLocation, self.bounds)){
        [self mouseEntered: [NSEvent new]];
    }else{
        [self mouseExited: [NSEvent new]];
    }
}

#pragma mark - event handling

- (void)mouseEntered:(NSEvent *)theEvent{
    if([NSApp modalWindow] && self.window != [NSApp modalWindow] && self.window.parentWindow != [NSApp modalWindow]){
        return;
    }
    
    _rateView.hidden = NO;
}

- (void)mouseExited:(NSEvent *)theEvent{
    if(0==_rateView.rate){
        _rateView.hidden = YES;
    }
    
    [self setNeedsDisplay:YES];
}

- (int)rate{
    return _rateView.rate;
}

- (void)setRate:(int)rate{
    _rateView.rate = rate;
    
    _rateView.hidden = (0==_rateView.rate);
    
}

- (void)setHighlighted:(BOOL)highlighted{
    _highlighted = highlighted;
    
    _rateView.highlighted = highlighted;
}

@end
