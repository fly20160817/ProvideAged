//
//  FLYOpenDoorViewController.m
//  ProvideAged
//
//  Created by fly on 2021/12/23.
//

#import "FLYOpenDoorViewController.h"
#import "FLYOpenDoorView.h"
#import "FLYOpenDoorMenuView.h"
#import "FLYTempAuthorizeListViewController.h"
#import "FLYOpenRecordListViewController.h"
#import "FLYForgetLockPasswordViewController.h"
#import "FLYZiGuangManager.h"
#import "FLYOpenDoorResultView.h"
#import "FLYPopupView.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "FLYUtility.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "FLYBase64.h"
#import "FLYInputFaceViewController.h"
#import "FLYFingerprintViewController.h"

//服务的UUID
#define SER_UUID_A  @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
//写特征的UUID
#define CHAR_UUID_A  @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
//读特征的UUID
#define CHAR_UUID_B  @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"

@interface FLYOpenDoorViewController () < CBCentralManagerDelegate, CBPeripheralDelegate >
{
    NSString * _openId;//开锁id
    NSString * _command;//开锁指令
}
@property (nonatomic, strong) FLYOpenDoorView * openDoorView;
@property (nonatomic, strong) FLYOpenDoorMenuView * menuView;

//中央管理者
@property (nonatomic, strong) CBCentralManager * centralManager;

//连接的外围设备
@property (nonatomic, strong) CBPeripheral * peripheral;

//特征uuid数组
@property (nonatomic, strong) NSArray * characteristicUUIDs;

//特征数组
@property (nonatomic, strong) NSMutableArray<CBCharacteristic *> * characteristicList;


@end

@implementation FLYOpenDoorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.openDoorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(370);
    }];
    
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.openDoorView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}



#pragma mark - UI

- (void)initUI
{
    self.navigationItem.title = @"门锁";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.openDoorView];
    [self.view addSubview:self.menuView];
}



#pragma mark - DATA

- (void)loadData
{
    
}



#pragma mark - NETWORK

//获取开锁指令
- (void)getUnlockCodeNetwork
{
    WeakSelf
    StrongSelf
    
    NSDictionary * params = @{ @"id" : self.lockModel.idField };
    
    [FLYNetworkTool postRawWithPath:API_TUOBANGOPENDOOR params:params loadingType:(FLYNetworkLoadingTypeNotInteractionClear) loadingTitle:@"获取开锁指令" isHandle:YES success:^(id json) {
                
        strongSelf->_openId = json[SERVER_DATA][@"openId"];
        strongSelf->_command = json[SERVER_DATA][@"command"];
         
        NSLog(@"json = %@", json);
        
        [SVProgressHUD showWithStatus:@"开锁中"];
        
        NSData * data = [self dataWithHexString:json[SERVER_DATA][@"command"]];
        CBCharacteristic * characteristic = [self characteristicForUUID:CHAR_UUID_A];
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                
    } failure:^(id obj) {
        
        NSLog(@"失败：%@", obj);
        
    }];
}

//告诉服务器开门成功
- (void)openlockCompleteNetwork
{
    NSDictionary * params = @{ @"openId" : _openId, @"command" : _command };
    
    [FLYNetworkTool postRawWithPath:API_TUOBANGOPENDOORSUCCESS params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:NO success:^(id  _Nonnull json) {
        
        NSLog(@"json = %@", json);
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}



#pragma mark - event handler

- (void)openDoorClick
{
    //紫光
    if( self.lockModel.bluetoothType == 4 )
    {
        [SVProgressHUD showWithStatus:@"开锁中"];
        
        NSDictionary * params = @{ @"deviceInfoId" : self.lockModel.idField };
        
        [FLYZiGuangManager openLock:self.lockModel.imei otherParams:params disconnect:YES success:^(NSString * _Nonnull lockId) {
            
            [SVProgressHUD dismiss];
            
            [self showOpenDoorResult:FLYOpenDoorStatusSuccess];
            
        } failure:^(id  _Nonnull result) {
            
            [SVProgressHUD dismiss];
            
            [self showOpenDoorResult:FLYOpenDoorStatusFailure];
        }];
    }
    else
    {
        [self tuoBangOpenDoor];
    }
}

- (void)menuClick:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            FLYTempAuthorizeListViewController * vc = [[FLYTempAuthorizeListViewController alloc] init];
            vc.deviceInfoId = self.lockModel.idField;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 1:
        {
            FLYOpenRecordListViewController * vc = [[FLYOpenRecordListViewController alloc] init];
            vc.deviceInfoId = self.lockModel.idField;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2:
        {
            FLYForgetLockPasswordViewController * vc = [[FLYForgetLockPasswordViewController alloc] init];
            vc.deviceInfoId = self.lockModel.idField;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 3:
        {
            if ( self.lockModel.bluetoothType == 4 )
            {
                FLYFingerprintViewController * vc = [[FLYFingerprintViewController alloc] init];
                vc.lockModel = self.lockModel;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                FLYInputFaceViewController * vc = [[FLYInputFaceViewController alloc] init];
                vc.deviceInfoId = self.lockModel.idField;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

//拓邦开门
- (void)tuoBangOpenDoor
{
    if ( self.peripheral == nil )
    {
        if ( self.centralManager.state == CBManagerStateUnknown || self.centralManager.state == CBManagerStatePoweredOn )
        {
            [SVProgressHUD showWithStatus:@"扫描中"];
            
            //60秒后执行超时方法
            [self performSelector:@selector(searchTimeout) withObject:nil afterDelay:60];
            
            //扫描周边设备 (Services:是服务的UUID，而且是一个数组。如果不传，默认扫描所有服务)
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        }
        else
        {
            [self showCentralStateAlert:self.centralManager.state];
        }
    }
    else
    {
        [self getUnlockCodeNetwork];
    }
    
}



#pragma mark - CBCentralManagerDelegate

//判断设备的更新状态 (必须执行的代理)
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self showCentralStateAlert:central.state];
    
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"中心管理器状态未知");
            break;
        case CBManagerStateResetting:
            NSLog(@"中心管理器状态重置");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"中心管理器状态不被支持");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"中心管理器状态未被授权");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"中心管理器状态电源关闭");
            break;
        case CBManagerStatePoweredOn:
        {
            NSLog(@"中心管理器状态电源开启");
            
            //扫描周边设备 (Services:是服务的UUID，而且是一个数组。如果不传，默认扫描所有服务)
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        }
            break;
        default:
            break;
    }

}

/**
 当发现外围设备时，会调用的方法

 @param central 中央管理者
 @param peripheral 外围设备
 @param advertisementData 相关的数据
 @param RSSI 信号强度
 */
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    FLYLog(@"扫描到外设：%@", peripheral);
    
    if ( [advertisementData[@"kCBAdvDataLocalName"] localizedStandardContainsString:self.lockModel.imei] )
    {
        //取消延迟执行的 searchTimeout 方法
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        //停止扫描
        [self.centralManager stopScan];
        
        [SVProgressHUD showWithStatus:@"连接中"];
        
        self.peripheral = peripheral;
        self.peripheral.delegate = self;
        
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

/**
 连接到外设后调用

 @param central 中央管理者
 @param peripheral 外围设备
 */
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    FLYLog(@"连接外设成功：%@", peripheral);
    

    //扫描服务 -->可以传入UUID的数组，传nil代表扫描所有服务
    
    CBUUID * serviceUUID = [CBUUID UUIDWithString:SER_UUID_A];

    [self.peripheral discoverServices:@[serviceUUID]];
    
}

//连接外设失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    FLYLog(@"连接外设失败：%@, error：%@", peripheral, error);
}

//断开外设连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    if ( error )
    {
        FLYLog(@"发生错误导致断开连接：%@", peripheral);
        FLYLog(@"error：%@", error);
    }
    else
    {
        FLYLog(@"正常断开连接：%@", peripheral);
    }
    
    
    
    //[SVProgressHUD showImage:nil status:@"蓝牙已断开"];
    
    self.peripheral = nil;
    [self.characteristicList removeAllObjects];
}



#pragma mark - CBPeripheralDelegate

//当发现服务时调用
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService * service in peripheral.services )
    {
        if ( [service.UUID.UUIDString isEqualToString:SER_UUID_A] )
        {
            FLYLog(@"发现服务：%@", service);
            
            
            NSMutableArray * UUIDArray = [NSMutableArray array];
            
            [self.characteristicUUIDs enumerateObjectsUsingBlock:^(NSString * characteristicUUID, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CBUUID * UUID = [CBUUID UUIDWithString:characteristicUUID];
                [UUIDArray addObject:UUID];
            }];
            //扫描特征
            [self.peripheral discoverCharacteristics:UUIDArray forService:service];
        }
    }
}

//当发现特征时调用
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic * characteristic in service.characteristics )
    {
        
        if ( [self.characteristicUUIDs containsObject:characteristic.UUID.UUIDString] )
        {
            FLYLog(@"发现特征：%@", characteristic);
            
            [self.characteristicList addObject:characteristic];
            
            
            // 订阅, 实时接收 (在didUpdateValueForCharacteristic里返回)
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            if ( [characteristic.UUID.UUIDString isEqualToString:CHAR_UUID_A] )
            {
                //获取开锁指令
                [self getUnlockCodeNetwork];
            }
        }
    }
}

//执行readValueForCharacteristic:(读取特征数据)时会调用此代理
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ( error )
    {
        FLYLog(@"读取失败：%@", error);
    }
    else
    {
        FLYLog(@"读取成功：%@", characteristic.value);
    }
    
    
    
    //处理蓝牙传过来的数据
    
    if ( [characteristic.UUID.UUIDString isEqualToString:CHAR_UUID_B] )
    {
        /* 开锁之后，服务器锁会回传两次数据，要拼起来才能用 */
        
        NSString * hexStr = [FLYUtility convertDataToHexStr:characteristic.value];
        NSLog(@"hexStringhexString = %@", _command);
        
        if( hexStr.length > 5)
        {
            _command = hexStr;
        }
        else
        {
            _command = [NSString stringWithFormat:@"%@%@", _command, hexStr];
            
            //告诉服务器开锁成功
            [self openlockCompleteNetwork];
        }
    }
}


//写入数据回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    [SVProgressHUD dismiss];
    
    if ( error )
    {
        FLYLog(@"写入失败：%@", error);
    }
    else
    {
        FLYLog(@"写入成功");
    }
    
    
    if ( error )
    {
        [self showOpenDoorResult:FLYOpenDoorStatusFailure];
    }
    else
    {
        [self showOpenDoorResult:FLYOpenDoorStatusSuccess];
    }

}





#pragma mark - private methods

- (void)showOpenDoorResult:(FLYOpenDoorStatus)status
{
    FLYOpenDoorResultView * resultView = [[FLYOpenDoorResultView alloc] init];
    resultView.status = status;
    
    FLYPopupView * popupView = [FLYPopupView popupView:resultView animationType:(FLYPopupAnimationTypeMiddle) maskType:(FLYPopupMaskTypeBlack)];
    
    [resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(popupView);
        make.size.mas_equalTo(CGSizeMake(223, 160));
    }];
    
    [popupView show];
    
    
    //1秒后dissmiss
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         
        [popupView dissmiss];
        
        if( self.peripheral )
        {
            //断开蓝牙
            [self.centralManager cancelPeripheralConnection:self.peripheral];
        }
     });
 
}

//根据characteristicUUID获取characteristic
-(CBCharacteristic *)characteristicForUUID:(NSString *)characteristicUUID
{
    for (CBCharacteristic * characteristic in self.characteristicList)
    {
        if ( [characteristic.UUID.UUIDString isEqualToString:characteristicUUID] )
        {
            return characteristic;
        }
    }
    return nil;
}

- (void)searchTimeout
{
    [SVProgressHUD showErrorWithStatus:@"未搜索到设备"];
    
    //停止扫描
    [self.centralManager stopScan];
}

- (void)showCentralStateAlert:(CBManagerState)state
{
    if ( self.centralManager.state != CBManagerStatePoweredOn )
    {
        [SVProgressHUD dismiss];
        
        //取消延迟执行的 searchTimeout 方法
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    
    switch (state)
    {
        case CBManagerStateResetting:
        case CBManagerStateUnsupported:
            [SVProgressHUD showImage:nil status:@"蓝牙状态异常，请稍重试"];
            break;
        case CBManagerStateUnauthorized:
        {
            NSLog(@"中心管理器状态未被授权");
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"蓝牙未授权，请您开启蓝牙权限" preferredStyle:(UIAlertControllerStyleAlert) titles:@[@"取消", @"去设置"] alertAction:^(NSInteger index) {
                
                if ( index == 1 )
                {
                    NSURL * url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            
            [alertController show];
        }
            break;
        case CBManagerStatePoweredOff:
        {
            NSLog(@"中心管理器状态电源关闭");
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"蓝牙未开启，请打开蓝牙" preferredStyle:(UIAlertControllerStyleAlert) titles:@[@"确认"] alertAction:^(NSInteger index) {
            }];
            
            [alertController show];
        }
            break;
        default:
            break;
    }
}

- (NSData *)dataWithHexString:(NSString *)hexStr {
    hexStr = [hexStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    hexStr = [hexStr lowercaseString];
    NSUInteger len = hexStr.length;
    if (!len) return nil;
    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) return nil;
    [hexStr getCharacters:buf range:NSMakeRange(0, len)];
    
    NSMutableData *result = [NSMutableData data];
    unsigned char bytes;
    char str[3] = { '\0', '\0', '\0' };
    int i;
    for (i = 0; i < len / 2; i++) {
        str[0] = buf[i * 2];
        str[1] = buf[i * 2 + 1];
        bytes = strtol(str, NULL, 16);
        [result appendBytes:&bytes length:1];
    }
    free(buf);
    return result;
}



#pragma mark - setters and getters

-(FLYOpenDoorView *)openDoorView
{
    if ( _openDoorView == nil )
    {
        WeakSelf
        _openDoorView = [[FLYOpenDoorView alloc] init];
        _openDoorView.lockModel = self.lockModel;
        _openDoorView.openDoorBlock = ^(FLYOpenLockModel * _Nonnull lockModel) {
            
            [weakSelf openDoorClick];
        };
    }
    return _openDoorView;
}

-(FLYOpenDoorMenuView *)menuView
{
    if ( _menuView == nil )
    {
        WeakSelf
        _menuView = [[FLYOpenDoorMenuView alloc] init];
        _menuView.lockModel = self.lockModel;
        _menuView.menuBlock = ^(NSInteger index) {
            [weakSelf menuClick:index];
        };
    }
    return _menuView;
}

-(CBCentralManager *)centralManager
{
    if ( _centralManager == nil )
    {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _centralManager;
}

-(NSArray *)characteristicUUIDs
{
    if ( _characteristicUUIDs == nil )
    {
        _characteristicUUIDs = @[ CHAR_UUID_A, CHAR_UUID_B ];
    }
    return _characteristicUUIDs;
}

-(NSMutableArray<CBCharacteristic *> *)characteristicList
{
    if ( _characteristicList == nil )
    {
        _characteristicList = [NSMutableArray array];
    }
    return _characteristicList;
}

@end
