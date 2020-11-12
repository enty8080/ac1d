#import "ac1d.h"

@implementation ac1d
    
-(id)init {
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

-(void)send_command:(NSString *)command :(NSString *)arg1 :(NSString *)arg2 {
    NSArray *keys = [NSArray arrayWithObjects:@"cmd", @"arg1", @"arg2", nil];
    NSArray *values = [NSArray arrayWithObjects:command, arg1, arg2, nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    NSDictionary *reply = [_messagingCenter sendMessageAndReceiveReplyName:@"recieve_command" userInfo:userInfo];
    NSString *replystr = [reply objectForKey:@"returnStatus"];
    printf("%s", [replystr cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
