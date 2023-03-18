package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func parsingLine(line string) string {
    newLine := ""
    isACrate := false
    for _, char := range line {
        if char == '[' || char == ' ' && !isACrate {
            isACrate = true
            continue
        }
        if isACrate {
            if char == ' ' {
                newLine += "-"
            } else {
                newLine += string(char)
            }
            isACrate = false
        }
    }
    return newLine
}

func parsingLines(lines []string) ([]string, []string) {
    var crateLines []string
    var moveLines []string

    idx := 0
    for _, line := range lines {
        if len(line) == 0 {
            break
        }
        crateLines = append(crateLines, parsingLine(line))
        idx++
    }
    crateLines = crateLines[:len(crateLines) - 1]
    moveLines = lines[idx:]
    return crateLines, moveLines
}

func parsingStacksIntoAMap(crateLines []string) map[int][]string {
    crates := make(map[int][]string)
    
    crateIdx := 1
    for _, crateLine := range crateLines {
        crateLine = strings.ReplaceAll(crateLine, "--", "-")
        crateIdx = 1
        for _, char := range crateLine {
            if char == '-' {
                crateIdx++
                continue
            }
            crates[crateIdx] = append(crates[crateIdx], string(char))
            crateIdx++
        }
    }
    return crates
}

func reverse(cratesToMove []string) []string {
    for i, j := 0, len(cratesToMove) - 1; i < j; i, j = i+1, j-1 {
        cratesToMove[i], cratesToMove[j] = cratesToMove[j], cratesToMove[i]
    }
    return cratesToMove
}

func moveCrates(amount, from, to int, crates map[int][]string, isReverse bool) {
    // get elements from "from"
    // put them into "crates[to]"
    // remove elements from "from"

    if amount > len(crates[from]) {
        amount = len(crates[from])
    }
    cratesToMove := make([]string, amount)
    copy(cratesToMove, crates[from][0:amount])
    if isReverse {
        cratesToMove = reverse(cratesToMove)
    }

    crates[to] = append(cratesToMove, crates[to]...)

    crates[from] = crates[from][amount:]
}

func parsingMoves(moves []string, crates map[int][]string, isReverse bool) {
    for _, what := range moves {
        if len(what) == 0 {
            continue
        }
        pieces := strings.Split(what, " ")
        
        amount, _ := strconv.Atoi(pieces[1])
        from, _ := strconv.Atoi(pieces[3])
        to, _ := strconv.Atoi(pieces[5])
        
        moveCrates(amount, from, to, crates, isReverse)
    }
}

func printCrates(crates map[int][]string) {
    cratesAmount := len(crates)
    for i := 1; i <= cratesAmount; i++ {
        currentCrate := crates[i]
        if len(currentCrate) > 0 {
            fmt.Print(currentCrate[0])
        }
    }
    fmt.Println()
}

func part1(cratesLines []string, moveLines []string) {
    crates := parsingStacksIntoAMap(cratesLines)
    parsingMoves(moveLines, crates, true)
    fmt.Print("Part 1: ")
    printCrates(crates)
}

func part2(cratesLines []string, moveLines []string) {
    crates := parsingStacksIntoAMap(cratesLines)
    parsingMoves(moveLines, crates, false)
    fmt.Print("Part 2: ")
    printCrates(crates)
}

func solve(contents []string) {
    crateLines, moveLines := parsingLines(contents)

    part1(crateLines, moveLines)
    part2(crateLines, moveLines)
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
