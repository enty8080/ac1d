#import <AppSupport/CPDistributedMessagingCenter.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIAlertView.h>
#import <UIKit/UIDevice.h>

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
    NSString *argument3 = [userInfo objectForKey:@"arg3"];
    NSString *argument4 = [userInfo objectForKey:@"arg4"];
    NSString *argument5 = [userInfo objectForKey:@"arg5"];
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
    	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:argument1 message:argument2 delegate:nil cancelButtonTitle:argument3 otherButtonTitles:argument4];
	[alert show];
	[alert release];
    } else if ([command isEqual:@"setvol"]) {
    	[[MPMusicPlayerController systemMusicPlayer] setVolume:[argument1 floatValue]];
    } else if ([command isEqual:@"getvol"]) {
    	[[AVAudioSession sharedInstance] setActive:YES error:nil];
    	NSString *level = [NSString stringWithFormat:@"%.2f", [[AVAudioSession sharedInstance] outputVolume]];
	MRMediaRemoteSendCommand(kMRPlay, nil);
	return [NSDictionary dictionaryWithObject:level forKey:@"returnStatus"];
    } else if ([command isEqual:@"say"]) {
    	AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:argument1];
    	utterance.rate = 0.4;
    	AVSpeechSynthesizer *syn = [[[AVSpeechSynthesizer alloc] init]autorelease];
    	[syn speakUtterance:utterance];
    } else if ([command isEqual:@"battery"]) {
    	UIDevice *thisUIDevice = [UIDevice currentDevice];
	[thisUIDevice setBatteryMonitoringEnabled:YES];
	int battery_level = ([thisUIDevice batteryLevel] * 100);
	NSString *result = [NSString stringWithFormat:@"%d", battery_level];
	return [NSDictionary dictionaryWithObject:result forKey:@"returnStatus"];
    }
    return [NSDictionary dictionaryWithObject:@"" forKey:@"returnStatus"];
}

%end
