import '../route/octopus_route.dart';
import 'octopus_node.dart';

/// {@template octopus_multi_child_node}
/// OctopusMultiChildNode class
/// {@endtemplate}
abstract class OctopusMultiChildNode implements OctopusNode<OctopusRoute> {
  /// Children of this node
  abstract final List<OctopusNode<OctopusRoute>> children;
}
