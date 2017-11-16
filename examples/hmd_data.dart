import 'dart:mason';
import 'dart:materials' as m;
import 'dart:collection';

class Bullet {
  Vector3 position;
  Vector3 direction;
  Vector3 color;
  Bullet(this.position, this.direction, this.color);
}

@Application(
  title: "HMD and Controller Data",
  description: "Example of controller buttons and hmd/touch data.",
  keywords: const ['controller', 'buttons'],
)
main() async {
  // All materials must be created using a [MaterialBuilder]
  var materialBuilder = new m.MaterialBuilder();

  // Constants such as double's, Vector2, Vector3, Vector4
  // will be compiled into the shader and can not be changed at a later time.
  materialBuilder.baseColor =
      new Vector4(0.0, 0.6, 0.5, 1.0);

  //Material Parameters can be changed
  materialBuilder.metallic = new m.ScalarParam("metallic", 1.0);
  materialBuilder.roughness = new m.ScalarParam("roughness", 1.0);

  // the compile process is asynchronous
  var material = await materialBuilder.compile();

  var materialInstance = material.createInstance();

  var sphere = await Mesh.sphere();

  var triggered = false;

  var bullets = new Queue<Bullet>();

  TrackableDevice rightController;

  // Expect trigger to reach 0.0 before being able to shoot again.
  bool triggerLoaded = true;

  world.addInputListener((InputState state) {
    bool add = state.buttons.indexOf(Button.ovrButton_A) > -1;
    if(add){
      var forward = new Vector3(0.0, 0.0, -1.0);
      Vector3 pointerDirection = forward
        ..applyQuaternion(rightController.orientation);
      bullets.add(new Bullet(rightController.position, pointerDirection,
        new Vector3.random().normalized()));
      if (bullets.length > 140) {
        bullets.removeFirst();
      }

    }
    if (state.analogs.containsKey(AnalogInput.ovrTouch_RIndexTrigger)) {
      Vector2 value = state.analogs[AnalogInput.ovrTouch_RIndexTrigger];
      if (value.x > 0.5 && triggerLoaded) {
        triggerLoaded = false;
        var forward = new Vector3(0.0, 0.0, -1.0);
        Vector3 pointerDirection = forward
          ..applyQuaternion(rightController.orientation);
        bullets.add(new Bullet(rightController.position, pointerDirection,
            new Vector3.random().normalized()));
        if (bullets.length > 300) {
          bullets.removeFirst();
        }
      }

      if(value.x <= 0.5 && !triggerLoaded){
        triggerLoaded = true;
      }
    }
  });

  Vector3 pointerDirection;
  world.onBeginFrame = (FrameData frameData) {
    rightController = frameData.devices[Device.OCULUS_TOUCH_RIGHT];
    var leftController = frameData.devices[Device.OCULUS_TOUCH_LEFT];
    frameData.headset; // Access to headset position.

    var forward = new Vector3(0.0, 0.0, -1.0);
    var rightPos = rightController.position;

    var renderables = new List<Renderable>();
    renderables.add(new Renderable(
        materialInstance,
        sphere,
        new Matrix4.identity()
          ..translate(rightPos.x, rightPos.y, rightPos.z)
          ..scale(0.2)));

    for (var bullet in bullets) {
      //update bullet
      bullet.position += (bullet.direction * 0.7);
      renderables.add(new Renderable(
          material.createInstance(),
          sphere,
          new Matrix4.identity()
            ..translate(bullet.position)
            ..scale(0.2)));
    }

    world.render(renderables, [new PointLight(position: new Vector3(0.0, 10.0, 0.0))]);
    world.scheduleFrame();
  };
  world.scheduleFrame();
}
