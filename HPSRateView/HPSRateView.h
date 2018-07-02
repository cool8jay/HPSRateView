#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, HPSRateViewType) {
    HPSRateViewTypeText,
    HPSRateViewTypeImage,
};

@interface HPSRateView : NSControl

@property (nonatomic) int rate;

@property (nonatomic) HPSRateViewType type;

@property (nonatomic) NSColor *labelColor;

@property (nonatomic, copy) NSString *onText;
@property (nonatomic, copy) NSString *offText;

@property (nonatomic, copy) NSImage *onImage;
@property (nonatomic, copy) NSImage *offImage;

@end
