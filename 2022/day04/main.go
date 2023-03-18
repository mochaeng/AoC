package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func generateInterval(interval string) []string {
    line := strings.Split(interval, "-")
    start, _ := strconv.Atoi(line[0])
    end, _ := strconv.Atoi(line[1])

    var newInterval []string
    for i := start; i <= end; i++ {
        newInterval = append(newInterval, strconv.Itoa(i))
    }
    return newInterval
}

func min(a, b [] string) ([]string, []string) {
    if len(a) < len(b) {
        return a, b
    }
    return b, a
}

func check1(interval1, interval2 []string) bool {
    small, big := min(interval1, interval2)
    for _, bigElement := range big {
        for _, smallElement := range small {
            if smallElement == bigElement {
                small = small[1:]
            }
        }
    }
    return len(small) == 0
}

func check2(interval1, interval2 []string) bool {
    small, big := min(interval1, interval2)
    for _, bigElement := range big {
        for _, smallElement := range small {
            if smallElement == bigElement {
                return true
            }
        }
    }
    return false
}


func solve(contents []string) {
    total1 := 0
    total2 := 0
    for _, line := range contents {
        intervals := strings.Split(line, ",")
        first := generateInterval(intervals[0])
        second := generateInterval(intervals[1])
            
        pass1 := check1(first, second)
        if pass1 {
            total1++
        }

        pass2 := check2(first, second)
        if pass2 {
            total2++
        }

    }

    fmt.Println("Total part 1: ", total1)
    fmt.Println("Total part 2: ", total2)
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
