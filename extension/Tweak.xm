#import <AppSupport/CPDistributedMessagingCenter.h>
#import <AudioToolbox/AudioServices.h>
#import <UIKit/UIAlertView.h>

#import "MediaRemote.h"
#import "ac1d.h"

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)application {
    %orig;
    mediaController = (SBMediaController *)[%c(SBMediaController) sharedInstance];
    CPDistributedMessagingCenter *messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.ac1d"];
    [messagingCenter runServerOnCurrentThread];
    [messagingCenter registerForMessageName:@"commandWithNoReply" target:self selector:@selector(commandWithNoReply:withUserInfo:)];
    [messagingCenter registerForMessageName:@"commandWithReply" target:self selector:@selector(commandWithReply:withUserInfo:)];
}

%new
-(void)commandWithNoReply:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
    NSString *command = [userInfo objectForKey:@"cmd"];
    NSString *argument1 = [userInfo objectForKey:@"arg1"];
    NSString *argument2 = [userInfo objectForKey:@"arg2"];
    if ([command isEqual:@"home"]) {
	if ([(SBUIController *)[%c(SBUIController) sharedInstance] respondsToSelector:@selector(handleHomeButtonSinglePressUp)]) {
	    [(SBUIController *)[%c(SBUIController) sharedInstance] handleHomeButtonSinglePressUp];
	} else if ([(SBUIController *)[%c(SBUIController) sharedInstance] respondsToSelector:@selector(clickedMenuButton)]) {
	    [(SBUIController *)[%c(SBUIController) sharedInstance] clickedMenuButton];
        }
    } else if ([command isEqual:@"dhome"]) {
	if ([(SBUIController *)[%c(SBUIController) sharedInstance] respondsToSelector:@selector(handleHomeButtonDoublePressDown)]) {
	    [(SBUIController *)[%c(SBUIController) sharedInstance] handleHomeButtonDoublePressDown];
        } else if ([(SBUIController *)[%c(SBUIController) sharedInstance] respondsToSelector:@selector(handleMenuDoubleTap)]) {
	    [(SBUIController *)[%c(SBUIController) sharedInstance] handleMenuDoubleTap];
	}
    } else if ([command isEqual:@"locon"]) {
        [%c(CLLocationManager) setLocationServicesEnabled:true];
    } else if ([command isEqual:@"locoff"]) {
        [%c(CLLocationManager) setLocationServicesEnabled:false];
    } else if ([command isEqual:@"vibrate"]) {
    	typedef void* (*vibratePointer)(SystemSoundID inSystemSoundID, id arg, NSDictionary *vibratePattern);
        NSMutableArray* vPattern = [NSMutableArray array];
        [vPattern addObject:[NSNumber numberWithBool:YES]];
        [vPattern addObject:[NSNumber numberWithInt:100]];
        NSDictionary *vDict = @{ @"VibePattern" : vPattern, @"Intensity" : @1 };

        vibratePointer vibrate;
        void *handle = dlopen(0, 9);
        *(void**)(&vibrate) = dlsym(handle,"AudioServicesPlaySystemSoundWithVibration");
        vibrate(kSystemSoundID_Vibrate, nil, vDict);
    } else if ([command isEqual:@"alert"]) {
    	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:argument1 message:argument2 delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
    }
}

%new
- (NSDictionary *)commandWithReply:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
    NSString *command = [userInfo objectForKey:@"cmd"];
    if ([command isEqual:@"state"]) {
	if ([(SBLockScreenManager *)[%c(SBLockScreenManager) sharedInstance] isUILocked]) return [NSDictionary dictionaryWithObject:@"locked" forKey:@"returnStatus"];
	return [NSDictionary dictionaryWithObject:@"unlocked" forKey:@"returnStatus"];
    }
    return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"returnStatus"];
}
%end
