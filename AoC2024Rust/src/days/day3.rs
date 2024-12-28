
use std::fs::File;
use std::io::{BufReader, Read};
use std::str::FromStr;

pub fn part1(){
    println!("Day3 Part1");
    
    let mut total:i32 = 0;

    let input_doc = File::open("./src/inputs/Day3input.txt").expect("File not found.");
    let mut reader = BufReader::new(input_doc);
    let mut total_string:String = String::new();
    reader.read_to_string(&mut total_string).expect("Cannot read String.");
    
    let mult_list: Vec<String> = compile_all_multi(total_string);
    
    for m in mult_list{
        total += convert_multi(&m);
    }

    println!("{total}")

}

pub fn part2(){
    println!("Day3 Part2");
   
    let mut mult_list: Vec<String> = Vec::new();
    let mut total:i32 = 0;

    let input_doc = File::open("./src/inputs/Day3input.txt").expect("File not found.");
    let mut reader = BufReader::new(input_doc);
    let mut total_string:String = String::new();
    reader.read_to_string(&mut total_string).expect("Cannot read String.");

    let enabled_strings:Vec<&str> = total_string.split("do()").collect();
    let mut filtered_strings:Vec<&str> = Vec::new();

    for e in enabled_strings{
        let slice:Vec<&str> = e.split("don't()").collect();
        filtered_strings.push(slice[0]);
    }
    
    for f in filtered_strings{
        let slice:String = String::from(f);
        let mut new_list = compile_all_multi(slice);
        mult_list.append(&mut new_list);
        
    }

    for m in mult_list{
        total += convert_multi(&m);
    }

    println!("{total}")
}

fn compile_all_multi(input_str:String) -> Vec<String>{
    let mut new_mults:Vec<String> = Vec::new();
    let mut parse_string = input_str;
    while parse_string.contains("mul("){
        
        let mut mult_string:String = String::new();
        let start_location:usize = match parse_string.find("mul("){
            Some(x)=>x,
            None => continue,
        };
        
        let cropped_string = parse_string.get(start_location..);
        match cropped_string{
            Some(x) => mult_string = String::from(x),
            None => println!("Error in cropping"),
        }
        
        let end_location:usize = match mult_string.find(")"){
            Some(x) => x,
            None => 0,
        };
        if end_location == 0{break;}
        else{
            let cropped_string = mult_string.get(..end_location+1);
            match cropped_string{
                Some(x) => mult_string = String::from(x),
                None => println!("Error in cropping"),
            }
            if mult_string.contains(","){
                let halves:Vec<&str> = mult_string.split(",").collect();
                if halves.len()==2{
                    let a_str:&str = match halves[0].strip_prefix("mul("){
                        Some(x)=>x,
                        None=>continue,
                    };
                    let b_str:&str = match halves[1].strip_suffix(")"){
                        Some(x)=>x,
                        None=>continue,
                    };
                   
                    if a_str.parse::<i32>().is_ok() && a_str.len()<4 && b_str.parse::<i32>().is_ok() && b_str.len()<4{
                        new_mults.push(mult_string);
                    }
                }
            }
            let new_string:&str = match parse_string.get(start_location+1..){
                Some(x)=>x,
                None=>{
                    println!("Error progressing total_string");
                    continue
                },
            };
            parse_string = String::from(new_string);
        }
    }
    return new_mults;
}

//performs multiplication based on valid mul(x,y) strings
fn convert_multi(input:&String) -> i32{
    let mut stripping = input.strip_prefix("mul(");
    let mut stripped_string:&str="";
    match stripping{
        Some(x)=>stripped_string = x,
        None => println!("Cannot process {input}"),
    }
    let binding = String::from(stripped_string);
    stripping = binding.strip_suffix(")");
    match stripping{
        Some(x)=>stripped_string = x,
        None => println!("Cannot process {input}"),
    }
    
    let mut numbers:Vec<i32> = Vec::new();
    let numbers_str:Vec<&str> = stripped_string.split(",").collect();
    for n in numbers_str{
        numbers.push(FromStr::from_str(n).unwrap());
    }
    return numbers[0]*numbers[1];
}