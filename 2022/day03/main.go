package main

import (
	"bufio"
	"errors"
	"fmt"
	"os"
)

func part1(contents []string, priorities map[string]int) int {
    sum := 0
    for i := 0; i < len(contents); i++ {
        rucksack := contents[i]
        middleIdx := len(rucksack) / 2
        sameItem, _ := whichItemInCommon(rucksack[middleIdx:], rucksack[:middleIdx])
        sum += priorities[sameItem]
    }
    return sum
}

func part2(contents []string, priorities map[string]int) int {
    sum := 0
    for i := 0; i < len(contents); i++ {
        ruscksack1 := contents[i]
        i++
        rucksack2 := contents[i]
        i++
        rucksack3 := contents[i]
        
        item, _ := whichTypeItem(ruscksack1, rucksack2, rucksack3)
        sum += priorities[item]
    }
    return sum
}

func whichTypeItem(grup1 string, group2 string, group3 string) (string, error){
    for _, char1 := range grup1 {
        for _, char2 := range group2 {
            for _, char3 := range group3 {
                if char1 == char2 && char2 == char3 {
                    return string(char1), nil
                }
            }
        }
    }
    return "", errors.New("no items in common")
}

func whichItemInCommon(compartment1 string, compartment2 string) (string, error){
    for _, char1 := range compartment1 {
        for _, char2 := range compartment2 {
            if char1 == char2 {
                return string(char1), nil
            }
        }
    }
    return "", errors.New("no items in common")
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
    
    priorities := initPriorites()
    sum1 := part1(contents, priorities)
    sum2 := part2(contents, priorities)
    fmt.Println("Sum part1: ", sum1)
    fmt.Println("Sum part2: ", sum2)
}

func initPriorites() map[string]int {
    priorities := make(map[string]int)
    idx := 1
    for i := 'a'; i <= 'z'; i++ {
        priorities[string(i)] = idx
        idx++
    }

    for i := 'A'; i <= 'Z'; i++ {
        priorities[string(i)] = idx
        idx++
    }
    return priorities
}
