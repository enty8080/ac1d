#import <Foundation/Foundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>

@interface ac1d : NSObject {
}

@property (retain) CPDistributedMessagingCenter *messagingCenter;

-(void)send_command:(NSMutableArray *)args;

@end
