package main

import (
	// "bufio"
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

func main() {
    file, err := os.Open("input.txt")
    if err != nil {
        panic(err)
    }

    defer file.Close()
    
    // test()

    fileScanner := bufio.NewScanner(file)
    elfCalories := 0
    elves := make([]int, 1000)
    nthElf := 0
    for fileScanner.Scan() {
        line := fileScanner.Text()
        calorie, err := strconv.Atoi(line)
        if err != nil {  // a new elf
            elves[nthElf] = elfCalories
            elfCalories = 0
            nthElf++
            continue
        }
        elfCalories += calorie
    }
    elves[nthElf] = elfCalories
    sort.Ints(elves)
    sum := 0
    for i := 1; i <= 3; i++ {
        sum += elves[len(elves) - i]
    }
    fmt.Println(sum)
}

func test() {
    scanner := bufio.NewScanner(strings.NewReader(inputExample))
    elfCalories := 0
    top3 := make([]int, 3)
    fmt.Println(top3)
    for scanner.Scan() {
        line := scanner.Text()
        calorie, err := strconv.Atoi(string(line))
        if err != nil {  // a new elf
            fmt.Println(top3, elfCalories)
            elfCalories = 0
            continue
        }
        elfCalories += calorie
    }
    fmt.Println(top3)
    fmt.Println("Total calores by top3 elves: ", top3[0] + top3[1] + top3[2])
}

var inputExample =  `1000
2000
3000

9000

5000

7000
8000

10000

7000`
