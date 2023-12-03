use std::collections::HashMap;

mod advent {

    pub struct Engine<'a> {
        pub map: &'a [u8],
        pub num_columns: usize,
    }

    impl<'a> Engine<'a> {
        pub fn get_contained_symbol(&self, _idxs: &Vec<usize>) -> (bool, Option<usize>) {
            let idxs = self.get_idxs_with_diagonals(_idxs);

            let up = self.check_up(&idxs);
            let down = self.check_down(&idxs);
            let right = self.check_right(&idxs);
            let left = self.check_left(&idxs);

            if up.0 {
                return up;
            } else if down.0 {
                return down;
            } else if left.0 {
                return left;
            } else if right.0 {
                return right;
            }

            (false, None)
        }

        fn check_line<F>(&self, idxs: &Vec<usize>, operation: F) -> (bool, Option<usize>)
        where
            F: Fn(&usize, usize) -> Option<usize>,
        {
            for idx in idxs {
                if let Some(desire_idx) = operation(idx, self.num_columns) {
                    if let Some(_) = self.map.get(desire_idx) {
                        let result = self.get_symbol(desire_idx);
                        if result.0 {
                            return result;
                        }
                    }
                }
            }
            (false, None)
        }

        fn get_symbol(&self, idx: usize) -> (bool, Option<usize>) {
            if let Some(byte) = self.map.get(idx) {
                let ch = *byte as char;
                if !ch.is_numeric() && ch != '.' {
                    return (true, Some(idx));
                }
            }
            (false, None)
        }

        fn get_idxs_with_diagonals(&self, idxs: &Vec<usize>) -> Vec<usize> {
            let first_idx = idxs.first().unwrap();
            let last_idx = idxs.last().unwrap();
            let mut diagonals_idxs: Vec<usize> = Vec::new();

            if let Some(left_diagonal) = first_idx.checked_sub(1) {
                diagonals_idxs.push(left_diagonal);
            }

            if let Some(right_diagonal) = last_idx.checked_add(1) {
                diagonals_idxs.push(right_diagonal);
            }
            diagonals_idxs.extend(idxs);
            diagonals_idxs
        }

        fn check_up(&self, idxs: &Vec<usize>) -> (bool, Option<usize>) {
            self.check_line(idxs, |a, b| a.checked_sub(b))
        }

        fn check_down(&self, idxs: &Vec<usize>) -> (bool, Option<usize>) {
            self.check_line(idxs, |a, b| a.checked_add(b))
        }

        fn check_side(&self, idxs: &Vec<usize>, idx: usize) -> (bool, Option<usize>) {
            let idx = *idxs.get(idx).unwrap();

            if let Some(_) = self.map.get(idx) {
                let result = self.get_symbol(idx);
                if result.0 {
                    return result;
                }
            }
            (false, None)
        }

        fn check_right(&self, idxs: &Vec<usize>) -> (bool, Option<usize>) {
            self.check_side(idxs, 1)
        }

        fn check_left(&self, idxs: &Vec<usize>) -> (bool, Option<usize>) {
            self.check_side(idxs, 0)
        }
    }
}

fn get_number(idxs: &Vec<usize>, map: &String) -> usize {
    let mut number = String::new();
    let map_bytes = map.as_bytes();
    for idx in idxs {
        let byte = map_bytes.get(*idx).unwrap();
        let ch = *byte as char;
        number += &ch.to_string();
    }
    number.parse().unwrap()
}

fn part_1(input: &str) -> usize {
    let num_columns = input.lines().next().unwrap().len();
    let mut idxs: Vec<usize> = Vec::new();

    let mut map: String = input.to_string();
    map = map.replace("\n", "");

    let engine = advent::Engine {
        map: map.as_bytes(),
        num_columns,
    };

    let mut sum = 0;
    for (idx, ch) in map.chars().enumerate() {
        if ch.is_numeric() {
            idxs.push(idx);
        } else {
            if idxs.len() > 0 {
                let number = get_number(&idxs, &map);
                if engine.get_contained_symbol(&idxs).0 {
                    sum += number;
                }
            }
            idxs.clear();
        }
    }
    sum
}

fn part_2(input: &str) -> usize {
    let num_columns = input.lines().next().unwrap().len();
    let mut idxs: Vec<usize> = Vec::new();

    let mut map: String = input.to_string();
    map = map.replace("\n", "");

    let mut connected: HashMap<usize, Vec<usize>> = HashMap::new();

    let engine = advent::Engine {
        map: map.as_bytes(),
        num_columns,
    };

    for (idx, ch) in map.chars().enumerate() {
        if ch.is_numeric() {
            idxs.push(idx);
        } else {
            if idxs.len() > 0 {
                let number = get_number(&idxs, &map);
                let result = engine.get_contained_symbol(&idxs);
                if result.0 {
                    if let Some(idx_symbol) = result.1 {
                        connected
                            .entry(idx_symbol)
                            .and_modify(|v| v.push(number))
                            .or_insert(vec![number]);
                    }
                }
            }
            idxs.clear();
        }
    }

    let mut gear_product: usize = 0;
    connected.iter().for_each(|(_, value)| {
        if value.len() == 2 {
            let product = value.iter().fold(1, |acc, x| acc * x);
            gear_product += product;
        }
    });

    gear_product
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
        let input = "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..";

        let result = part_1(input);
        assert_eq!(result, 4361);
    }

    #[test]
    fn part_2_example() {
        let input = "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..";

        let result = part_2(input);
        assert_eq!(result, 467835);
    }
}
