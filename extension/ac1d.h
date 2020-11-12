#import "rocketbootstrap.h"

@interface UIApplication (Undocumented)

-(bool)launchApplicationWithIdentifier:(id)arg1 suspended:(bool)arg2;

@end

@interface SBIcon : NSObject
	
-(NSString *)nodeIdentifier;

@end

@interface SBApplicationIcon : SBIcon
	
@end  

@interface SBIconController : NSObject

-(id)lastTouchedIcon;

@end

@interface SBUserAgent : NSObject

+(id)sharedUserAgent;
-(void)lockAndDimDevice;
-(void)handleMenuDoubleTap;
-(void)clickedMenuButton;
-(bool)handleHomeButtonSinglePressUp;
-(bool)handleHomeButtonDoublePressDown;

@end


@interface SBDeviceLockController : NSObject

+(id)sharedController;
-(void)_clearBlockedState;
-(BOOL)isPasscodeLocked;

@end

@interface SBLockScreenManager : NSObject

@property (nonatomic, readonly) BOOL isUILocked;

+(id)sharedInstance;

@end

@interface SBHUDController : NSObject

+(id)sharedInstance;
-(void)hideHUD;
-(void)showHUD;

@end
	
@interface CLLocationManager : NSObject

+(void)setLocationServicesEnabled:(BOOL)arg1;

@end

@interface VolumeControl : NSObject

+(id)sharedVolumeControl;
-(void)toggleMute;

@end
