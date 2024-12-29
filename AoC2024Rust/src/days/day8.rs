use std::fs::File;
use std::io::{BufRead,BufReader};
use std::collections::HashMap;
use crate::vec2;

pub fn part1(){
    println!("Day8 Part1");

    let input_doc = File::open("./src/inputs/Day8input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);

    let mut total_grid:Vec<Vec<char>> = Vec::new();
    let mut relevant_grid:Vec<Vec<bool>> = Vec::new();
    let mut frequency_list:HashMap<char,Vec<[usize;2]>> = HashMap::new();

    for line in reader.lines(){
        let row:Vec<char> = match line {
            Ok(s)=>s.chars().collect(),
            Err(_)=>{println!("Failed to read row");break}
        };
        let mut new_row:Vec<bool> = Vec::new();
        for _r in &row{
            new_row.push(false);
        }
        total_grid.push(row);
        relevant_grid.push(new_row);
    }
    
    for y in 0..total_grid.len(){
        for x in 0..total_grid[y].len(){
            if total_grid[y][x] !='.'{
                let coords_list:Vec<[usize;2]>=Vec::with_capacity(1);
                
                let pos:&mut Vec<[usize;2]> = frequency_list.entry(total_grid[y][x]).or_insert(coords_list);
                pos.push([x,y]);
                
            }
        }
    }


    
    
    for (_f,row) in frequency_list{
        
        for a in &row{
            
            for b in &row{
                if b!=a{
                    let anti_coords:[i16;2] = [a[0]as i16+(a[0]as i16-b[0]as i16),a[1]as i16+(a[1]as i16-b[1]as i16)];
                    
                    if vec2::in_bounds(&anti_coords, &relevant_grid){
                        relevant_grid[anti_coords[1]as usize][anti_coords[0] as usize]= true;
                    }
                    
                }
            }
        }
    }
    
    
    let mut total:i32 = 0;
    for r in relevant_grid{
        for s in r{
            total+=s as i32;
        }
    }
    println!("{total}")
}

pub fn part2(){
    println!("Day8 Part2");

    let input_doc = File::open("./src/inputs/Day8input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);

    let mut total_grid:Vec<Vec<char>> = Vec::new();
    let mut relevant_grid:Vec<Vec<bool>> = Vec::new();
    let mut frequency_list:HashMap<char,Vec<[usize;2]>> = HashMap::new();

    for line in reader.lines(){
        let row:Vec<char> = match line {
            Ok(s)=>s.chars().collect(),
            Err(_)=>{println!("Failed to read row");break}
        };
        let mut new_row:Vec<bool> = Vec::new();
        for _r in &row{
            new_row.push(false);
        }
        total_grid.push(row);
        relevant_grid.push(new_row);
    }
    
    for y in 0..total_grid.len(){
        for x in 0..total_grid[y].len(){
            if total_grid[y][x] !='.'{
                let coords_list:Vec<[usize;2]>=Vec::with_capacity(1);
                
                let pos:&mut Vec<[usize;2]> = frequency_list.entry(total_grid[y][x]).or_insert(coords_list);
                pos.push([x,y]);
                
            }
        }
    }

    for (_f,row) in frequency_list{
        
        for a in &row{
            
            for b in &row{
                relevant_grid[b[1]][b[0]] = true;
                if b!=a{
                    let mut anti_coords:[i16;2] = [a[0]as i16+(a[0]as i16-b[0]as i16),a[1]as i16+(a[1]as i16-b[1]as i16)];
                    let anti_vector:[i16;2] = [a[0]as i16-b[0]as i16,a[1]as i16-b[1]as i16];
                    let mut in_bounds:bool = vec2::in_bounds(&anti_coords, &relevant_grid);
                    while in_bounds{
                        relevant_grid[anti_coords[1]as usize][anti_coords[0]as usize] = true;
                        anti_coords = [anti_coords[0]+anti_vector[0],anti_coords[1]+anti_vector[1]];
                        in_bounds = vec2::in_bounds(&anti_coords, &relevant_grid);
                    }
                }
            }
        }
    }

    let mut total:i32 = 0;
    for r in relevant_grid{
        for s in r{
            total+=s as i32;
        }
    }
    println!("{total}")
}