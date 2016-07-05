//
//  BLEDiscoverConnect.m
//  BumpDetection
//
//  Created by 徐冰 on 01/07/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import "BLECentral.h"

static NSString * const kServiceUUID = @"312700E2-E798-4D5C-8DCF-49908332DF9F";
static NSString * const kCharacteristicUUID = @"FFA28CDE-6525-4489-801C-1C060CAC9767";

@implementation BLECentral

/*
- Start up a central manager object
- Discover and connect to peripheral devices that are advertising
- Explore the data on a peripheral device after you’ve connected to it
- Send read and write requests to a characteristic value of a peripheral’s service
- Subscribe to a characteristic’s value to be notified when it is updated
*/

- (void) workAsCentral {
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void) connectFirstPeripheral {
    //TODO: Add a timer for timeout connection
    
    if (self.peripheral != NULL) {
        [self.centralManager connectPeripheral:self.peripheral options:nil];
    } else {
        NSLog(@"There is no peripheral to connect!");
    }
    
    //    if ([self.peripheralList count] == 0) {
    //        NSLog(@"There is no periperal to connect!");
    //    } else {
    //        [self.centralManager connectPeripheral:self.peripheralList[0] options:nil];
    //    }
}

- (void) disconnect {
    if (self.peripheral != NULL && self.peripheral.state == CBPeripheralStateConnected) {
        for(CBService *service in self.peripheral.services) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                [self.peripheral setNotifyValue:NO forCharacteristic:characteristic];
            }
        }
        [self.centralManager cancelPeripheralConnection:self.peripheral];
    } else {
        NSLog(@"Disconnect failed! There is no connected peripheral!");
    }
}

- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
//Start to scan peripheral
            [self.centralManager scanForPeripheralsWithServices:@[ [CBUUID UUIDWithString:kServiceUUID] ] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CoreBluetooth BLE hardware is resetting");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CoreBluetooth BLE state is unauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CoreBluetooth BLE state is unknown");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
            break;
        default:
            break;
    }
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    [self.centralManager stopScan];
    
    if (self.peripheral != peripheral) {
        self.peripheral = peripheral;
        NSLog(@"Discover the peripheral: %@", peripheral);
    }
//    if(![self.peripheralList containsObject:peripheral]) {
//        [self.peripheralList addObject:peripheral];
//        NSLog(@"Discover one peripheral: %@", peripheral);
//    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"Connection successfull to peripheral: %@",peripheral);
    [self.peripheral setDelegate:self];
    [self.peripheral discoverServices:@[[CBUUID UUIDWithString:kServiceUUID]]];
    
    //Do somenthing after successfull connection.
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Connection failed to peripheral: %@",peripheral);
    
    //Do something when a connection to a peripheral failes.
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if(error) {
        NSLog(@"Error discovering service: %@", [error localizedDescription]);
        return;
    }
    
    for (CBService *service in peripheral.services) {
        NSLog(@"Service found with UUID: %@", service.UUID);
        
        // Discovers the characteristics for a given service
        if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
            [self.peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:kCharacteristicUUID]] forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"Error discovering characteristic: %@", [error localizedDescription]);
        return;
    }
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUID]]) {
                NSLog(@"Characteristic found with UUID: %@", characteristic.UUID);
//                Subscribe to the characteristic
//                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//                Read characteristic's value manually
//                [peripheral readValueForCharacteristic:characteristic];
//                Write to characteristic's value manually
//                [peripheral writeValue:[NSData] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            }
        }
    }
}

//When the characteristic's value of a peripheral changes, notify the app here
- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if(error) {
        NSLog(@"Error while reading peripheral data %@", error.localizedDescription);
    }
    
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUID]]) {
        return;
    }
    
    NSLog(@"Updated characteristics value: %@", characteristic.value);
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
        [peripheral readValueForCharacteristic:characteristic];
    } else { // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.centralManager cancelPeripheralConnection:self.peripheral];
    }
}

//Access to the error of subscribing
- (void) peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if(error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    } else {
        NSLog(@"Update notification state: %@", characteristic);
    }
}

//Access to the error of write to peripheral characteristic
- (void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    
    if (error) {
        NSLog(@"Error writing characteristic value: %@", error.localizedDescription);
    }
}

//Access to the error of disconnect form the peripheral
- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (error) {
        NSLog(@"Error disconnect from peripheral: %@", error.localizedDescription);
    } else {
        NSLog(@"Successfully disconnect from the peripheral: %@", peripheral);
    }
}

@end
