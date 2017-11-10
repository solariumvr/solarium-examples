import 'dart:mason';
import 'dart:solarium_io';
import 'dart:math' as math;
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:materials' as m;

Physics physics;

@Application(
  title: "Hello World2",
  description: "This is my VR app",
  keywords: const ['hello', 'world'],
)
main() async {
  print("AssetBundle Demo");

  var mesh = await Mesh.create(3, 3, [
    AttributeDescription.POSITION,
    AttributeDescription.NORMAL,
  ], indexComponentType: ComponentType.UNSIGNED_BYTE);

  // front face has a counter-clockwise (CCW) winding order
  mesh.setIndices(new Uint8List.fromList([0, 2, 1]));

  mesh.setVertices(new Uint8List.view(new Float32List.fromList([
    0.0, 0.0, 0.0, // POSITIONS
    1.0, 0.0, 0.0,
    0.0, 0.0, 1.0,
    0.0, 1.0, 0.0, // NORMALS
    0.0, 1.0, 0.0,
    0.0, 1.0, 0.0,
  ]).buffer));

  // All materials must be created using a [MaterialBuilder]
  var materialBuilder = new m.MaterialBuilder();

  // Constants such as double's, Vector2, Vector3, Vector4
  // will be compiled into the shader and can not be changed at a later time.
  materialBuilder.baseColor = new Vector4(0.3, 0.4, 0.5, 1.0);

  //Material Parameters can be changed
  materialBuilder.metallic = new m.ScalarParam("metallic", 1.0);
  //Make sure not to use 0.0 for roughness, use low value above 0.0;
  materialBuilder.roughness = new m.ScalarParam("roughness", 0.05);

  // the compile process is asynchronous
  var material = await materialBuilder.compile();

  var materialInstance = material.createInstance();

  world.render([
    new Renderable(materialInstance, mesh, new Matrix4.identity()),
  ], [
    new PointLight(position: new Vector3(0.0, 2.0, .0))
  ]);
}
