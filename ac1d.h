#import <Foundation/Foundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>

#include "SpringBoardServices/SpringBoardServices.h"

@interface ac1d : NSObject {
}

CFArrayRef SBSCopyApplicationDisplayIdentifiers(bool onlyActive, bool debuggable);
extern int SBSLaunchApplicationWithIdentifier(CFStringRef identifier, Boolean suspended);

@property (retain) UIDevice *thisUIDevice;
@property (retain) CPDistributedMessagingCenter *messagingCenter;

-(void)battery;
-(void)openurl:(NSString *)url;
-(void)openapp:(NSString *)application;

-(void)send_command:(NSString *)command :(NSString *)arg1 :(NSString *)arg2;

@end
