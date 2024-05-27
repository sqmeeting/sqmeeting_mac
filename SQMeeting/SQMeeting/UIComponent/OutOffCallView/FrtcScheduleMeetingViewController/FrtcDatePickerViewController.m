#import "FrtcDatePickerViewController.h"

@interface FrtcDatePickerViewController ()

@end

@implementation FrtcDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    NSRect pickerFrame = NSMakeRect(22.0f, 17.0f, 139.0f, 148.0f);
    self.datePicker = [[NSDatePicker alloc] initWithFrame:pickerFrame];
    self.datePicker.datePickerStyle = NSClockAndCalendarDatePickerStyle;
    self.datePicker.drawsBackground = NO;
    [self.datePicker.cell setBezeled:NO];
    //self.datePicker.cell.enabled = NO;
    [self.datePicker setDateValue:[NSDate date]];
    [self.datePicker setTarget:self];
    [self.datePicker setAction:@selector(updateDateResult:)];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
     
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * mindateStr = @"2023-10-21 00:00:00";
     
    NSString * maxdateStr = @"2023-10-23 00:00:00";
     
    NSDate * mindate = [formatter dateFromString:mindateStr];
     
    NSDate * maxdate = [formatter dateFromString:maxdateStr];
     
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:1];
    NSDate *currentDate = [NSDate date];
    NSDate *maxDate = [self.datePicker.calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-30];
    NSDate *minDate = [self.datePicker.calendar dateByAddingComponents:comps toDate:currentDate options:0];

    
    self.datePicker.minDate = mindate;
    self.datePicker.maxDate = maxdate;
    
    [self.view addSubview:_datePicker];
}

- (void)updateDateResult:(NSDatePicker *)datePicker {
    NSDate *theDate = [datePicker dateValue];
    if(theDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd EE";
        
        NSString *dateString = [formatter stringFromDate:theDate];
        if(self.delegate && [self.delegate respondsToSelector:@selector(selectTime:withTag:)]) {
            [self.delegate selectTime:dateString withTag:self.viewControllerTag];
        }
        NSLog(@"%@", dateString);
    }
}

@end
