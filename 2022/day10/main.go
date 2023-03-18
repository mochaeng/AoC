package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// var time map[string]int = map[string]int{"noop": 1, "addx": 2}
var isFinish = false
var signalsStrenth []int
var currentCycle = 0
var xRegister = 1
var valuesToAdd []int
var clocksAndValues []int = make([]int, 241)


func checkCycle() {
    if (currentCycle % 40) - 20 == 0 {
        signalsStrenth = append(signalsStrenth, currentCycle * xRegister)
    }
    clocksAndValues[currentCycle] = xRegister 
}

func sumArray(arr []int) int {
    sum := 0
    for _, v := range arr {
        sum += v
    }
    return sum
}

func hasEnded() {
    if isFinish {
        value := valuesToAdd[0]
        valuesToAdd = valuesToAdd[1:]
        xRegister += value 
        isFinish = false
        clocksAndValues[currentCycle] = xRegister
    }
}

func simulateInstruction(clockCycles int) {
    hasEnded()
    for i := 0; i < clockCycles; i++ {
        currentCycle++
        checkCycle()
        fmt.Println(currentCycle, xRegister)
    }
}

func simulateAddInstruction(clockCycles int) {
    hasEnded()
    for i := 0; i < clockCycles; i++ {
        currentCycle++
        checkCycle()
        fmt.Println(currentCycle, xRegister)
    }
    isFinish = true
}

func parsing(contents []string) {
    for _, instruction := range contents {
        tokens := strings.Split(instruction, " ")
        switch tokens[0] {
        case "noop":
            simulateInstruction(1)
        case "addx":
            value, _ := strconv.Atoi(tokens[1])
            valuesToAdd = append(valuesToAdd, value)
            fmt.Println("Value: ", value)
            simulateAddInstruction(2)
        }

    }
    hasEnded()
}

// -------------

func drawing(contents []string) {
    // crt := 0
    // sprite := []int{0, 1, 3}
    clocksAndValues[0] = xRegister
    for _, instruction := range contents {
        tokens := strings.Split(instruction, " ")

        switch tokens[0] {
        case "noop":
            simulateInstruction(1)
        case "addx":
            value, _ := strconv.Atoi(tokens[1])
            valuesToAdd = append(valuesToAdd, value)
            fmt.Println("Value: ", value)
            simulateAddInstruction(2)
        }

        // for i := 0; i < 6; i++ {
        //     for j := 0; j < 40; j++ {
        //         fmt.Print("#")
        //     }
        //     fmt.Println()
        // }
    }
}

func main() {
    file, err := os.Open("./input_test2.txt")
    if err != nil {
        panic(err)
    }

    defer file.Close()

    var contents []string
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        contents = append(contents, scanner.Text())
    }

    // parsing(contents)
    
    // fmt.Println("Part1: ", sumArray(signalsStrenth))

    drawing(contents)
    fmt.Println(clocksAndValues)

}
