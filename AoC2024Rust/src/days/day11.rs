use std::fs::File;
use std::io::{BufRead,BufReader};
use std::str::FromStr;


pub fn part1(){
    println!("Day11 Part1");

    let input_doc = File::open("./src/inputs/Day11input.txt").expect("File not found.");
    let mut reader = BufReader::new(input_doc);
    let mut line_str:String = String::new();
    reader.read_line(&mut line_str).expect("Could not read file");
    line_str = String::from(line_str.trim_end());
    let input_array: Vec<&str> = line_str.split(" ").collect();
    let mut stone_array: Vec<i64> = Vec::new();
    for i in input_array{
        if i.parse::<i64>().is_ok(){stone_array.push(FromStr::from_str(i).unwrap());}
    }
    parse_stones(25,stone_array);
}

pub fn part2(){
    println!("Day11 Part2");

    let input_doc = File::open("./src/inputs/Day11input.txt").expect("File not found.");
    let mut reader = BufReader::new(input_doc);
    let mut line_str:String = String::new();
    reader.read_line(&mut line_str).expect("Could not read file");
    line_str = String::from(line_str.trim_end());
    let input_array: Vec<&str> = line_str.split(" ").collect();
    let mut stone_array: Vec<i64> = Vec::new();
    for i in input_array{
        if i.parse::<i64>().is_ok(){stone_array.push(FromStr::from_str(i).unwrap());}
    }

    parse_stones(75,stone_array);
}

fn parse_stones(timer:u16,mut vector:Vec<i64>){
    let mut quant_list:Vec<i64> = Vec::new();

    for _v in &vector{
        quant_list.push(1);
    }
    for _t in 0..timer{
        let mut new_list:Vec<i64> = Vec::new();
        let mut new_quant:Vec<i64> = Vec::new();
        let mut count:u32 = 0;
        for v in &vector{
            
            if *v == 0{
                new_list.push(1);
                new_quant.push(quant_list[count as usize]);
            }
            else if (v.ilog10()+1)%2==0{
                new_list.push(v/(10_i64.pow((v.ilog10()+1)/2)));
                new_quant.push(quant_list[count as usize]);
                new_quant.push(quant_list[count as usize]);
                new_list.push(v%(10_i64.pow((v.ilog10()+1)/2)));
            }
            else{
                new_list.push(v*2024);
                new_quant.push(quant_list[count as usize]);
            }
            count +=1;
        }
        

        let mut filtered_list:Vec<i64> = Vec::new();
        let mut filtered_quant:Vec<i64> = Vec::new();

        for n in 0..new_list.len(){
            if filtered_list.contains(&new_list[n]){
                let pos = match filtered_list.iter().position(|&r| r == new_list[n]){
                    Some(x)=>x,
                    None=>panic!("failed to find in list"),
                };
                filtered_quant[pos] += new_quant[n];
            }
            else{
                filtered_list.push(new_list[n]);
                filtered_quant.push(new_quant[n]);
            }
        }

        quant_list = filtered_quant;
        vector = filtered_list;
    }

    let mut total:i64 = 0;
    for q in quant_list{
        total += q;
    }
    println!("{total}");
}