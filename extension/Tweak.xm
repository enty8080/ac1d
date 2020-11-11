#import <AppSupport/CPDistributedMessagingCenter.h>
#import <CoreFoundation/CoreFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFlashlight.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#import <UIKit/UIAlertView.h>

#include "SpringBoardServices/SpringBoardServices.h"
#import "mediaremote.h"
#import "ac1d.h"

extern "C" void AudioServicesPlaySystemSoundWithVibration(SystemSoundID inSystemSoundID, id unknown, NSDictionary *options);
extern int SBSLaunchApplicationWithIdentifier(CFStringRef identifier, Boolean suspended);

static AVFlashlight *_sharedFlashlight;

#define kIOHIDEventUsageVolumeUp 233
#define kIOHIDEventUsageVolumeDown 234

%hook AVFlashlight

-(id)init
{
    if (!_sharedFlashlight) {
        _sharedFlashlight = %orig;
    }
    return _sharedFlashlight;
}

%end

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)application {
    %orig;
    CPDistributedMessagingCenter *messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.ac1d"];
    [messagingCenter runServerOnCurrentThread];
    [messagingCenter registerForMessageName:@"recieve_command" target:self selector:@selector(recieve_command:withUserInfo:)];
}

%new
-(NSDictionary *)recieve_command:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
    NSString *command = [userInfo objectForKey:@"cmd"];
    NSString *argument1 = [userInfo objectForKey:@"arg1"];
    NSString *argument2 = [userInfo objectForKey:@"arg2"];
    if ([command isEqual:@"state"]) {
	if ([(SBLockScreenManager *)[%c(SBLockScreenManager) sharedInstance] isUILocked]) return [NSDictionary dictionaryWithObject:@"locked" forKey:@"returnStatus"];
	return [NSDictionary dictionaryWithObject:@"unlocked" forKey:@"returnStatus"];
    } else if ([command isEqual:@"player"]) {
    	if ([argument1 isEqual:@"info"]) {
	    MPMediaItem *song = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];
            NSString *title = [song valueForProperty:MPMediaItemPropertyTitle];
            NSString *album = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
            NSString *artist = [song valueForProperty:MPMediaItemPropertyArtist];
            NSString *result = [NSString stringWithFormat:@"Title: %@\nAlbum: %@\nArtist: %@", title, album, artist];
	    return [NSDictionary dictionaryWithObject:result forKey:@"returnStatus"];
	} else if ([argument1 isEqual:@"play"]) {
	    MRMediaRemoteSendCommand(kMRPlay, nil);
	} else if ([argument1 isEqual:@"pause"]) {
	    MRMediaRemoteSendCommand(kMRPause, nil);
	} else if ([argument1 isEqual:@"next"]) {
	    MRMediaRemoteSendCommand(kMRNextTrack, nil);
	} else if ([argument1 isEqual:@"prev"]) {
	    MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
	}
    } else if ([command isEqual:@"location"]) {
    	if ([argument1 isEqual:@"info"]) {
	    return [NSDictionary dictionaryWithObject:@"test!" forKey:@"returnStatus"];
	} else if ([argument1 isEqual:@"on"]) {
	    [%c(CLLocationManager) setLocationServicesEnabled:true];
	} else if ([argument1 isEqual:@"off"]) {
	    [%c(CLLocationManager) setLocationServicesEnabled:false];
	}
    } else if ([command isEqual:@"home"]) {
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
    } else if ([command isEqual:@"alert"]) {
    	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:argument1 message:argument2 delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
    } else if ([command isEqual:@"openurl"]) {
        CFURLRef cu = CFURLCreateWithBytes(NULL, (UInt8*)[argument1 UTF8String], strlen([argument1 UTF8String]), kCFStringEncodingUTF8, NULL);
        if (!cu) return [NSDictionary dictionaryWithObject:@"error" forKey:@"returnStatus"];
        else {
            bool ret = SBSOpenSensitiveURLAndUnlock(cu, 1);
            if (!ret) return [NSDictionary dictionaryWithObject:@"error" forKey:@"returnStatus"];
        }
    } else if ([command isEqual:@"openapp"]) {
    	CFStringRef identifier = CFStringCreateWithCString(kCFAllocatorDefault, [argument1 UTF8String], kCFStringEncodingUTF8);
    	assert(identifier != NULL);
    	int ret = SBSLaunchApplicationWithIdentifier(identifier, FALSE);
    	if (ret != 0) {
        	return [NSDictionary dictionaryWithObject:@"error" forKey:@"returnStatus"];
    	}
    	CFRelease(identifier);
    } else if ([command isEqual:@"vibrate"]) {
    	NSMutableDictionary* VibrationDictionary = [NSMutableDictionary dictionary];
        NSMutableArray* VibrationArray = [NSMutableArray array ];
        [VibrationArray addObject:[NSNumber numberWithBool:YES]];
        [VibrationArray addObject:[NSNumber numberWithInt:30]];
        [VibrationDictionary setObject:VibrationArray forKey:@"VibePattern"];
        [VibrationDictionary setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
        AudioServicesPlaySystemSoundWithVibration(4095,nil,VibrationDictionary);
    } else if ([command isEqual:@"flashlight"]) {
    	if ([argument1 isEqual:@"on"]) {
	    [_sharedFlashlight setFlashlightLevel: 1.0 withError:nil];
	} else if ([argument1 isEqual:@"off"]) {
	    [_sharedFlashlight setFlashlightLevel: 0.0 withError:nil];
	}
    }
    return [NSDictionary dictionaryWithObject:@"noReply" forKey:@"returnStatus"];
}

%end
