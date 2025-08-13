//
//  BCVideoManager.swift
//  BCDramaLib_Swift
//
//  Created by 傅中正 on 2025/6/6.
//

import Foundation
import TXLiteAVSDK_Player
import MJRefresh

public enum BCTabPageType: Int {
    case collection = 0
    case album = 1
    case recommend = 2
}

/// 设置开发环境
public enum BCEnvType: Int {
    
    /// 测试环境
    case debug = 0
    
    /// 生产环境
    case release = 1
}

/// 广告显示策略 1、竞价策略（不支持穿山甲） 2、轮循策略
public enum BCStrategyType: Int {
    case bidding = 1
    case round = 2
}

public class BCVideoManager {
    static let shared = BCVideoManager()
    
    private var videoPlayCallBack = {
        return BCVideoPlayCallBack.shared
    }()
    
    // MARK: - Initialization
    private init() {}
}

//MARK: 公共方法
extension BCVideoManager {
    
    /// 初始化SDK
    /// - Parameters:
    ///   - appId: BCVideoSDK的AppId
    ///   - packageName: 包名（bundleId）
    ///   - secret: 签名秘钥
    ///   - userId: app端用户唯一标识
    public static func initSDK(withAppId appId: String,
                               packageName: String,
                               secret: String,
                               userId: String) {
        // 设置登录参数
        BCLoginManager.shared.appId = appId
        BCLoginManager.shared.packageName = packageName
        BCLoginManager.shared.secret = secret
        BCLoginManager.shared.userId = userId
        BCLoginManager.shared.updateAdConfig()
        if BCLoginManager.shared.txLicenceUrl == "" {
            self.initThirdSDK()
        }
    }
    
    /// 初始化优量汇广告SDK
    /// - Parameter appId: appID
    public static func registerGDTSDK(_ appId: String) {
        BCLoginManager.shared.gtdSdk = appId
        BCLoginManager.shared.initGDTSDK()
    }
    
    /// 初始化播放器
    /// - Parameters:
    ///   - licenceURL: licenseUrl
    ///   - key: key
    public static func registerTXLiveSDK(_ licenceURL: String, key: String) {
        BCLoginManager.shared.txLicenceUrl = licenceURL
        BCLoginManager.shared.txKey = key
        self.initThirdSDK()
    }
    
    /// 退出登录
    public static func logout() {
        BCLoginManager.shared.logout()
    }
    
    /// 进入首页
    /// - Parameters:
    ///   - vc: 来源控制器
    ///   - pageType: page 类型
    public static func showSDK(from vc: UIViewController,
                               pageType: BCTabPageType = .collection) {
        let watchingVC = BCDramaFavoriteListViewController(pageIndex: 0)
        watchingVC.topOffset = BCDeviceUtils.getStatusBarHeight() + 44
        let playlistVC = BCDramaMenuListViewController(pageIndex: 1)
        playlistVC.topOffset = BCDeviceUtils.getStatusBarHeight() + 44
        let recommendVC = BCDramaRecommendViewController(pageIndex: 2)
        recommendVC.topOffset = BCDeviceUtils.getStatusBarHeight() + 44
        
        // 设置默认语言
        BCLocalizableManager.setDefaultLanguage()
        
        // 创建标签页控制器
        let tabPageVC = BCTabPageViewController(
            titles: [
                BCLocalizableManager.local("watching"),
                BCLocalizableManager.local("drama_list"),
                BCLocalizableManager.local("recommend"),
            ],
            viewControllers: [watchingVC, playlistVC, recommendVC],
            initIndex: pageType.rawValue
        )
        
        let navigationController = BCNavigationController(rootViewController: tabPageVC)
        navigationController.modalPresentationStyle = .overFullScreen
        vc.present(navigationController, animated: true)
    }
    
    /// 进入在追
    /// - Parameter vc: 来源控制器
    public static func showCollectionPage(from vc: UIViewController) {
        self.showSDK(from: vc, pageType: .collection)
    }
 
    /// 进入剧单
    /// - Parameter vc: 来源控制器
    public static func showAlbumListPage(from vc: UIViewController) {
        self.showSDK(from: vc, pageType: .album)
    }
    
    /// 进入推荐
    /// - Parameter vc: 来源控制器
    public static func showRecommendPage(from vc: UIViewController) {
        self.showSDK(from: vc, pageType: .recommend)
    }
    
    /// 设置国际化多语言
    /// - Parameter type: 语言地区类型
    public static func setLanguage(_ type: BCLanguageType) {
        let lang = BCLocalizableManager.setLanguage(type)
        MJRefreshConfig.default.languageCode = lang
    }
    
    /// 设置视频播放回调
    /// - Parameters:
    ///   - onStart: 开始的回调
    ///   - onProgress: 进度的回调
    ///   - onEnd: 结束的回调
    ///   - onUnlock: 解锁的回调
    ///   - onReward: 奖励的回调
    public static func setVideoPlayCallBack(onStart: BCVideoPlayOnStart?,
                                            onProgress: BCVideoPlayOnProgress?,
                                            onEnd: BCVideoPlayOnEnd?,
                                            onUnlock: BCVideoPlayOnUnlock?,
                                            onReward: BCVideoPlayOnReward?) {
        shared.videoPlayCallBack.onStart = onStart
        shared.videoPlayCallBack.onProgress = onProgress
        shared.videoPlayCallBack.onEnd = onEnd
        shared.videoPlayCallBack.onUnlock = onUnlock
        shared.videoPlayCallBack.onReward = onReward
    }
    
    /// 设置开发环境
    /// - Parameter type: 环境类型：0：生产环境， 1：开发环境
    public static func setEnvType(_ type: BCEnvType) {
        BCAPIService.shared.setUpBaseUrl(type)
    }
    
    /// 当短剧SDK里面选择商品点击商品时，调用对应的回调
    /// - Parameter onPayment: 商品参数JSON
    public static func setPaymentCallback(onPayment: BCSetPaymentCallBack?) {
        shared.videoPlayCallBack.onPayment = onPayment
    }
    
    /// 支付设置的回调
    /// - Parameter onPaySuccess: 支付成功后的回调
    public static func setPayment(onPaySuccess: BCPaySuccess?) {
        shared.videoPlayCallBack.onPaySuccess = onPaySuccess
    }
    
    /// 当付款成功后调用此方法通知短剧sdk验证订单付款状态
    /// - Parameter onPaySuccess: 支付成功后的回调
    public static func paymentResultVerify(onPayVerify: BCPayResultVerify?) {
        shared.videoPlayCallBack.payResultVerify = onPayVerify
    }
    
    /// 查询订单支付状态
    /// - Parameter orderNo: 订单号
    /// - Returns: 支付状态
    public static func verifyPaymentResult(orderNo: String, complet: @escaping (Int)->Void) {
        BCPaymentManager.shared.checkPaymentOrder(orderNo) { checkModel in
            complet(checkModel.payState)
        } failure: { error in
            print("【BCXJ】订单查询失败: \(error)")
        }
    }

    /// 取消付款，当用户取消支付时调用此方法。
    /// - Parameter onPayCancle: 取消支付的回调
    public static func paymentCancel(onPayCancle: BCPayCancle?) {
        shared.videoPlayCallBack.onPayCancle = onPayCancle
    }
    
    /// 设置广告加载的回调
    /// - Parameters:
    ///   - onLoaded: 加载成功后的回调
    ///   - onClicked: 广告被点击的回调
    ///   - onEffective: 广告发放奖励后的回调（仅有激励视频有奖励的回调）
    ///   - onClosed: 广告关闭后的回调
    ///   - onFiled: 广告加载失败后的回调
    public static func loadVideoAdCallback(onLoaded: BCAdLoaded?,
                                           onClicked: BCAdClicked?,
                                           onEffective: BCAdDidRewardEffective?,
                                           onClosed: BCAdClosed?,
                                           onFailed: BCAdFailed?) {
        shared.videoPlayCallBack.onAdLoaded = onLoaded
        shared.videoPlayCallBack.onAdClicked = onClicked
        shared.videoPlayCallBack.onAdEffective = onEffective
        shared.videoPlayCallBack.onAdClosed = onClosed
        shared.videoPlayCallBack.onAdFailed = onFailed
    }
    
    /// 设置广告加载的回调
    /// - Parameter onLoaded: 加载成功后的回调
    public static func loadAdvSuccess(onLoaded: BCAdLoaded?) {
        shared.videoPlayCallBack.onAdLoaded = onLoaded
    }
    
    /// 设置广告加载的回调
    /// - Parameter onClicked: 广告被点击的回调
    public static func loadAdvOnClicked(onClicked: BCAdClicked?) {
        shared.videoPlayCallBack.onAdClicked = onClicked
    }
    
    
    /// 设置广告加载的回调
    /// - Parameter onEffective: 广告发放奖励后的回调（仅有激励视频有奖励的回调）
    public static func loadAdvEffective(onEffective: BCAdDidRewardEffective?) {
        shared.videoPlayCallBack.onAdEffective = onEffective
    }
    
    /// 设置广告加载的回调
    /// - Parameter onClosed: 广告关闭后的回调
    public static func loadAdvOnClosed(onClosed: BCAdClosed?) {
        shared.videoPlayCallBack.onAdClosed = onClosed
    }
    
    /// 设置广告加载的回调
    /// - Parameter onFailed: 广告加载失败后的回调
    public static func loadAdvOnFailed(onFailed: BCAdFailed?) {
        shared.videoPlayCallBack.onAdFailed = onFailed
    }
    
    /// 设置广告加载的回调
    /// - Parameter onFinished: 广告加载完成的回调
    public static func loadAdvOnShowFinished(onFinished: BCAdFinish?) {
        shared.videoPlayCallBack.onAdFinish = onFinished
    }
    
    
    /// 设置广告加载的回调
    /// - Parameter onRender: 信息流广告渲染是否成功的回调
    public static func loadNativeExpressRender(onRender: BCRenderStatus?) {
        shared.videoPlayCallBack.onAdRenderStatus = onRender
    }
    
    /// 自定义广告回调
    /// - Parameters:
    ///   - initAd: 初始化广告
    ///   - rewardAd: 自定义激励广告
    ///   - nativeExpressAd: 自定义信息流广告
    ///   - bannerAd: 自定义banner广告
    public static func setCustomAdvCallback(initAd: BCCustomAdvInit?,
                                            rewardAd: BCCustomAdvReward?,
                                            nativeExpressAd: BCCustomAdvNativeExpress?,
                                            bannerAd: BCCustomAdvBanner?) {
        shared.videoPlayCallBack.initAdCallback = initAd
        shared.videoPlayCallBack.rewardAdCallback = rewardAd
        shared.videoPlayCallBack.nativeExpressAdCallback = nativeExpressAd
        shared.videoPlayCallBack.bannerAdCallback = bannerAd
    }
    
    /// 设置默认播放速度，正常播放传1X，默认为1.25X
    /// 支持 0.75X、1.0X、1.25X、1.5X、2.0X
    ///  - Parameter videoId: 剧ID
    /// - Parameter rate: 播放速率
    public static func setVideoDefaultRate(_ videoId:Int, rate: Double) {
        BCPlayVideoRecord.shared.setVideoRatePreferences(videoId, rate: rate)
    }
    
    /// 剧集解锁是否成功的回调
    /// - Parameter onUnLock: 验证剧集是否解锁后的回调
    public static func onUnLock(onUnLock: BCAdUnLock?) {
        shared.videoPlayCallBack.onAdUnLock = onUnLock
    }
    
    /// 广告播放完成，奖励发放回调
    /// - Parameter onFinish: 广告播放完成后发放奖励的回调
    public static func onAdDidFinish(onFinish: BCAdFinish?) {
        shared.videoPlayCallBack.onAdFinish = onFinish
    }
    
    /// 开始激励视频
    /// - Parameters:
    ///   - vc: 来源控制器
    ///   - videoId: 短剧Id
    ///   - eposodeNo: 剧集索引
    ///   - placementId: 广告位ID
    ///   - extra: 扩展信息
    ///   - onStartReward: 开始激励视频的回调
    ///   - onAdFiled: 激励视频加载失败的回调
    public static func startRewardVideo(vc: UIViewController,
                                        videoId: Int,
                                        eposodeNo: Int,
                                        placementId: String = "",
                                        extra: String = "",
                                        onStartReward: BCStartAdReward?) {
        BCAdAPIManager.shared.unlockByWatchingRewardAds(vc, videoId, eposodeNo, placementId, extra, false) { playModel in
            
        } success: { ecmp in
            shared.videoPlayCallBack.onStartAdReward = onStartReward
        } failure: { error in
            print("【BCXJ】开始激励视频失败Error: \(error)")
        }
    }
    
    /// 进入播放页
    /// - Parameters:
    ///   - vc: 来源控制器
    ///   - videoId: 剧ID
    ///   - lastEpisodeNo: 播放的剧集索引
    public static func jumpToVideoPlayController(from vc: UIViewController,
                                                 videoId: Int,
                                                 lastEpisodeNo: Int) {
        
        // 设置默认语言
        BCLocalizableManager.setDefaultLanguage()
        
        let episodeListVC = BCDramaEpisodeListViewController(videoId: videoId, playEpisodeNo: lastEpisodeNo)
        if let navController = vc.navigationController {
            navController.pushViewController(episodeListVC, animated: true)
        }else {
//            let navigationController = BCNavigationController(rootViewController: episodeListVC)
//            navigationController.modalPresentationStyle = .overFullScreen
            episodeListVC.modalPresentationStyle = .overFullScreen
            vc.present(episodeListVC, animated: true)
        }
    }
    
    /// 进入剧单更多-剧列表
    /// - Parameters:
    ///   - vc: 来源控制器
    ///   - menuId: 剧单ID
    public static func jumpToVideoMoreDetailList(from vc: UIViewController, _ menuId: Int, _ menuName: String) {
        // 设置默认语言
        BCLocalizableManager.setDefaultLanguage()
        
        let menuDetailVC = BCDramaMenuDetailViewController()
        menuDetailVC.menu = BCDramaMenuModel(menuId: menuId, menuName: menuName, list: [])
        if let navController = vc.navigationController {
            navController.pushViewController(menuDetailVC, animated: true)
        }else {
            menuDetailVC.modalPresentationStyle = .overFullScreen
            vc.present(menuDetailVC, animated: true)
        }
    }
    
    /// 获取可支持的广告平台的eCPM()
    /// - Parameters:
    ///   - platform: 媒体类型：1-优量汇，2-百度联盟，3-穿山甲
    ///   - adType: 广告类型：1-banner，2-激励广告，3-信息流广告
    ///   - complete: 初始化广告成功后的回调
    public static func getECPM(with platform: BCAdPlatformType, adType: BCAdType, complete: @escaping (Int, String, BCAdType)->Void) {
        BCAdStrategyManager.shared.getECPM(with: platform, adType: adType, complete: complete)
    }
    
    /// 设置广告策略
    /// - Parameter type: 策略类型
    public static func setAdvStrategy(type: BCStrategyType) {
        BCLoginManager.shared.strategtType = type
    }
    
    
    // 观看历史记录, 我的收藏页面
    
//    /// 日志拦截且上报
//    /// - Parameter exception: 闪退异常
//    public static func registerException(exception: NSException) {
//        BCExceptionManager.shared.exceptionHandler(exception: exception)
//    }
//    
//    /// 关闭打印 - 还没做
//    /// - Parameter isClose: 是否关闭打印
//    public static func closePrint(_ isClose: Bool = true) {
//        
//    }
}


//MARK: 私有方法
extension BCVideoManager {
    
    // 初始化第三方SDK
    private static func initThirdSDK() {
        
        var key = "99c843cd9e1a46a589fbd1a76cd244f6"
        var licenceUrl = "https://license.vod2.myqcloud.com/license/v2/1314161253_1/v_cube.license"
        
        if BCLoginManager.shared.txKey != "" {
            key = BCLoginManager.shared.txKey
        }
        if BCLoginManager.shared.txLicenceUrl != "" {
            licenceUrl = BCLoginManager.shared.txLicenceUrl
        }
        
        TXLiveBase.setConsoleEnabled(true)
        TXLiveBase.setLogLevel(.LOGLEVEL_DEBUG)
        TXLiveBase.setLicenceURL(licenceUrl,key: key)
        
        // 设置视频缓存地址和大小
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let path = paths.first {
            let cachePath = path.appending("/TXCache")
            TXPlayerGlobalSetting.setCacheFolderPath(cachePath)
            TXPlayerGlobalSetting.setMaxCacheSize(1000)
        }
    }
}
