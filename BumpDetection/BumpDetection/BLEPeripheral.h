//
//  BLEPeripheral.h
//  BumpDetection
//
//  Created by 徐冰 on 01/07/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEPeripheral : NSObject <CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic *customCharacteristic;
@property (strong, nonatomic) CBMutableService *customService;

- (void) workAsPeripheral;

@end
