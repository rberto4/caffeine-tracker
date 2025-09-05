import 'dart:core';

import 'package:caffeine_tracker/domain/models/models.dart';

class DummyData {

static List<Beverage> beverages = [
  Beverage.withSuggestions(
        id: 'default_espresso',
        name: 'Espresso',
        volume: 30.0,
        caffeineAmount: 63.0,
        colorIndex: 3, // Purple for espresso
        imageIndex: 0, // coffee-cup.png
      ),
      Beverage.withSuggestions(
        id: 'default_coffee',
        name: 'Coffee',
        volume: 240.0,
        caffeineAmount: 95.0,
        colorIndex: 6, // brow for coffee
        imageIndex: 4, // coffee-mug.png
      ),
      Beverage.withSuggestions(
        id: 'default_red_bull',
        name: 'Red Bull',
        volume: 250.0,
        caffeineAmount: 80.0,
        colorIndex: 4, // Red for Red Bull
        imageIndex: 6, // energy-drink.png
      ),
      Beverage.withSuggestions(
        id: 'default_green_tea',
        name: 'Green Tea',
        volume: 240.0,
        caffeineAmount: 25.0,
        colorIndex: 1, // Green for tea
        imageIndex: 5, // tea-cup.png
      ),
];


static List<Intake> get intakes => [ 
     Intake(
        id: "dummy_1",
        beverage: beverages[2],
        timestamp: DateTime.parse("2025-07-01 04:51:30"),
      ),
      
      Intake(
        id: "dummy_2",
        beverage: beverages[0],
        timestamp: DateTime.parse("2025-07-01 08:20:00"),
      ),
      Intake(
        id: "dummy_3",
        beverage: beverages[1],
        timestamp: DateTime.parse("2025-07-01 12:15:00"),
      ),
      // ... continua      
      Intake(
        id: "dummy_4",
        beverage: beverages[3],
        timestamp: DateTime.parse("2025-07-03 08:56:28"),
      ),
      Intake(
        id: "dummy_5",
        beverage: beverages[1],
        timestamp: DateTime.parse("2025-07-03 12:32:35"),
      ),
      Intake(
        id: "dummy_6",
        beverage: beverages[2],
        timestamp: DateTime.parse("2025-07-03 20:21:10"),
      ),
      Intake(
        id: "dummy_7",
        beverage: beverages[0],
        timestamp: DateTime.parse("2025-07-03 01:23:09"),
      ),
      Intake(
        id: "dummy_8",
        beverage: beverages[3],
        timestamp: DateTime.parse("2025-07-04 01:08:52"),
      ),
      Intake(
        id: "dummy_9",
        beverage: beverages[0],
        timestamp: DateTime.parse("2025-07-04 10:56:11"),
      ),
      Intake(
        id: "dummy_10",
        beverage: beverages[2],
        timestamp: DateTime.parse("2025-07-04 01:49:35"),
      ),
      Intake(
        id: "dummy_11",
        beverage: beverages[3],
        timestamp: DateTime.parse("2025-07-05 14:45:00"),
      ),
      Intake(
        id: "dummy_12",
        beverage: beverages[1],
        timestamp: DateTime.parse("2025-07-05 19:10:00"),
      ),
      Intake(
        id: "dummy_13",
        beverage: beverages[0],
        timestamp: DateTime.parse("2025-07-06 07:25:00"),
      ),
      Intake(
        id: "dummy_14",
        beverage: beverages[2],
        timestamp: DateTime.parse("2025-07-06 21:40:00"),
      ),
      Intake(
        id: "dummy_15",
        beverage: beverages[1],
        timestamp: DateTime.parse("2025-07-07 09:05:00"),
      ),
      Intake(
        id: "dummy_16",
        beverage: beverages[3],
        timestamp: DateTime.parse("2025-07-07 17:20:00"),
      ),
      Intake(
        id: "dummy_17",
        beverage: beverages[2],
        timestamp: DateTime.parse("2025-07-08 13:10:00"),
      ),
      Intake(
        id: "dummy_18",
        beverage: beverages[0],
        timestamp: DateTime.parse("2025-07-08 22:00:00"),
      ),
      Intake(
        id: "dummy_19",
        beverage: beverages[3],
        timestamp: DateTime.parse("2025-07-09 15:45:00"),
      ),
      Intake(
        id: "dummy_20",
        beverage: beverages[1],
        timestamp: DateTime.parse("2025-07-09 18:30:00"),
      ),
      Intake(
        id: "dummy_21",
        beverage: beverages[0],
        timestamp: DateTime.parse("2025-07-10 08:10:00"),
      ),
      Intake(
        id: "dummy_22",
        beverage: beverages[2],
        timestamp: DateTime.parse("2025-07-10 20:55:00"),
      ),
      Intake(
        id: "dummy_23",
        beverage: beverages[1],
        timestamp: DateTime.parse("2025-07-11 11:35:00"),
      ),
      Intake(
        id: "dummy_24",
        beverage: beverages[3],
        timestamp: DateTime.parse("2025-07-11 23:15:00"),
      ),
      Intake(
        id: "dummy_25",
        beverage: beverages[2],
        timestamp: DateTime.parse("2025-07-12 14:00:00"),
      ),
      Intake(
        id: "dummy_26",
        beverage: beverages[0],
        timestamp: DateTime.parse("2025-07-12 09:25:00"),
      ),
      Intake(
        id: "dummy_27",
        beverage: beverages[1],
        timestamp: DateTime.parse("2025-07-13 16:20:00"),
      ),
      Intake(
        id: "dummy_28",
        beverage: beverages[3],
        timestamp: DateTime.parse("2025-07-13 21:45:00"),
      ),
      Intake(
        id: "dummy_29",
        beverage: beverages[0],
        timestamp: DateTime.parse("2025-07-14 07:55:00"),
      ),
      Intake(
        id: "dummy_30",
        beverage: beverages[2],
        timestamp: DateTime.parse("2025-07-14 19:05:00"),
      ),
    ];




    
     



}
