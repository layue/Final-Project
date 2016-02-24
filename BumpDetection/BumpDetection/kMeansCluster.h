//
//  kMeansCluster.h
//  BumpDetection
//
//  Created by 徐冰 on 22/02/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kMeansCluster : NSObject
- (NSMutableArray *) getCentralValue:(NSArray *) rawData;

@end
