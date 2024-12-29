use std::fs::File;
use std::io::{BufRead,BufReader};
use crate::vec2;


pub fn part1(){
    println!("Day10 Part1");
    let input_doc = File::open("./src/inputs/Day10input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);

    let mut topo_map:Vec<Vec<i16>> = Vec::new();
    for line in reader.lines(){
        let row:Vec<char> = match line {
            Ok(s)=>s.chars().collect(),
            Err(_)=>{println!("Failed to read row");break}
        };
        let mut num_row:Vec<i16> = Vec::with_capacity(row.len());
        for r in row{
            let numb = match r.to_digit(10){
                Some(x)=>x as i16,
                None=>{println!("Char conv failure.");0}
            };
            num_row.push(numb);
        }
        topo_map.push(num_row);
    }

    let mut total:i32 = 0;

    for y in 0..topo_map.len(){
        for x in 0..topo_map[y].len(){
            if topo_map[y][x]==0{
                total+=scan_trail_filtered([x as i16,y as i16], &topo_map);
            }
        }
    }

    println!("{total}")
    
}

pub fn part2(){
    println!("Day10 Part2");

    let input_doc = File::open("./src/inputs/Day10input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);

    let mut topo_map:Vec<Vec<i16>> = Vec::new();
    for line in reader.lines(){
        let row:Vec<char> = match line {
            Ok(s)=>s.chars().collect(),
            Err(_)=>{println!("Failed to read row");break}
        };
        let mut num_row:Vec<i16> = Vec::with_capacity(row.len());
        for r in row{
            let numb = match r.to_digit(10){
                Some(x)=>x as i16,
                None=>{println!("Char conv failure.");0}
            };
            num_row.push(numb);
        }
        topo_map.push(num_row);
    }

    let mut total:i32 = 0;

    for y in 0..topo_map.len(){
        for x in 0..topo_map[y].len(){
            if topo_map[y][x]==0{
                total+=scan_trail([x as i16,y as i16], &topo_map);
            }
        }
    }

    println!("{total}")
}

fn scan_trail(input:[i16;2],grid:&Vec<Vec<i16>>)->i32{

    let mut target_locations:Vec<[i16;2]> = vec![input];
    for i in 0..9{
        let mut new_locations:Vec<[i16;2]> = Vec::new();
        for t in target_locations{
            if is_at_location([t[0],t[1]-1], i+1, grid){ new_locations.push([t[0],t[1]-1]);}
            if is_at_location([t[0],t[1]+1], i+1, grid){ new_locations.push([t[0],t[1]+1]);}
            if is_at_location([t[0]-1,t[1]], i+1, grid){ new_locations.push([t[0]-1,t[1]]);}
            if is_at_location([t[0]+1,t[1]], i+1, grid){ new_locations.push([t[0]+1,t[1]]);}
        }
        target_locations = new_locations;

    }
    return target_locations.len() as i32;
}

fn scan_trail_filtered(input:[i16;2],grid:&Vec<Vec<i16>>)->i32{

    let mut target_locations:Vec<[i16;2]> = vec![input];
    for i in 0..9{
        let mut new_locations:Vec<[i16;2]> = Vec::new();
        for t in target_locations{
            if is_at_location([t[0],t[1]-1], i+1, grid){ new_locations.push([t[0],t[1]-1]);}
            if is_at_location([t[0],t[1]+1], i+1, grid){ new_locations.push([t[0],t[1]+1]);}
            if is_at_location([t[0]-1,t[1]], i+1, grid){ new_locations.push([t[0]-1,t[1]]);}
            if is_at_location([t[0]+1,t[1]], i+1, grid){ new_locations.push([t[0]+1,t[1]]);}
        }
        target_locations = new_locations;

    }
    //filter
    let mut filtered_locations:Vec<[i16;2]> = Vec::new();
    for t in target_locations{
        if !filtered_locations.contains(&t){filtered_locations.push(t);}
    }

    return filtered_locations.len() as i32;
}

fn is_at_location(pos:[i16;2],num:i16,grid:&Vec<Vec<i16>>)->bool{
    return vec2::in_bounds(&pos, grid) && grid[pos[1]as usize][pos[0]as usize]==num;
}