#import "ac1d.h"

@implementation ac1d

-(id)init {
    _messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.ac1d"];
    return self;
}

-(void)send_command:(NSString *)command :(NSString *)arg1 :(NSString *)arg2 {
    NSArray *keys = [NSArray arrayWithObjects:@"cmd", @"arg1", @"arg2", nil];
    NSArray *values = [NSArray arrayWithObjects:command, arg1, arg2, nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    NSDictionary *reply = [_messagingCenter sendMessageAndReceiveReplyName:@"recieve_command" userInfo:userInfo];
    NSString *replystr = [reply objectForKey:@"returnStatus"];
    printf("%s", [replystr cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
