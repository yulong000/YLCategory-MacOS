#import "MASHotKey.h"

FourCharCode const MASHotKeySignature = 'MASS';

@interface MASHotKey ()
@property(assign) EventHotKeyRef hotKeyRef;
@property(assign) UInt32 carbonID;
@end

@implementation MASHotKey

static UInt32 CarbonHotKeyID = 0;

- (instancetype) initWithShortcut: (MASShortcut*) shortcut
{
    self = [super init];
    _carbonID = ++CarbonHotKeyID;
    EventHotKeyID hotKeyID = { .signature = MASHotKeySignature, .id = _carbonID };

    OSStatus status = RegisterEventHotKey([shortcut carbonKeyCode], [shortcut carbonFlags],
        hotKeyID, GetEventDispatcherTarget(), 0, &_hotKeyRef);

    if (status != noErr) {
        return nil;
    }

    return self;
}

- (instancetype) initWithOptionShortcut: (MASShortcut*) shortcut
{
    self = [super init];
    _carbonID = ++CarbonHotKeyID;
    return self;
}

+ (instancetype) registeredHotKeyWithShortcut: (MASShortcut*) shortcut
{
    return [[self alloc] initWithShortcut:shortcut];
}

+ (instancetype)registeredOptionHotKeyWithShortcut:(MASShortcut *)shortcut
{
    return [[self alloc] initWithOptionShortcut:shortcut];
}

- (void) dealloc
{
    if (_hotKeyRef) {
        UnregisterEventHotKey(_hotKeyRef);
        _hotKeyRef = NULL;
    }
}

@end
