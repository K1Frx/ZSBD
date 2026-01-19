// "Wiedza"
LOAD CSV WITH HEADERS FROM 'file:///Dimensions.csv' AS row
MERGE (d:Dimension { DimensionID: row.ID })
SET d.Name = row.name,
    d.DebutDate = row.debutDate,
    d.MinecraftVersion = row.minecraftVersion;

LOAD CSV WITH HEADERS FROM 'file:///Biomes.csv' AS row
MERGE (b:Biome { BiomeID: row.ID })
SET b.Name = row.name,
    b.TreesOrGrass = toBoolean(row.treesOrGrass),
    b.GenerateStructures = toBoolean(row.generateStructures),
    b.MinecraftVersion = row.minecraftVersion;

LOAD CSV WITH HEADERS FROM 'file:///LandscapeBlocks.csv' AS row
MERGE (b:Block { BlockID: row.ID })
SET b.Name = row.name,
    b.Gravitational = toBoolean(row.gravitational),
    b.BlockType = row.blockType,
    b.State = row.state,
    b.DebutDate = row.debutDate,
    b.MinecraftVersion = row.minecraftVersion;

LOAD CSV WITH HEADERS FROM 'file:///Mobs.csv' AS row
MERGE (m:Mob { MobID: row.ID })
SET m.Name = row.name,
    m.BehaviorTypes = row.behaviorTypes,
    m.MaxHealth = toInteger(row.healthPoints),
    m.MaxDamage = toInteger(row.maxDamage),
    m.DebutDate = row.debutDate,
    m.MinecraftVersion = row.minecraftVersion;

LOAD CSV WITH HEADERS FROM 'file:///Ingredients.csv' AS row
MERGE (i:Ingredient { IngredientID: row.ID })
SET i.Name = row.name,
    i.stackable = toBoolean(row.stackable),
    i.DebutDate = row.debutDate,
    i.MinecraftVersion = row.minecraftVersion;

LOAD CSV WITH HEADERS FROM 'file:///Flora.csv' AS row
MERGE (p:Plant { PlantID: row.ID })
SET p.Name = row.name,
    p.MinGrowthTime = toInteger(row.minGrowthTime),
    p.MaxGrowthTime = toInteger(row.maxGrowthTime),
    p.GrowhtType = row.growthType,
    p.SeedType = row.seedType,
    p.DebutDate = row.debutDate,
    p.MinecraftVersion = row.minecraftVersion;

LOAD CSV WITH HEADERS FROM 'file:///Biomes.csv' AS row
MATCH (d:Dimension {DimensionID: row.dimensionID})
MATCH (b:Biome {BiomeID: row.ID})
MERGE (b)-[:LOCATED_IN]->(d);

LOAD CSV WITH HEADERS FROM 'file:///BlockGeography.csv' AS row
MATCH (b:Block {BlockID: row.blockID})
MATCH (bio:Biome {BiomeID: row.biomeID})
MERGE (b)-[:GENERATED_IN]->(bio);

LOAD CSV WITH HEADERS FROM 'file:///FaunaGeography.csv' AS row
MATCH (m:Mob {MobID: row.mobID})
MATCH (bio:Biome {BiomeID: row.biomeID})
MERGE (m)-[:SPAWNS_IN]->(bio);

LOAD CSV WITH HEADERS FROM 'file:///MobIngredientDrops.csv' AS row
MATCH (m:Mob {MobID: row.mobID})
MATCH (i:Ingredient {IngredientID: row.ingredientID})
MERGE (m)-[:DROPS]->(i);

LOAD CSV WITH HEADERS FROM 'file:///FloraGeography.csv' AS row
MATCH (p:Plant {PlantID: row.floraID})
MATCH (bio:Biome {BiomeID: row.biomeID})
MERGE (p)-[:GROWS_IN]->(bio);

// "Lista encji""
LOAD CSV WITH HEADERS FROM 'file:///ActualDimensions.csv' AS row
MERGE (ad:ActualDimension { ActualDimensionID: row.ID })
SET ad.SizeX = toInteger(row.sizeX),
    ad.SizeY = toInteger(row.sizeY),
    ad.StartPoint = point({x: -500.0, y: -500.0, z: 0.0}),
    ad.EndPoint = point({x: 500.0, y: 500.0, z: 0.0});

LOAD CSV WITH HEADERS FROM 'file:///ActualBiomes.csv' AS row
MERGE (ab:ActualBiome { ActualBiomeID: row.ID })
SET ab.StartPoint = point({x: toFloat(row.startX), y: toFloat(row.startY), z: 0.0}),
    ab.EndPoint = point({x: toFloat(row.endX), y: toFloat(row.endY), z: 0.0});

LOAD CSV WITH HEADERS FROM 'file:///ActualMobs.csv' AS row
MERGE (am:ActualMob { ActualMobID: row.ID })
SET am.Health = toInteger(row.actualHealth),
    am.Location = point({x: toFloat(row.coordinatesX), y: toFloat(row.coordinatesY), z: 0.0}),
    am.HoldingItem = toInteger(row.holdingItem);

// "Łączenie encji z wiedzą"
LOAD CSV WITH HEADERS FROM 'file:///ActualDimensions.csv' AS row
MATCH (d:Dimension {DimensionID: row.dimensionID })
MATCH (ad:ActualDimension {ActualDimensionID: row.ID})
MERGE (ad)-[:IS]->(d);

LOAD CSV WITH HEADERS FROM 'file:///ActualBiomes.csv' AS row
MATCH (b:Biome {BiomeID: row.biomeID})
MATCH (ab:ActualBiome {ActualBiomeID: row.ID})
MERGE (ab)-[:IS]->(b);

LOAD CSV WITH HEADERS FROM 'file:///ActualMobs.csv' AS row
MATCH (m:Mob {MobID: row.mobID})
MATCH (am:ActualMob {ActualMobID: row.ID})
MERGE (am)-[:IS]->(m);

LOAD CSV WITH HEADERS FROM 'file:///ActualMobs.csv' AS row
WITH row WHERE row.holdingItem IS NOT NULL
MATCH (am:ActualMob {ActualMobID: row.ID})
MATCH (i:Ingredient {IngredientID: row.holdingItem})
MERGE (am)-[:HOLDS]->(i);