fn part_1(input: &str) -> i32 {
    let on_each_pair = &mut |pair: &[i32]| pair[1] - pair[0];
    summation(input, false, on_each_pair)
}

fn part_2(input: &str) -> i32 {
    let on_each_pair = &mut |pair: &[i32]| pair[0] - pair[1];
    summation(input, true, on_each_pair)
}

fn summation<F>(input: &str, is_to_get_first_value: bool, on_each_pair: &mut F) -> i32
where
    F: FnMut(&[i32]) -> i32,
{
    let lines = input.lines();

    let mut all_sequences_sum = 0;

    lines.for_each(|line| {
        let mut sequence: Vec<i32> = line
            .split_ascii_whitespace()
            .map(|num| num.parse::<i32>().unwrap())
            .collect();

        let mut sequence_sum = if is_to_get_first_value {
            *sequence.first().unwrap()
        } else {
            *sequence.last().unwrap()
        };

        loop {
            let mut new_sequence: Vec<i32> = Vec::with_capacity(sequence.len() -1);
            for pair in sequence.windows(2) {
                new_sequence.push(on_each_pair(pair));
            }
            sequence = new_sequence;

            if is_to_get_first_value {
                sequence_sum += sequence.first().unwrap();
            } else {
                sequence_sum += sequence.last().unwrap();
            }

            let sum = sequence.iter().fold(0, |acc, value| acc + value);
            if sum == 0 {
                break;
            }

        }

        all_sequences_sum += sequence_sum;
    });

    all_sequences_sum
}

fn main() {
    let input = include_str!("./input.txt");

    println!("Part 1: {:?}", part_1(input));
    println!("Part 2: {:?}", part_2(input));
}
