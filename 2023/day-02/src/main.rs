use std::collections::HashMap;

#[derive(Debug)]
struct Game<'a> {
    target_red: u32,
    target_green: u32,
    target_blue: u32,

    max_values: HashMap<&'a str, u32>,

    red: u32,
    green: u32,
    blue: u32,
    is_failed: bool,
}

fn build_game<'a>(target_red: u32, target_green: u32, target_blue: u32) -> Game<'a> {
    let mut init_max_values: HashMap<&str, u32> = HashMap::new();
    init_max_values.insert("red", 0);
    init_max_values.insert("green", 0);
    init_max_values.insert("blue", 0);

    Game {
        red: 0,
        green: 0,
        blue: 0,
        max_values: init_max_values,
        is_failed: false,
        target_red,
        target_green,
        target_blue,
    }
}

impl<'a> Game<'a> {
    fn add(&mut self, num: u32, color: &str) {
        match color {
            "red" => self.red += num,
            "green" => self.green += num,
            "blue" => self.blue += num,
            _ => (),
        }
    }

    fn push(&mut self, num: u32, color: &'a str) {
        if let Some(value) = self.max_values.get(color) {
            if num > *value {
                self.max_values.insert(color, num);
            }
        }
    }

    fn power_product(&self) -> u32 {
        self.max_values
            .iter()
            .map(|(_, &value)| value)
            .fold(1, |acc, x| acc * x)
    }

    fn is_possible(&self) -> bool {
        self.red <= self.target_red
            && self.green <= self.target_green
            && self.blue <= self.target_blue
    }

    fn clear(&mut self) {
        self.red = 0;
        self.green = 0;
        self.blue = 0;
    }
}

fn part_1(input: &str) -> u32 {
    let mut ids_sum: u32 = 0;
    let lines = input.lines();
    for line in lines {
        let instance: Vec<&str> = line.split(":").collect();
        let game_id: u32 = instance[0].split(" ").last().unwrap().parse().unwrap();
        let mut game = build_game(12, 13, 14);

        let sets = instance[1].trim().split(";").into_iter();
        for mut set in sets {
            if game.is_failed {
                break;
            }
            set = set.trim();

            let cubes = set.split(",").into_iter().map(|unit| unit.trim());
            for cube in cubes {
                let mut entity = cube.split(" ").into_iter();
                let amount: u32 = entity.next().unwrap().parse().unwrap();
                let color = entity.next().unwrap();

                game.add(amount, color);
            }
            if !game.is_possible() {
                game.is_failed = true;
            }
            game.clear();
        }

        if !game.is_failed {
            ids_sum += game_id;
        }
    }
    ids_sum
}

fn part_2(input: &str) -> u32 {
    let mut sum_products: u32 = 0;

    input.lines().for_each(|line| {
        let instance: Vec<&str> = line.split(":").collect();
        let mut game = build_game(0, 0, 0);

        let sets = instance[1].trim().split(";").into_iter();
        for mut set in sets {
            set = set.trim();

            let cubes = set.split(",").into_iter().map(|unit| unit.trim());
            for cube in cubes {
                let mut entity = cube.split(" ").into_iter();
                let amount: u32 = entity.next().unwrap().parse().unwrap();
                let color = entity.next().unwrap();

                game.push(amount, color);
            }
        }

        let product = game.power_product();
        sum_products += product;
    });
    sum_products
}

fn main() {
    let input = include_str!("./input.txt");

    println!("Part 1: {}", part_1(input));
    println!("Part 2: {}", part_2(input));
}

#[cfg(test)]
mod tests {
    use crate::{part_1, part_2};

    #[test]
    fn part_1_example() {
        let input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green";

        let result = part_1(input);
        assert_eq!(result, 8);
    }

    #[test]
    fn part_2_example() {
        let input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green";

        let result = part_2(input);
        assert_eq!(result, 2286);
    }
}
