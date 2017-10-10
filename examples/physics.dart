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
  planeCollider.setScale(new Vector3(3.0, 3.0, 3.0));
  var c = new CollisionObject(planeCollider);
  c.setTransform(new Transform(position: new Vector3(0.0, 0.0, 0.0)));
  physics = new Physics();
  physics.addCollisionObject(c);

  var sphere = new SphereCollider(0.2);
  var rigidBody = new RigidBody(5.0, sphere);
  rigidBody
      .setTransform(new Transform(position: new Vector3(0.0, 10.0, 0.005)));
  physics.addRigidBody(rigidBody);

  world.onBeginFrame = (FrameData frameData) {
    physics.step(frameData.timeDelta);
    world.render([
      new Renderable(
          materialInstance,
          Mesh.Sphere(),
          rigidBody.getTransform().matrix)
    ]);
    world.scheduleFrame();
  };
  world.scheduleFrame();
}
