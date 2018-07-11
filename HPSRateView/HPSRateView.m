#import "HPSRateView.h"

static const int kPaddingX = 10;
static const int kSpacingX = 2;

@interface HPSRateView(){
    NSView              *_rateBackView;
    NSMutableArray      *_imageList;
    
    NSImage             *_onImage;
    NSImage             *_offImage;
}

@end

@implementation HPSRateView

- (instancetype)initWithFrame:(NSRect)rect{
    self = [super initWithFrame:rect];
    if(self){
        [self setUp];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if(self){
        [self setUp];
    }
    
    return self;
}

- (void)setUp{
    _imageList = [NSMutableArray array];
    
    for(int i=0;i<5;i++){
        NSImageView *startView = [[NSImageView alloc] init];
        
        [_imageList addObject:startView];
    }
    
    _rateBackView = [[NSView alloc] init];
    
    self.onImage = [NSImage imageNamed:@"star-on"];
    self.offImage = [NSImage imageNamed:@"star-off"];
    
    [self addSubview:_rateBackView];
    
    [self arrangeView];
}

- (void)arrangeView{
    _rateBackView.frame = self.bounds;
    
    [_imageList enumerateObjectsUsingBlock:^(NSImageView *view, NSUInteger idx, BOOL *stop) {
        view.frame = NSMakeRect(kPaddingX + (self.frame.size.height + kSpacingX) * idx, 0, self.frame.size.height, self.frame.size.height);
        [_rateBackView addSubview:view];
    }];
}

- (BOOL)isMouseIn:(NSEvent *)theEvent{
    NSPoint mouseLocation = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    BOOL isIn = NSPointInRect(mouseLocation, self.bounds);
    return isIn;
}

#pragma mark - event handling

- (void)mouseDragged:(NSEvent *)event{
    int rate = [self rateValueAtMouse:event];
    [self displayRateUnitView:rate];
    
    _rate = rate;
    [self _invokeTargetAction];
}

- (void)mouseDown:(NSEvent *)event{
    if (![self isMouseIn:event]){
        return;
    }
    
    int rate = [self rateValueAtMouse:event];
    [self displayRateUnitView:rate];
    
    _rate = rate;
    [self _invokeTargetAction];
}

- (void)displayRateUnitView:(int)rate{
    [_imageList enumerateObjectsUsingBlock:^(NSImageView *view, NSUInteger idx, BOOL *stop) {
        if(idx < rate){
            view.image = _onImage;
        }else{
            view.image = _offImage;
        }
    }];
}

- (int)rateValueAtMouse:(NSEvent *)event{
    NSPoint pointInView = [_rateBackView convertPoint:[event locationInWindow] fromView:nil];
    
    int rate;
    int size = self.frame.size.height;
    if(0==size){
        size = 1;
    }
    rate = (pointInView.x - kPaddingX)/size + 1;
    
    rate = MAX(0, MIN(rate, 5));
    
    return rate;
}

- (void)_invokeTargetAction {
    if (self.action && self.target){
        [NSApp sendAction:self.action to:self.target from:self];
    }
}

- (NSView *)hitTest:(NSPoint)point{
    return self;
}

#pragma mark - getter & setter

- (void)setOnImage:(NSImage *)image{
    _onImage = [image copy];
    [self displayRateUnitView:self.rate];
}

- (void)setOffImage:(NSImage *)image{
    _offImage = [image copy];
    [self displayRateUnitView:self.rate];
}

- (void)setRate:(int)rate{
    if(rate>5 || rate<0){
        return;
    }
    _rate = rate;
    
    [self displayRateUnitView:rate];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    if(highlighted){
        self.onImage = [NSImage imageNamed:@"star-on-highlighted"];
        self.offImage = [NSImage imageNamed:@"star-off-highlighted"];
    }else{
        self.onImage = [NSImage imageNamed:@"star-on"];
        self.offImage = [NSImage imageNamed:@"star-off"];
    }
}

@end
