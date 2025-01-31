use std::marker::PhantomData;
use std::ops::Add;


#[derive(Debug, Clone, Copy)]
enum Inch {}

#[derive(Debug, Clone, Copy)]
enum Mm {}

#[derive(Debug, Clone, Copy)]
struct Length<Unit>(f64, PhantomData<Unit>);

impl<Unit> Add for Length<Unit> {
    type Output = Length<Unit>;

    fn add(self, rhs: Length<Unit>) -> Length<Unit> {
        Length(self.0 + rhs.0, PhantomData)
    }
}

fn main() {
    let x = Length::<Inch>(64.0,PhantomData).add(Length::<Inch>(72.0, PhantomData));
    // Add code that add unit
    let y = Length::<Mm>(65.0, PhantomData);
    let z = y.add(Length::<Mm>(32.0, PhantomData));
    println!("tst {}", x.0 );
    println!("{}", z.0);
    println!("Hello, world!");
}


