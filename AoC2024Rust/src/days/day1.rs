
use std::fs::File;
use std::io::{BufRead,BufReader};

pub fn part1(){
    println!("Day1 Part1");

    let input_doc = File::open("./src/inputs/Day1input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);
    let mut left_vec: Vec<i32> = Vec::new();
    let mut right_vec: Vec<i32> = Vec::new();
    let mut total = 0;
    let mut count = 0;

    for line in reader.lines(){
        let row = line.expect("Could not read line");
        let sides: Vec<&str> = row.split("   ").collect();
        let left:i32 = match sides[0].parse(){
            Ok(num) =>num,
            Err(_) => {
                println!("Failed to convert");
                return
            }
        };
        let right:i32 = match sides[1].parse(){
            Ok(num) =>num,
            Err(_) => {
                println!("Failed to convert");
                return
            }
        };
        left_vec.push(left);
        right_vec.push(right);
    }
    left_vec.sort();
    right_vec.sort();

    
    for l in &left_vec{
        
        total += (l-&right_vec[count]).abs();
        count+=1;
    }
    println!("Total:{total}");
}

pub fn part2(){
    println!("Day1 Part2");

    let input_doc = File::open("./src/inputs/Day1input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);
    let mut left_vec: Vec<i32> = Vec::new();
    let mut right_vec: Vec<i32> = Vec::new();
    let mut total = 0;
    

    for line in reader.lines(){
        let row = line.expect("Could not read line");
        let sides: Vec<&str> = row.split("   ").collect();
        let left:i32 = match sides[0].parse(){
            Ok(num) =>num,
            Err(_) => {
                println!("Failed to convert");
                return
            }
        };
        let right:i32 = match sides[1].parse(){
            Ok(num) =>num,
            Err(_) => {
                println!("Failed to convert");
                return
            }
        };
        left_vec.push(left);
        right_vec.push(right);
    }

    
    for l in &left_vec{
        let mut count = 0;
        for r in &right_vec{
            count += (l == r) as i32;
        }
        total += l*count;
        
    }

    println!("Total:{total}");
}

