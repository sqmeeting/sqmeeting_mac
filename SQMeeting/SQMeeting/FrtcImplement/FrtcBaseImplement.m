#import "FrtcBaseImplement.h"

static FrtcBaseImplement *baseImpleSingleton = nil;

@implementation FrtcBaseImplement


+ (FrtcBaseImplement *)baseImpleSingleton {
    if (baseImpleSingleton == nil) {
        @synchronized(self) {
            if (baseImpleSingleton == nil) {
                baseImpleSingleton = [[FrtcBaseImplement alloc] init];
            }
        }
    }
    
    return baseImpleSingleton;
}

- (NSColor *)baseColor {
    return [NSColor colorWithRed:0x24/255.0 green:0x24/255.0 blue:0x25/255.0 alpha:1];
}

- (NSColor *)blueColor {
    return [NSColor colorWithRed:2/255.0 green:111/255.0 blue:254/255.0 alpha:1];
}

- (NSColor *)redColor {
    return [NSColor colorWithRed:0xff/255.0 green:0x39/255.0 blue:0x00/255.0 alpha:1];
}

- (NSColor *)whiteColor {
    return [NSColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1];
}

- (NSColor *)lightGrayColor {
    return [NSColor colorWithRed:0xef/255.0 green:0xf1/255.0 blue:0xf5/255.0 alpha:1];
}

- (NSColor *)buttonTitleColor {
    return [NSColor colorWithRed:0x00/255.0 green:0x26/255.0 blue:0x3e/255.0 alpha:1];
}

- (NSColor *)sharingBarColor {
    return [NSColor colorWithRed:(float)40/255 green:(float)180/255 blue:(float)69/255 alpha:1.0];
}

- (NSColor *)titleButtonBackGroundColor {
    return [NSColor colorWithRed:0x00/255.0 green:0x14/255.0 blue:0x21/255.0 alpha:1];
}

- (NSString *)bundleVersion {
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    return [infoDict objectForKey:@"CFBundleVersion"];
}

- (NSString *)masterVersion {
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    return [infoDict objectForKey:@"CFBundleShortVersionString"];
}

- (NSSize)baseScreenSize {
    NSScreen *screen = [NSScreen mainScreen];
    NSDictionary *description = [screen deviceDescription];
    NSSize dispalyPixelSize = [[description objectForKey:NSDeviceSize] sizeValue];
    
    if(dispalyPixelSize.height >= 1200) {
        return NSMakeSize(1536, 1037);
    } else if(dispalyPixelSize.height >= 1000 && dispalyPixelSize.height < 1200) {
        return NSMakeSize(1280, 864);
    } else if(dispalyPixelSize.height >= 800 && dispalyPixelSize.height < 1000) {
        return NSMakeSize(1024, 691);
    } else {
        return NSMakeSize(819, 553);
    }
}

- (CGFloat)baseScale {
    NSScreen *screen = [NSScreen mainScreen];
    NSDictionary *description = [screen deviceDescription];
    NSSize dispalyPixelSize = [[description objectForKey:NSDeviceSize] sizeValue];
    
    if(dispalyPixelSize.height >= 1200) {
        return 1.2;
    } else if(dispalyPixelSize.height >= 1000 && dispalyPixelSize.height < 1200) {
        return 1.0;
    } else if(dispalyPixelSize.height >= 800 && dispalyPixelSize.height < 1000) {
        return 0.8;
    } else {
        return 0.64;
    }
}

- (CGFloat)screenWidth {
    return [self baseScreenSize].width;
}

- (CGFloat)screenHeight {
    return [self baseScreenSize].height;
}

- (NSString *)currentTimeString {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
    return timeString;
}

- (NSString *)dateStringWithTimeString:(NSString *)timeString {
    NSTimeInterval time = [timeString doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([self isTodayWithTimeString:detailDate]) {
        [dateFormatter setDateFormat:@"a HH:mm"];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd EE HH:mm"];
    }

    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    
    return currentDateStr;
}

- (NSString *)dateStringWithAccountTimeString:(NSString *)timeString {
    NSTimeInterval time = [timeString doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([self isTodayWithTimeString:detailDate]) {
        [dateFormatter setDateFormat:@"HH:mm"];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }

    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    
    return currentDateStr;
}

- (NSString *)dateStringWithMonthAndDayString:(NSString *)timeString {
    NSTimeInterval time = [timeString doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([self isTodayWithTimeString:detailDate]) {
        [dateFormatter setDateFormat:@"a HH:mm"];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }

    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    
    return currentDateStr;
}

- (NSDate *)dateConvertFromTimeString:(NSString *)dataString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:dataString];
    
    return datestr;
}

- (NSDate *)DateConvertFromDateAndTimeString:(NSString *)dataString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSTimeInterval timestamp = [dataString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    return date;
}

- (NSString *)getDateTimeFromDateString:(NSString *)dateString {
    // Set up the date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // Convert the Unix timestamp to an NSDate object
    NSTimeInterval endTimestamp = [dateString doubleValue] / 1000.0;
    NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:endTimestamp];
    
    // Convert the NSDate object to a formatted string    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:kCFCalendarUnitMonth| kCFCalendarUnitDay| NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:endTime];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSString *dateTimeString = [NSString stringWithFormat:@"%d/%d %02ld:%02ld", (int)month, (int)day, (long)hour, (long)minute];
    return dateTimeString;
}

- (NSString *)getTimeFromDateString:(NSString *)dateString {
    // Set up the date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // Convert the Unix timestamp to an NSDate object
    NSTimeInterval endTimestamp = [dateString doubleValue] / 1000.0;
    NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:endTimestamp];
    
    // Convert the NSDate object to a formatted string
    //NSString *endTimeString = [dateFormatter stringFromDate:endTime];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:endTime];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld", (long)hour, (long)minute];
    return timeString;
}

- (BOOL)isTodayWithTimeString:(NSDate *)time {
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:time];
    
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    if([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
       [today era] == [otherDay era]) {
        return YES;
    }
    
    return NO;
}


//for local reminder: date @"yyyy-MM-dd HH:mm".

- (NSDate *)getCurrentDateWithFormarter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd KK:mm"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentTime = [dateFormatter dateFromString:currentDateString];
    
    NSLog(@"[%s][%d]: currentTime: %@", __func__, __LINE__, currentTime);
    return currentTime;
}

//aDateString: @"yyyy-MM-dd HH:mm"

- (NSDate *)getDateFromSting:(NSString *)aDateString {
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    ////[dateFormatter setDateFormat:@"yyyy-MM-dd KK:mm"];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // Convert the Unix timestamp to an NSDate object
    NSTimeInterval timestamp = [aDateString doubleValue] / 1000.0;
    NSDate *aDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    //NSLog(@"[%s][%d]: aDate: %@: from aDateString: %@", __func__, __LINE__, aDate, aDataString);
    
    return aDate;
}

- (NSTimeInterval)getTimeIntervalFromNowToDateFromSting:(NSString *)aDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd KK:mm"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentTime = [dateFormatter dateFromString:currentDateString];
    
    // Convert the Unix timestamp to an NSDate object
    NSTimeInterval timestamp = [aDateString doubleValue] / 1000.0;
    NSDate *aDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSTimeInterval timeInterval = [aDate timeIntervalSinceDate:currentTime];
    
    //NSLog(@"[%s][%d]: timeInterval: %d: from aDateString: %@ ~ currentTime: %@", __func__, __LINE__, (int)timeInterval, aDate, currentTime);

    return timeInterval;
}

- (NSTimeInterval)getTimeIntervalSinceNowToDate:(NSDate *)aDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd KK:mm"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentTime = [dateFormatter dateFromString:currentDateString];

//    // Convert the Unix timestamp to an NSDate object
//    NSTimeInterval timestamp = [aDateString doubleValue] / 1000.0;
//    NSDate *aDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSTimeInterval timeInterval = [aDate timeIntervalSinceDate:currentTime];
    
    NSLog(@"[%s][%d]: timeInterval: %d: from aDateString: %@ ~ currentTime: %@", __func__, __LINE__, (int)timeInterval, aDate, currentTime);

    return timeInterval;
}

@end
