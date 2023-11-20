import MapKit
import SwiftUI

@available(iOS 17.0, *)
public struct MapClusterContent<Single: MapSingle, SingleContent: MapContent, ClusterContent: MapContent>: MapContent {
    private let items: [Single]
    private let markerContent: (Single) -> SingleContent
    private let markerClusterContent: (MapCluster<Single>) -> ClusterContent

    public init(
        _ items: [Single],
        @MapContentBuilder markerContent: @escaping (Single) -> SingleContent
    ) where ClusterContent == DefaultClusterContent<Single> {
        self.init(items, markerContent: markerContent, markerClusterContent: DefaultClusterContent.init(cluster:))
    }

    public init(
        _ items: [Single],
        @MapContentBuilder markerContent: @escaping (Single) -> SingleContent,
        @MapContentBuilder markerClusterContent: @escaping (MapCluster<Single>) -> ClusterContent
    ) {
        self.items = items
        self.markerContent = markerContent
        self.markerClusterContent = markerClusterContent
    }

    public var body: some MapContent {
        Group {
            ForEach(items) { item in
                markerContent(item)
            }
            // TODO: Clusterize properly
            markerClusterContent(.init(id: items.first!.id, singles: items))
        }
    }
}


