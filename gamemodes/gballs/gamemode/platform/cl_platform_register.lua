GB.platformType = {
    Spawn = 1,
    BasicSquare = 2,
    BasicCircle = 3,
    Goal = 4
}

GB.platforms = {
    [GB.platformType.Spawn] = {"platform_gb_spawn01"},
    [GB.platformType.BasicSquare] = {"platform_gb_square_2x1", "platform_gb_square_2x2", "platform_gb_square_3x1", "platform_gb_square_3x2"},
    [GB.platformType.BasicCircle] = {"platform_gb_circle_2x2","platform_gb_circle_3x3", "platform_gb_circle_4x4"},
    [GB.platformType.Goal] = {"platform_gb_spawn_4x4"}
}