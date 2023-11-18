import CoreLocation
import Foundation
import MapKit

public struct MapCluster<Single: MapSingle>: Equatable, Identifiable, WithCoordinate {
    public let id: Single.ID
    public var singles: [Single]

    public init(id: Single.ID, singles: [Single]) {
        self.id = id
        self.singles = singles
    }

    public var coordinate: CLLocationCoordinate2D {
        return centerpoint(of: singles.map(\.coordinate)) ?? .init()
    }
}

public extension MapCluster {
    static func clusterize(_ singles: [Single], proximity: Double, bounds: MKMapRect?) -> [MapMarker<Single>] {
        var markers: [MapMarker<Single>] = []
        singlesLoop: for newSingle in singles {
            if let bounds, !bounds.contains(MKMapPoint(newSingle.coordinate)) { continue }
            for index in 0..<markers.count {
                let marker = markers[index]

                if newSingle.distance(to: marker) < proximity {
                    let cluster = marker.joining(other: newSingle)
                    markers.remove(at: index)
                    markers.insert(cluster, at: index)
                    continue singlesLoop
                }
            }
            markers.append(.single(newSingle))
        }
        return markers
    }
}

private func centerpoint(of locations: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
    guard !locations.isEmpty else { return nil }
    var minLat = 90.0
    var maxLat = -90.0
    var minLon = 180.0
    var maxLon = -180.0
    for location in locations {
        if location.latitude  < minLat { minLat = location.latitude }
        if location.latitude  > maxLat { maxLat = location.latitude }
        if location.longitude < minLon { minLon = location.longitude }
        if location.longitude > maxLon { maxLon = location.longitude }
    }
    return CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
}
