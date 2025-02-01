components {
  id: "status_panel_script"
  component: "/status-panel/status_panel_script.script"
}
embedded_components {
  id: "background"
  type: "sprite"
  data: "default_animation: \"panel-slice9\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "slice9 {\n"
  "  x: 5.0\n"
  "  y: 5.0\n"
  "  z: 5.0\n"
  "  w: 5.0\n"
  "}\n"
  "size {\n"
  "  x: 160.0\n"
  "  y: 80.0\n"
  "}\n"
  "size_mode: SIZE_MODE_MANUAL\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/images/images.atlas\"\n"
  "}\n"
  ""
  position {
    x: 80.0
    y: 40.0
  }
}
embedded_components {
  id: "text"
  type: "label"
  data: "size {\n"
  "  x: 128.0\n"
  "  y: 64.0\n"
  "}\n"
  "color {\n"
  "  x: 0.0\n"
  "  y: 0.0\n"
  "  z: 0.0\n"
  "}\n"
  "pivot: PIVOT_NW\n"
  "text: \"Label\"\n"
  "font: \"/builtins/fonts/default.font\"\n"
  "material: \"/builtins/fonts/label-df.material\"\n"
  ""
  position {
    x: 5.0
    y: 75.0
    z: 0.1
  }
}
