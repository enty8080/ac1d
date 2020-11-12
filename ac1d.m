#import "ac1d.h"

@implementation ac1d
    
-(id)init {
    _messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.ac1d"];
    return self;
}

-(void)openapp:(NSString *)application {
    CFStringRef identifier = CFStringCreateWithCString(kCFAllocatorDefault, [application UTF8String], kCFStringEncodingUTF8);
    assert(identifier != NULL);
    int ret = SBSLaunchApplicationWithIdentifier(identifier, FALSE);
    if (ret != 0) printf("error");
    CFRelease(identifier);
}

-(void)send_command:(NSMutableArray *)args {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:args forKey:@"args"];
    NSDictionary *reply = [_messagingCenter sendMessageAndReceiveReplyName:@"recieve_command" userInfo:userInfo];
    NSString *result = [reply objectForKey:@"returnStatus"];
    if (result) {
        printf("%s", [result cStringUsingEncoding:NSUTF8StringEncoding]);
    } else {
        printf("error");
    }
}

@end
