
//
//  BLEPeripheral.m
//  BumpDetection
//
//  Created by 徐冰 on 01/07/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

/*BB697B05-999A-47D4-91C5-9BC19BD290F9
 C94DF471-35E9-4EF1-9EF9-D83207364805
 */


#import "BLEPeripheral.h"

static NSString * const kServiceUUID = @"312700E2-E798-4D5C-8DCF-49908332DF9F";
static NSString * const kCharacteristicUUID = @"FFA28CDE-6525-4489-801C-1C060CAC9767";

@implementation BLEPeripheral

- (void) workAsPeripheral {
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

- (void) peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
            [self setupService];
            break;
        case CBPeripheralManagerStateUnknown:
            NSLog(@"CoreBluetooth BLE state is unknown");
            break;
        case CBPeripheralManagerStateResetting:
            NSLog(@"CoreBluetooth BLE hardware is resetting");
            break;
        case CBPeripheralManagerStateUnsupported:
            NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
            break;
        case CBPeripheralManagerStateUnauthorized:
            NSLog(@"CoreBluetooth BLE state is unauthorized");
            break;
        case CBPeripheralManagerStatePoweredOff:
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            break;
        default:
            break;
    }
}

- (void) setupService {
    // Creates the characteristic UUID
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:kCharacteristicUUID];
    
    // Creates the characteristic
    self.customCharacteristic = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    
    // Creates the service UUID
    CBUUID *serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
    
    // Creates the service and adds the characteristic to it
    self.customService = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
    
    // Sets the characteristics for this service
    [self.customService setCharacteristics:@[self.customCharacteristic]];
    
    // Publishes the service
    [self.peripheralManager addService:self.customService];
    
}

- (void) peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if(error == nil) {
        [self.peripheralManager startAdvertising:@{CBAdvertisementDataLocalNameKey : @"LocalPName",
            CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:kServiceUUID]]}];
    }
}

- (void) peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    if(error == nil) {
        NSLog(@"Peripheral starts to advertise. Info: %@", peripheral);
    }
}

- (void) peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"The central %@ dis subscribe to the peripheral %@", central, peripheral);
//    [self.peripheralManager updateValue:<#(nonnull NSData *)#> forCharacteristic:<#(nonnull CBMutableCharacteristic *)#> onSubscribedCentrals:<#(nullable NSArray<CBCentral *> *)#>];
}


@end
