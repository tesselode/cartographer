return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.3.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 95,
  height = 95,
  tilewidth = 24,
  tileheight = 24,
  nextlayerid = 17,
  nextobjectid = 21,
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      filename = "tiles.tsx",
      tilewidth = 24,
      tileheight = 24,
      spacing = 0,
      margin = 0,
      columns = 10,
      image = "tiles.png",
      imagewidth = 240,
      imageheight = 240,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 24,
        height = 24
      },
      properties = {},
      terrains = {},
      tilecount = 100,
      tiles = {
        {
          id = 1,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 2,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 5,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 6,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 7,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 10,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 14,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 18,
          animation = {
            {
              tileid = 18,
              duration = 500
            },
            {
              tileid = 28,
              duration = 500
            }
          }
        },
        {
          id = 20,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 21,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 22,
          properties = {
            ["collidable"] = false
          }
        },
        {
          id = 23,
          properties = {
            ["collidable"] = false
          }
        },
        {
          id = 24,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 25,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 26,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 27,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 33,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 34,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 38,
          properties = {
            ["collidable"] = true
          },
          animation = {
            {
              tileid = 38,
              duration = 600
            },
            {
              tileid = 48,
              duration = 600
            }
          }
        },
        {
          id = 40,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 41,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 42,
          properties = {
            ["collidable"] = true
          },
          animation = {
            {
              tileid = 42,
              duration = 500
            },
            {
              tileid = 41,
              duration = 500
            }
          }
        },
        {
          id = 43,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 44,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 46,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 47,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 48,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 76,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 77,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 78,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 86,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 87,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 88,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 90,
          animation = {
            {
              tileid = 90,
              duration = 900
            },
            {
              tileid = 80,
              duration = 400
            }
          }
        },
        {
          id = 96,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 97,
          properties = {
            ["collidable"] = true
          }
        },
        {
          id = 98,
          properties = {
            ["collidable"] = true
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 1,
      name = "Water",
      x = 0,
      y = 0,
      width = 95,
      height = 95,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eAHt0EEKgDAMBMD+xv//UC+FEkywsccRRNN09zBjeAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQ2BG4nsvx3cm72xOI5nHutUpVAtE4m6sOu55AZh3Pe+1SlUA0zuaqw64vkHmv5/12yUpgNc7+q7zdP4HMfJ7/a5euBKbx27fK2Z0TWO3PtWoiQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQOCLwA3HCQwK"
    },
    {
      type = "tilelayer",
      id = 2,
      name = "Ground",
      x = 0,
      y = 0,
      width = 95,
      height = 95,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "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"
    },
    {
      type = "tilelayer",
      id = 3,
      name = "Path",
      x = 0,
      y = 0,
      width = 95,
      height = 95,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eAHt2dENwgAMQ8F+wCDsvyTyFE9VjgUMFysN8DxeBAgQIECAAAECBAgQIECAAAEClwV+lz98/NnZdwNgz74T6JL1nn0n0CXrPftOoEvWe/adQJes9+w7gS5Z71t7/q1/l347We+7+bNv7fm3/l367WS97+Y/e/6tf5d+O1n32/nbO52/7nf2S+bf+7fv4G667rez/7bxp9PZd+Nn39m79Tv7Txd9Onmdt3OaCnBv3Jdq3zT22zfsO/smWarbsumA+6ZxX6rOs+8EmuTd9Hrf2LsrG/el+i7LvhPoku36xn67nn1n3yRLdeN0HbBvOnv3ZWev9+w7gS7Zs5Z9J9Al631nv2etW6f179JvJ/vvpJ2/O7/z93tmZ79kz9zO395p7d37nT/7zt7O7+zXe93v/HW/s3fvdPaSCRAgQIAAAQIECBAgQIAAAQIECLxZ4A+TsQfh"
    },
    {
      type = "tilelayer",
      id = 4,
      name = "House Void",
      x = 0,
      y = 0,
      width = 95,
      height = 95,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eAHt0MEJACAMA0BXcP9l1Q0M5KFwhf5CaG8MQ4AAAQIECLwqMPdht/vqD7/edet+cqYrwL7rmbSxT7S6WfZdz6SNfaLVzbLvemojQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgQIAAAQIECBAgkAosb6UFHg=="
    },
    {
      type = "tilelayer",
      id = 5,
      name = "House",
      x = 0,
      y = 0,
      width = 95,
      height = 95,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eAHt0DEKgDAMBdBO6ihOot7/nNa10x8yVHiBDKWfkLzWFAECBAgQIDCrwNIXW4PeZj3gx3vt4e5HmBPLBdjnVtVJ9tWi+Tz2uVV1kn21aD7v6tF76HN4f/9Pb0WAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAQL3ACxVfAh4="
    },
    {
      type = "tilelayer",
      id = 6,
      name = "WellBase",
      x = 0,
      y = 0,
      width = 95,
      height = 95,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eAHt0AENAAAIwzAcgX91IIMnnYKlVSJAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQI5Aj0rU7OrlMCBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECLwUWq4QAYA=="
    },
    {
      type = "tilelayer",
      id = 7,
      name = "Trees",
      x = 0,
      y = 0,
      width = 95,
      height = 95,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "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"
    },
    {
      type = "objectgroup",
      id = 8,
      name = "Fishing Spots",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 20,
          name = "",
          type = "FishingSpot",
          shape = "rectangle",
          x = 336,
          y = 960,
          width = 288,
          height = 246.667,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      id = 9,
      name = "Triggers",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 3,
          name = "CantFaceThat",
          type = "ThoughtText",
          shape = "rectangle",
          x = 624,
          y = 456,
          width = 24,
          height = 24,
          rotation = 0,
          visible = true,
          properties = {
            ["thoughtText"] = "I can't face them right now..."
          }
        },
        {
          id = 11,
          name = "",
          type = "ThoughtText",
          shape = "rectangle",
          x = 720,
          y = 864,
          width = 96,
          height = 48,
          rotation = 0,
          visible = true,
          properties = {
            ["thoughtText"] = "Have to protect...\nFood one day"
          }
        }
      }
    },
    {
      type = "objectgroup",
      id = 10,
      name = "Sprites",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {}
    },
    {
      type = "tilelayer",
      id = 11,
      name = "Invisible Walls",
      x = 0,
      y = 0,
      width = 95,
      height = 95,
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eAHt1kEKwCAMBEDv/f9/29wtGFhQYQJeZEninBxDESBAgAABAqcKPN9iq+fUN9y616p75VRWgH3Ws9ONfUcrm2Wf9ex0Y9/RymZn9jXh7z47XTcCBAgQIECAAAECBHYK1L9fESBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAgQIECBAgAABAvsFXl+SA1A="
    },
    {
      type = "objectgroup",
      id = 12,
      name = "Spawns",
      visible = false,
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
          x = 480,
          y = 384,
          width = 24,
          height = 24,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      id = 13,
      name = "Warps",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "Warp",
          shape = "rectangle",
          x = 480,
          y = 264,
          width = 24,
          height = 24,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "maps/house",
            ["x"] = 16,
            ["y"] = 14
          }
        },
        {
          id = 7,
          name = "",
          type = "Warp",
          shape = "rectangle",
          x = 648,
          y = 1944,
          width = 24,
          height = 24,
          rotation = 0,
          visible = true,
          properties = {
            ["map"] = "maps/pond 1.lua",
            ["x"] = 19,
            ["y"] = 20
          }
        }
      }
    },
    {
      type = "tilelayer",
      id = 14,
      name = "WellTop",
      x = 0,
      y = 0,
      width = 95,
      height = 95,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eAHt0CEBAAAIA8GVgf4RoQIOcdN7c4kRIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECV4HaoK+RPwECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBAgQIECAAAECBJ4IDKioAEw="
    },
    {
      type = "tilelayer",
      id = 15,
      name = "Notes",
      x = 0,
      y = 0,
      width = 95,
      height = 95,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eAHt0IEAAAAAw6D5Ux/khVBhwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwIABAwYMGDBgwMDTwACNBAAB"
    },
    {
      type = "objectgroup",
      id = 16,
      name = "Water",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 16,
          name = "",
          type = "Water",
          shape = "rectangle",
          x = 408,
          y = 504,
          width = 48,
          height = 72,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
