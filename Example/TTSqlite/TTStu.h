//
//  TTStu.h
//  TTSqlite_Example
//
//  Created by 任梦晗 on 2016/1/9.
//  Copyright © 2016年 renmenghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTModelProtocol.h"
@interface TTStu : NSObject<TTModelProtocol>
{
    int b;
}
@property (nonatomic,assign) int stuNum;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int age1;
@property (nonatomic,assign) float score;
@property (nonatomic, assign) float score2;

@property (nonatomic,strong) NSArray *xx;
@property (nonatomic,strong) NSDictionary *oo;
@end
