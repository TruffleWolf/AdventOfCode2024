use std::collections::HashMap;
use std::fs::File;
use std::io::{BufRead,BufReader};


pub fn part1(){
    println!("Day9 Part1");

    let input_doc = File::open("./src/inputs/Day9input.txt").expect("File not found.");
    let mut reader = BufReader::new(input_doc);

    let mut vec_string:String = String::new();
    reader.read_line(&mut vec_string).expect("could not parse document");

    let mut file_sizes: HashMap<i32,[u32;2]> = HashMap::new();
    let mut empty_spaces: HashMap<usize,u32> = HashMap::new();
    let mut number_vec:Vec<i32> = Vec::new();

    let mut count:i32 = 0;
    let mut empty_mode:bool = false;
    for v in vec_string.chars(){
        let current_number:u32 = match v.to_digit(10){
            Some(x)=>x,
            None => 0,
        };
        if empty_mode{
            empty_spaces.insert(number_vec.len(),current_number);
            for _i in 0..current_number{
                number_vec.push(-1);
            }
        }
        else{
            file_sizes.insert(count, [number_vec.len()as u32,current_number]);
            for _i in 0..current_number{
                number_vec.push(count);
            }
            count +=1;
        }
        empty_mode = !empty_mode;
    }

    
    let mut pos:usize = 0;
    
    while pos < number_vec.len(){
        
        if number_vec[pos]==-1{
            let mut pop_number:i32 = -1;
            while pop_number == -1{
                pop_number = number_vec.pop().expect("broken number_vec");
            }
            number_vec[pos] = pop_number;
        }
        pos+=1;
    }


    print_checksum(number_vec);
}

pub fn part2(){
    println!("Day9 Part2");

    let input_doc = File::open("./src/inputs/Day9input.txt").expect("File not found.");
    let mut reader = BufReader::new(input_doc);

    let mut vec_string:String = String::new();
    reader.read_line(&mut vec_string).expect("could not parse document");

    let mut file_sizes: HashMap<i32,[u32;2]> = HashMap::new();
    let mut empty_spaces: HashMap<usize,u32> = HashMap::new();
    let mut number_vec:Vec<i32> = Vec::new();

    let mut count:i32 = 0;
    let mut empty_mode:bool = false;
    for v in vec_string.chars(){
        let current_number:u32 = match v.to_digit(10){
            Some(x)=>x,
            None => 0,
        };
        if empty_mode{
            empty_spaces.insert(number_vec.len(),current_number);
            for _i in 0..current_number{
                number_vec.push(-1);
            }
        }
        else{
            file_sizes.insert(count, [number_vec.len()as u32,current_number]);
            for _i in 0..current_number{
                number_vec.push(count);
            }
            count +=1;
        }
        empty_mode = !empty_mode;
    }

    let mut file_ids:Vec<&i32> = file_sizes.keys().collect();
    file_ids.sort();
    let mut count:usize = 1;
    for _f in &file_ids{
        let target_id:&i32 = file_ids[file_ids.len()-count];
        let to_size:&[u32;2] = file_sizes.get(target_id).expect("File_size Failure");
        let target_size:u32 = to_size[1];
        let target_pos:usize = to_size[0] as usize;
        let temp_spaces = empty_spaces.clone();
        let mut space_locations:Vec<&usize> = temp_spaces.keys().collect();
        space_locations.sort();
        for e in space_locations{
            
            if empty_spaces.get(e).expect("Empty_failure 1") >= &target_size && e<&target_pos{
                //valid spot
                for t in 0..target_size{
                    number_vec[*e+t as usize] = *target_id;
                    number_vec[target_pos+t as usize]=-1;
                }
                println!("{target_id}");
                let new_spot = e+target_size as usize;
                empty_spaces.insert(new_spot, empty_spaces[e]-target_size);
                empty_spaces.remove(e);
                break;
            }
        }

        count +=1;
    }

    print_checksum(number_vec);
}


fn print_checksum(input:Vec<i32>){
    let mut checksum:i64 = 0;
    let mut count:i32 = 0;

    for i in input{
        if i>-1{
            checksum+=i as i64 *count as i64;
        }
        count+=1
    }
    println!("Total:{checksum}");
}