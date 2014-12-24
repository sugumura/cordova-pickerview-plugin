#import <Cordova/CDVPlugin.h>

@interface PickerViewPlugin : CDVPlugin<UIPickerViewDelegate> {
    UIView* maskView;
    UIPickerView* _providerPickerView;
    UIToolbar* _providerToolbar;
    NSArray* options;
    NSString* callbackId;
    NSMutableArray* values;
}

- (void) show:(CDVInvokedUrlCommand*)command;

@end

