#import <Cocoa/Cocoa.h>

@interface HPSRateView : NSControl

@property (nonatomic) int rate;

@property (nonatomic, copy) NSImage *onImage;
@property (nonatomic, copy) NSImage *offImage;

@end
