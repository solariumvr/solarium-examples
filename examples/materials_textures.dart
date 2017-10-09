import 'dart:mason';
import 'dart:materials' as m;
import 'dart:async';

@Application(
  title: "Materials",
  description: "Working on Materials",
  keywords: const ['hello', 'world'],
)
main() async {
  Texture albedo, ao, metallic, roughness, albedo2, ao2, metallic2, roughness2;

  await Future.wait([
    Texture.FromUrl("assets/textures/rusted_iron/albedo.jpg").then((texture) => albedo = texture),
    Texture.FromUrl("assets/textures/rusted_iron/ao.jpg").then((texture) => ao = texture),
    Texture.FromUrl("assets/textures/rusted_iron/metallic.jpg").then((texture) => metallic = texture),
    Texture.FromUrl("assets/textures/rusted_iron/roughness.jpg").then((texture) => roughness = texture),
    Texture.FromUrl("assets/textures/grass/albedo.jpg").then((texture) => albedo2 = texture),
    Texture.FromUrl("assets/textures/grass/ao.jpg").then((texture) => ao2 = texture),
    Texture.FromUrl("assets/textures/grass/metallic.jpg").then((texture) => metallic2 = texture),
    Texture.FromUrl("assets/textures/grass/roughness.jpg").then((texture) =>  roughness2 = texture)
  ]);

  print("Textures Loaded");

  var materialBuilder = new m.MaterialBuilder();
  materialBuilder.baseColor = new m.TextureSamplerParam("albedo", albedo);
  materialBuilder.metallic = new m.TextureSamplerParam("metallic", metallic);
  materialBuilder.roughness = new m.TextureSamplerParam("roughness", roughness);
  materialBuilder.ao = new m.TextureSamplerParam("ao", ao);
  var material = await materialBuilder.compile();

  var renderables = new List<Renderable>();

  // Rusted Iron - we put the default values as the rusted iron. No need to set instance params.
  var ironMaterial = material.createInstance();
  renderables.add(new Renderable(ironMaterial, Mesh.Sphere(), new Matrix4.identity()
    ..translate(-1.0, 1.0, -1.0)
    ..scale(0.2)
  ));

  // Grass
  var grassMaterial = material.createInstance({
    "albedo": albedo2,
    "metallic": metallic2,
    "roughness": roughness2,
    "ao": ao2,
  });
  renderables.add(new Renderable(grassMaterial, Mesh.Sphere(), new Matrix4.identity()
    ..translate(1.0, 1.0, -1.0)
    ..scale(0.2)
  ));

  world.render(renderables,[new PointLight()]);
  print("Scene Rendered");
}
