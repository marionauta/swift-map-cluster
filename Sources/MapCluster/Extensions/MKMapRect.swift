import Foundation
import MapKit

internal extension MKMapRect {
    var northEast: MKMapPoint {
        var base = origin
        base.x += width
        return base
    }

    var northWest: MKMapPoint { origin }
}
