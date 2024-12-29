
use std::fs::File;
use std::io::{BufRead,BufReader};
use std::str::FromStr;

pub fn part1(){
    println!("Day7 Part1");

    let input_doc = File::open("./src/inputs/Day7input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);

    let mut results:Vec<i64>=Vec::new();
    let mut equations:Vec<Vec<i64>>=Vec::new();

    for line in reader.lines(){
        let row:String = match line {
            Ok(s)=>s.chars().collect(),
            Err(_)=>{println!("Failed to read row");break}
        };
        let row:Vec<&str> = row.split(":").collect();
        if row.len()>1{
            results.push(FromStr::from_str(row[0]).expect("Failed to conver to i64"));
            let eq_str:Vec<&str> = row[1].split(" ").collect();
            let mut new_list:Vec<i64> = Vec::new();
            for e in eq_str{
                if e.len()>0{new_list.push(FromStr::from_str(e).expect("Failed to conver to i64"));}
                
            }
            equations.push(new_list);
        }

    }
    let mut valid_results:Vec<i64> = Vec::new();
    let mut count:i32 = 0;
    for r in results{
        
        if is_valid(&r,&equations[count as usize]){valid_results.push(r);}

        count +=1;
    }

    let mut total:i64 = 0;
    for v in valid_results{
        
        total+=v;
    }
    println!("{total}");
    
}

pub fn part2(){
    println!("Day7 Part2");
    
    let input_doc = File::open("./src/inputs/Day7input.txt").expect("File not found.");
    let reader = BufReader::new(input_doc);

    let mut results:Vec<i64>=Vec::new();
    let mut equations:Vec<Vec<i64>>=Vec::new();

    for line in reader.lines(){
        let row:String = match line {
            Ok(s)=>s.chars().collect(),
            Err(_)=>{println!("Failed to read row");break}
        };
        let row:Vec<&str> = row.split(":").collect();
        if row.len()>1{
            results.push(FromStr::from_str(row[0]).expect("Failed to conver to i64"));
            let eq_str:Vec<&str> = row[1].split(" ").collect();
            let mut new_list:Vec<i64> = Vec::new();
            for e in eq_str{
                if e.len()>0{new_list.push(FromStr::from_str(e).expect("Failed to conver to i64"));}
                
            }
            equations.push(new_list);
        }

    }
    let mut valid_results:Vec<i64> = Vec::new();
    let mut count:i32 = 0;
    for r in results{
        
        if is_conc_valid(&r,&equations[count as usize]){valid_results.push(r);}

        count +=1;
    }

    let mut total:i64 = 0;
    for v in valid_results{
        
        total+=v;
    }
    println!("{total}");
}

fn is_conc_valid(result:&i64,numbers:&Vec<i64>)->bool{
    if numbers.len()==1{return result==&numbers[0];}
    let mut answer_array:Vec<i64> = Vec::new();
    answer_array.push(numbers[0]);
    let mut stage:usize = 0;
    while stage != numbers.len()-1{
        let mut new_array:Vec<i64> = Vec::new();
        for a in answer_array{
            new_array.push(a*numbers[stage+1]);
            new_array.push(a+numbers[stage+1]);
            let concatenation = a.to_string()+&numbers[stage+1].to_string();
            new_array.push(FromStr::from_str(&concatenation).expect("Failed to conver to i64"))
        }
        answer_array = new_array;
        stage +=1;
    }
    return answer_array.contains(result);
}

fn is_valid(result:&i64,numbers:&Vec<i64>)->bool{
    if numbers.len()==1{return result==&numbers[0];}
    let mut answer_array:Vec<i64> = Vec::new();
    answer_array.push(numbers[0]);
    let mut stage:usize = 0;
    while stage != numbers.len()-1{
        let mut new_array:Vec<i64> = Vec::new();
        for a in answer_array{
            new_array.push(a*numbers[stage+1]);
            new_array.push(a+numbers[stage+1]);
        }
        answer_array = new_array;
        stage +=1;
    }
    return answer_array.contains(result);
}