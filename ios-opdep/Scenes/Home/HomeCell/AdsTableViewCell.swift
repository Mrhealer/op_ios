//
//  AdsTableViewCell.swift
//  ios-opdep
//
//  Created by VMO C10 IOS on 6/7/21.
//

import UIKit
import GoogleMobileAds

class AdsTableViewCell: UITableViewCell {

    @IBOutlet weak var tableAdsCell: UIView!
    
    private var adLoader: GADAdLoader!
    private var nativeAdView: GADUnifiedNativeAdView!
    private var request = GADRequest()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        tableAdsCell.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = tableAdsCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let rightConstraint = tableAdsCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let bottomConstraint = tableAdsCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, bottomConstraint])
    }
    
    func loadAd(rootViewController: UIViewController) {
        loadViewAdMob()
        let adMediaLoad = GADNativeAdMediaAdLoaderOptions()
        adMediaLoad.mediaAspectRatio = .landscape
        adLoader = GADAdLoader(
            adUnitID: "", rootViewController: rootViewController,
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
