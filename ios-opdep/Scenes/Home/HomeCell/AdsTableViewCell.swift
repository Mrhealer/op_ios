//
//  AdsTableViewCell.swift
//  ios-opdep
//
//  Created by VMO C10 IOS on 6/7/21.
//

import UIKit
import GoogleMobileAds

class AdsTableViewCell: UITableViewCell {

    var tableAdsCell =  UIView()
    
    private var adLoader: GADAdLoader!
    private var nativeAdView: GADUnifiedNativeAdView!
    private var request = GADRequest()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepare() {
        self.addSubview(tableAdsCell)
        tableAdsCell.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }
    }
    
    func loadAd(rootViewController: UIViewController) {
        loadViewAdMob()
        let adMediaLoad = GADNativeAdMediaAdLoaderOptions()
        adMediaLoad.mediaAspectRatio = .landscape
        adLoader = GADAdLoader(
            adUnitID: "ca-app-pub-7717959238784130/1547878940", rootViewController: rootViewController,
            adTypes: [.unifiedNative], options: [adMediaLoad])
        adLoader.delegate = self
        adLoader.load(request)
    }
    
    private func loadViewAdMob() {
        guard
            let nibObjects = Bundle.main.loadNibNamed("UnifiedNativeAdView", owner: nil, options: nil),
            let adView = nibObjects.first as? GADUnifiedNativeAdView
        else {
            return
        }
        if nativeAdView != nil {
            nativeAdView.removeFromSuperview()
        }
        nativeAdView = adView
        tableAdsCell.addSubview(nativeAdView)
    }
    
}

extension AdsTableViewCell: GADAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {

    }
    
}

extension AdsTableViewCell: GADUnifiedNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        nativeAd.delegate = self
        let widthView = UIScreen.main.bounds.width - CGFloat(46)
        let heightView = widthView * 142 / 329
        nativeAdView.frame = CGRect(x: 0, y: 0, width: widthView, height: heightView)
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        (nativeAdView.imageView as? UIImageView)?.image = nativeAd.images?.first?.image
        if let viewWithTag = nativeAdView.viewWithTag(10215) {
            viewWithTag.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            viewWithTag.frame = CGRect(x: 0, y: 0, width: widthView, height: heightView)
            viewWithTag.layer.cornerRadius = 15
            viewWithTag.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            viewWithTag.clipsToBounds = true
        }
//        nativeAdView.snp.makeConstraints{
//            $0.left.equalToSuperview().offset(24)
//            $0.right.equalToSuperview().offset(-24)
//            $0.bottom.equalToSuperview().offset(-8)
//        }
        nativeAdView.nativeAd = nativeAd
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
    }
    
}

extension AdsTableViewCell: GADUnifiedNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
        
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
        
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
        
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
        
    }
    
}
