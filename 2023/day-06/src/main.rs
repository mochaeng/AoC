fn calc_distance(velocity: usize, time_record: usize) -> usize {
    velocity * (time_record - velocity)
}

fn count_possible_solutions(races_records: &Vec<(usize, usize)>) -> usize {
    let mut number_solutions: Vec<usize> = Vec::new();

    races_records.clone().into_iter().for_each(|record| {
        let time_record = record.0;
        let distance_record = record.1;

        let interval = 0..record.0 + 1;
        let mut possible_solutions: Vec<(usize, usize)> = Vec::new();

        interval.for_each(|velocity| {
            possible_solutions.push((velocity, calc_distance(velocity, time_record)))
        });

        let winnings: Vec<(usize, usize)> = possible_solutions
            .into_iter()
            .clone()
            .filter(|solution| solution.1 > distance_record)
            .collect();

        number_solutions.push(winnings.len());
    });

    let result = number_solutions
        .into_iter()
        .fold(1, |acc, solution| acc * solution);
    result
}

fn part_1(input: &str) -> usize {
    let mut lines = input.lines();

    let times: Vec<usize> = lines
        .next()
        .unwrap()
        .split_ascii_whitespace()
        .skip(1)
        .map(|time| time.parse::<usize>().unwrap())
        .collect();

    let distances: Vec<usize> = lines
        .next()
        .unwrap()
        .split_ascii_whitespace()
        .skip(1)
        .map(|distance| distance.parse::<usize>().unwrap())
        .collect();

    let races_records: Vec<(usize, usize)> = times
        .clone()
        .into_iter()
        .zip(distances.clone().into_iter())
        .collect();

    count_possible_solutions(&races_records)
}

fn part_2(input: &str) -> usize {
    let mut lines = input.lines();

    let time: usize = lines
        .next()
        .unwrap()
        .split_ascii_whitespace()
        .skip(1)
        .collect::<String>()
        .parse::<usize>()
        .unwrap();

    let distance: usize = lines
        .next()
        .unwrap()
        .split_ascii_whitespace()
        .skip(1)
        .collect::<String>()
        .parse::<usize>()
        .unwrap();

    let race_record: Vec<(usize, usize)> = vec![(time, distance)];
    count_possible_solutions(&race_record)
}

fn main() {
    let input = include_str!("./input.txt");

    println!("Part 1: {:?}", part_1(input));
    println!("Part 2: {:?}", part_2(input));
}

#[cfg(test)]
mod tests {
    use crate::{part_1, part_2};

    #[test]
    fn part_1_example() {
        let input = "Time:      7  15   30
Distance:  9  40  200";

        let result = part_1(input);
        assert_eq!(result, 288);
    }
    #[test]
    fn part_2_example() {
        let input = "Time:      7  15   30
Distance:  9  40  200";

        let result = part_2(input);
        assert_eq!(result, 71503);
    }
}
