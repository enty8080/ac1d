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

@end
