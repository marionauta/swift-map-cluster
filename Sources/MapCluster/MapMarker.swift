import CoreLocation
import Foundation
import MapKit

public typealias ClusterizableMarker<Single: MapSingle> = MapMarker<Single>

public enum MapMarker<Single: MapSingle>: Equatable, Identifiable, WithCoordinate {
    case single(Single)
    case cluster(MapCluster<Single>)

    public var id: Single.ID {
        switch self {
        case let .single(single):
            return single.id
        case let .cluster(cluster):
            return cluster.id
        }
    }

    public var coordinate: CLLocationCoordinate2D {
        switch self {
        case let .single(single):
            return single.coordinate
        case let .cluster(cluster):
            return cluster.coordinate
        }
    }

    func joining(other: Single) -> MapMarker {
        switch self {
        case let .single(single):
            return .cluster(MapCluster(id: single.id, singles: [single, other]))
        case let .cluster(cluster):
            var cluster = cluster
            cluster.singles.append(other)
            return .cluster(cluster)
        }
    }
}
