import 'dart:mason';
import 'dart:materials' as m;

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

  var sphere = await Mesh.sphere();

  world.onBeginFrame = (FrameData frameData) {
    var rightController = frameData.devices[Device.OCULUS_TOUCH_RIGHT];
    var leftController = frameData.devices[Device.OCULUS_TOUCH_LEFT];
    frameData.headset;// Access to headset position.
    var rightPos = rightController.position;
    world.render([
      new Renderable(materialInstance, sphere,
          new Matrix4.identity()..translate(rightPos.x, rightPos.y, rightPos.z)..scale(0.2))
    ]);
    world.scheduleFrame();
  };
  world.scheduleFrame();
}
