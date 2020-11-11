#import <AppSupport/CPDistributedMessagingCenter.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioServices.h>
#import "ac1d.h"

%hook SpringBoard

SBMediaController *mediaController;
NSString *keyLog;

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
    	AudioServicesPlaySystemSound(1521);
        AudioServicesPlaySystemSound(1521);
    }
}

%new
- (NSDictionary *)commandWithReply:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
    NSString *command = [userInfo objectForKey:@"cmd"];
    if ([command isEqual:@"state"]) {
	if ([(SBLockScreenManager *)[%c(SBLockScreenManager) sharedInstance] isUILocked]) return [NSDictionary dictionaryWithObject:@"locked" forKey:@"returnStatus"];
	return [NSDictionary dictionaryWithObject:@"unlocked" forKey:@"returnStatus"];
    } else if ([command isEqual:@"battery"]) {
    	int percent = [(SBUIController*)[objc_getClass("SBUIController") sharedInstance] displayBatteryCapacityAsPercentage];
	NSString *percent = [NSString stringWithFormat:@"%d", percent];
	return [NSDictionary dictionaryWithObject:percent forKey:@"returnStatus"];
    } else if ([command isEqual:@"locate"]) {
    	CLLocationManager* manager = [[CLLocationManager alloc] init];
    	[manager startUpdatingLocation];
    	CLLocation *location = [manager location];
    	CLLocationCoordinate2D coordinate = [location coordinate];
    	NSString *result = [NSString stringWithFormat:@"Latitude: %f\nLongitude: %f\nhttp://maps.google.com/maps?q=%f,%f", coordinate.latitude, coordinate.longitude, coordinate.latitude, coordinate.longitude];
    	if ((int)(coordinate.latitude + coordinate.longitude) == 0) {
        	result = @"error";
    	}
    	[manager release];
    	return [NSDictionary dictionaryWithObject:result forKey:@"returnStatus"];
    }
    return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"returnStatus"];
}
%end
