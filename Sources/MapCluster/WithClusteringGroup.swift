public protocol WithClusteringGroup<ClusteringGroup> {
    associatedtype ClusteringGroup: Hashable
    var clusteringGroup: Self.ClusteringGroup? { get }
}
