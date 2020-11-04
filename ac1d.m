#import "ac1d.h"

@implementation ac1d

-(id)init {
	return self;
}

-(void)showAlert:(NSString *)title :(NSString *)message :(NSString *)first_button :(NSString *)second_button {
    UIAlertController * alert = [UIAlertController
				 alertControllerWithTitle:title
				 message:message
				 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * firstButton = [UIAlertAction
				 actionWithTitle:first_button
				 style:UIAlertActionStyleDefault
				 handler:^(UIAlertAction * action) {
				     printf("First button tapped.\n");
				 }];
    UIAlertAction * secondButton = [UIAlertAction
				    actionWithTitle:second_button
				    style:UIAlertActionStyleDefault
				    handler:^(UIAlertAction * action) {
					printf("Second button tapped.\n");
				    }];
    [alert addAction:firstButton];
    [alert addAction:secondButton];

//    [self presentViewController:alert animated:YES completion:nil];
}

@end
