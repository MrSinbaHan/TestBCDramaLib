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
        let sdkPageType: BCTabPageType
        switch pageType {
        case .collection:
            sdkPageType = .collection
        case .album:
            sdkPageType = .album
        case .recommend:
            sdkPageType = .recommend
        }
        BCVideoManager.showSDK(from: vc, pageType: sdkPageType)
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
    case collection = 0
    case album = 1
    case recommend = 2
}

@objc public enum BCEnvTypeWrapper: Int {
    case debug = 0
    case release = 1
}

@objc public enum BCStrategyTypeWrapper: Int {
    case bidding = 1
    case round = 2
}

@objc public enum BCLanguageTypeWrapper: Int {
    case system = 0
    case chineseSimplified = 1
    case chineseTraditional = 2
    case english = 3
    case vietnamese = 4
}

// Block type definitions - REMOVED @objc public
public typealias BCVideoPlayOnStartBlock = @convention(block) (NSDictionary) -> Void
public typealias BCVideoPlayOnProgressBlock = @convention(block) (NSDictionary) -> Void
public typealias BCVideoPlayOnEndBlock = @convention(block) (NSDictionary) -> Void
public typealias BCVideoPlayOnUnlockBlock = @convention(block) (NSDictionary) -> Void
public typealias BCVideoPlayOnRewardBlock = @convention(block) (NSDictionary) -> Void
public typealias BCSetPaymentCallBackBlock = @convention(block) (NSDictionary) -> Void
public typealias BCPaySuccessBlock = @convention(block) (NSDictionary) -> Void
public typealias BCPayResultVerifyBlock = @convention(block) (NSDictionary) -> Void
public typealias BCPayCancleBlock = @convention(block) () -> Void // Assuming this one is correct
public typealias BCAdLoadedBlock = @convention(block) (NSDictionary?, NSDictionary?, NSDictionary?, NSDictionary?) -> Void
public typealias BCAdClickedBlock = @convention(block) (NSDictionary?) -> Void
public typealias BCAdDidRewardEffectiveBlock = @convention(block) (NSDictionary?, NSDictionary?) -> Void
public typealias BCAdClosedBlock = @convention(block) (NSDictionary?) -> Void
public typealias BCAdFailedBlock = @convention(block) (Int, NSError) -> Void
public typealias BCAdFinishBlock = @convention(block) (NSDictionary?) -> Void
public typealias BCRenderStatusBlock = @convention(block) (Bool) -> Void
public typealias BCCustomAdvInitBlock = @convention(block) () -> Void
public typealias BCCustomAdvRewardBlock = @convention(block) () -> Void
public typealias BCCustomAdvNativeExpressBlock = @convention(block) () -> Void
public typealias BCCustomAdvBannerBlock = @convention(block) () -> Void
public typealias BCAdUnLockBlock = @convention(block) (Int, Int) -> Void
public typealias BCStartAdRewardBlock = @convention(block) (NSDictionary?, NSDictionary?) -> Void

extension BCDramaLibWrapper {
    @objc public func logout() {
        BCVideoManager.logout()
    }

    @objc public func setLanguage(_ type: BCLanguageTypeWrapper) {
        let langType: BCLanguageType
        switch type {
        case .system: langType = .system
        case .chineseSimplified: langType = .chineseSimplified
        case .chineseTraditional: langType = .chineseTraditional
        case .english: langType = .english
        case .vietnamese: langType = .vietnamese
        }
        BCVideoManager.setLanguage(langType)
    }

    @objc public func setVideoPlayCallBack(onStart: BCVideoPlayOnStartBlock?, onProgress: BCVideoPlayOnProgressBlock?, onEnd: BCVideoPlayOnEndBlock?, onUnlock: BCVideoPlayOnUnlockBlock?, onReward: BCVideoPlayOnRewardBlock?) {
        BCVideoManager.setVideoPlayCallBack(
            onStart: { data in onStart?(data as NSDictionary) },
            onProgress: { data in onProgress?(data as NSDictionary) },
            onEnd: { data in onEnd?(data as NSDictionary) },
            onUnlock: { data in onUnlock?(data as NSDictionary) },
            onReward: { data in onReward?(data as NSDictionary) }
        )
    }

    @objc public func setEnvType(_ type: BCEnvTypeWrapper) {
        let envType: BCEnvType
        switch type {
        case .debug: envType = .debug
        case .release: envType = .release
        }
        BCVideoManager.setEnvType(envType)
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
            onPayVerify?(data as NSDictionary)
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
            onLoaded: { arg1, arg2, arg3, arg4 in onLoaded?(arg1 as? NSDictionary, arg2 as? NSDictionary, arg3 as? NSDictionary, arg4 as? NSDictionary) },
            onClicked: { arg1 in onClicked?(arg1 as? NSDictionary) },
            onEffective: { arg1, arg2 in onEffective?(arg1 as? NSDictionary, arg2 as? NSDictionary) },
            onClosed: { arg1 in onClosed?(arg1 as? NSDictionary) },
            onFailed: { adType, error in onFailed?(adType.rawValue, error as NSError) }
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
            onFinish?(data as? NSDictionary)
        }
    }

    @objc public func startRewardVideo(vc: UIViewController, videoId: Int, eposodeNo: Int, placementId: String, extra: String, onStartReward: BCStartAdRewardBlock?) {
        BCVideoManager.startRewardVideo(vc: vc, videoId: videoId, eposodeNo: eposodeNo, placementId: placementId, extra: extra) { arg1, arg2 in
            onStartReward?(arg1 as? NSDictionary, arg2 as? NSDictionary)
        }
    }

    @objc public func setAdvStrategy(type: BCStrategyTypeWrapper) {
        let strategyType: BCStrategyType
        switch type {
        case .bidding: strategyType = .bidding
        case .round: strategyType = .round
        }
        BCVideoManager.setAdvStrategy(type: strategyType)
    }
}
