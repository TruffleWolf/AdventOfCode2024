use std::fs::File;
use std::io::{BufRead,BufReader};
use std::str::FromStr;

pub fn part1(){
    println!("Day5 Part1");

    let input_doc = File::open("./src/inputs/Day5input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);

    let mut rules:Vec<[i32;2]> = Vec::new();
    let mut updates:Vec<Vec<i32>> = Vec::new();

    for line in reader.lines(){
        let row:String = match line{
            Ok(x)=>x,
            Err(_)=>{println!("Failed To Read"); continue}
        };
        //let row_point = row.clone();
        if row.contains("|"){
            let split:Vec<&str> = row.split("|").collect();

            rules.push([FromStr::from_str(split[0]).unwrap(),FromStr::from_str(split[1]).unwrap()]);
        }
        else if row.contains(","){
            let split:Vec<&str> = row.split(",").collect();
            let mut numbers:Vec<i32> = Vec::new();
            for s in split{
                numbers.push(FromStr::from_str(s).expect("Failed to conver to i32"));
            }
            updates.push(numbers);
        }

    }
    let mut filtered_updates:Vec<&Vec<i32>> = Vec::new();
    let mut broken_updates:Vec<&Vec<i32>> = Vec::new();

    for u in &updates{
        if rules_check(u, &rules){
            filtered_updates.push(u);
        }
        else{
            broken_updates.push(u);
        }
    }


    let mut total:i32 = 0;
    for u in filtered_updates{
        total += u[u.len()/2];
    }
    println!("{total}");

}

pub fn part2(){
    println!("Day5 Part2");

    let input_doc = File::open("./src/inputs/Day5input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);

    let mut rules:Vec<[i32;2]> = Vec::new();
    let mut updates:Vec<Vec<i32>> = Vec::new();

    for line in reader.lines(){
        let row:String = match line{
            Ok(x)=>x,
            Err(_)=>{println!("Failed To Read"); continue}
        };
        //let row_point = row.clone();
        if row.contains("|"){
            let split:Vec<&str> = row.split("|").collect();

            rules.push([FromStr::from_str(split[0]).unwrap(),FromStr::from_str(split[1]).unwrap()]);
        }
        else if row.contains(","){
            let split:Vec<&str> = row.split(",").collect();
            let mut numbers:Vec<i32> = Vec::new();
            for s in split{
                numbers.push(FromStr::from_str(s).expect("Failed to conver to i32"));
            }
            updates.push(numbers);
        }

    }
    let mut filtered_updates:Vec<&Vec<i32>> = Vec::new();
    let mut broken_updates:Vec<&Vec<i32>> = Vec::new();

    for u in &updates{
        if rules_check(u, &rules){
            filtered_updates.push(u);
        }
        else{
            broken_updates.push(u);
        }
    }

    updates = correct_updates(broken_updates,rules);

    let mut total:i32 = 0;
    for u in updates{
        total += u[u.len()/2];
    }
    println!("{total}");
}

fn correct_updates(input:Vec<&Vec<i32>>,rule:Vec<[i32;2]>)->Vec<Vec<i32>>{

    let mut reparied_vec:Vec<Vec<i32>> = Vec::new();

    for i in input{
        let mut row:Vec<i32> = i.to_vec();
        let mut count:i32 = 0;
        while count < row.len()as i32{
            let target:i32 = row[row.len()-1-count as usize];
            for r in &rule{
                if r[0]==target{
                    if row.contains(&r[1])&& row.iter().position(|f| f==&target)>row.iter().position(|f| f==&r[1]){
                        
                        let pos = match row.iter().position(|f| f==&target){
                            Some(x)=>x,
                            None=>continue,
                        };
                        row.remove(pos);
                        let pos = match row.iter().position(|f| f==&r[1]){
                            Some(x)=>x,
                            None=>continue,
                        };
                        row.insert(pos, target);
                        count = -1;
                    }
                }
            }
            count +=1;
        }
        reparied_vec.push(row);
    }

    return reparied_vec;
}

fn rules_check(input:&Vec<i32>,rule:&Vec<[i32;2]>)-> bool{
    
    for i in input{
        for r in rule{
            if &r[0]== i{
                if input.contains(&r[1]) && input.iter().position(|&f| &f==i)>input.iter().position(|&f| f==r[1]){
                    return false;
                }
            }
        }
    }

    return true;
}