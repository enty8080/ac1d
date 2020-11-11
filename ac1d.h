#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

#include "SpringBoardServices/SpringBoardServices.h"

@interface ac1d : NSObject {
}

@property (retain) CPDistributedMessagingCenter *messagingCenter;

-(void)send_command:(NSString *)command :(NSString *)arg1 :(NSString *)arg2;

@end
