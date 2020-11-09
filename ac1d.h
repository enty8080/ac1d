#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>

#include "SpringBoardServices/SpringBoardServices.h"

@interface ac1d : NSObject {
}

CFArrayRef SBSCopyApplicationDisplayIdentifiers(bool onlyActive, bool debuggable);
extern int SBSLaunchApplicationWithIdentifier(CFStringRef identifier, Boolean suspended);

@property (retain) UIDevice *thisUIDevice;
@property (retain) CPDistributedMessagingCenter *messagingCenter;

-(void)battery;
-(void)vibrate;
-(void)locate;
-(void)say:(NSString *)message;
-(void)getvol;
-(void)setvol:(NSString *)level;
-(void)openurl:(NSString *)url;
-(void)openapp:(NSString *)application;
-(void)applications;
-(void)sysinfo;

-(void)send_command(NSString *)command;
-(void)send_reply_command(NSString *)command;

@end
