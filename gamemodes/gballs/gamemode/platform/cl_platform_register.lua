GB.platformType = {
    Spawn = 1,
    BasicSquare = 2,
    BasicCircle = 3,
    Goal = 4
}

GB.platforms = {
    [GB.platformType.Spawn] = {"platform_gb_spawn01"},
    [GB.platformType.BasicSquare] = {
        "gb_platform_square_1x1",
        "gb_platform_square_2x1",
        "gb_platform_square_2x2",
        "gb_platform_square_3x1",
        "gb_platform_square_3x2",
        "gb_platform_square_3x3",
        "gb_platform_square_4x1",
        "gb_platform_square_4x2",
        "gb_platform_square_4x3",
        "gb_platform_square_4x4",
        "gb_platform_square_5x1",
        "gb_platform_square_5x2",
        "gb_platform_square_5x3",
        "gb_platform_square_5x4",
        "gb_platform_square_5x5"},
    [GB.platformType.BasicCircle] = {"platform_gb_circle_2x2", "platform_gb_circle_3x3", "platform_gb_circle_4x4"},
    [GB.platformType.Goal] = {"platform_gb_spawn_4x4"}
}