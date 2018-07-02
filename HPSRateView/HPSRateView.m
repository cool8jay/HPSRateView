#import "HPSRateView.h"

static const int kPaddingX = 10;
static const int kSpacingX = 2;
static const int kHeight = 20;

static const int kLabelUnitSize = 20;
static const int kImageUnitSize = 20;

@interface HPSRateView(){
    NSView              *_rateBackView;
    NSMutableArray      *_imageList;
    NSMutableArray      *_labelList;

    
    NSString            *_onText;
    NSString            *_offText;
    
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
    _labelList = [NSMutableArray array];
    
    _onText = @"★";
    _offText = @"☆";
    
    for(int i=0;i<5;i++){
        NSImageView *startView = [[NSImageView alloc] init];
        
        NSTextField *startLabel = [[NSTextField alloc] init];
        startLabel.drawsBackground = YES;
        startLabel.backgroundColor = NSColor.clearColor;
        startLabel.bordered = NO;
        startLabel.editable = NO;
        startLabel.selectable = NO;
        
        [_imageList addObject:startView];
        [_labelList addObject:startLabel];
    }
    
    _rateBackView = [[NSView alloc] init];
    
    [self addSubview:_rateBackView];
    
    [self arrangeView];
}

- (void)arrangeView{
    self.frame = NSMakeRect(0, 0, self.intrinsicContentSize.width, self.intrinsicContentSize.height);
    _rateBackView.frame = self.bounds;
    
    if(HPSRateViewTypeText == _type){
        [_labelList enumerateObjectsUsingBlock:^(NSTextField *view, NSUInteger idx, BOOL *stop) {
            view.hidden = NO;
            view.frame = NSMakeRect(kPaddingX + (kLabelUnitSize + kSpacingX) * idx + kSpacingX, 0, kLabelUnitSize, kLabelUnitSize);
            [_rateBackView addSubview:view];
        }];
        
        [_imageList enumerateObjectsUsingBlock:^(NSTextField *view, NSUInteger idx, BOOL *stop) {
            view.hidden = YES;
        }];
    }else{
        [_labelList enumerateObjectsUsingBlock:^(NSTextField *view, NSUInteger idx, BOOL *stop) {
            view.hidden = YES;
        }];
        
        [_imageList enumerateObjectsUsingBlock:^(NSImageView *view, NSUInteger idx, BOOL *stop) {
            view.hidden = NO;
            view.frame = NSMakeRect(kPaddingX + (kImageUnitSize + kSpacingX) * idx, 0, kImageUnitSize, kImageUnitSize);
            [_rateBackView addSubview:view];
        }];
    }
}

- (NSSize)intrinsicContentSize {
    int count = 5;
    CGFloat width;
    
    if(HPSRateViewTypeText == _type){
        width = count * kLabelUnitSize + (count - 1) * kSpacingX + kPaddingX * 2;
    }else{
        width = count * kImageUnitSize + (count - 1) * kSpacingX + kPaddingX * 2;
    }
    
    return NSMakeSize(width, kHeight);
}

#pragma mark - event handling

- (void)mouseDragged:(NSEvent *)event{
    int rate = [self rateValueAtMouse:event];
    [self displayRateUnitView:rate];
 
    _rate = rate;
    [self _invokeTargetAction];
}

- (void)mouseDown:(NSEvent *)event{
    int rate = [self rateValueAtMouse:event];
    [self displayRateUnitView:rate];
    
    _rate = rate;
    [self _invokeTargetAction];
    
}

- (void)mouseUp:(NSEvent *)event{
    int rate = [self rateValueAtMouse:event];
    [self displayRateUnitView:rate];
    
    _rate = rate;
    [self _invokeTargetAction];
}

- (void)displayRateUnitView:(int)rate{
    if(HPSRateViewTypeText == _type){
        [_labelList enumerateObjectsUsingBlock:^(NSTextField *label, NSUInteger idx, BOOL *stop) {
            label.hidden = NO;
            if(idx<rate){
                label.stringValue = _onText;
            }else{
                label.stringValue = _offText;
            }
        }];
    }else{
        [_imageList enumerateObjectsUsingBlock:^(NSImageView *view, NSUInteger idx, BOOL *stop) {
            view.hidden = NO;
            if(idx<rate){
                view.image = _offImage;
            }else{
                view.image = _onImage;
            }
        }];
    }
}

- (int)rateValueAtMouse:(NSEvent *)event{
    NSPoint pointInView = [_rateBackView convertPoint:[event locationInWindow] fromView:nil];
    
    int rate;
    
    if(HPSRateViewTypeText == _type){
        rate = (pointInView.x - kPaddingX)/kLabelUnitSize + 1;
    }else{
        rate = (pointInView.x - kPaddingX)/kImageUnitSize + 1;
    }
    
    rate = MAX(0, MIN(rate, 5));
    
    return rate;
}

- (void)_invokeTargetAction {
    if (self.action && self.target){
        [NSApp sendAction:self.action to:self.target from:self];
    }
}

#pragma mark - getter & setter

- (void)setType:(HPSRateViewType)type{
    _type = type;
    [self arrangeView];
    [self displayRateUnitView:self.rate];
}

- (void)setLabelColor:(NSColor *)labelColor{
    [_labelList enumerateObjectsUsingBlock:^(NSTextField *label, NSUInteger idx, BOOL *stop) {
        label.textColor = labelColor;
    }];
}

- (void)setOnText:(NSString *)text{
    _onText = [text copy];
    [self displayRateUnitView:self.rate];
}

- (void)setOffText:(NSString *)text{
    _offText = [text copy];
    [self displayRateUnitView:self.rate];
}

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

@end
