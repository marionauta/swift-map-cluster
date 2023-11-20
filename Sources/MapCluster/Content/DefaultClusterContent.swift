import MapKit
import SwiftUI

@available(iOS 17.0, *)
public struct DefaultClusterContent<Single: MapSingle>: MapContent {
    private let cluster: MapCluster<Single>

    public init(cluster: MapCluster<Single>) {
        self.cluster = cluster
    }

    public var body: some MapContent {
        Annotation(coordinate: cluster.coordinate, anchor: .center) {
            DefaultClusterView(count: cluster.singles.count)
        } label: {
            EmptyView()
        }
    }
}

@available(iOS 15.0, *)
public struct DefaultClusterView: View {
    private let count: Int

    public init(count: Int) {
        self.count = count
    }

    public var body: some View {
        Text(String(count))
            .minimumScaleFactor(0.5)
            .foregroundStyle(Color.white)
            .padding(2)
            .frame(width: 25, height: 25, alignment: .center)
            .background(.tint)
            .clipShape(Circle())
            .padding(1.5)
            .background(Color.white)
            .clipShape(Circle())
            .shadow(radius: 2, y: 2)
    }
}
