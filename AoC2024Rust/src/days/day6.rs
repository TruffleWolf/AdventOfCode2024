
use std::fs::File;
use std::io::{BufRead,BufReader};
use crate::vec2;

pub fn part1(){
    println!("Day6 Part1");

    let input_doc = File::open("./src/inputs/Day6input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);

    let mut char_grid:Vec<Vec<char>> = Vec::new();
    let mut relevant_grid:Vec<Vec<bool>> = Vec::new();

    for line in reader.lines(){
        let row:Vec<char> = match line {
            Ok(s)=>s.chars().collect(),
            Err(_)=>{println!("Failed to read row");break}
        };
        let mut new_line:Vec<bool>= Vec::new();
        for _r in 0..row.len(){
            new_line.push(false);
        }
        char_grid.push(row);
        relevant_grid.push(new_line);
    }

    let mut current_pos:[i16;2]=start_pos(&char_grid);
    let mut direction= vec2::north();
    loop{
        relevant_grid[current_pos[1]as usize][current_pos[0]as usize] = true;
        let new_location:[i16;2]= [current_pos[0]+direction[0],current_pos[1]+direction[1]];
        if !vec2::in_bounds(&new_location, &char_grid){break;}
        else if char_grid[new_location[1]as usize][new_location[0]as usize]=='#'{direction=rotate_vector2(direction);}
        else{current_pos=new_location;}
    }



    let mut total:i32 = 0;
    for y in relevant_grid{
        for x in y{
            total += x as i32;
        }
    }
    println!("{total}");
}

pub fn part2(){
    println!("Day6 Part2");

    let input_doc = File::open("./src/inputs/Day6input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);

    let mut char_grid:Vec<Vec<char>> = Vec::new();
    let mut relevant_grid:Vec<Vec<bool>> = Vec::new();

    for line in reader.lines(){
        let row:Vec<char> = match line {
            Ok(s)=>s.chars().collect(),
            Err(_)=>{println!("Failed to read row");break}
        };
        let mut new_line:Vec<bool>= Vec::new();
        for _r in 0..row.len(){
            new_line.push(false);
        }
        char_grid.push(row);
        relevant_grid.push(new_line);
    }

    let mut current_pos:[i16;2]=start_pos(&char_grid);
    let mut direction= vec2::north();
    loop{
        relevant_grid[current_pos[1]as usize][current_pos[0]as usize] = true;
        let new_location:[i16;2]= [current_pos[0]+direction[0],current_pos[1]+direction[1]];
        if !vec2::in_bounds(&new_location, &char_grid){break;}
        else if char_grid[new_location[1]as usize][new_location[0]as usize]=='#'{direction=rotate_vector2(direction);}
        else{current_pos=new_location;}
    }

    let mut total:i32 = 0;
    let current_pos:[i16;2]=start_pos(&char_grid);
    let mut count:i16 = 0;
    for y in 0..char_grid.len(){
        for x in 0..char_grid[y].len(){
            if relevant_grid[y][x]{
                let mut test_grid = char_grid.clone();
                test_grid[y][x]='#';
                total+=loop_check(test_grid,&current_pos) as i32;
                count +=1;
                println!("{}/{}",total,count)
            }
        }
    }



    println!("{total}");

}

fn loop_check(grid:Vec<Vec<char>>,start:&[i16;2])->bool{
    let mut count:i32 = 0;
    let mut direction:[i16;2]= vec2::north();
    let mut known_transforms:Vec<[i16;4]>=Vec::with_capacity(5410);
    let mut position:[i16;2] = [start[0],start[1]];

    while count < i32::MAX-1{
        let current_transform:[i16;4] = [position[0],position[1],direction[0],direction[1]];
        if known_transforms.contains(&current_transform){return true;}
        known_transforms.push(current_transform);

        let new_location:[i16;2]= [position[0]+direction[0],position[1]+direction[1]];
        if !vec2::in_bounds(&new_location, &grid){return false;}
        else if grid[new_location[1]as usize][new_location[0]as usize]=='#'{direction=rotate_vector2(direction);}
        else{position = new_location;}       
        count +=1;
    }
    println!("Loop check failed.");
    return false;
}

fn rotate_vector2(input:[i16;2])->[i16;2]{
    return [input[1]*-1,input[0]];
}

fn start_pos(input:&Vec<Vec<char>>)->[i16;2]{
    for y in 0..input.len(){
        for x in 0..input[y].len(){
            if input[y][x]=='^'{
                return [x as i16,y as i16];
            }
        }
    }
    println!("start not fount");
    return [-1,-1];
}