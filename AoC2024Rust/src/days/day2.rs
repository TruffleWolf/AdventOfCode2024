use std::fs::File;
use std::io::{BufRead,BufReader};

pub fn part1(){
    println!("Day2 Part1");

    let input_doc = File::open("./src/inputs/Day2input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);
    //let mut input_vec: Vec<Vec<i32>> = Vec::new();
    let mut total:i32 = 0;
    for line in reader.lines(){
        let mut input_line:Vec<i32> = Vec::new();
        let row = line.expect("Could not read line");
        let numbers: Vec<&str> = row.split(" ").collect();
        
        for a in numbers{
            
            let new_numb:i32 = match a.parse(){
                Ok(num) =>num,
                Err(_) => {
                    println!("Failed to convert");
                    return
                }
            };
            input_line.push(new_numb);
        }
        total += array_check(&input_line) as i32;
        //input_vec.push(input_line);
    }

    println!("Total:{}",total);

}

pub fn part2(){
    println!("Day2 Part2");

    let input_doc = File::open("./src/inputs/Day2input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);
    let mut input_vec: Vec<Vec<i32>> = Vec::new();
    let mut total:i32 = 0;
    for line in reader.lines(){
        let mut input_line:Vec<i32> = Vec::new();
        let row = line.expect("Could not read line");
        let numbers: Vec<&str> = row.split(" ").collect();
        
        for a in numbers{
            
            let new_numb:i32 = match a.parse(){
                Ok(num) =>num,
                Err(_) => {
                    println!("Failed to convert");
                    return
                }
            };
            input_line.push(new_numb);
        }
        
        input_vec.push(input_line);
    }

    for i in input_vec{
        let mut safe:bool = true;
        if !array_check(&i){
            let mut fixed_safe:bool = false;

            for x in 0..i.len(){
                let mut new_input:Vec<i32> = i.clone();
                new_input.remove(x);
                if array_check(&new_input){
                    fixed_safe = true;
                    break;
                }
            }

            safe = fixed_safe;
        }

        total += safe as i32;
    }

    println!("Total:{}",total);
}

fn array_check(input:&Vec<i32>) -> bool{
    let safe:bool = true;
    if input.len()<2{return false;}
    else if input[0]>input[1]{
        //decending
        for b in 0..input.len()-1{
            if !(input[b]>input[b+1]) || (input[b]-input[b+1]).abs() > 3{
                return false;
            }
        }
    }
    else if input[0]<input[1]{
        //acending
        for b in 0..input.len()-1{
            if !(input[b]<input[b+1]) || (input[b]-input[b+1]).abs() > 3{
                return false;
            }
        }
   
    }
    else{return false;}

    return safe;
}