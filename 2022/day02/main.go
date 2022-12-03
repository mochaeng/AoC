package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

var results map[string]map[string]int
var equivalent map[string]string
var win map[string]string
var lose map[string]string

func guidedStrategy(elf string, me string) int {
    if me == "X" {
        return results[elf][lose[elf]]
    } else if me == "Y" {
        return results[elf][equivalent[elf]]
    } else {
        return results[elf][win[elf]]
    }
}

func part1(contents []string) int {
    sum := 0
    for _, line := range contents {
        ops := strings.Split(line, " ")
        sum += results[ops[0]][ops[1]]
    }
    return sum
}

func part2(contents []string) int {
    sum := 0
    for _, line := range contents {
        ops := strings.Split(line, " ")
        sum += guidedStrategy(ops[0], ops[1])
    }
    return sum
}

func main() {
    file, err := os.Open("./input.txt")
    if err != nil {
        panic(err)
    }

    defer file.Close()
    
    var contents []string
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        contents = append(contents, scanner.Text())
    }

    results = map[string]map[string]int{
        "A": {"X":4, "Y":8, "Z":3},
        "B": {"X":1, "Y":5, "Z":9},
        "C": {"X":7, "Y":2, "Z":6},
    }
    equivalent = map[string]string{"A": "X", "B": "Y", "C": "Z"}
    win = map[string]string{"A": "Y", "B": "Z", "C": "X"}
    lose = map[string]string{"A": "Z", "B": "X", "C": "Y"}
    
    ans1 := part1(contents)
    ans2 := part2(contents)

    fmt.Println("Answer 1: ", ans1)
    fmt.Println("Answer 2: ", ans2)
}
