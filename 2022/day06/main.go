package main

import (
	"bufio"
	"fmt"
	"os"
)

func add(buffer []string, str string) map[rune]int {
    mapper := make(map[rune]int)
    for _, ch := range str {
        mapper[ch] += 1
    }
    return mapper
}

func check(mapper map[rune]int) bool {
    for _, v := range mapper {
        if v > 1 {
            return true
        }
    }
    return false
}

func parsing(line string, nDistinct int) int {
    // size := len(line)
    for pointer := range line {
        buffer := make([]string, nDistinct)
        
        start := pointer
        end := pointer + nDistinct
        if end > len(line) {
            end = len(line)
        }
    
        mapper := add(buffer, line[start : end])
        isChecked := check(mapper)
        if !isChecked {
            return pointer + nDistinct
        }
    }
    return 0
}

func part1(line string) int {
    return parsing(line, 4)
}

func part2(line string) int {
    return parsing(line, 14)
}

func solve(contents []string) {
    for _, line := range contents {
        fmt.Println("Part1: ", part1(line))
        fmt.Println("Part2: ", part2(line))
    }
}

func main() {
    file, err := os.Open("./input.txt")
    if err != nil {
        panic(err)
    }

    defer file.Close()
    
    scanner := bufio.NewScanner(file)
    var contents []string
    for scanner.Scan() {
        contents = append(contents, scanner.Text())
    }

    solve(contents)
    

}
