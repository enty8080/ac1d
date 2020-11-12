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
    NSMutableArray *args = [userInfo objectForKey:@"args"];
    int args_count = [args count];
    if ([args[1] isEqual:@"state"]) {
	if ([(SBLockScreenManager *)[%c(SBLockScreenManager) sharedInstance] isUILocked]) return [NSDictionary dictionaryWithObject:@"locked" forKey:@"returnStatus"];
	return [NSDictionary dictionaryWithObject:@"unlocked" forKey:@"returnStatus"];
    } else if ([args[1] isEqual:@"player"]) {
    	if (args_count < 3) return [NSDictionary dictionaryWithObject:@"Usage: player [next|prev|pause|play|info]" forKey:@"returnStatus"];
	else {
    	    if ([args[2] isEqual:@"info"]) {
	    	MPMediaItem *song = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];
            	NSString *title = [song valueForProperty:MPMediaItemPropertyTitle];
            	NSString *album = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
            	NSString *artist = [song valueForProperty:MPMediaItemPropertyArtist];
            	NSString *result = [NSString stringWithFormat:@"Title: %@\nAlbum: %@\nArtist: %@", title, album, artist];
	    	return [NSDictionary dictionaryWithObject:result forKey:@"returnStatus"];
	    } else if ([args[2] isEqual:@"play"]) {
	    	MRMediaRemoteSendCommand(kMRPlay, nil);
	    } else if ([args[2] isEqual:@"pause"]) {
	    	MRMediaRemoteSendCommand(kMRPause, nil);
	    } else if ([args[2] isEqual:@"next"]) {
	    	MRMediaRemoteSendCommand(kMRNextTrack, nil);
	    } else if ([args[2] isEqual:@"prev"]) {
	    	MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
	    } else {
	        return [NSDictionary dictionaryWithObject:result forKey:@"returnStatus"];
	    }
	}
    } else if ([args[1] isEqual:@"location"]) {
    	if (args_count < 3) return [NSDictionary dictionaryWithObject:@"Usage: location [on|off|info]" forKey:@"returnStatus"];
	else {
    	    if ([args[2] isEqual:@"info"]) {
	    	return [NSDictionary dictionaryWithObject:@"test!" forKey:@"returnStatus"];
	    } else if ([args[2] isEqual:@"on"]) {
	    	[%c(CLLocationManager) setLocationServicesEnabled:true];
	    } else if ([args[2] isEqual:@"off"]) {
	    	[%c(CLLocationManager) setLocationServicesEnabled:false];
	    } else {
	    	return [NSDictionary dictionaryWithObject:@"Usage: location [on|off|info]" forKey:@"returnStatus"];
	    }
	}
    } else if ([args[1] isEqual:@"home"]) {
	if ([(SBUIController *)[%c(SBUIController) sharedInstance] respondsToSelector:@selector(handleHomeButtonSinglePressUp)]) {
	    [(SBUIController *)[%c(SBUIController) sharedInstance] handleHomeButtonSinglePressUp];
	} else if ([(SBUIController *)[%c(SBUIController) sharedInstance] respondsToSelector:@selector(clickedMenuButton)]) {
	    [(SBUIController *)[%c(SBUIController) sharedInstance] clickedMenuButton];
        }
    } else if ([args[1] isEqual:@"dhome"]) {
	if ([(SBUIController *)[%c(SBUIController) sharedInstance] respondsToSelector:@selector(handleHomeButtonDoublePressDown)]) {
	    [(SBUIController *)[%c(SBUIController) sharedInstance] handleHomeButtonDoublePressDown];
        } else if ([(SBUIController *)[%c(SBUIController) sharedInstance] respondsToSelector:@selector(handleMenuDoubleTap)]) {
	    [(SBUIController *)[%c(SBUIController) sharedInstance] handleMenuDoubleTap];
	}
    } else if ([args[1] isEqual:@"alert"]) {
        if (args_count < 6) return [NSDictionary dictionaryWithObject:@"Usage: alert <title> <message> <first_button> <second_button>" forKey:@"returnStatus"];
	else {
    	    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:args[2] message:args[3] delegate:nil cancelButtonTitle:args[4] otherButtonTitles:args[5]];
	    [alert show];
	    [alert release];
	}
    } else if ([args[1] isEqual:@"setvol"]) {
        if (args_count < 3) return [NSDictionary dictionaryWithObject:@"Usage: setvol [0-1]" forKey:@"returnStatus"];
	else {
    	    [[MPMusicPlayerController systemMusicPlayer] setVolume:[args[2] floatValue]];
	}
    } else if ([args[1] isEqual:@"getvol"]) {
    	[[AVAudioSession sharedInstance] setActive:YES error:nil];
    	NSString *level = [NSString stringWithFormat:@"%.2f", [[AVAudioSession sharedInstance] outputVolume]];
	MRMediaRemoteSendCommand(kMRPlay, nil);
	return [NSDictionary dictionaryWithObject:level forKey:@"returnStatus"];
    } else if ([args[1] isEqual:@"say"]) {
        if (args_count < 3) return [NSDictionary dictionaryWithObject:@"Usage: say <message>" forKey:@"returnStatus"];
	else {
    	    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:args[2]];
    	    utterance.rate = 0.4;
    	    AVSpeechSynthesizer *syn = [[[AVSpeechSynthesizer alloc] init]autorelease];
    	    [syn speakUtterance:utterance];
	}
    } else if ([args[1] isEqual:@"battery"]) {
    	UIDevice *thisUIDevice = [UIDevice currentDevice];
	[thisUIDevice setBatteryMonitoringEnabled:YES];
	int battery_level = ([thisUIDevice batteryLevel] * 100);
	NSString *result = [NSString stringWithFormat:@"%d", battery_level];
	return [NSDictionary dictionaryWithObject:result forKey:@"returnStatus"];
    }
    return [NSDictionary dictionaryWithObject:@"noReply" forKey:@"returnStatus"];
}

%end
