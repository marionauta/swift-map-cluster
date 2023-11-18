import Foundation
import MapKit

public protocol WithCoordinate {
    var coordinate: CLLocationCoordinate2D { get }
}

public extension WithCoordinate {
    /// Returns the number of meters between two `WithCoordinate` types.
    ///
    /// This distance reflects the actual distance between the two points on the surface of the globe,
    /// taking into account the curvature of the Earth.
    func distance(to other: any WithCoordinate) -> Double {
        MKMapPoint(coordinate).distance(to: MKMapPoint(other.coordinate))
    }
}
