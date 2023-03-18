package main

import (
	"bufio"
	"fmt"
	"os"
)

func checkColumn(ch byte, contents []string, j, from, to int) bool {
    isVisible := true 
    for i := from; i < to; i++ {   
        if ch <= contents[i][j] {
            return false
        }
    }
    return isVisible
}

func checkRow(ch byte, str string) bool {
    isVisible := true 
    for i :=0; i < len(str); i++ {
        if ch <= str[i]  {
            return false
        }
    }
    return isVisible
}

func check_visibility(ch byte, contents []string, i, j int) bool {
    isTop := checkColumn(ch, contents, j, 0, i)
    isBottom := checkColumn(ch, contents, j, i+1, len(contents))
    isRight := checkRow(ch, contents[i][j+1:])
    isLeft := checkRow(ch, contents[i][:j])

    return isTop || isBottom || isRight || isLeft
}

func count(contents []string) int {
    dx := len(contents[0])
    dy := len(contents)
    sum := 0
    for i := 1; i < dy - 1; i++ {
        for j := 1; j < dx - 1; j++ {
            ch := contents[i][j]
            if check_visibility(ch, contents, i, j) {
                sum++
            }
        }
    }

    sum += 2 * (dx + dy) - 4
    return sum
}

// ---------------------

func reverse(contents []string) []string {
    newContens := make([]string, len(contents))
    copy(newContens, contents)
    for i, j := 0, len(newContens)-1; i < j; i, j = i+1, j-1 {
        newContens[i], newContens[j] = newContens[j], newContens[i] 
    }
    return newContens
}

func reverseStr(str string) string {
    rs := []rune(str)
    for i, j := 0, len(rs)-1; i < j; i, j = i+1, j-1 {
        rs[i], rs[j] = rs[j], rs[i]
    }
    return string(rs)
}

func getColumn(contents []string, j int) []string {
    column := make([]string, len(contents[0]))
    for i := 0; i < len(contents[0]); i++ {
        column[i] = string(contents[i][j])
    }
    return column
}

func countColumn(ch byte, contents []string) int {
    total := 0
    for i := 0; i < len(contents); i++  {   
        total++
        if string(ch) <= contents[i] {
            return total
        }
    }
    return total
}

func countRow(ch byte, str string) int {
    total := 0
    for i := 0; i < len(str); i++  {   
        total++
        if ch <= str[i] {
            return total
        }
    }
    return total
}

func checkHowMany(ch byte, contents []string, i, j int) int {
    column := getColumn(contents, j)

    fromTop := countColumn(ch, reverse(column[:i]))
    fromBottom := countColumn(ch, column[i+1:])
    fromRight := countRow(ch, contents[i][j+1:])
    fromLeft := countRow(ch, reverseStr(contents[i][:j]))
    return fromTop * fromBottom * fromRight * fromLeft
}

func calcSceniScore(contents []string) int {
    dx := len(contents[0])
    dy := len(contents)
    bestScore := 0
    for i := 1; i < dy - 1; i++ {
        for j := 1; j < dx - 1; j++ {
            ch := contents[i][j]
            res := checkHowMany(ch, contents, i, j)
            if res > bestScore {
                bestScore = res
            }
        }
    }
    return bestScore
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
    
    fmt.Println("Part1: ", count(contents))
    fmt.Println("Part2: ", calcSceniScore(contents))
}
