#import "ac1d.h"

@implementation ac1d
    
-(id)init {
    _messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.ac1d"];
    return self;
}

-(void)openurl:(NSString *)url {
    if (![url isEqualToString:@""]) {
        CFURLRef cu = CFURLCreateWithBytes(NULL, (UInt8*)[url UTF8String], strlen([url UTF8String]), kCFStringEncodingUTF8, NULL);
        if (!cu) printf("error");
        else {
            bool ret = SBSOpenSensitiveURLAndUnlock(cu, 1);
            if (!ret) {
                printf("error");
            }
        }
    }
}

-(void)openapp:(NSString *)application {
    CFStringRef identifier = CFStringCreateWithCString(kCFAllocatorDefault, [application UTF8String], kCFStringEncodingUTF8);
    assert(identifier != NULL);
    int ret = SBSLaunchApplicationWithIdentifier(identifier, FALSE);
    if (ret != 0) {
        printf("error");
    }
    CFRelease(identifier);
}

-(void)send_command:(NSString *)cmd :(NSArray *)args {
    NSArray *keys = [NSArray arrayWithObjects:@"cmd", @"args", nil];
    NSArray *values = [NSArray arrayWithObjects:command, cmd, args nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    NSDictionary *reply = [_messagingCenter sendMessageAndReceiveReplyName:@"recieve_command" userInfo:userInfo];
    NSString *replystr = [reply objectForKey:@"returnStatus"];
    printf("%s", [replystr cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
