use std::collections::{HashMap, HashSet};

fn part_1(input: &str) -> usize {
    let mut total_points: usize = 0;

    input.lines().for_each(|line| {
        let mut data = line.split(": ");

        let _ = data.next().unwrap().split(" ").last().unwrap();
        let mut pile_line = data.next().unwrap().trim().split("|").into_iter();

        let winning_numbers = pile_line
            .next()
            .map(|num| num.trim())
            .unwrap()
            .split(" ")
            .filter(|&s| s != "");

        let mut set: HashSet<&str> = HashSet::new();
        winning_numbers.for_each(|win_num| {
            set.insert(win_num);
        });

        let numbers_elf_have = pile_line
            .next()
            .map(|num| num.trim())
            .unwrap()
            .split(" ")
            .filter(|&s| s != "");

        let mut points: usize = 0;
        let mut is_first_match = true;
        numbers_elf_have.for_each(|elf_num| {
            if set.contains(elf_num) {
                if is_first_match {
                    points += 1;
                    is_first_match = false;
                } else {
                    points *= 2;
                }
            }
        });
        total_points += points;
    });
    total_points
}

fn part_2(input: &str) -> usize {
    let mut cards: HashMap<usize, Vec<&str>> = HashMap::new();

    let mut last_card_number: usize = 1;

    input.lines().for_each(|line| {
        let mut data = line.split(": ");

        let card_number: usize = data
            .next()
            .unwrap()
            .split(" ")
            .last()
            .unwrap()
            .parse()
            .unwrap();

        last_card_number = card_number;

        cards
            .entry(card_number)
            .and_modify(|cs| cs.push("O"))
            .or_insert(vec!["O"]);

        let mut pile_line = data.next().unwrap().trim().split("|").into_iter();

        let winning_numbers = pile_line
            .next()
            .map(|num| num.trim())
            .unwrap()
            .split(" ")
            .filter(|&s| s != "");

        let mut set: HashSet<&str> = HashSet::new();
        winning_numbers.for_each(|win_num| {
            set.insert(win_num);
        });

        let numbers_elf_have = pile_line
            .next()
            .map(|num| num.trim())
            .unwrap()
            .split(" ")
            .filter(|&s| s != "");

        let mut matches: usize = 0;
        numbers_elf_have.for_each(|elf_num| {
            if set.contains(elf_num) {
                matches += 1;
            }
        });

        if let Some(ref mut copies) = cards.get(&card_number) {
            for _ in 0..copies.len() {
                for card_id in card_number + 1..=card_number + matches {
                    cards
                        .entry(card_id)
                        .and_modify(|cs| cs.push("C"))
                        .or_insert(vec!["C"]);
                }
            }
        }
    });

    let mut sum = 0;
    cards.into_iter().for_each(|(card_number, copies)| {
        if card_number >= 1 && card_number <= last_card_number {
            sum += copies.len();
        }
    });
    sum
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
        let input = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11";

        let result = part_1(input);
        assert_eq!(result, 13);
    }

    #[test]
    fn part_2_example() {
        let input = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11";

        let result = part_2(input);
        assert_eq!(result, 30);
    }
}
