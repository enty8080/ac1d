@interface AVFlashlight : NSObject {
    AVFlashlightInternal * _internal;
}

@property (getter=isAvailable, nonatomic, readonly) bool available;
@property (nonatomic, readonly) float flashlightLevel;
@property (getter=isOverheated, nonatomic, readonly) bool overheated;

+ (bool)hasFlashlight;
+ (void)initialize;

- (void)_handleNotification:(id)arg1 payload:(id)arg2;
- (void)_reconnectToServer;
- (void)_setupFlashlight;
- (void)_teardownFlashlight;
- (void)dealloc;
- (float)flashlightLevel;
- (id)init;
- (bool)isAvailable;
- (bool)isOverheated;
- (bool)setFlashlightLevel:(float)arg1 withError:(id*)arg2;
- (void)turnPowerOff;
- (bool)turnPowerOnWithError:(id*)arg1;

@end
