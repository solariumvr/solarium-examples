import 'dart:mason';
import 'dart:solarium_io';
import 'dart:math' as math;
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:materials' as m;

Physics physics;

@Application(
  title: "Physics",
  description: "Physics Example",
  keywords: const ['physics'],
)
main() async {
  // All materials must be created using a [MaterialBuilder]
  var materialBuilder = new m.MaterialBuilder();

  // Constants such as double's, Vector2, Vector3, Vector4
  // will be compiled into the shader and can not be changed at a later time.
  materialBuilder.baseColor = new Vector4(0.0, 0.0, 0.5, 1.0);

  //Material Parameters can be changed
  materialBuilder.metallic = new m.ScalarParam("metallic", 1.0);
  materialBuilder.roughness = new m.ScalarParam("roughness", 1.0);

  // the compile process is asynchronous
  var material = await materialBuilder.compile();

  var materialInstance = material.createInstance();

  var planeCollider = new PlaneYCollider();
  planeCollider.setScale(new Vector3(40.0, 40.0, 40.0));
  var c = new CollisionObject(planeCollider);
  c.setTransform(new Transform(position: new Vector3(0.0, 0.0, 0.0)));
  physics = new Physics(gravity: new Vector3(0.0, -1.0, 0.0));
  physics.addCollisionObject(c);

  var sphere = new SphereCollider(0.25);

  var size = 7;
  var rigidBodies = new List<RigidBody>(size * size * size);

  var yStart = 10.0;
  var xStart = -5.0;
  var zStart = -10.0;
  var space = 0.4;

  var index = 0;
  for (var i = 0; i < size; i++) {
    for(var j = 0; j < size; j++){
      for(var k = 0; k < size; k++){
        var rigidBody = new RigidBody(1.0, sphere);
        var x = space * i;
        var y = space * j;
        var z = space * k;

        rigidBody.setTransform(
          new Transform(position: new Vector3(xStart + x, yStart + y, zStart + z)));
        physics.addRigidBody(rigidBody);
        rigidBodies[index] = rigidBody;
        index++;
      }
    }
  }

  var sphereMesh = await Mesh.sphere();

  world.onBeginFrame = (FrameData frameData) {
    physics.step(frameData.timeDelta);
    var renderables = new List<Renderable>();
    for (var r in rigidBodies) {
      renderables.add(
        new Renderable(
          materialInstance,
          sphereMesh,
          r.transform.matrix..scale(0.5))
      );
    }
    world.render(renderables, [new PointLight()]);
//    for(var i = 20; i < 20; i++){
//      world.render([
//        new Renderable(
//          materialInstance,
//          Mesh.Sphere(),
//          rigidBody.transform.matrix)
//      ]);
//    }
    world.scheduleFrame();
  };
  world.scheduleFrame();
}
