import Combine
import MapKit
import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
public struct MapClusterContent<Single: MapSingle, SingleContent: MapContent, ClusterContent: MapContent>: MapContent {
    private let markers: [MapMarker<Single>]
    private let markerContent: (Single) -> SingleContent
    private let markerClusterContent: (MapCluster<Single>) -> ClusterContent

    public init(
        _ items: [Single],
        mapBounds: MKMapRect?,
        markerSize: Double = 30,
        @MapContentBuilder markerContent: @escaping (Single) -> SingleContent,
        @MapContentBuilder markerClusterContent: @escaping (MapCluster<Single>) -> ClusterContent
    ) {
        self.markerContent = markerContent
        self.markerClusterContent = markerClusterContent
        if let mapBounds {
            self.markers = MapCluster.clusterize(items, markerSize: markerSize, bounds: mapBounds)
        } else {
            self.markers = items.map { .single($0) }
        }
    }

    public var body: some MapContent {
        ForEach(markers) { marker in
            switch marker {
            case let .single(single):
                markerContent(single)
            case let .cluster(cluster):
                markerClusterContent(cluster)
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
public extension MapClusterContent where ClusterContent == DefaultClusterContent<Single> {
    init(
        _ items: [Single],
        mapBounds: MKMapRect?,
        markerSize: Double = 30,
        @MapContentBuilder markerContent: @escaping (Single) -> SingleContent
    ) where ClusterContent == DefaultClusterContent<Single> {
        self.init(items, mapBounds: mapBounds, markerSize: markerSize, markerContent: markerContent) { cluster in
            DefaultClusterContent(cluster: cluster)
        }
    }
}
