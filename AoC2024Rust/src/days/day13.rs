use std::fs::File;
use std::io::{BufRead,BufReader};
use std::str::FromStr;

pub fn part1(){
    println!("Day13 Part1");

    let (buttons_a,buttons_b,prizes)=parse_document();

    let mut total:i64 = 0;
    for i in 0..prizes.len(){
        total+= find_best_solution(buttons_a[i],buttons_b[i],prizes[i]);
    }
    
    println!("{total}");
}

pub fn part2(){
    println!("Day13 Part2");

    let (buttons_a,buttons_b,prizes)=parse_document();

    let mut total:i64 = 0;
    for i in 0..prizes.len(){
        let new_prize = [prizes[i][0]+10000000000000,prizes[i][1]+10000000000000];
        total+= find_best_solution(buttons_a[i],buttons_b[i],new_prize);
    }
    
    println!("{total}");

}

fn parse_document()->(Vec<[i64;2]>,Vec<[i64;2]>,Vec<[i64;2]>){
    let mut buttons_a:Vec<[i64;2]> = Vec::new();
    let mut buttons_b:Vec<[i64;2]> = Vec::new();
    let mut prizes:Vec<[i64;2]> = Vec::new();

    let mut step:u16 = 0;

    let input_doc = File::open("./src/inputs/Day13input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);
    for line in reader.lines(){
        let row:String = match line {
            Ok(s)=>s.chars().collect(),
            Err(_)=>{println!("Failed to read row");break}
        };
        match step%4{
            0=>{
                let splits_a:Vec<&str> = row.split(" ").collect();
                let x = &splits_a[splits_a.len()-2][2..4];
                let y = &splits_a[splits_a.len()-1][2..4];
                buttons_a.push([FromStr::from_str(x).expect("Failed to convert a to i64"),FromStr::from_str(y).expect("Failed to conver to i64")])
            },
            1=>{
                let splits_b:Vec<&str> = row.split(" ").collect();
                let x = &splits_b[splits_b.len()-2][2..4];
                let y = &splits_b[splits_b.len()-1][2..4];
                buttons_b.push([FromStr::from_str(x).expect("Failed to convert b to i64"),FromStr::from_str(y).expect("Failed to conver to i64")])
            },
            2=>{
                let splits_p:Vec<&str> = row.split(" ").collect();
                let x = match splits_p[splits_p.len()-2][2..].strip_suffix(","){
                    Some(x)=>x,
                    None=>{println!("P/X is broken");""},
                };
                let y = &splits_p[splits_p.len()-1][2..];
                prizes.push([FromStr::from_str(x).expect("Failed to convert p to i64"),FromStr::from_str(y).expect("Failed to conver to i64")])
            },
            3=>(),
            _=>println!("out of step range"),
        }
        
        step+=1;
    }

    return (buttons_a,buttons_b,prizes)
}

fn find_best_solution(button_a:[i64;2],button_b:[i64;2],prize:[i64;2])->i64{
    
    let solution_y = ((button_a[0]*prize[1])-(button_a[1]*prize[0]))/((button_a[0]*button_b[1])-(button_a[1]*button_b[0]));
    let y_float = ((button_a[0]*prize[1])-(button_a[1]*prize[0]))%((button_a[0]*button_b[1])-(button_a[1]*button_b[0]));
    let solution_x = (prize[0]-(button_b[0]*solution_y))/button_a[0];
    let x_float =(prize[0]-(button_b[0]*solution_y))%button_a[0];
    if y_float==0 && x_float == 0{
        return (solution_x*3)+solution_y;
    }

    return 0;
}