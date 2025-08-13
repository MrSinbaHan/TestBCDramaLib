import Foundation
import BCDramaLib
import UIKit

@objc(BCDramaLibWrapper)
public class BCDramaLibWrapper: NSObject {

    @objc public override init() {
        super.init()
    }

    @objc public func initSDK(withAppId appId: String, packageName: String, secret: String, userId: String) {
        BCVideoManager.initSDK(withAppId: appId, packageName: packageName, secret: secret, userId: userId)
    }

    @objc public func registerGDTSDK(_ appId: String) {
        BCVideoManager.registerGDTSDK(appId)
    }

    @objc public func registerTXLiveSDK(_ licenceURL: String, key: String) {
        BCVideoManager.registerTXLiveSDK(licenceURL, key: key)
    }

    @objc public func showSDK(from vc: UIViewController, pageType: BCTabPageTypeWrapper) {
        BCVideoManager.showSDK(from: vc, pageType: BCTabPageType(rawValue: pageType.rawValue)!)
    }

    @objc public func showCollectionPage(from vc: UIViewController) {
        BCVideoManager.showCollectionPage(from: vc)
    }

    @objc public func showAlbumListPage(from vc: UIViewController) {
        BCVideoManager.showAlbumListPage(from: vc)
    }

    @objc public func showRecommendPage(from vc: UIViewController) {
        BCVideoManager.showRecommendPage(from: vc)
    }

    @objc public func jumpToVideoPlayController(from vc: UIViewController, videoId: Int, lastEpisodeNo: Int) {
        BCVideoManager.jumpToVideoPlayController(from: vc, videoId: videoId, lastEpisodeNo: lastEpisodeNo)
    }

    @objc public func jumpToVideoMoreDetailList(from vc: UIViewController, menuId: Int, menuName: String) {
        BCVideoManager.jumpToVideoMoreDetailList(from: vc, menuId, menuName)
    }
}

// Wrapper Enums
@objc public enum BCTabPageTypeWrapper: Int {
    case collection, album, recommend
}

@objc public enum BCEnvTypeWrapper: Int {
    case debug, release
}

@objc public enum BCStrategyTypeWrapper: Int {
    case bidding = 1, round = 2
}

@objc public enum BCLanguageTypeWrapper: Int {
    case cn, ct, en, vi
}

@objc public enum BCAdPlatformTypeWrapper: Int {
    case union, baidu, chuanshanjia
}

@objc public enum BCAdTypeWrapper: Int {
    case banner, reward, nativeExpress
}

// Block type definitions
public typealias BCVideoPlayOnStartBlock = @convention(block) (NSDictionary) -> Void
public typealias BCVideoPlayOnProgressBlock = @convention(block) (Int, Int, Int, Int) -> Void
public typealias BCVideoPlayOnEndBlock = @convention(block) (NSDictionary) -> Void
public typealias BCVideoPlayOnUnlockBlock = @convention(block) (NSDictionary) -> Void
public typealias BCVideoPlayOnRewardBlock = @convention(block) (NSDictionary) -> Void
public typealias BCSetPaymentCallBackBlock = @convention(block) (NSDictionary) -> Void
public typealias BCPaySuccessBlock = @convention(block) (NSDictionary) -> Void
public typealias BCPayResultVerifyBlock = @convention(block) (Int) -> Void
public typealias BCPayCancleBlock = @convention(block) () -> Void
public typealias BCAdLoadedBlock = @convention(block) (Int, String?, String?, String?) -> Void
public typealias BCAdClickedBlock = @convention(block) (Int) -> Void
public typealias BCAdDidRewardEffectiveBlock = @convention(block) (Int, Int) -> Void
public typealias BCAdClosedBlock = @convention(block) (Int) -> Void
public typealias BCAdFailedBlock = @convention(block) (Int, NSError) -> Void
public typealias BCAdFinishBlock = @convention(block) (Int) -> Void
public typealias BCRenderStatusBlock = @convention(block) (Int, Bool) -> Void
public typealias BCCustomAdvInitBlock = @convention(block) (String) -> Void
public typealias BCCustomAdvRewardBlock = @convention(block) (String, String, String) -> Void
public typealias BCCustomAdvNativeExpressBlock = @convention(block) (String, Double, Double) -> Void
public typealias BCCustomAdvBannerBlock = @convention(block) (String) -> Void
public typealias BCAdUnLockBlock = @convention(block) (Int, Int) -> Void
public typealias BCStartAdRewardBlock = @convention(block) (Int, Int) -> Void
public typealias BCECPMCompleteBlock = @convention(block) (Int, String, Int) -> Void

extension BCDramaLibWrapper {
    @objc public func logout() {
        BCVideoManager.logout()
    }

    @objc public func setLanguage(_ type: BCLanguageTypeWrapper) {
        let langType: BCLanguageType
        switch type {
        case .cn: langType = .cn
        case .ct: langType = .ct
        case .en: langType = .en
        case .vi: langType = .vi
        }
        BCVideoManager.setLanguage(langType)
    }

    @objc public func setVideoPlayCallBack(onStart: BCVideoPlayOnStartBlock?, onProgress: BCVideoPlayOnProgressBlock?, onEnd: BCVideoPlayOnEndBlock?, onUnlock: BCVideoPlayOnUnlockBlock?, onReward: BCVideoPlayOnRewardBlock?) {
        BCVideoManager.setVideoPlayCallBack(
            onStart: { data in onStart?(data as NSDictionary) },
            onProgress: { videoId, episode, current, total in onProgress?(videoId, episode, current, total) },
            onEnd: { data in onEnd?(data as NSDictionary) },
            onUnlock: { data in onUnlock?(data as NSDictionary) },
            onReward: { data in onReward?(data as NSDictionary) }
        )
    }

    @objc public func setEnvType(_ type: BCEnvTypeWrapper) {
        BCVideoManager.setEnvType(BCEnvType(rawValue: type.rawValue)!)
    }

    @objc public func setPaymentCallback(onPayment: BCSetPaymentCallBackBlock?) {
        BCVideoManager.setPaymentCallback { json in
            onPayment?(json as NSDictionary)
        }
    }

    @objc public func setPayment(onPaySuccess: BCPaySuccessBlock?) {
        BCVideoManager.setPayment { data in
            onPaySuccess?(data as NSDictionary)
        }
    }

    @objc public func paymentResultVerify(onPayVerify: BCPayResultVerifyBlock?) {
        BCVideoManager.paymentResultVerify { data in
            onPayVerify?(data)
        }
    }

    @objc public func verifyPaymentResult(orderNo: String, complet: @escaping (Int) -> Void) {
        BCVideoManager.verifyPaymentResult(orderNo: orderNo, complet: complet)
    }

    @objc public func paymentCancel(onPayCancle: BCPayCancleBlock?) {
        BCVideoManager.paymentCancel {
            onPayCancle?()
        }
    }

    @objc public func loadVideoAdCallback(onLoaded: BCAdLoadedBlock?, onClicked: BCAdClickedBlock?, onEffective: BCAdDidRewardEffectiveBlock?, onClosed: BCAdClosedBlock?, onFailed: BCAdFailedBlock?) {
        BCVideoManager.loadVideoAdCallback(
            onLoaded: { adType, s1, s2, s3 in onLoaded?(adType.rawValue, s1, s2, s3) },
            onClicked: { adType in onClicked?(adType.rawValue) },
            onEffective: { adType, val in onEffective?(adType.rawValue, val) },
            onClosed: { adType in onClosed?(adType.rawValue) },
            onFailed: { adType, error in onFailed?(adType.rawValue, error as NSError) }
        )
    }

    @objc public func loadNativeExpressRender(onRender: BCRenderStatusBlock?) {
        BCVideoManager.loadNativeExpressRender { adType, success in
            onRender?(adType.rawValue, success)
        }
    }

    @objc public func setCustomAdvCallback(initAd: BCCustomAdvInitBlock?, rewardAd: BCCustomAdvRewardBlock?, nativeExpressAd: BCCustomAdvNativeExpressBlock?, bannerAd: BCCustomAdvBannerBlock?) {
        BCVideoManager.setCustomAdvCallback(
            initAd: initAd,
            rewardAd: rewardAd,
            nativeExpressAd: nativeExpressAd,
            bannerAd: bannerAd
        )
    }

    @objc public func setVideoDefaultRate(_ videoId: Int, rate: Double) {
        BCVideoManager.setVideoDefaultRate(videoId, rate: rate)
    }

    @objc public func onUnLock(onUnLock: BCAdUnLockBlock?) {
        BCVideoManager.onUnLock { unlockType, val in
            onUnLock?(unlockType.rawValue, val)
        }
    }

    @objc public func onAdDidFinish(onFinish: BCAdFinishBlock?) {
        BCVideoManager.onAdDidFinish { data in
            onFinish?(data)
        }
    }

    @objc public func startRewardVideo(vc: UIViewController, videoId: Int, eposodeNo: Int, placementId: String, extra: String, onStartReward: BCStartAdRewardBlock?) {
        BCVideoManager.startRewardVideo(vc: vc, videoId: videoId, eposodeNo: eposodeNo, placementId: placementId, extra: extra) { platform, adType in
            onStartReward?(platform.rawValue, adType.rawValue)
        }
    }

    @objc public func getECPM(with platform: BCAdPlatformTypeWrapper, adType: BCAdTypeWrapper, complete: @escaping BCECPMCompleteBlock) {
        BCVideoManager.getECPM(with: BCAdPlatformType(rawValue: platform.rawValue)!, adType: BCAdType(rawValue: adType.rawValue)!) { i, s, adT in
            complete(i, s, adT.rawValue)
        }
    }

    @objc public func setAdvStrategy(type: BCStrategyTypeWrapper) {
        BCVideoManager.setAdvStrategy(type: BCStrategyType(rawValue: type.rawValue)!)
    }
}
