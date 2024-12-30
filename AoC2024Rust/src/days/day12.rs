use std::fs::File;
use std::io::{BufRead,BufReader};
use std::collections::HashMap;
use crate::vec2;

struct AreaData{
    area:i64,
    perimeter:i64,
    sides:i64,
}


pub fn part1(){
    println!("Day12 Part1");
    
    let mut total:i64 = 0;
    let region:HashMap<[i16;2],AreaData> = parse_grid();
    for (_k,v) in region{
        total+=v.area*v.perimeter;
    }
    println!("{total}");
}

pub fn part2(){
    println!("Day12 Part2");

    let mut total:i64 = 0;
    let region:HashMap<[i16;2],AreaData> = parse_grid();
    for (_k,v) in region{
        total+=v.area*v.sides;
    }
    
    println!("{total}");
}

fn parse_grid()->HashMap<[i16;2],AreaData>{
    let mut regions:HashMap<[i16;2],AreaData> = HashMap::new();
    let mut total_grid:Vec<Vec<char>> = Vec::new();
    let mut parsed_grid:Vec<Vec<bool>> = Vec::new();
    let input_doc = File::open("./src/inputs/Day12input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);

    for line in reader.lines(){
        let row:Vec<char> = match line {
            Ok(s)=>s.chars().collect(),
            Err(_)=>{println!("Failed to read row");break}
        };
        let mut new_vec:Vec<bool> = Vec::new();
        for _r in &row{
            new_vec.push(false);
        }
        parsed_grid.push(new_vec);
        total_grid.push(row);
    }

    for y in 0..total_grid.len(){
        for x in 0..total_grid[y].len(){
            if !parsed_grid[y][x]{
                //fences are stored as a vector3 with x/y being grid coords and z being facing
                //0==north,1==east,2==south,3==west
                let (plot_info,parsed_fences) = calc_region([x as i16,y as i16],&mut parsed_grid,&total_grid);

                let mut valid_vec:Vec<bool> = Vec::new();
                for _f in &parsed_fences{
                    valid_vec.push(true);
                }
                let mut count:usize = 0;
                let mut sides:i64 = 0;
                for f in &parsed_fences{
                    if valid_vec[count]{
                        valid_vec[count]=false;
                        sides+=1;
                        
                        let mut move_vec:[i16;2]=[0,0];
                        
                        
                        if f[2]==1{move_vec=vec2::north();}
                        else if f[2]==2 {move_vec=vec2::east();}
                        else if f[2]==3 {move_vec=vec2::south();}
                        else if f[2]==0 {move_vec=vec2::west()}
                        
                        let mut current_x:i16 = f[0];
                        let mut current_y:i16 = f[1];
                        
                        //while parsed_fences.contains(&[current_x+move_vec[0],current_y+move_vec[1],f[2]]){
                        while parsed_fences.iter().any(|e| e == &[current_x+move_vec[0],current_y+move_vec[1],f[2]]){
                            let pos = match parsed_fences.iter().position(|&r| r == [current_x+move_vec[0],current_y+move_vec[1],f[2]]){
                                Some(x)=>x,
                                None=>panic!("failed to find in fence positive"),
                            };
                            
                            valid_vec[pos]=false;
                            current_x+=move_vec[0];
                            current_y+=move_vec[1];
                        }
                        current_x = f[0];
                        current_y = f[1];
                        while parsed_fences.contains(&[current_x-move_vec[0],current_y-move_vec[1],f[2]]){
                            let pos = match parsed_fences.iter().position(|&r| r == [current_x-move_vec[0],current_y-move_vec[1],f[2]]){
                                Some(x)=>x,
                                None=>panic!("failed to find in fence positive"),
                            };
                            
                            valid_vec[pos]=false;
                            current_x-=move_vec[0];
                            current_y-=move_vec[1];
                        }
                    }
                    count+=1;
                }
                regions.insert([x as i16,y as i16], AreaData{area:plot_info[0],perimeter:plot_info[1],sides:sides});
            }
        }
    }



    return regions;
}

fn calc_region(input:[i16;2],grid:&mut Vec<Vec<bool>>,char_grid:&Vec<Vec<char>>)->([i64;2],Vec<[i16;3]>){
    grid[input[1] as usize][input[0]as usize] = true;
    let mut region:[i64;2]=[1,0];
    let mut parsed_fences:Vec<[i16;3]> = Vec::new();
    let mut count:i16 = 0;
    for dir in vec2::cardinals(){
        
        if vec2::in_bounds(&[input[0]+dir[0],input[1]+dir[1]], grid) && char_grid[input[1]as usize][input[0]as usize]==char_grid[(input[1]+dir[1])as usize][(input[0]+dir[0])as usize]{
            if !grid[(input[1]+dir[1])as usize][(input[0]+dir[0])as usize]{
                let (addition,mut new_fences) = calc_region([input[0]+dir[0],input[1]+dir[1]], grid,char_grid);
                region[0]+=addition[0];
                region[1]+=addition[1];
                parsed_fences.append(&mut new_fences);
            }
        }
        else{
            parsed_fences.push([input[0],input[1],count]);
            region[1]+=1;
        }
        count +=1;
    }


    return (region,parsed_fences);
}