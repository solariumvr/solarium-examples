import 'dart:mason';
import 'dart:materials' as m;

@Application(
  title: "Materials",
  description: "Simple PBR Materials",
  keywords: const ['materials'],
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

  var sphere = await Mesh.sphere();
//  var sphere = await Mesh.plane(normal: new Vector3(0.5, 0.0, 0.5));

  var rowCount = 7;
  var colCount = 7;
  var spacing = 0.3;
  var renderables = new List<Renderable>();
  for(var i = 0; i < rowCount; i++ ){
    var metallic = i/rowCount;
    for(var j = 0; j < colCount; j++){
      var roughness = j / colCount;

      // Here we are assigning the parameters of metallic and roughness,
      // if we did not pass values when using [Material.createInstance]
      // the shader would use the default values set above.
      var materialInstance = material.createInstance({
        "metallic": metallic,
        "roughness": roughness.clamp(0.025, 1.0), // Avoid using roughness of zero,
      });
      var x = (j*spacing) - ((colCount * spacing)/2);
      var y = (i*spacing) - ((rowCount * spacing)/2) + 1.0;
      var transform = new Matrix4.identity()
        ..translate(x, y, -1.0)
        ..scale(0.1);
      renderables.add(new Renderable(materialInstance, sphere, transform));
    }
  }

  world.render(renderables, [
    new PointLight(position: new Vector3(10.0, 10.0, 0.0)),
    new PointLight(position: new Vector3(-10.0, 10.0, 0.0), color: new Vector3(0.0, 0.0, 300.0)),
    new PointLight(position: new Vector3(-10.0, -10.0, 0.0), color: new Vector3(0.0, 300.0, 0.0)),
    new PointLight(position: new Vector3(10.0, -10.0, 0.0), color: new Vector3(300.0, 0.0, 0.0)),
  ]);
}
