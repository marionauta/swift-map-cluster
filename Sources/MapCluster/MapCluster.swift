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
        return singles.map(\.coordinate).centerpoint() ?? .init()
    }
}

public extension MapCluster {
    static func clusterize(_ singles: any Collection<Single>, proximity: Double, bounds: MKMapRect?) -> [MapMarker<Single>] {
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

    static func clusterize(_ singles: any Collection<Single>, markerSize: Double, bounds: MKMapRect) -> [MapMarker<Single>] {
        #if canImport(UIKit)
        guard let windowBounds = UIApplication.shared.keyWindow?.bounds ?? UIApplication.shared.screen?.bounds else {
            return singles.map { .single($0) }
        }
        #else
        guard let windowBounds = NSApplication.shared.keyWindow?.frame else {
            return singles.map { .single($0) }
        }
        #endif
        let splits = windowBounds.width / markerSize
        let proximity = bounds.northEast.distance(to: bounds.northWest) / splits
        return clusterize(singles, proximity: proximity * 1.2, bounds: bounds)
    }
}

private extension Array where Element == CLLocationCoordinate2D {
    func centerpoint() -> CLLocationCoordinate2D? {
        guard !isEmpty else { return nil }
        var minLat = 90.0
        var maxLat = -90.0
        var minLon = 180.0
        var maxLon = -180.0
        for location in self {
            if location.latitude  < minLat { minLat = location.latitude }
            if location.latitude  > maxLat { maxLat = location.latitude }
            if location.longitude < minLon { minLon = location.longitude }
            if location.longitude > maxLon { maxLon = location.longitude }
        }
        return CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
    }
}
