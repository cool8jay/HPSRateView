#import "ViewController.h"
#import "HPSRateView.h"
#import "HPSRateTableCellView.h"

@interface ViewController() <NSTableViewDelegate, NSTableViewDataSource>{
    NSInteger selectedIndex;
}

@property (weak) IBOutlet HPSRateView *rateView;
@property (weak) IBOutlet NSTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (IBAction)rateViewAction:(id)sender{
    NSLog(@"rate=%d", _rateView.rate);
    _rateView.rate = _rateView.rate;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return 30;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = tableColumn.identifier;
    
    if ([identifier isEqualToString:@"name"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        cellView.textField.stringValue = [NSString stringWithFormat:@"%ld", row + 1];
        
        return cellView;
    }else if ([identifier isEqualToString:@"rate"]) {
        HPSRateTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        cellView.rate = row%6;
        return cellView;
    } else {
        NSAssert1(NO, @"Unhandled table column identifier %@", identifier);
    }
    return nil;
}

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)tableView{
    selectedIndex = _tableView.selectedRow;
    return YES;
}

- (void)tableViewSelectionIsChanging:(NSNotification *)notification{
    if(-1 != selectedIndex){
        HPSRateTableCellView *oldCellView = [_tableView viewAtColumn:1
                                                                 row:selectedIndex
                                                     makeIfNecessary:YES];
        
        oldCellView.highlighted = NO;
    }
    
    HPSRateTableCellView *newCellView = [_tableView viewAtColumn:1
                                                             row:_tableView.selectedRow
                                                 makeIfNecessary:YES];
    
    newCellView.highlighted = YES;
}

@end
