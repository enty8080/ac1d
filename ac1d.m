#include "ac1d.h"

@implementation ac1d

-(void)showAlert:(NSString *)title :(NSString *)message :(NSString *)first_button :(NSString *)second_button {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:first_button];
    [alert addButtonWithTitle:second_button];
    [alert setMessageText:title];
    [alert setInformativeText:message];
    [alert setAlertStyle:NSWarningAlertStyle];

    if ([alert runModal] == NSAlertFirstButtonReturn) {
        NULL;
    }
}

@end
