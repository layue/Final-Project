//
//  ViewController.m
//  BumpDetection
//
//  Created by 徐冰 on 22/02/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

//    self.kMeans = [[kMeansCluster alloc] init];
    self.bleCentral = [[BLECentral alloc] init];
    self.blePeripheral = [[BLEPeripheral alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)Start:(id)sender {
    self.motionData = [[MotionData alloc] init];
    if (![self.motionData startCaptureData]) {
        [self showAlertMessage:@"Failed to start update acceleration data."];
    } else {
        NSLog(@"Start to collect sensor data.");
    }
}
//- (IBAction)addBumpRecord:(id)sender {
//    [self.motionData addBump];
//}

- (IBAction)stopCaptureData:(id)sender {
    [self.motionData stopCaptureData];
    [self showAlertMessage:@"Stop to capture Accelerometer data."];
}

- (IBAction)clearDB:(id)sender {
    if([[DBManager getSharedInstance] clearDB]) {
        [self showAlertMessage:@"You have cleared all Accelerometer data."];
    } else {
        [self showAlertMessage:@"Failed to clear Accelerometer data."];
    }
}

- (void) showAlertMessage:(NSString *)myMessage {
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"Alert message" message:myMessage preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Okey" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"MapView"]) {
        UIViewController *destination = segue.destinationViewController;
        if ([destination respondsToSelector:@selector(setMotionData:)]) {
            [destination setValue:self.motionData forKey:@"motionData"];
        }
        SEL selector = NSSelectorFromString(@"setAccDBData:");
        if ([destination respondsToSelector:selector]) {
            NSArray *tempData = [self.motionData getDBRecord];
            [destination setValue:tempData forKey:@"accDBData"];
        }
    }
}

- (IBAction)centralButton:(id)sender {
    [self.bleCentral workAsCentral];
}

//Connect to one discovered peripheral
- (IBAction)connectPeripheral:(id)sender {
    [self.bleCentral connectFirstPeripheral];
}

- (IBAction)peripheralButton:(id)sender {
    [self.blePeripheral workAsPeripheral];
}

- (IBAction)disconnect:(id)sender {
    [self.bleCentral disconnect];
}

- (void) changeDeviceStateLabel: (NSString *) state {
    self.deviceState.text = state;
}

@end
