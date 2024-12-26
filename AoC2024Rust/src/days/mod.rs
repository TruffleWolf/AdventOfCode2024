

mod day1;
mod day2;

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
        _ => println!("Invalid Day"),
    }
}