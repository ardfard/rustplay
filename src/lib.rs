// Add test
#[cfg(test)]
mod tests {
    use std::{fs::File, io::Read, path::Path};

    // This is an example of using AsRef. Note AsRef<T> means that the type can
    // be converted to a reference of type T.
    #[test]
    fn as_ref_test() {
        fn cat<T: AsRef<Path>>(path: T) {
            println!("the path: {:?}", path.as_ref());
            // open file at path
            let mut file = File::open(path).unwrap();

            // print the file content as string
            let mut content = String::new();

            file.read_to_string(&mut content)
                .expect("failed to read file");

            println!("the content: {}", content);
        }

        // using &str
        cat(".envrc");

        // using Path
        cat(Path::new(".envrc"));

        // using PathBuf
        cat(Path::new(".").join(".envrc"));

        // using String
        cat(String::from("./.envrc"));
    }
}
