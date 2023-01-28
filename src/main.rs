use std::borrow::Cow;

fn main() {
    let x = 1;
    let b = Cow::Borrowed(&x);
    let y = b;
    match y {
        Cow::Borrowed(_) => println!("Borrowed"),
        Cow::Owned(_) => println!("Owned"),
    }
    match y {
        Cow::Borrowed(_) => println!("Borrowed"),
        Cow::Owned(_) => println!("Owned"),
    }
}
