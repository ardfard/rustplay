#[cfg(test)]
mod tests {

    use std::{fs::File, io::Read};
    #[test]
    fn test_read() {
        let result = File::open("mod.rs");
        match result {
            Ok(mut file) => {
                let mut contents = String::new();
                file.read_to_string(&mut contents).unwrap();
                println!("{}", contents);
            }
            Err(e) => {
                println!("Error: {}", e);
            }
        }
    }

    #[test]
    fn test_byte_read() {
        let bytes = std::fs::read("flake.nix");
        match bytes {
            Ok(bytes) => {
                println!("{}", bytes.len());
                // bytes to string
                println!("{}", String::from_utf8(bytes).unwrap());
            }
            Err(e) => {
                println!("Error: {}", e);
            }
        }
    }

    struct Data {
        i: u8,
        x: u8,
    }

    #[test]
    fn test_mutate() {
        let mut d = Data { i: 1, x: 2 };
        {
            let r = &mut d;
            r.i = 10;
        }

        println!("i: {}, x: {}", d.i, d.x);
    }

    #[test]
    fn test_fizzbuzz() {
        for i in 1..=100 {
            println!("i: {}", i);
            if i % 3 == 0 && i % 5 == 0 {
                println!("FizzBuzz");
            } else if i % 3 == 0 {
                println!("Fizz");
            } else if i % 5 == 0 {
                println!("Buzz");
            } else {
                println!("{}", i);
            }
        }
    }
}
