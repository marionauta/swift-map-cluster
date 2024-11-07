import CoreLocation
import Foundation
import MapKit

public typealias ClusterizableMarker<Single: MapSingle> = MapMarker<Single>

public enum MapMarker<Single: MapSingle>: MapSingle {
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

    public var clusteringGroup: Single.ClusteringGroup? {
        switch self {
        case let .single(single): single.clusteringGroup
        case let .cluster(cluster): cluster.clusteringGroup
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
            return .cluster(MapCluster(id: single.id, group: single.clusteringGroup, singles: [single, other]))
        case let .cluster(cluster):
            var cluster = cluster
            cluster.singles.append(other)
            return .cluster(cluster)
        }
    }
}
