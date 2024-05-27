#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FrtcSaveServerAddressActionHandler)();
typedef void (^FrtcSaveServerAddressCancelActionHandler)();

@interface FrtcSaveServerAddressWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindowWithWindow:(NSWindow *)window
              withSaveAction:(FrtcSaveServerAddressActionHandler)saveAction
            withCancelAction:(FrtcSaveServerAddressCancelActionHandler)cancelSaveAction;


- (void)adjustToSize:(NSSize)size;

@property (nonatomic, strong) NSTextField   *descriptionTextField;

@property (nonatomic, copy) FrtcSaveServerAddressActionHandler saveActionHandler;

@property (nonatomic, copy) FrtcSaveServerAddressCancelActionHandler cancelSaveActionHandler;

@end

NS_ASSUME_NONNULL_END
