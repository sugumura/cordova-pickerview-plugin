#import "PickerViewPlugin.h"

@implementation PickerViewPlugin

- (void) show:(CDVInvokedUrlCommand*)command
{
    options = [command.arguments objectAtIndex:0];
    callbackId = command.callbackId;
    values = [[NSMutableArray alloc] initWithCapacity:0];

    [self createPickerView];
}

- (void) createPickerView
{
    UIView* view = self.webView.superview;
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
    [maskView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2]];

    [view addSubview:maskView];

    _providerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 260, view.bounds.size.width, 44)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissActionSheet:)];
    _providerToolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], done];
    _providerToolbar.translucent = YES;
    _providerToolbar.barStyle = UIBarStyleDefault;
    [view addSubview:_providerToolbar];

    _providerPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - (260 - 44), view.bounds.size.width, 260)];
    _providerPickerView.backgroundColor = [UIColor colorWithRed:210.0f/255.0f green:213.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    _providerPickerView.showsSelectionIndicator = YES;
    _providerPickerView.delegate = self;

    for (int i = 0; i < [options count]; i++) {
        NSDictionary* obj = [options objectAtIndex:i];
        NSObject* defaultIndex = [obj objectForKey:@"defaultIndex"];
        NSString* stringIndex = [NSString stringWithFormat:@"%@", defaultIndex];
        if ([stringIndex integerValue] > -1) {
            [_providerPickerView selectRow:[stringIndex integerValue] inComponent:i animated:NO];
        }
        [values addObject:[obj objectForKey:@"default"]];
    }

    [UIView transitionWithView:view
                      duration:0.5
                       options:UIViewAnimationOptionBeginFromCurrentState
                    animations:^{[view addSubview:_providerPickerView];}
                    completion:nil];
}

- (void)dismissActionSheet:(id)sender
{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:values];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];

    [maskView removeFromSuperview];
    [_providerPickerView removeFromSuperview];
    [_providerToolbar removeFromSuperview];
}

- (void)pickerView:(UIPickerView*)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary* data = [options objectAtIndex:component];
    NSArray* opts = [data objectForKey:@"options"];
    NSObject* selected = [opts objectAtIndex:row];
    [values setObject:selected atIndexedSubscript:component];
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSDictionary* object = [options objectAtIndex:component];
    NSArray* opts = [object objectForKey:@"options"];
    return [opts count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return [options count];
}

- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary* object = [options objectAtIndex:component];
    NSArray* opts = [object objectForKey:@"options"];
    NSString* title = [NSString stringWithFormat:@"%@", [opts objectAtIndex:row]];
    return title;
}

- (CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger)component
{
    NSDictionary* object = [options objectAtIndex:component];
    NSString* width = [object objectForKey:@"width"];
    return (CGFloat)[width intValue];
}

@end
