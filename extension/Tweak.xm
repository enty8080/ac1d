//
// MIT License
//
// Copyright (c) 2020 Ivan Nikolsky
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import <AppSupport/CPDistributedMessagingCenter.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import <CoreLocation/CoreLocation.h>

#import <UIKit/UIApplication.h>
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
	        return [NSDictionary dictionaryWithObject:@"Usage: player [next|prev|pause|play|info]" forKey:@"returnStatus"];
	    }
	}
    } else if ([args[1] isEqual:@"location"]) {
    	if (args_count < 3) return [NSDictionary dictionaryWithObject:@"Usage: location [on|off|info]" forKey:@"returnStatus"];
	else {
    	    if ([args[2] isEqual:@"info"]) {
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
    	    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:args[2] message:args[3] delegate:nil cancelButtonTitle:args[4] otherButtonTitles:args[5], nil];
	    [alert show];
	    [alert release];
	}
    } else if ([args[1] isEqual:@"setvol"]) {
        if (args_count < 3) return [NSDictionary dictionaryWithObject:@"Usage: setvol [0-100]" forKey:@"returnStatus"];
	else {
	    [[MPMusicPlayerController systemMusicPlayer] setVolume:[args[2] floatValue]/100];
	}
    } else if ([args[1] isEqual:@"getvol"]) {
    	[[AVAudioSession sharedInstance] setActive:YES error:nil];
    	NSString *volumeLevel = [NSString stringWithFormat:@"%.2f", [[AVAudioSession sharedInstance] outputVolume]];
	MRMediaRemoteSendCommand(kMRPlay, nil);
	return [NSDictionary dictionaryWithObject:volumeLevel forKey:@"returnStatus"];
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
	int batteryLevel = ([thisUIDevice batteryLevel] * 100);
	NSString *result = [NSString stringWithFormat:@"%d", batteryLevel];
	return [NSDictionary dictionaryWithObject:result forKey:@"returnStatus"];
    } else if ([args[1] isEqual:@"openurl"]) {
    	if (args_count < 3) return [NSDictionary dictionaryWithObject:@"Usage: openurl <url>" forKey:@"returnStatus"];
	else {
	    UIApplication *application = [UIApplication sharedApplication];
	    NSURL *URL = [NSURL URLWithString:args[2]];
	    [application openURL:URL options:@{} completionHandler:nil];
	}
    } else if ([args[1] isEqual:@"openapp"]) {
    	if (args_count < 3) return [NSDictionary dictionaryWithObject:@"Usage: openapp <application>" forKey:@"returnStatus"];
	else {
	    UIApplication *application = [UIApplication sharedApplication];
	    if (![application launchApplicationWithIdentifier:args[2] suspended:NO]) {
	    	return [NSDictionary dictionaryWithObject:@"error" forKey:@"returnStatus"];
	    }
	}
    } else if ([args[1] isEqual:@"dial"]) {
    	if (args_count < 3) return [NSDictionary dictionaryWithObject:@"Usage: dial <phone>" forKey:@"returnStatus"];
	else {
	    UIApplication *application = [UIApplication sharedApplication];
	    NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@", args[2]];
	    NSURL *phoneURL = [NSURL URLWithString:phoneNumber];
	    [application openURL:phoneURL options:@{} completionHandler:nil];
	}
    }
    return [NSDictionary dictionaryWithObject:@"noReply" forKey:@"returnStatus"];
}

%end
