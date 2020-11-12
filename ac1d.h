#import <Foundation/Foundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>

#include "SpringBoardServices/SpringBoardServices.h"

@interface ac1d : NSObject {
}

extern int SBSLaunchApplicationWithIdentifier(CFStringRef identifier, Boolean suspended);

@property (retain) CPDistributedMessagingCenter *messagingCenter;

-(void)openapp:(NSString *)application;

-(void)send_command:(NSMutableArray *)args;

@end
