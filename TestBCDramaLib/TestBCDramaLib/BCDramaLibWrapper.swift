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
        let sdkPageType = BCTabPageType(rawValue: pageType.rawValue) ?? .collection
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

// Block type definitions
@objc public typealias BCVideoPlayOnStartBlock = @convention(block) (Int, Int) -> Void
@objc public typealias BCVideoPlayOnProgressBlock = @convention(block) (Int, Int, Int, Int) -> Void
@objc public typealias BCVideoPlayOnEndBlock = @convention(block) (Int, Int) -> Void
@objc public typealias BCVideoPlayOnUnlockBlock = @convention(block) (Int, Int) -> Void
@objc public typealias BCVideoPlayOnRewardBlock = @convention(block) (Int, Int) -> Void
@objc public typealias BCSetPaymentCallBackBlock = @convention(block) (String) -> Void
@objc public typealias BCPaySuccessBlock = @convention(block) () -> Void
@objc public typealias BCPayResultVerifyBlock = @convention(block) () -> Void
@objc public typealias BCPayCancleBlock = @convention(block) () -> Void
@objc public typealias BCAdLoadedBlock = @convention(block) () -> Void
@objc public typealias BCAdClickedBlock = @convention(block) () -> Void
@objc public typealias BCAdDidRewardEffectiveBlock = @convention(block) () -> Void
@objc public typealias BCAdClosedBlock = @convention(block) () -> Void
@objc public typealias BCAdFailedBlock = @convention(block) (String) -> Void
@objc public typealias BCAdFinishBlock = @convention(block) () -> Void
@objc public typealias BCRenderStatusBlock = @convention(block) (Bool) -> Void
@objc public typealias BCCustomAdvInitBlock = @convention(block) () -> Void
@objc public typealias BCCustomAdvRewardBlock = @convention(block) () -> Void
@objc public typealias BCCustomAdvNativeExpressBlock = @convention(block) () -> Void
@objc public typealias BCCustomAdvBannerBlock = @convention(block) () -> Void
@objc public typealias BCAdUnLockBlock = @convention(block) (Bool) -> Void
@objc public typealias BCStartAdRewardBlock = @convention(block) () -> Void

extension BCDramaLibWrapper {
    @objc public func logout() {
        BCVideoManager.logout()
    }

    @objc public func setLanguage(_ type: BCLanguageTypeWrapper) {
        if let langType = BCLanguageType(rawValue: type.rawValue) {
            BCVideoManager.setLanguage(langType)
        }
    }

    @objc public func setVideoPlayCallBack(onStart: BCVideoPlayOnStartBlock?, onProgress: BCVideoPlayOnProgressBlock?, onEnd: BCVideoPlayOnEndBlock?, onUnlock: BCVideoPlayOnUnlockBlock?, onReward: BCVideoPlayOnRewardBlock?) {
        // Since I cannot know the exact signature of the original callbacks, I'm assuming them based on the context.
        // The user might need to correct this if the assumptions are wrong.
        BCVideoManager.setVideoPlayCallBack(
            onStart: { videoId, episode in onStart?(videoId, episode) },
            onProgress: { videoId, episode, current, total in onProgress?(videoId, episode, current, total) },
            onEnd: { videoId, episode in onEnd?(videoId, episode) },
            onUnlock: { videoId, episode in onUnlock?(videoId, episode) },
            onReward: { videoId, episode in onReward?(videoId, episode) }
        )
    }

    @objc public func setEnvType(_ type: BCEnvTypeWrapper) {
        if let envType = BCEnvType(rawValue: type.rawValue) {
            BCVideoManager.setEnvType(envType)
        }
    }

    @objc public func setPaymentCallback(onPayment: BCSetPaymentCallBackBlock?) {
        BCVideoManager.setPaymentCallback { json in
            onPayment?(json)
        }
    }

    @objc public func setPayment(onPaySuccess: BCPaySuccessBlock?) {
        BCVideoManager.setPayment {
            onPaySuccess?()
        }
    }

    @objc public func paymentResultVerify(onPayVerify: BCPayResultVerifyBlock?) {
        BCVideoManager.paymentResultVerify {
            onPayVerify?()
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
            onLoaded: { onLoaded?() },
            onClicked: { onClicked?() },
            onEffective: { onEffective?() },
            onClosed: { onClosed?() },
            onFailed: { error in onFailed?(error.localizedDescription) }
        )
    }

    @objc public func setVideoDefaultRate(_ videoId: Int, rate: Double) {
        BCVideoManager.setVideoDefaultRate(videoId, rate: rate)
    }

    @objc public func onUnLock(onUnLock: BCAdUnLockBlock?) {
        BCVideoManager.onUnLock { success in
            onUnLock?(success)
        }
    }

    @objc public func onAdDidFinish(onFinish: BCAdFinishBlock?) {
        BCVideoManager.onAdDidFinish {
            onFinish?()
        }
    }

    @objc public func startRewardVideo(vc: UIViewController, videoId: Int, eposodeNo: Int, placementId: String, extra: String, onStartReward: BCStartAdRewardBlock?) {
        BCVideoManager.startRewardVideo(vc: vc, videoId: videoId, eposodeNo: eposodeNo, placementId: placementId, extra: extra) {
            onStartReward?()
        }
    }

    @objc public func setAdvStrategy(type: BCStrategyTypeWrapper) {
        if let strategyType = BCStrategyType(rawValue: type.rawValue) {
            BCVideoManager.setAdvStrategy(type: strategyType)
        }
    }
}
