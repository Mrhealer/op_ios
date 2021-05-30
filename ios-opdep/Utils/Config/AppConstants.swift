//
//  AppConstants.swift

import UIKit

struct AppConstants {
    struct CreateDesign {
        static let designImageSize = CGSize(width: 100,
                                            height: 100)
        static let designBorderWidth: CGFloat = 3.0
        static let designBorderTextWidth: CGFloat = 1.0
        static let imageMaxZoom: CGFloat = 10.0
        static let textMaxZoom: CGFloat = 2.0
        static let minZoom: CGFloat = 0.1
        static let defaultText = "Write your story"
        static let designSizeStandard: CGSize = CGSize(width: 375,
                                                       height: 812)
        static let designFrameSize: CGSize = CGSize(width: 108,
                                                    height: 192)
    }
    
    enum Common {
        static let currencyUnit: String = "vnđ"
        static let tabBarHeight: CGFloat = 62.0
        static let heightItemHome: CGFloat = (UIScreen.main.bounds.size.width - 24 - 24) * 179 / 353
    }
    enum Links {
        // MARK: Social Media
        static let youtube = "https://www.youtube.com/channel/UC9VzzV9FvE7EchuRaIRL9hA"
    }
    enum OrderStatusNumber {
        static let RECEIVED = 0
        static let PAID = 1
        static let PROCESSING = 2
        static let SHIPPED = 3
        static let DELIVERED = 4
        static let CANCELLED = 5
        static let CONFIRMED = 6
        static let INCOMPLETE = 7
    }
    enum OperationType {
        static let ANDROID = 1
        static let IOS = 2
    }

    static let colors: [ColorModel] = [
        ColorModel(hexColor: "0048BA"),
        ColorModel(hexColor: "#B0BF1A"),
        ColorModel(hexColor: "#7CB9E8"),
        ColorModel(hexColor: "#C0E8D5"),
        ColorModel(hexColor: "#B284BE"),
        ColorModel(hexColor: "#72A0C1"),
        ColorModel(hexColor: "#EDEAE0"),
        ColorModel(hexColor: "#F0F8FF"),
        ColorModel(hexColor: "#C46210"),
        ColorModel(hexColor: "#EFDECD"),
        ColorModel(hexColor: "#E52B50"),
        ColorModel(hexColor: "#9F2B68"),
        ColorModel(hexColor: "#F19CBB"),
        ColorModel(hexColor: "#AB274F"),
        ColorModel(hexColor: "#D3212D"),
        ColorModel(hexColor: "#3B7A57"),
        ColorModel(hexColor: "#FFBF00"),
        ColorModel(hexColor: "#FF7E00"),
        ColorModel(hexColor: "#9966CC"),
        ColorModel(hexColor: "#A4C639"),
        ColorModel(hexColor: "#CD9575"),
        ColorModel(hexColor: "#665D1E"),
        ColorModel(hexColor: "#915C83"),
        ColorModel(hexColor: "#841B2D"),
        ColorModel(hexColor: "#FAEBD7"),
        ColorModel(hexColor: "#008000"),
        ColorModel(hexColor: "#8DB600"),
        ColorModel(hexColor: "#FBCEB1"),
        ColorModel(hexColor: "#00FFFF"),
        ColorModel(hexColor: "#7FFFD4"),
        ColorModel(hexColor: "#D0FF14"),
        ColorModel(hexColor: "#4B5320"),
        ColorModel(hexColor: "#8F9779"),
        ColorModel(hexColor: "#E9D66B"),
        ColorModel(hexColor: "#B2BEB5"),
        ColorModel(hexColor: "#87A96B"),
        ColorModel(hexColor: "#FF9966"),
        ColorModel(hexColor: "#A52A2A"),
        ColorModel(hexColor: "#FDEE00"),
        ColorModel(hexColor: "#568203"),
        ColorModel(hexColor: "#007FFF"),
        ColorModel(hexColor: "#F0FFFF"),
        ColorModel(hexColor: "#89CFF0"),
        ColorModel(hexColor: "#A1CAF1"),
        ColorModel(hexColor: "#F4C2C2"),
        ColorModel(hexColor: "#FEFEFA"),
        ColorModel(hexColor: "#FF91AF"),
        ColorModel(hexColor: "#FAE7B5"),
        ColorModel(hexColor: "#DA1884"),
        ColorModel(hexColor: "#7C0A02"),
        ColorModel(hexColor: "#848482"),
        ColorModel(hexColor: "#BCD4E6"),
        ColorModel(hexColor: "#9F8170"),
        ColorModel(hexColor: "#F5F5DC"),
        ColorModel(hexColor: "#2E5894"),
        ColorModel(hexColor: "#9C2542"),
        ColorModel(hexColor: "#FFE4C4"),
        ColorModel(hexColor: "#3D2B1F"),
        ColorModel(hexColor: "#967117"),
        ColorModel(hexColor: "#CAE00D"),
        ColorModel(hexColor: "#BFFF00"),
        ColorModel(hexColor: "#FE6F5E"),
        ColorModel(hexColor: "#BF4F51"),
        ColorModel(hexColor: "#000000"),
        ColorModel(hexColor: "#3D0C02"),
        ColorModel(hexColor: "#1B1811"),
        ColorModel(hexColor: "#ACE5EE"),
        ColorModel(hexColor: "#CB4154"),
        ColorModel(hexColor: "#2F847C"),
        ColorModel(hexColor: "#DFFF00"),
        ColorModel(hexColor: "#CC397B"),
        ColorModel(hexColor: "#CC397B")
    ]
}
