#import "rocketbootstrap.h"

@interface MRMediaController : NSObject

extern CFStringRef kMRMediaRemoteNowPlayingInfoTitle;
extern CFStringRef kMRMediaRemoteNowPlayingInfoArtist;
extern CFStringRef kMRMediaRemoteNowPlayingInfoAlbum;

typedef NS_ENUM(NSInteger, MRCommand) {
    kMRPlay = 0,
    kMRPause = 1,
    kMRNextTrack = 4,
    kMRPreviousTrack = 5,
};

extern Boolean MRMediaRemoteSendCommand(MRCommand command, id userInfo);

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

@interface CLLocationManager : NSObject

+(void)setLocationServicesEnabled:(BOOL)arg1;

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

@interface VolumeControl : NSObject

+(id)sharedVolumeControl;
-(void)toggleMute;

@end
