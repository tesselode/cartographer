return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.4",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 32,
  height = 18,
  tilewidth = 16,
  tileheight = 16,
  nextlayerid = 11,
  nextobjectid = 8,
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      filename = "tiles.tsx",
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      columns = 64,
      image = "kenney_16x16.png",
      imagewidth = 1024,
      imageheight = 1728,
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
      tilecount = 6912,
      tiles = {}
    },
    {
      name = "objects",
      firstgid = 6913,
      filename = "objects.tsx",
      tilewidth = 16,
      tileheight = 24,
      spacing = 0,
      margin = 0,
      columns = 0,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 1,
        height = 1
      },
      properties = {},
      terrains = {},
      tilecount = 6,
      tiles = {
        {
          id = 0,
          image = "door.png",
          width = 16,
          height = 24
        },
        {
          id = 1,
          image = "key.png",
          width = 14,
          height = 8
        },
        {
          id = 4,
          image = "player_frame_1.png",
          width = 16,
          height = 20,
          animation = {
            {
              tileid = 4,
              duration = 200
            },
            {
              tileid = 5,
              duration = 200
            },
            {
              tileid = 6,
              duration = 200
            },
            {
              tileid = 7,
              duration = 200
            }
          }
        },
        {
          id = 5,
          image = "player_frame_2.png",
          width = 16,
          height = 20
        },
        {
          id = 6,
          image = "player_frame_3.png",
          width = 16,
          height = 20
        },
        {
          id = 7,
          image = "player_frame_4.png",
          width = 16,
          height = 20
        }
      }
    }
  },
  layers = {
    {
      type = "imagelayer",
      id = 5,
      name = "background",
      visible = true,
      opacity = 1,
      offsetx = 48,
      offsety = 112,
      image = "background.png",
      properties = {}
    },
    {
      type = "group",
      id = 6,
      name = "foreground",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      layers = {
        {
          type = "group",
          id = 7,
          name = "terrain",
          visible = true,
          opacity = 1,
          offsetx = 0,
          offsety = 0,
          properties = {},
          layers = {
            {
              type = "tilelayer",
              id = 8,
              name = "terrainMain",
              x = 0,
              y = 0,
              width = 32,
              height = 18,
              visible = true,
              opacity = 1,
              offsetx = 0,
              offsety = 0,
              properties = {},
              encoding = "lua",
              chunks = {
                {
                  x = 0, y = 0, width = 16, height = 16,
                  data = {
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 6917, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2400,
                    0, 0, 0, 0, 0, 2464, 2464, 2464, 2464, 2464, 2464, 2464, 2465, 2465, 2465, 2465,
                    0, 0, 0, 0, 0, 2464, 2464, 2464, 2464, 2464, 2464, 2464, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 2527, 2464, 2464, 2464, 2464, 2464, 2531, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                  }
                },
                {
                  x = 16, y = 0, width = 16, height = 16,
                  data = {
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2464, 2464, 2464, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2464, 2464, 2464, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2464, 2464, 2464, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 2400, 2464, 2464, 2464, 0, 0, 0,
                    2464, 2464, 2464, 2464, 2464, 2464, 2464, 2464, 2465, 2465, 2464, 2464, 2464, 0, 0, 0,
                    2464, 2464, 2464, 2464, 2464, 2464, 2464, 2464, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                  }
                }
              }
            },
            {
              type = "tilelayer",
              id = 9,
              name = "terrainFront",
              x = 0,
              y = 0,
              width = 32,
              height = 18,
              visible = true,
              opacity = 1,
              offsetx = 0,
              offsety = 0,
              properties = {},
              encoding = "lua",
              chunks = {
                {
                  x = 0, y = 0, width = 16, height = 16,
                  data = {
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2641,
                    0, 0, 0, 0, 0, 2578, 2642, 2642, 2642, 2642, 2642, 2642, 2642, 2642, 2642, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                  }
                },
                {
                  x = 16, y = 0, width = 16, height = 16,
                  data = {
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2642, 2642, 2578, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 2641, 0, 0, 0, 0, 0, 0,
                    2642, 2642, 2642, 2642, 2642, 2642, 2642, 2642, 2642, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                  }
                }
              }
            }
          }
        },
        {
          type = "objectgroup",
          id = 10,
          name = "entities",
          visible = true,
          opacity = 1,
          offsetx = 0,
          offsety = 0,
          draworder = "topdown",
          properties = {},
          objects = {
            {
              id = 2,
              name = "",
              type = "",
              shape = "rectangle",
              x = 320,
              y = 160,
              width = 16,
              height = 24,
              rotation = 0,
              gid = 6913,
              visible = true,
              properties = {}
            },
            {
              id = 3,
              name = "",
              type = "",
              shape = "rectangle",
              x = 433,
              y = 80,
              width = 14,
              height = 8,
              rotation = 0,
              gid = 6914,
              visible = true,
              properties = {}
            },
            {
              id = 4,
              name = "",
              type = "",
              shape = "rectangle",
              x = 192,
              y = 176,
              width = 16,
              height = 16,
              rotation = 0,
              gid = 1793,
              visible = true,
              properties = {}
            },
            {
              id = 5,
              name = "",
              type = "",
              shape = "rectangle",
              x = 368,
              y = 160,
              width = 16,
              height = 16,
              rotation = 0,
              gid = 1857,
              visible = true,
              properties = {}
            },
            {
              id = 7,
              name = "",
              type = "",
              shape = "rectangle",
              x = 128,
              y = 176,
              width = 16,
              height = 20,
              rotation = 0,
              gid = 6917,
              visible = true,
              properties = {}
            }
          }
        }
      }
    }
  }
}
