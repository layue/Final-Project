//
//  BLEDiscoverConnect.h
//  BumpDetection
//
//  Created by 徐冰 on 01/07/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLECentral : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;
//@property (strong, nonatomic) NSMutableArray *peripheralList;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) NSMutableArray *data;

- (void) workAsCentral;
- (void) connectFirstPeripheral;
- (void) disconnect;

@end
