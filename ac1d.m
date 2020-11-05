#import "ac1d.h"

@implementation ac1d

-(id)init {
    _thisUIDevice = [UIDevice currentDevice];
    [_thisUIDevice setBatteryMonitoringEnabled:YES];
    return self;
}

-(void)battery {
    int battery_level = ([_thisUIDevice batteryLevel] * 100);
    printf("Battery Level: %d\n", battery_level);
}

-(void)vibrate {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

-(void)locate {
    CLLocationManager* manager = [[CLLocationManager alloc] init];
    [manager startUpdatingLocation];
    CLLocation *location = [manager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    NSString *result = [NSString stringWithFormat:@"Latitude: %f\nLongitude: %f\nhttp://maps.google.com/maps?q=%f,%f", coordinate.latitude, coordinate.longitude, coordinate.latitude, coordinate.longitude];
    if ((int)(coordinate.latitude + coordinate.longitude) == 0) {
        result = @"Failed to get coordinates!";
    }
    [manager release];
    printf("%s\n", [result cString]);
}

-(void)say:(NSString *)message {
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:message];
    utterance.rate = 0.4;
    AVSpeechSynthesizer *syn = [[[AVSpeechSynthesizer alloc] init]autorelease];
    [syn speakUtterance:utterance];
}

@end
