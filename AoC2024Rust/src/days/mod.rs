

mod day1;
mod day2;
mod day3;
mod day4;
mod day5;
mod day6;
mod day7;
mod day8;
mod day9;
mod day10;

pub fn call_daypart(day:i32,part:i32){
    match day{
        1 => {
            if part == 1{
                day1::part1();
            }
            else{
                day1::part2();
            }
        },
        2 => {
            if part == 1{
                day2::part1();
            }
            else{
                day2::part2();
            }
        },
        3 => {
            if part == 1{
                day3::part1();
            }
            else{
                day3::part2();
            }
        },
        4 =>{
            if part == 1{
                day4::part1();
            }
            else{
                day4::part2();
            }
        },
        5 =>{
            if part == 1{
                day5::part1();
            }
            else{
                day5::part2();
            }
        },
        6 =>{
            if part == 1{
                day6::part1();
            }
            else{
                day6::part2();
            }
        },
        7 =>{
            if part == 1{
                day7::part1();
            }
            else{
                day7::part2();
            }
        },
        8 =>{
            if part == 1{
                day8::part1();
            }
            else{
                day8::part2();
            }
        },
        9 =>{
            if part == 1{
                day9::part1();
            }
            else{
                day9::part2();
            }
        },
        10 =>{
            if part == 1{
                day10::part1();
            }
            else{
                day10::part2();
            }
        },
        _ => println!("Invalid Day"),
    }
}


