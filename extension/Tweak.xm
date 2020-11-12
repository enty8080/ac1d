#import <AppSupport/CPDistributedMessagingCenter.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIAlertView.h>

#import "mediaremote.h"
#import "ac1d.h"

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
        CLLocationManager *manager = [[CLLocationManager alloc] init];
    	if ([argument1 isEqual:@"info"]) {
     	    [manager startUpdatingLocation];
     	    CLLocation *location = [manager location];
     	    CLLocationCoordinate2D coordinate = [location coordinate];
            NSString *result = [NSString stringWithFormat:@"Latitude: %f\nLongitude: %f\nhttp://maps.google.com/maps?q=%f,%f", coordinate.latitude, coordinate.longitude, coordinate.latitude, coordinate.longitude];
            if ((int)(coordinate.latitude + coordinate.longitude) == 0) {
                result = @"error";
            }
            [manager release];
	    return [NSDictionary dictionaryWithObject:result forKey:@"returnStatus"];
	//} else if ([argument1 isEqual:@"on"]) {
	//    [manager setLocationServicesEnabled:true];
	//} else if ([argument1 isEqual:@"off"]) {
	//    [manager setLocationServicesEnabled:false];
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
    } else if ([command isEqual:@"setvol"]) {
    	[[MPMusicPlayerController systemMusicPlayer] setVolume:[argument1 floatValue]];
    } else if ([command isEqual:@"getvol"]) {
    	[[AVAudioSession sharedInstance] setActive:YES error:nil];
    	NSString *level = [NSString stringWithFormat:@"%.2f", [[AVAudioSession sharedInstance] outputVolume]];
	MRMediaRemoteSendCommand(kMRPlay, nil);
	return [NSDictionary dictionaryWithObject:level forKey:@"returnStatus"];
    }
    return [NSDictionary dictionaryWithObject:@"" forKey:@"returnStatus"];
}

%end
