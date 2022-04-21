//
//  GCDDemoInstance.h
//  gcd-demo-kirin
//
//  Created by Admin on 2022-04-15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelloGCD : NSObject
-(void)syncOnSerialQueue;
-(void)asyncOnSerialQueue;
-(void)syncOnConcurrentQueue;
-(void)asyncOnConcurrentQueue;
-(void)syncOnMainQueue;
-(void)asyncOnMainQueue;

@end

NS_ASSUME_NONNULL_END
