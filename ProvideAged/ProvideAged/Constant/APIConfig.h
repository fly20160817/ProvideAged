//
//  APIConfig.h
//  Paint
//
//  Created by fly on 2019/9/19.
//  Copyright © 2019 fly. All rights reserved.
//

#ifndef APIConfig_h
#define APIConfig_h

//生产环境 https://api.zhiaiapp.com/      （不加密）
//测试环境 https://apitest.zhiaiapp.com/  （加密）
//本地环境 http://210.22.113.222:8888/
#define BASE_API @"https://api.zhiaiapp.com/"

//是否加密
#define ISENCRYPTION [BASE_API isEqualToString:@"https://apitest.zhiaiapp.com/"]



#pragma mark - 首页

//老人列表
#define API_ELDERLIST @"familyApplets/findElderList"

//老人详细信息
#define API_ELDERDETAIL @"familyApplets/singleElderDetail"

//首页药盒提醒
#define API_NEWESTREMIND @"familyApplets/newestRemind"

//系统字典 （参数type，1=照顾需求等级、2=老人状态、3=紧急按钮设备型号、4=门磁设备型号、5=烟感设备型号、6=燃气设备型号、7=水浸设备型号、8=红外设备型号、9=服务内容）
#define API_SYSDICT @"sys/dict/list"

//服务记录列表
#define API_SERVICERECORDLIST @"serviceRecord/page"

//设备状态
#define API_DEVICESTATUSE @"familyApplets/findDeviceStatus"

//设备列表
#define API_DEVICELIST @"familyApplets/findDeviceList"

//设备告警列表
#define API_WARNINGLIST @"deviceWarningLog/page"

//门磁开门记录
#define API_DOORRECORD @"magneticOpenInfo/page"

//门锁开门记录
#define API_LOCKRECORD @"lockInfo/pageOpenLog"

//在床记录
#define API_BEDRECORD @"mattressHealthInfo/page"

//步数历史数据
#define API_STEPLIST @"familyApplets/pageMotionTrajectoryRecord"

//颐养卡的位置信息
#define API_CARDLOCATION @"familyApplets/deviceLocation"

//运动轨迹
#define API_TRACK @"familyApplets/findMotionTrajectory"

//生理数据
#define API_HEALTH @"familyApplets/findHealthFile"

//生理数据
#define API_HEALTHHISTORY @"familyApplets/pageHealthDataList"

//折线图数据
#define API_HEALTHLIST @"familyApplets/findHealthDataList"

//联系老人聊天记录
#define API_CHATRECORD @"watchInformationInfo/page"

//给老人发送消息
#define API_SENDMESSAGE @"deviceInfo/information"

//视频监控列表
#define API_VIDEOLIST @"familyApplets/findCameraList"

//摄像头登录
#define API_CAMERALOGIN @"deviceInfo/cameraLogin"



#pragma mark - 智能药盒

//药品清单表
#define API_DRUGLIST @"drugsInfo/page"

//新增药品
#define API_ADDDRUG @"drugsInfo/add"

//删除药品
#define API_DELETEDRUG @"drugsInfo/delete"

//修改药品
#define API_UPDATEDRUG @"drugsInfo/update"

//用药记录
#define API_MEDICATIONRECORD @"medicationRecordInfo/list"

//服药时间列表
#define API_DRUGTIMELIST @"workRestInfo/list"

//修改时间列表
#define API_UPDATEDRUGTIME @"workRestInfo/update"

//用药提醒列表
#define API_DRUGREMINDLIST @"medicationRemindInfo/page"

//打开或关闭提醒
#define API_SWITCHREMIND @"medicationRemindInfo/openOrCloseUsed"

//删除提醒
#define API_DELETEREMIND @"medicationRemindInfo/delete"

//新增提醒
#define APIADDREMIND @"medicationRemindInfo/add"

//搜索药品（新增提醒时）
#define APISEARCHDRUGS @"drugsInfo/list"



#pragma mark - 开门

//开门的门锁列表
#define API_DOORLOCKLIST @"familyApplets/findDoorLockList"

//临时授权列表
#define API_TEMPAUTHORIZELIST @"lockInfo/pageLockAuthByApp"

//删除授权
#define API_DELETEAUTH @"lockInfo/deleteAuth"

//添加临时授权
#define API_ADDTEMPAUTH @"lockInfo/addTemporaryAuth"

//开门记录
#define API_OPENDOORRECORD @"lockInfo/pageOpenLog"

//忘记开门密码 (调用后会发送密码到手机号上)
#define API_FORGOTPASSWORD @"lockInfo/forgotPassword"

//拓邦开锁指令
#define API_TUOBANGOPENDOOR @"lockInfo/bluetoothOpen"

//告诉服务器拓邦开门成功
#define API_TUOBANGOPENDOORSUCCESS @"lockInfo/bluetoothResult"

//查询指纹
#define API_GETFINGER @"lockInfo/getFingerInfo"

//修改指纹名称
#define API_MODIFYFINGER @"lockInfo/modifyFingerName"



#pragma mark - 消息

//消息列表
#define API_MESSAGELIST @"familyApplets/pageDeviceWarningLog"

//消息标记已读
#define API_READMESSAGE @"familyApplets/haveReadWarningLog"



#pragma mark - 我的（包含登陆、用户相关）

//获取手机验证码
#define API_GETVITIFICATION @"auth/sendCode"

//登陆
#define API_LOGIN @"auth/login"

//退出登录
#define API_LOGOUT @"auth/logout"

//家庭列表
#define API_FAMILYLIST @"familyInfo/findHouseholdListByApplets"

//家庭人员列表
#define API_MEMBERLIST @"familyInfo/list"

//根据手机号，获取家庭人员信息
#define API_MEMBERINFO @"familyInfo/findUniqueByPhone"

//更新家庭人员信息
#define API_MEMBERUPDATE @"familyInfo/update"

//删除家庭人员
#define API_MEMBERDELETE @"familyInfo/delete"

//添加家庭人员
#define API_MEMBERADD @"familyInfo/add"

//意见反馈
#define API_FEEDBACK @"feedbackInfo/familyAdd"

//检测更新
#define API_APPVERSION @"softwareVersion/getLatestVersion"

//查询房间的门锁
#define API_HOUSELOCK @"lockInfo/findLockByHouseId"

//查询已经授权的房间门锁
#define API_AUTHORIZELOCK @"familyInfo/findAuthList"



#endif /* APIConfig_h */
