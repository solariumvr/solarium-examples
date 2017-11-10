import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:mason';
import 'dart:materials' as mat;

ui.Window w1;

@Application(
  title: "SolariumVR Home",
  description: "Home Page of SolariumVR",
  keywords: const ['Home', 'Solarium'],
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
      ..layout(new ui.ParagraphConstraints(width: logicalSize.width));

    final ui.Rect physicalBounds = ui.Offset.zero & physicalSize;
    final ui.PictureRecorder recorder = new ui.PictureRecorder();
    final ui.Canvas canvas = new ui.Canvas(recorder, physicalBounds);
    canvas.scale(devicePixelRatio, devicePixelRatio);
    canvas.drawRect(ui.Offset.zero & logicalSize,
        new ui.Paint()..color = const ui.Color(0xFF3F862F));
    canvas.drawParagraph(paragraph, new ui.Offset(0.0, 0.0));
    final ui.Picture picture = recorder.endRecording();

    final ui.SceneBuilder sceneBuilder = new ui.SceneBuilder()
      // TODO(abarth): We should be able to add a picture without pushing a
      // container layer first.
      ..pushClipRect(physicalBounds)
      ..addPicture(ui.Offset.zero, picture)
      ..pop();
    w1.render(sceneBuilder.build());
    w1.scheduleFrame();
  };
  w1.scheduleFrame();

  // All materials must be created using a [MaterialBuilder]
  var materialBuilder = new mat.MaterialBuilder();

  // Constants such as double's, Vector2, Vector3, Vector4
  // will be compiled into the shader and can not be changed at a later time.
  materialBuilder.baseColor = new mat.TextureSampler(w1.texture);

  //Material Parameters can be changed
//  materialBuilder.metallic = new mat.ScalarParam("metallic", 1.0);
//  materialBuilder.roughness = new mat.ScalarParam("roughness", 1.0);

  // the compile process is asynchronous
  var material = await materialBuilder.compile();

  var plane = await Mesh.plane(normal: new Vector3(0.0, 0.0, 1.0));

  world.render([
    new Renderable(
        material.createInstance(),
        plane,
        new Matrix4.identity()
          ..translate(2.0, 1.3, -2.0)
          ..rotateY(-45.0))
  ]);
}
