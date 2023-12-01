fn part_1(input: &str) -> i32 {
    let mut sum = 0;

    input.lines().for_each(|line| {
        let mut digits: Vec<char> = Vec::new();
        line.chars().for_each(|c| {
            if c.is_digit(10) {
                digits.push(c)
            }
        });
        let result = format!("{}{}", digits.first().unwrap(), digits.last().unwrap());
        let line_sum: i32 = result.parse().unwrap();
        sum += line_sum;
    });
    sum
}

fn part_2(input: &str) -> i32 {
    let lines = input.lines();
    let patterns = vec![
        "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
    ];

    let mut sum = 0;
    for line in lines {
        let mut word = String::new();
        let mut all_words: Vec<String> = Vec::new();

        for c in line.chars() {
            if c.is_numeric() {
                all_words.push(c.to_string());
                word.clear();
            } else {
                word.push(c);
                if let Some(value) = look_for_substr(&patterns, &word) {
                    all_words.push(value.to_string());
                    word = c.to_string();
                }
            }
        }

        let first = get_value(all_words.first().unwrap()).unwrap();
        let last = get_value(all_words.last().unwrap()).unwrap();
        let concat = format!("{}{}", first, last);
        let value: i32 = concat.parse().unwrap();
        sum += value;
    }

    sum
}

fn get_value(element: &str) -> Option<&str> {
    match element {
        "one" => Some("1"),
        "two" => Some("2"),
        "three" => Some("3"),
        "four" => Some("4"),
        "five" => Some("5"),
        "six" => Some("6"),
        "seven" => Some("7"),
        "eight" => Some("8"),
        "nine" => Some("9"),
        _ => Some(element),
    }
}

fn look_for_substr<'a>(patterns: &Vec<&'a str>, word: &'a str) -> Option<&'a str> {
    patterns
        .iter()
        .find(|&&pattern| word.contains(pattern))
        .copied()
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
        let input = "1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
";

        let result = part_1(input);
        assert_eq!(result, 142);
    }

    #[test]
    fn part_2_example() {
        let input = "two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen";

        let result = part_2(input);
        assert_eq!(result, 281);
    }

    #[test]
    fn edge_cases() {
        let input = "twone
eightwo
nineight
eighthree
nineeight
oooneeone
";

        let result = part_2(input);
        assert_eq!(result, 393);
    }
}
