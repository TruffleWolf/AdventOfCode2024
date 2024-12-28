
use std::fs::File;
use std::io::{BufRead,BufReader};
use crate::vec2;



pub fn part1(){
    println!("Day4 Part1");
    
    let input_doc = File::open("./src/inputs/Day4input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);
    let mut letter_grid:Vec<Vec<char>> = Vec::new();

    for line in reader.lines(){
        let row:Vec<char> = match line {
            Ok(s)=>s.chars().collect(),
            Err(_)=>{println!("Failed to read row");break}
        };
        letter_grid.push(row);
    }

    let mut total_found:i32 = 0;
    
    for y in 0..letter_grid.len(){
        for x in 0..letter_grid[y].len(){
            if letter_grid[y][x]=='X'{
                let pos = [x,y];
                for i in vec2::full_compass(){
                    total_found+= check_xmas(&letter_grid,&pos, i);
                }

            }
        }
    }

    println!("Total:{total_found}");

}

pub fn part2(){
    println!("Day4 Part2");

    let input_doc = File::open("./src/inputs/Day4input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);
    let mut letter_grid:Vec<Vec<char>> = Vec::new();

    for line in reader.lines(){
        let row:Vec<char> = match line {
            Ok(s)=>s.chars().collect(),
            Err(_)=>{println!("Failed to read row");break}
        };
        letter_grid.push(row);
    }
    let mut total_found:i32 = 0;

    for y in 1..letter_grid.len()as i16-1{
        for x in 1..letter_grid[y as usize].len()as i16-1{
            if letter_grid[y as usize][x as usize]=='A'{
                let mas_count:i32 = cross_ne(&letter_grid,[x,y])+cross_nw(&letter_grid,[x,y])+cross_se(&letter_grid,[x,y])+cross_sw(&letter_grid,[x,y]);

                if mas_count == 2{
                    total_found+=1;
                }
            }
        }
    }
    println!("Total:{total_found}");
}

fn check_xmas(grid:&Vec<Vec<char>>,coords:&[usize;2],direction:[i16;2]) -> i32{
    //Check out of bounds
    if !vec2::in_bounds(&[coords[0]as i16+(direction[0]*3),coords[1]as i16+(direction[1]*3)], grid){
        return 0;
    }

    let letters:[char;3] = [grid[(coords[1]as i16+direction[1])as usize][(coords[0]as i16+direction[0])as usize],
    grid[(coords[1]as i16+(direction[1]*2))as usize][(coords[0]as i16+(direction[0]*2))as usize],
    grid[(coords[1]as i16+(direction[1]*3))as usize][(coords[0]as i16+(direction[0]*3))as usize]];

    return (letters[0]=='M'&&letters[1]=='A'&&letters[2]=='S')as i32;
    
}

fn cross_nw(grid:&Vec<Vec<char>>,coords:[i16;2])->i32{
    return (grid[(coords[1]-1)as usize][(coords[0]-1)as usize]=='M'&&grid[(coords[1]+1)as usize][(coords[0]+1)as usize]=='S')as i32;
}

fn cross_sw(grid:&Vec<Vec<char>>,coords:[i16;2])->i32{
    return (grid[(coords[1]+1)as usize][(coords[0]-1)as usize]=='M'&&grid[(coords[1]-1)as usize][(coords[0]+1)as usize]=='S')as i32;
}

fn cross_ne(grid:&Vec<Vec<char>>,coords:[i16;2])->i32{
    return (grid[(coords[1]-1)as usize][(coords[0]+1)as usize]=='M'&&grid[(coords[1]+1)as usize][(coords[0]-1)as usize]=='S')as i32;
}

fn cross_se(grid:&Vec<Vec<char>>,coords:[i16;2])->i32{
    return (grid[(coords[1]+1)as usize][(coords[0]+1)as usize]=='M'&&grid[(coords[1]-1)as usize][(coords[0]-1)as usize]=='S')as i32;
}