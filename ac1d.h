#import <Foundation/Foundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <CoreFoundation/CoreFoundation.h>

#include "SpringBoardServices/SpringBoardServices.h"

@interface ac1d : NSObject {
}

CFArrayRef SBSCopyApplicationDisplayIdentifiers(bool onlyActive, bool debuggable);
extern int SBSLaunchApplicationWithIdentifier(CFStringRef identifier, Boolean suspended);

@property (retain) CPDistributedMessagingCenter *messagingCenter;

-(void)openurl:(NSString *)url;
-(void)openapp:(NSString *)application;

-(void)send_command:(NSString *)cmd :(NSArray *)args;

@end
