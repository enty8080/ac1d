#import "ac1d.h"

@implementation ac1d
    
-(id)init {
    _messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.ac1d"];
    return self;
}

-(void)openurl:(NSString *)url {
    CFURLRef cu = CFURLCreateWithBytes(NULL, (UInt8*)[url UTF8String], strlen([url UTF8String]), kCFStringEncodingUTF8, NULL);
    if (!cu) printf("error");
    else {
        bool ret = SBSOpenSensitiveURLAndUnlock(cu, 1);
        if (!ret) printf("error");
    }
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
        printf("%s", [replystr cStringUsingEncoding:NSUTF8StringEncoding]);
    } else {
        printf("error");
    }
}

@end
