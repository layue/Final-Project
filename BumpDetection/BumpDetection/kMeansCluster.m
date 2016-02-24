//
//  kMeansCluster.m
//  BumpDetection
//
//  Created by 徐冰 on 22/02/2016.
//  Copyright © 2016 Bing. All rights reserved.
//

#import "kMeansCluster.h"

@implementation kMeansCluster
- (NSMutableArray *) getCentralValue:(NSArray *) rawData
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSMutableArray *cluster1 = [[NSMutableArray alloc] init];
    NSMutableArray *cluster2 = [[NSMutableArray alloc] init];
    
    int pos1 = arc4random()%rawData.count;
    int pos2 = arc4random()%rawData.count;
    
    float central1 = [rawData[pos1] floatValue];
    float central2 = [rawData[pos2] floatValue];
    
    float sumCluster1 = 0.0;
    float sumCluster2 = 0.0;
    int countCluster1 = 0;
    int countCluster2 = 0;
    
    for (int i = 0; i < rawData.count; i ++) {
        float dis1 = fabsf([rawData[i] floatValue] - central1);
        float dis2 = fabsf([rawData[i] floatValue] - central2);
        if (dis1 < dis2) {
            [cluster1 addObject:rawData[i]];
            sumCluster1 += [rawData[i] floatValue];
            countCluster1 ++;
        } else {
            [cluster2 addObject:rawData[i]];
            sumCluster2 += [rawData[i] floatValue];
            countCluster2 ++;
        }
    }
    
    float meanCluster1 = sumCluster1 / countCluster1;
    float meanCluster2 = sumCluster2 / countCluster2;
    BOOL stillChange = true;
    int MAX_CHANGE_TIMES = 50;
    int times = 0;

    while (stillChange && times < MAX_CHANGE_TIMES) {
        stillChange = false;
        for (int i = 0; i < cluster1.count; i ++) {
            if (fabsf([cluster1[i] floatValue] - meanCluster1) >
                fabsf([cluster1[i] floatValue] - meanCluster2) &&
                cluster1.count > 1) {
                [cluster2 addObject:cluster1[i]];
                [cluster1 removeObject:cluster1[i]];
                stillChange = true;
            }
        }

        for (int i = 0; i < cluster2.count; i ++) {
            if (fabsf([cluster2[i] floatValue] - meanCluster2) >
                fabsf([cluster2[i] floatValue] - meanCluster1) &&
                cluster2.count > 1) {
                [cluster1 addObject:cluster2[i]];
                [cluster2 removeObject:cluster2[i]];
                stillChange = true;
            }
        }
        
        sumCluster1 = 0.0;
        sumCluster2 = 0.0;
        
        for (int i = 0; i < cluster1.count; i ++) {
            sumCluster1 += [cluster1[i] floatValue];
        }
        meanCluster1 = sumCluster1 / cluster1.count;
        
        for (int i = 0; i < cluster2.count; i ++) {
            sumCluster2 += [cluster2[i] floatValue];
        }
        meanCluster2 = sumCluster2 / cluster2.count;
        
        times ++;
    }
    
    NSLog(@"cluster1:%@, cluster2:%@", cluster1, cluster2);
    
    result[0] = cluster1;
    result[1] = cluster2;
    
    return result;
}

@end
