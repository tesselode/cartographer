-- cartographer
map = cartographer.load 'demos/platformer/platformer.lua'

-- map
layer = map.layers.layerName -- also applies to group layers
layer = map:getLayer(child1, child2, child3, ...) -- also applies to group layers
tileset = map:getTileset(gid)
tile = map:getTile(gid)
tileType = map:getTileType(gid)
value = map:getTileProperty(gid, propertyName)
map:update(dt)
map:drawBackground()
map:draw()

-- tileset
tileset:getTile(gid)

-- layer
layer:update(dt)
layer:draw()

-- tile layer
for n, x, y, gid in tilelayer:getTiles() do end
gid = tilelayer:getTileAt(x, y)
