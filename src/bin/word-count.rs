use std::fs;

fn main() {
    use std::env;
    use std::fs;

    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: {} <filename>", args[0]);
        return;
    }

    let filename = &args[1];
    let contents = fs::read_to_string(filename).expect("Failed to read file");

    // count words in the file
    let word_count = contents.split_whitespace().count();

    println!("Word count: {}", word_count);
}
