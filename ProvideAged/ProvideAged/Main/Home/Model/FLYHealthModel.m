//
//  FLYHealthModel.m
//  ProvideAged
//
//  Created by fly on 2021/11/12.
//

#import "FLYHealthModel.h"

@implementation FLYHealthModel

-(NSString *)healthValue
{
    if ( _healthValue.length == 0 )
    {
        return @"--";
    }
    
    return _healthValue;
}

-(NSString *)healthValue2
{
    if ( _healthValue2.length == 0 )
    {
        return @"--";
    }
    
    return _healthValue2;
}

-(NSString *)healthTypeName
{
    NSString * string = @"";
    
    switch ( self.healthType )
    {
        case 1:
        {
            string = @"心率";
        }
            break;
            
        case 2:
        {
            string = @"呼吸";
        }
            break;
            
        case 3:
        {
            string = @"血糖";
        }
            break;
            
        case 4:
        {
            string = @"体温";
        }
            break;
            
        case 5:
        {
            string = @"血氧";
        }
            break;
            
        case 6:
        {
            string = @"血压";
        }
            break;
            
        default:
            break;
    }
    
    return string;
}

-(NSInteger)status
{
    NSInteger s = 0;
    
    switch ( self.healthType )
    {
        case 1:
        {
            if ( [self.healthValue floatValue] < 60 )
            {
                s = 2;
            }
            else if ( [self.healthValue floatValue] > 100 )
            {
                s = 3;
            }
            else
            {
                s = 1;
            }
            
        }
            break;
            
        case 2:
        {
            if ( [self.healthValue floatValue] < 13 )
            {
                s = 2;
            }
            else if ( [self.healthValue floatValue] > 20 )
            {
                s = 3;
            }
            else
            {
                s = 1;
            }
        }
            break;
            
        case 3:
        {
            if ( [self.healthValue floatValue] < 3.92 )
            {
                s = 2;
            }
            else if ( [self.healthValue floatValue] > 7.0 )
            {
                s = 3;
            }
            else
            {
                s = 1;
            }
        }
            break;
            
        case 4:
        {
            if ( [self.healthValue floatValue] < 36.0 )
            {
                s = 2;
            }
            else if ( [self.healthValue floatValue] > 37.7 )
            {
                s = 3;
            }
            else
            {
                s = 1;
            }
        }
            break;
            
        case 5:
        {
            if ( [self.healthValue floatValue] < 95.0 )
            {
                s = 2;
            }
            else if ( [self.healthValue floatValue] > 98.0 )
            {
                s = 3;
            }
            else
            {
                s = 1;
            }
        }
            break;
            
        case 6:
        {
            if ( [self.healthValue2 floatValue] > 90.0 && [self.healthValue2 floatValue] < 140.0 )
            {
                
                if ( [self.healthValue floatValue] < 60.0 )
                {
                    s = 2;
                }
                else if ( [self.healthValue floatValue] > 90.0 )
                {
                    s = 3;
                }
                else
                {
                    s = 1;
                }
                
            }
            else if ( [self.healthValue2 floatValue] < 90.0 )
            {
                s = 2;
            }
            else if ( [self.healthValue2 floatValue] > 140.0 )
            {
                s = 3;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    return s;
}

-(NSString *)unit
{
    NSString * string = @"";
    
    switch ( self.healthType )
    {
        case 1:
        {
            string = @"bpm";
        }
            break;
            
        case 2:
        {
            string = @"次/分";
        }
            break;
            
        case 3:
        {
            string = @"mmol/L";
        }
            break;
            
        case 4:
        {
            string = @"°C";
        }
            break;
            
        case 5:
        {
            string = @"SpO";
        }
            break;
            
        case 6:
        {
            string = @"mmHg";
        }
            break;
            
        default:
            break;
    }
    
    return string;
}

@end
