#import "FrtcScheduleFunctionController.h"
#import "FrtcMeetingManagement.h"
#import "FrtcTagFunctionCell.h"

@interface FrtcScheduleFunctionController () <FrtcTagFunctionCellDelegate>

@property (nonatomic, strong) FrtcTagFunctionCell *copyCell;

@property (nonatomic, strong) FrtcTagFunctionCell *editCell;

@property (nonatomic, strong) FrtcTagFunctionCell *cancelCell;

@property (nonatomic, strong) FrtcTagFunctionCell *viewRecurrenceCell;

@property (nonatomic, strong) FrtcTagFunctionCell *removeCell;

@end

@implementation FrtcScheduleFunctionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    if([self.meetingType isEqualToString:@"recurrence"]) {
        if(self.isNeedView) {
            [self.view setFrame:CGRectMake(0, 0, 140, 146)];//76 111
        } else {
            [self.view setFrame:CGRectMake(0, 0, 90, 79)];
        }
        
        if(self.isAddMeeting) {
            [self.view setFrame:CGRectMake(0, 0, 140, 112)];
        }
    } else {
        if(self.isAddMeeting) {
            [self.view setFrame:CGRectMake(0, 0, 80, 82)];
        } else {
            [self.view setFrame:CGRectMake(0, 0, 76, 111)];
        }
    }
    
    [self configFrtcScheduleFunctionControllerLayoutWithFrame:self.view.frame];
}

#pragma mark --layout--
- (void)configFrtcScheduleFunctionControllerLayoutWithFrame:(CGRect)rect {
    if(self.isNeedView) {
        [self.copyCell mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(11);
            make.left.mas_equalTo(self.view.mas_left);
            make.width.mas_equalTo(rect.size.width);
            make.height.mas_equalTo(28);
        }];
    }
    
    if([self.meetingType isEqualToString:@"instant"]) {
        if(self.isAddMeeting) {
            [self.removeCell mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.copyCell.mas_bottom).offset(5);
                make.left.mas_equalTo(self.view.mas_left);
                make.width.mas_equalTo(rect.size.width);
                make.height.mas_equalTo(28);
            }];
        } else {
            [self.cancelCell mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.copyCell.mas_bottom).offset(5);
                make.left.mas_equalTo(self.view.mas_left);
                make.width.mas_equalTo(rect.size.width);
                make.height.mas_equalTo(28);
            }];
        }
    } else if([self.meetingType isEqualToString:@"recurrence"]) {
        if(self.isNeedView) {
            [self.viewRecurrenceCell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.copyCell.mas_bottom).offset(5);
                make.left.mas_equalTo(self.view.mas_left);
                make.width.mas_equalTo(rect.size.width);
                make.height.mas_equalTo(28);
            }];
            
            if(self.isAddMeeting) {
                [self.removeCell mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.viewRecurrenceCell.mas_bottom).offset(5);
                    make.left.mas_equalTo(self.view.mas_left);
                    make.width.mas_equalTo(rect.size.width);
                    make.height.mas_equalTo(28);
                }];
                
                return;
            } else {
                [self.editCell mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.viewRecurrenceCell.mas_bottom).offset(5);
                    make.left.mas_equalTo(self.view.mas_left);
                    make.width.mas_equalTo(rect.size.width);
                    make.height.mas_equalTo(28);
                }];
            }
        } else {
            [self.editCell mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.mas_top).offset(11);
                make.left.mas_equalTo(self.view.mas_left);
                make.width.mas_equalTo(rect.size.width);
                make.height.mas_equalTo(28);
            }];
        }
        
        [self.cancelCell mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.editCell.mas_bottom).offset(5);
            make.left.mas_equalTo(self.view.mas_left);
            make.width.mas_equalTo(rect.size.width);
            make.height.mas_equalTo(28);
        }];
    } else {
        if(self.isAddMeeting) {
            [self.removeCell mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.copyCell.mas_bottom).offset(5);
                make.left.mas_equalTo(self.view.mas_left);
                make.width.mas_equalTo(rect.size.width);
                make.height.mas_equalTo(28);
            }];
        } else {
            [self.editCell mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.copyCell.mas_bottom).offset(5);
                make.left.mas_equalTo(self.view.mas_left);
                make.width.mas_equalTo(rect.size.width);
                make.height.mas_equalTo(28);
            }];
            
            [self.cancelCell mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.editCell.mas_bottom).offset(5);
                make.left.mas_equalTo(self.view.mas_left);
                make.width.mas_equalTo(rect.size.width);
                make.height.mas_equalTo(28);
            }];
        }
    }
}

#pragma mark --FrtcTagFunctionCellDelegate--
- (void)didSelectedCell:(FrtcTagFunctionCell *)cell {
    BOOL isRecurrence;
    if([self.meetingType isEqualToString:@"recurrence"]) {
        isRecurrence = YES;
    } else {
        isRecurrence = NO;
    }
    if(cell.cellTag == FrtcFunctionCancelTag) {
//        BOOL isRecurrence;
//        if([self.meetingType isEqualToString:@"recurrence"]) {
//            isRecurrence = YES;
//        } else {
//            isRecurrence = NO;
//        }
        if(self.delegate && [self.delegate respondsToSelector:@selector(deleteNonCurrentMeetingWithReservationID:withRecurrence:)]) {
            [self.delegate deleteNonCurrentMeetingWithReservationID:self.reservationID withRecurrence:isRecurrence];
        }
    } else if(cell.cellTag == FrtcFunctionEditTag) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(editSelectMeetingWitReservationID:withRecurrence:withRow:)]) {
            [self.delegate editSelectMeetingWitReservationID:self.reservationID withRecurrence:isRecurrence withRow:self.row];
        }
    } else if(cell.cellTag == FrtcFunctionCopyTag) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(editCopyMeetingWitReservationID:withReservationID:)]) {
            [self.delegate editCopyMeetingWitReservationID:self.row withReservationID:self.reservationID];
        }
    } else if(cell.cellTag == FrtcFunctionViewTag) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(viewDetailRecurrenceWithReservationID:)]) {
            [self.delegate viewDetailRecurrenceWithReservationID:self.row];
        }
    } else if(cell.cellTag == FrtcFunctionRemoveTag) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(removeDetailRecurrenceWithReservationID:)]) {
            [self.delegate removeDetailRecurrenceWithReservationID:self.row];
        }
    }
}

#pragma mark -- getter lazy --
- (FrtcTagFunctionCell *)copyCell {
    if(!_copyCell) {
        _copyCell = [[FrtcTagFunctionCell alloc] initWithType:self.meetingType];
        _copyCell.cellTag = FrtcFunctionCopyTag;
        _copyCell.titleView.stringValue = NSLocalizedString(@"FM_MEETING_COPY", @"Copy");
        _copyCell.delegate = self;
        
        [self.view addSubview:_copyCell];
    }
    
    return _copyCell;
}

- (FrtcTagFunctionCell *)editCell {
    if(!_editCell) {
        _editCell = [[FrtcTagFunctionCell alloc] initWithType:self.meetingType];
        _editCell.cellTag = FrtcFunctionEditTag;
        _editCell.delegate = self;
        _editCell.titleView.stringValue = NSLocalizedString(@"FM_MEETING_EDIT", @"Edit");
        [self.view addSubview:_editCell];
    }
    
    return _editCell;
}

- (FrtcTagFunctionCell *)cancelCell {
    if(!_cancelCell) {
        _cancelCell = [[FrtcTagFunctionCell alloc] initWithType:self.meetingType];
        _cancelCell.cellTag = FrtcFunctionCancelTag;
        _cancelCell.delegate = self;
        _cancelCell.titleView.stringValue = self.isOverTime ? NSLocalizedString(@"FM_DELETE_MEETING", @"Delete Meeting") : NSLocalizedString(@"FM_MEETING_CANCEL", @"Cancel");
        _cancelCell.titleView.textColor = [NSColor colorWithString:@"#E32726" andAlpha:1];
        [self.view addSubview:_cancelCell];
    }
    
    return _cancelCell;
}

- (FrtcTagFunctionCell *)viewRecurrenceCell {
    if(!_viewRecurrenceCell) {
        _viewRecurrenceCell = [[FrtcTagFunctionCell alloc] initWithType:self.meetingType];
        _viewRecurrenceCell.cellTag = FrtcFunctionViewTag;
        _viewRecurrenceCell.delegate = self;
        _viewRecurrenceCell.titleView.stringValue = NSLocalizedString(@"FM_MEETING_RECURRENCE", @"View  Recurring Meeting") ;
        [self.view addSubview:_viewRecurrenceCell];
    }
    
    return _viewRecurrenceCell;
}

- (FrtcTagFunctionCell *)removeCell {
    if(!_removeCell) {
        _removeCell = [[FrtcTagFunctionCell alloc] initWithType:self.meetingType];
        _removeCell.cellTag = FrtcFunctionRemoveTag;
        _removeCell.delegate = self;
        _removeCell.titleView.stringValue = NSLocalizedString(@"FM_REMOVE_MEETING_FROMLIST", @"Remove Meeting");
        _removeCell.titleView.textColor = [NSColor colorWithString:@"#E32726" andAlpha:1];
        [self.view addSubview:_removeCell];
    }
    
    return _removeCell;
}

@end
