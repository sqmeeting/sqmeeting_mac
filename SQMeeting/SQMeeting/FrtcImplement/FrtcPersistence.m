#import "FrtcPersistence.h"
#import "FrtcUserDefault.h"

#define kDocumentPath(user_id)  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@MeetingList.data",user_id]]

static FrtcPersistence *sharedUserPersistence = nil;

@implementation FrtcPersistence

+ (FrtcPersistence *)sharedUserPersistence {
    if (sharedUserPersistence == nil) {
        @synchronized(self) {
            if (sharedUserPersistence == nil) {
                sharedUserPersistence = [[FrtcPersistence alloc] init];
            }
        }
    }
    
    return sharedUserPersistence;
}

- (BOOL)saveMeeting:(MeetingDetailModel *)model {
    NSString *userID = [[FrtcUserDefault defaultSingleton] objectForKey:USER_ID];
    NSLog(@"------------------------------%@", userID);
    if(userID == nil || [userID isEqualToString:@""]) {
        return NO;
    }
    
    BOOL result = YES;
    
    NSMutableArray *meetinglist = [NSMutableArray arrayWithCapacity:20];
    NSArray <MeetingDetailModel *> *list = [self getMeetingList];
    
    if (list.count > 0) {
        [meetinglist addObjectsFromArray:[self dataProcessingWith:list model:model]];
    }
    
    [meetinglist insertObject:model atIndex:0];
    
    NSError *error = nil;
    NSData *meetingListData = [NSKeyedArchiver archivedDataWithRootObject:meetinglist requiringSecureCoding:NO error:&error];
    if (!error && meetingListData) {
        NSString *localPath = kDocumentPath([[FrtcUserDefault defaultSingleton] objectForKey:USER_ID]);
        if ([meetingListData writeToFile:localPath atomically:YES]) {
            result = YES;
        } else {
            NSLog(@"111");
        }
    } else {
        NSLog(@"222");
    }
    
    return result;
}

- (NSArray <MeetingDetailModel *> *)getMeetingList {
    NSError *error = nil;
    NSSet *set = [NSSet setWithObjects:[NSArray class],[NSString class],[NSDictionary class],[MeetingDetailModel class],[NSNumber class],nil];
    
    NSString *localPath = kDocumentPath([[FrtcUserDefault defaultSingleton] objectForKey:USER_ID]);
    NSData *data = [NSData dataWithContentsOfFile:localPath];
    
    NSArray *listInfo = [NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:&error];
    
    if (!error && listInfo) {
        return listInfo;
    } else {
        return @[];
    }
    return @[];
}

- (NSArray *)dataProcessingWith:(NSArray <MeetingDetailModel *> *)listdata model:(MeetingDetailModel *)model {
    NSMutableArray *resultarray = [NSMutableArray arrayWithCapacity:20];
    
    for (MeetingDetailModel *info in listdata) {
//        if (![info.meetingNumber isEqualToString:model.meetingNumber]) {
//            [resultarray addObject:info];
//        }
        
        [resultarray addObject:info];
    }
    
    return resultarray;
}

- (BOOL)deleteHistoryMeetingWithMeetingStartTime:(NSString *)meetingStartTime {
    if (ObjectiveStringIsEmpty(meetingStartTime)) { return NO ; }
    BOOL result = NO;
    NSMutableArray *meetinglist = [NSMutableArray arrayWithCapacity:20];
    NSArray <MeetingDetailModel *> *list = [self getMeetingList];
    if (list.count > 0) {
        [meetinglist addObjectsFromArray:list];
    }
    
    for (MeetingDetailModel *info in meetinglist) {
        if ([info.meetingStartTime isEqualToString:meetingStartTime]) {
            [meetinglist removeObject:info];
            result = YES;
            break;
        }
    }
    if (!result) { return NO; }
    
    NSError *error = nil;
    NSData *meetingListData = [NSKeyedArchiver archivedDataWithRootObject:meetinglist requiringSecureCoding:NO error:&error];
    if (!error && meetingListData) {
        NSString *localPath = kDocumentPath([[FrtcUserDefault defaultSingleton] objectForKey:USER_ID]);
        if ([meetingListData writeToFile:localPath atomically:YES]) {
            result = YES;
        } else {

        }
    } else {
 
    }
    
    return result;
}

- (void)deleteCurrentUserHistoryMeeting {
    NSString *localPath = kDocumentPath([[FrtcUserDefault defaultSingleton] objectForKey:USER_ID]);
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL isExist = [fileMgr fileExistsAtPath:localPath];
    
    if (isExist) {
        [fileMgr removeItemAtPath:localPath error:nil];
    }
}

@end
