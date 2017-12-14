return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "2017.12.07",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 9,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 4,
  properties = {},
  tilesets = {
    {
      name = "sheet",
      firstgid = 1,
      filename = "sheet.tsx",
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "sheet.png",
      imagewidth = 272,
      imageheight = 128,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      terrains = {},
      tilecount = 136,
      tiles = {}
    },
    {
      name = "characters",
      firstgid = 137,
      filename = "characters.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "characters.png",
      imagewidth = 736,
      imageheight = 128,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 92,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Back tiles",
      x = 0,
      y = 0,
      width = 16,
      height = 9,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 54, 55, 56, 57, 58, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 71, 72, 73, 74, 75, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 88, 89, 90, 91, 92, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 105, 106, 107, 108, 109, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 122, 123, 124, 125, 126, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94,
        111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111, 111
      }
    },
    {
      type = "imagelayer",
      name = "Sun",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      image = "sun.png",
      properties = {}
    },
    {
      type = "tilelayer",
      name = "Main tiles",
      x = 0,
      y = 0,
      width = 16,
      height = 9,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 26, 9, 9, 9, 9, 9, 27, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 28, 29, 29, 29, 29, 29, 30, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 28, 29, 29, 29, 29, 29, 30, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 28, 29, 29, 29, 29, 29, 30, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "Geometry",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 64,
          y = 80,
          width = 112,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "Entities",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 2,
          name = "Player",
          type = "",
          shape = "rectangle",
          x = 96,
          y = 80,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 137,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "tilelayer",
      name = "Front tiles",
      x = 0,
      y = 0,
      width = 16,
      height = 9,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 49, 50, 50, 50, 51, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
