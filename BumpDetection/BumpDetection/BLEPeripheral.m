
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

/*
- Start up a peripheral manager object
- Set up services and characteristics on your local peripheral
- Publish your services and characteristics to your device’s local database
- Advertise your services
- Respond to read and write requests from a connected central
- Send updated characteristic values to subscribed centrals
*/


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

//If an error occurs and your services can’t be advertised, access to the error
- (void) peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    if(error == nil) {
        NSLog(@"Peripheral starts to advertise. Info: %@", peripheral);
    } else {
        NSLog(@"Peripheral cannot be advertised. Info: %@", error);
    }
}

- (void) peripheralManager:(CBPeripheralManager *)peripheral
     didReceiveReadRequest:(CBATTRequest *)request {
    
//Make sure the characteristic in your device’s database matches the one that the remote central specified in the original read reques
    if ([request.characteristic.UUID isEqual:self.customCharacteristic.UUID]) {
        
//Make sure that the read request isn’t asking to read from an index position that is outside the bounds of your characteristic’s value
        if (request.offset > self.customCharacteristic.value.length) {
            
            [self.peripheralManager respondToRequest:request
                                       withResult:CBATTErrorInvalidOffset];
            
            return;
        }

//Build up the data for responding to central
        request.value = [self.customCharacteristic.value subdataWithRange:NSMakeRange(request.offset,
                                self.customCharacteristic.value.length - request.offset)];
        
//Send the data to the central
        [self.peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
    }
    
}

- (void) peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests {
//Fullfill the first write request
    self.customCharacteristic.value = [requests objectAtIndex:0].value;
    
//Respond to the central the first write request has been fullfilled
    [self.peripheralManager respondToRequest:[requests objectAtIndex:0]
                               withResult:CBATTErrorSuccess];
}

- (void) peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    
    NSLog(@"The central %@ did subscribe to the peripheral %@", central, peripheral);
    
//    Build up some data for update to the central
    NSString *str = @"There is a test message";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    data = [data subdataWithRange:NSMakeRange(0, data.length - 1)];
    
    [self.peripheralManager updateValue:data forCharacteristic:self.customCharacteristic onSubscribedCentrals:nil];
}


@end
