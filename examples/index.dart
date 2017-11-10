import 'dart:mason';
import 'dart:solarium_io';
import 'dart:math' as math;
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:materials' as m;
import 'dart:ui' as ui;
import 'package:solarium_mason/solarium_mason.dart' as mason;

Physics physics;
ui.Window w1;
ui.Window w2;

@Application(
  title: "Scene using Mason Library",
  description: "Example Scene",
  keywords: const ['scene', 'example'],
)
main() async {
  /// Window variable should be global for now. There is a bug where garbage
  /// collection will try to destroy window object.
  w1 = new ui.Window(512, 512);
  w1.onBeginFrame = (Duration timeStamp) {
    final double devicePixelRatio = w1.devicePixelRatio;
    final ui.Size physicalSize = w1.physicalSize;
    final ui.Size logicalSize = physicalSize / devicePixelRatio;

    final ui.ParagraphBuilder paragraphBuilder = new ui.ParagraphBuilder(
        new ui.ParagraphStyle(fontSize: 36.0))
      ..pushStyle(new ui.TextStyle(color: new ui.Color(0xFFFFFFFF)))
      ..addText(
          'Hello! Welcome to SolariumVR. SolariumVR is a new web browser specifically made for virtual reality.\n\n')
      ..addText(
          'If you want to make virtual worlds make sure you check out our developer documentation at docs.solariumvr.com');
    final ui.Paragraph paragraph = paragraphBuilder.build()
      ..layout(new ui.ParagraphConstraints(width: logicalSize.width - 20.0));

    final ui.Rect physicalBounds = ui.Offset.zero & physicalSize;
    final ui.PictureRecorder recorder = new ui.PictureRecorder();
    final ui.Canvas canvas = new ui.Canvas(recorder, physicalBounds);
    canvas.scale(devicePixelRatio, devicePixelRatio);
    canvas.drawRect(ui.Offset.zero & logicalSize,
        new ui.Paint()..color = const ui.Color(0xFF3F862F));
    canvas.drawParagraph(paragraph, new ui.Offset(10.0, 0.0));
    final ui.Picture picture = recorder.endRecording();

    final ui.SceneBuilder sceneBuilder = new ui.SceneBuilder()
      // TODO(abarth): We should be able to add a picture without pushing a
      // container layer first.
      ..pushClipRect(physicalBounds)
      ..addPicture(ui.Offset.zero, picture)
      ..pop();
    w1.render(sceneBuilder.build());
  };
  w1.scheduleFrame();

  w2 = new ui.Window(512, 512);
  w2.onBeginFrame = (Duration timeStamp) {
    final double devicePixelRatio = w2.devicePixelRatio;
    final ui.Size physicalSize = w2.physicalSize;
    final ui.Size logicalSize = physicalSize / devicePixelRatio;

    final ui.ParagraphBuilder paragraphBuilder = new ui.ParagraphBuilder(
        new ui.ParagraphStyle(fontSize: 36.0))
      ..pushStyle(new ui.TextStyle(color: new ui.Color(0xFFFFFFFF)))
      ..addText(
          '3d Assets from Jeremy Edelblut and Poly by Google, and can be found at poly.google.com');
    final ui.Paragraph paragraph = paragraphBuilder.build()
      ..layout(new ui.ParagraphConstraints(width: logicalSize.width - 20.0));

    final ui.Rect physicalBounds = ui.Offset.zero & physicalSize;
    final ui.PictureRecorder recorder = new ui.PictureRecorder();
    final ui.Canvas canvas = new ui.Canvas(recorder, physicalBounds);
    canvas.scale(devicePixelRatio, devicePixelRatio);
    canvas.drawRect(ui.Offset.zero & logicalSize,
        new ui.Paint()..color = const ui.Color(0xFF3F862F));
    canvas.drawParagraph(paragraph, new ui.Offset(10.0, 0.0));
    final ui.Picture picture = recorder.endRecording();

    final ui.SceneBuilder sceneBuilder = new ui.SceneBuilder()
      // TODO(abarth): We should be able to add a picture without pushing a
      // container layer first.
      ..pushClipRect(physicalBounds)
      ..addPicture(ui.Offset.zero, picture)
      ..pop();
    w2.render(sceneBuilder.build());
  };
  w2.scheduleFrame();
  mason.AssetBundle assets = await mason.AssetBundle.import("assets/cube.gltf");

  var renderables = await mason.renderStaticScene(assets.scenes[0]);
  // All materials must be created using a [MaterialBuilder]
  var materialBuilder = new m.MaterialBuilder();

  // Constants such as double's, Vector2, Vector3, Vector4
  // will be compiled into the shader and can not be changed at a later time.
  materialBuilder.baseColor = new m.TextureSamplerParam("t", w1.texture);

  //Material Parameters can be changed

  // the compile process is asynchronous
  var material = await materialBuilder.compile();

  var plane = await Mesh.plane(normal: new Vector3(0.0, 0.0, 1.0));

  renderables.add(new Renderable(
      material.createInstance(),
      plane,
      new Matrix4.identity()
        ..translate(2.4, 1.4, -2.0)
        ..rotateY(-45.0)));

  renderables.add(new Renderable(
      material.createInstance({"t": w2.texture}),
      plane,
      new Matrix4.identity()
        ..translate(0.0, 1.0, 2.0)
        ..rotateY(math.PI)));

  world.render(
      renderables, [new PointLight(position: new Vector3(0.0, 10.0, 0.0))]);
}