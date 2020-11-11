#import <Foundation/Foundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>

@interface ac1d : NSObject {
}

@property (retain) CPDistributedMessagingCenter *messagingCenter;

-(void)send_command:(NSString *)command :(NSString *)arg1 :(NSString *)arg2;

@end
