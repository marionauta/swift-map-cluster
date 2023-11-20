#if canImport(UIKit)
import UIKit

internal extension UIApplication {
    var windowScene: UIWindowScene? {
        return connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first
    }

    var screen: UIScreen? { windowScene?.screen }

    var keyWindow: UIWindow? { windowScene?.windows.first(where: \.isKeyWindow) }
}
#endif
